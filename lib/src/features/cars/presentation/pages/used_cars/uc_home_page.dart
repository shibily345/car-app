import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/slider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class UsedCarsHome extends StatelessWidget {
  const UsedCarsHome({super.key});

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    bool isLoggedin = context.watch<UserProvider>().firebaseUser != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh the cars data
          await context.read<CarsProvider>().eitherFailureOrCars();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            _buildHeader(context, th, isLoggedin),
            _buildSearchBar(context),
            _buildFilterChips(context),
            _buildCarSlider(),
            _buildTiles(th),
            _buildlistOfcars(context),
            _buildSpacing(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTiles(ThemeData th) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              Icons.trending_up,
              color: th.primaryColor,
              size: 24.sp,
            ),
            12.spaceX,
            Text(
              "Popular Cars",
              style: th.textTheme.headlineMedium?.copyWith(
                color: th.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildlistOfcars(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final car = context
              .watch<CarsProvider>()
              .cars
              ?.where((car) => car.isForSale == true)
              .toList()[index];

          if (car == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: _buildCarCard(context, car, index),
          );
        },
        childCount: context
                .watch<CarsProvider>()
                .cars
                ?.where((car) => car.isForSale == true)
                .toList()
                .length ??
            0,
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, dynamic car, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, "/carDetails", arguments: car);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarImage(context, car),
                16.spaceX,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCarTitle(context, car),
                      8.spaceY,
                      _buildCarSubtitle(context, car),
                      12.spaceY,
                      _buildCarPrice(context, car),
                      8.spaceY,
                      _buildCarFeatures(context, car),
                    ],
                  ),
                ),
                _buildLikeButton(context, car),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarImage(BuildContext context, dynamic car) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: "${Ac.baseUrl}${car.images?.first}",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.error_outline,
              color: Colors.grey.shade400,
              size: 28.sp,
            ),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCarTitle(BuildContext context, dynamic car) {
    return Text(
      '${car.make} ${car.model}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 16.sp,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCarSubtitle(BuildContext context, dynamic car) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14.sp,
          color: Colors.grey.shade600,
        ),
        6.spaceX,
        Text(
          '${car.year}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 13.sp,
              ),
        ),
        16.spaceX,
        Icon(
          Icons.location_on,
          size: 14.sp,
          color: Colors.grey.shade600,
        ),
        6.spaceX,
        Expanded(
          child: Text(
            '${car.location}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 13.sp,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCarPrice(BuildContext context, dynamic car) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '\$${car.price}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
      ),
    );
  }

  Widget _buildCarFeatures(BuildContext context, dynamic car) {
    return Row(
      children: [
        _buildFeatureChip(context, '${car.mileage}km', Icons.speed),
        8.spaceX,
        _buildFeatureChip(context, '${car.fuel}', Icons.local_gas_station),
      ],
    );
  }

  Widget _buildFeatureChip(BuildContext context, String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: Colors.grey.shade700,
          ),
          4.spaceX,
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, dynamic car) {
    bool isLoggedin = context.watch<UserProvider>().firebaseUser != null;
    bool isFavorite =
        context.watch<UserProvider>().currentFavorites.contains(car.id);

    return Container(
      decoration: BoxDecoration(
        color:
            isFavorite ? Theme.of(context).primaryColor : Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          if (!isLoggedin) {
            StyledDialog.show(
              context: context,
              content: const LoginButton(),
            );
            return;
          }
          if (isFavorite) {
            context.read<UserProvider>().removeProductFromFavorites(car.id);
          } else {
            context.read<UserProvider>().addProductToFavorites(car.id);
          }
        },
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.white : Colors.grey.shade600,
          size: 20.sp,
        ),
      ),
    );
  }

  //! Header with title and button
  Widget _buildHeader(BuildContext context, ThemeData th, bool isLoggedin) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: 50.0.h,
          left: 20.w,
          right: 20.w,
          bottom: 16.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: Colors.black87,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text(
              'Used Cars',
              style: th.textTheme.headlineMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: th.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  if (!isLoggedin) {
                    StyledDialog.show(
                      context: context,
                      content: const LoginButton(),
                    );
                    return;
                  }
                  context.read<UserProvider>().isSeller
                      ? Navigator.pushNamed(context, "/myShop")
                      : Navigator.pushNamed(context, "/addSeller");
                },
                icon: const Icon(HugeIcons.strokeRoundedDashboardSquareAdd,
                    size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! Search bar
  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/search"),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 18.sp,
                ),
                12.spaceX,
                Text(
                  "Search cars, brands, models...",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.tune,
                  color: Colors.grey.shade600,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! Filter chips for car makes
  Widget _buildFilterChips(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Consumer<CarsProvider>(
          builder: (context, carsProvider, child) {
            final carMakes =
                carsProvider.cars?.map((car) => car.make).toSet().toList() ??
                    [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  20.spaceX,
                  ...carMakes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final make = entry.value;
                    final isSelected =
                        carsProvider.selectedMakes.contains(make);
                    return _sortChip(
                      make!,
                      () => carsProvider.toggleMakeSelection(make),
                      context,
                      isSelected: isSelected,
                      index: index,
                    );
                  }),
                  if (carsProvider.selectedMakes.isNotEmpty)
                    _sortChip(
                      "All",
                      () => carsProvider.resetFilter(),
                      context,
                      isSelected: false,
                      index: carMakes.length,
                    ),
                  20.spaceX,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //! Car slider
  Widget _buildCarSlider() {
    return SliverToBoxAdapter(
      child: Consumer<CarsProvider>(
        builder: (context, cars, state) {
          final forSaleCars =
              (cars.cars ?? []).where((car) => car.isForSale == true).toList();
          return SliderHome(
            carData: forSaleCars,
          );
        },
      ),
    );
  }

  //! Bottom spacing
  Widget _buildSpacing() {
    return SliverToBoxAdapter(
      child: 24.w.spaceY,
    );
  }

  //! Sort chip widget
  Widget _sortChip(String label, VoidCallback ontap, BuildContext context,
      {bool isSelected = false, int index = 0}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 14.sp,
                ),
              if (isSelected) 6.spaceX,
              Ctext(
                label,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
