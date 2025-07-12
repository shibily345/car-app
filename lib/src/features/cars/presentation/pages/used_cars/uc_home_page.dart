import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/used_cars/slider.dart';
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
      body: Container(
        decoration: _buildBackgroundGradient(th), //! Background gradient
        child: CustomScrollView(
          slivers: <Widget>[
            _buildHeader(
                context, th, isLoggedin), //! Header with title and button
            _buildSearchBar(context), //! Search bar
            _buildFilterChips(context), //! Filter chips for car makes
            _buildCarSlider(),

            _buildTiles(th),
            //! ListView of cars
            _buildlistOfcars(context),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTiles(ThemeData th) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Text(
          "Popular Cars",
          style: th.textTheme.headlineMedium?.copyWith(
            color: th.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverList _buildlistOfcars(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final car = context.watch<CarsProvider>().cars?[index];
          if (car == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 80,
                        height: 80,
                        imageUrl: "${Ac.baseUrl}${car.images?.first}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    15.spaceX,
                    // Car details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car.make} ${car.model}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          5.spaceY,
                          Text(
                            '${car.year} • ${car.location}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.6),
                                    ),
                          ),
                          10.spaceY,
                          Text(
                            '\$${car.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Like button
                    // IconButton(
                    //   onPressed: () {
                    //     // context.read<CarsProvider>().toggleLike(car.id);
                    //   },
                    //   icon: Icon(

                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: context.watch<CarsProvider>().cars?.length ?? 0,
      ),
    );
  }

  //! Background gradient
  BoxDecoration _buildBackgroundGradient(ThemeData th) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
        colors: [
          th.hoverColor,
          th.primaryColor.withOpacity(0.2),
        ],
        stops: const [0.38, 0.8],
      ),
    );
  }

  //! Header with title and button
  Widget _buildHeader(BuildContext context, ThemeData th, bool isLoggedin) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.only(top: 60.0.h, left: 20.w, right: 20.w, bottom: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              ),
              color: th.primaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Used Cars',
              style: th.textTheme.headlineMedium?.copyWith(
                color: th.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              color: th.primaryColor,
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
              icon: const Icon(
                HugeIcons.strokeRoundedDashboardSquareAdd,
                size: 40,
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/search"),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                10.spaceX,
                Text(
                  "Search here...",
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    fontSize: 18.sp,
                  ),
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
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Consumer<CarsProvider>(
          builder: (context, carsProvider, child) {
            final carMakes =
                carsProvider.cars?.map((car) => car.make).toSet().toList() ??
                    [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  20.spaceX,
                  ...carMakes.map((make) {
                    final isSelected =
                        carsProvider.selectedMakes.contains(make);
                    return _sortChip(
                      make!,
                      () => carsProvider.toggleMakeSelection(make),
                      context,
                      isSelected: isSelected,
                    );
                  }),
                  if (carsProvider.selectedMakes.isNotEmpty)
                    _sortChip(
                      "All",
                      () => carsProvider.resetFilter(),
                      context,
                      isSelected: false,
                    ),
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
          return SliderHome(
            carData: cars.cars ?? [],
          );
        },
      ),
    );
  }

  //! Bottom spacing
  Widget _buildSpacing() {
    return SliverToBoxAdapter(
      child: 40.w.spaceY,
    );
  }

  //! Sort chip widget
  Widget _sortChip(String label, VoidCallback ontap, BuildContext context,
      {bool isSelected = false}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Ctext(
            label,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
