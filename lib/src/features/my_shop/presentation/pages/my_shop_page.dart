import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/widgets/cached_image.dart';

class MyShopPage extends StatefulWidget {
  const MyShopPage({super.key});

  @override
  State<MyShopPage> createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage> {
  Future<void> _refreshAll(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final carsProvider = Provider.of<CarsProvider>(context, listen: false);
    final rentalProvider = Provider.of<RentalProvider>(context, listen: false);
    final String uid = userProvider.firebaseUser!.uid;
    // Refresh seller
    userProvider.eitherFailureOrSeller(value: uid);
    // Refresh cars
    await carsProvider.eitherFailureOrCars();
    // Refresh rentals (after seller refresh, in case sellerId changes)
    if (userProvider.cSeller != null) {
      await rentalProvider.getSellerRentals(userProvider.cSeller!.id);
    }
    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "addRentalFAB",
            onPressed: () => Navigator.pushNamed(context, "/addRentalCar"),
            backgroundColor: Colors.orange.shade600,
            icon: const Icon(Icons.car_rental, color: Colors.white),
            label: const Text(
              'Add Rental',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            heroTag: "addSaleFAB",
            onPressed: () => Navigator.pushNamed(context, "/addSale"),
            backgroundColor: Colors.green.shade700,
            icon: const Icon(Icons.sell, color: Colors.white),
            label: const Text(
              'Add Sale',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withAlpha(13),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Consumer3<UserProvider, CarsProvider, RentalProvider>(
          builder: (context, userProvider, carsProvider, rentalProvider, _) {
            final String sellerId = userProvider.cSeller!.id;
            final List<CarEntity> filteredCars = carsProvider.cars!
                .where((car) => car.sellerId == sellerId)
                .toList();
            final SellerModel seller = userProvider.cSeller!;
            final String imageUrl = _getImageUrl(seller.photoURL);

            return RefreshIndicator(
              onRefresh: () => _refreshAll(context),
              child: Column(
                children: [
                  // Normal App Bar
                  AppBar(
                    backgroundColor: theme.primaryColor,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'My Shop',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width * 0.06,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/addNew"),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.add,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Seller Profile Section
                          SellerProfileSection(
                              seller: seller, imageUrl: imageUrl),

                          // Garage Section with Tabs
                          GarageSection(
                            cars: filteredCars,
                            sellerId: sellerId,
                            rentalProvider: rentalProvider,
                            allCars: carsProvider.cars!,
                          ),

                          // Bottom spacing
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getImageUrl(String url) {
    return url.startsWith('ww') ? url : '${Ac.baseUrl}$url';
  }
}

class SellerProfileSection extends StatelessWidget {
  final SellerModel seller;
  final String imageUrl;

  const SellerProfileSection({
    required this.seller,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.05),
      child: Card(
        elevation: 4,
        shadowColor: theme.primaryColor.withAlpha(51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              "/editSeller",
              arguments: seller,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: screenSize.width * 0.18,
                  height: screenSize.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withAlpha(51),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedImageWithShimmer(
                      width: screenSize.width * 0.18,
                      height: screenSize.width * 0.18,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.04),

                // Seller Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.dealershipName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              seller.location,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              seller.contactNumber,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edit Profile',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GarageSection extends StatefulWidget {
  final List<CarEntity> cars;
  final String sellerId;
  final RentalProvider rentalProvider;
  final List<CarEntity> allCars;
  const GarageSection({
    required this.cars,
    required this.sellerId,
    required this.rentalProvider,
    required this.allCars,
    super.key,
  });

  @override
  State<GarageSection> createState() => _GarageSectionState();
}

class _GarageSectionState extends State<GarageSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _selectedTabIndex = 0;
  bool _didFetchRentals = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
    // Fetch rentals if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didFetchRentals) {
        widget.rentalProvider.getSellerRentals(widget.sellerId);
        _didFetchRentals = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // All cars owned by the seller
    final List<CarEntity> yourCars = widget.cars.reversed.toList();
    // Cars for sale
    final List<CarEntity> forSaleCars =
        widget.cars.reversed.where((car) => car.isForSale == true).toList();
    // Cars for rent (filter by isForRent)
    final List<CarEntity> forRentCars =
        widget.cars.reversed.where((car) => car.isForRent == true).toList();

    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garage Header
          Container(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.garage,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: screenSize.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Garage',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Manage your vehicles',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenSize.height * 0.02),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTab(
                    context,
                    title: 'Your Cars',
                    count: yourCars.length,
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                Expanded(
                  child: _buildTab(
                    context,
                    title: 'For Sale',
                    count: forSaleCars.length,
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                Expanded(
                  child: _buildTab(
                    context,
                    title: 'For Rent',
                    count: forRentCars.length,
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenSize.height * 0.02),

          // Content based on selected tab
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTabIndex == 0
                ? _buildCarsList(yourCars, theme, screenSize)
                : _selectedTabIndex == 1
                    ? _buildCarsList(forSaleCars, theme, screenSize)
                    : _buildCarsList(forRentCars, theme, screenSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015,
          horizontal: screenSize.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(51)
                    : theme.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsList(
      List<CarEntity> cars, ThemeData theme, Size screenSize) {
    if (cars.isEmpty) {
      return _buildEmptyState(theme, screenSize);
    }

    // No fixed height, let GridView take space as needed, fix column spacing
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.72,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return CarCard(car: car);
      },
    ).animate().moveY(
        duration: 300.ms, curve: Curves.easeOutCubic, begin: 100, end: 0);
  }

  Widget _buildEmptyState(ThemeData theme, Size screenSize) {
    String title;
    String subtitle;
    IconData icon;
    if (_selectedTabIndex == 0) {
      title = 'No cars yet';
      subtitle = 'Start by adding your first car!';
      icon = Icons.directions_car_outlined;
    } else if (_selectedTabIndex == 1) {
      title = 'No cars for sale yet';
      subtitle = 'Mark a car as for sale!';
      icon = Icons.sell_outlined;
    } else {
      title = 'No rental cars yet';
      subtitle = 'Start by adding your first rental car!';
      icon = Icons.car_rental_outlined;
    }
    return Container(
      height: screenSize.height * 0.15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, Size screenSize, String error) {
    return Container(
      height: screenSize.height * 0.15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            'Error loading rentals',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final CarEntity car;
  const CarCard({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.45;
    final isRental = car.features?.contains('Rental') == true ||
        car.title?.toLowerCase().contains('rental') == true;

    // Determine sale/rent label
    String statusLabel;
    if ((car.isForSale ?? false) && (car.isForRent ?? false)) {
      statusLabel = 'Sale & Rent';
    } else if (car.isForSale ?? false) {
      statusLabel = 'Sale';
    } else if (car.isForRent ?? false) {
      statusLabel = 'Rent';
    } else {
      statusLabel = 'N/A';
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vibrant header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.directions_car,
                            color: Colors.white, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Post Car',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose an action for this car',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.sell, size: 24),
                            label: Text(
                              (car.isForSale == true)
                                  ? 'Update Sale'
                                  : 'Post for Sale',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (car.isForSale == true) {
                                Navigator.pushNamed(
                                  context,
                                  '/editSale',
                                  arguments: car.id,
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/addSale',
                                  arguments: car.id,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.car_rental, size: 24),
                            label: Text(
                              (car.isForRent == true)
                                  ? 'Update Rent'
                                  : 'Post for Rent',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () {
                              if (car.isForRent == true) {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  '/updateRentalCar',
                                  arguments: car.id,
                                );
                              } else {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  '/addRentalCar',
                                  arguments: car.id,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: theme.primaryColor.withAlpha(26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image with Rental Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: car.images != null && car.images!.isNotEmpty
                        ? CachedImageWithShimmer(
                            width: cardWidth,
                            height: cardWidth * 0.6,
                            imageUrl: car.images!.first.startsWith('http')
                                ? car.images!.first
                                : '${Ac.baseUrl}${car.images!.first}',
                          )
                        : Container(
                            width: cardWidth,
                            height: cardWidth * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Icon(
                              Icons.directions_car,
                              size: 32,
                              color: Colors.grey.shade400,
                            ),
                          ),
                  ),
                  if (isRental)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(230),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'RENTAL',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Car Details
              Padding(
                padding: EdgeInsets.all(screenSize.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.title ?? '',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenSize.height * 0.005),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            car.location ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenSize.height * 0.01),

                    // Stats Row
                    Row(
                      children: [
                        // Mileage
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.speed,
                                  size: 10,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    '${car.mileage ?? 0}k',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Status Label (replaces Price)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.purple.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 10,
                                  color: Colors.purple.shade700,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    statusLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.purple.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Action Buttons
                    SizedBox(height: screenSize.height * 0.01),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () => Navigator.pushNamed(
                                    context, "/carUpdate",
                                    arguments: car),
                                child: Center(
                                  child: Text(
                                    'Edit',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () {
                                  // Handle delete
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Car'),
                                      content: const Text(
                                          'Are you sure you want to delete this car?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final carCreateProvider =
                                                Provider.of<CarCreateProvider>(
                                                    context,
                                                    listen: false);
                                            final result = await carCreateProvider
                                                .eitherFailureOrDeleteCarData(
                                              value: car.id ?? '',
                                              context: context,
                                            );

                                            if (result is DataSuccess) {
                                              // Refresh the cars list after successful deletion

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Car deleted successfully!'),
                                                    backgroundColor:
                                                        Colors.green,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                                final carsProvider =
                                                    Provider.of<CarsProvider>(
                                                        context,
                                                        listen: false);
                                                await carsProvider
                                                    .eitherFailureOrCars();
                                              }
                                            } else if (result is DataFailed) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to delete car: ${result.error?.message ?? 'Unknown error'}'),
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'Delete',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
