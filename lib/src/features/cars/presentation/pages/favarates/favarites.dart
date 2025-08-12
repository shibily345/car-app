import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  final ScrollController? scrollController;
  const FavoritePage({super.key, this.scrollController});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadFavorites();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load favorites from Firebase
      await context.read<UserProvider>().getFavoriteProductIds();

      // Add a small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
      });

      _animationController.forward();

      // Show success message
      if (mounted) {
        final currentTheme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Favorites refreshed successfully!'),
            backgroundColor: currentTheme.colorScheme.primary,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load favorites: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer2<UserProvider, CarsProvider>(
        builder: (context, userProvider, carsProvider, _) {
          // Check if user is logged in
          if (userProvider.firebaseUser == null) {
            return _buildLoginRequired(theme);
          }

          // Show loading state
          if (_isLoading) {
            return _buildLoadingState(theme);
          }

          // Get favorite cars
          final favoriteCars = _getFavoriteCars(userProvider, carsProvider);

          // Show empty state if no favorites
          if (favoriteCars.isEmpty) {
            return _buildEmptyState(theme);
          }

          // Show favorites list
          return _buildFavoritesList(theme, userProvider, favoriteCars);
        },
      ),
    );
  }

  Widget _buildLoginRequired(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildCustomAppBar(theme, "Favorites"),

            // Login Content
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 64.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ).animate().scale(delay: 200.ms).then().shake(),

                      SizedBox(height: 24.h),

                      // Title
                      Text(
                        'Sign in to view your favorites',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

                      SizedBox(height: 12.h),

                      // Subtitle
                      Text(
                        'Save your favorite cars and access them anytime',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

                      SizedBox(height: 32.h),

                      // Login Button
                      const LoginButton()
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .slideY(begin: 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(theme, "Favorites"),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading your favorites...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(theme, "Favorites"),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Empty Icon
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: 64.sp,
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ).animate().scale(delay: 200.ms).then().shake(),

                      SizedBox(height: 24.h),

                      // Title
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

                      SizedBox(height: 12.h),

                      // Subtitle
                      Text(
                        'Start exploring cars and add them to your favorites',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

                      SizedBox(height: 32.h),

                      // Browse Button
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, "/search");
                        },
                        icon: Icon(Icons.search, size: 20.sp),
                        label: Text(
                          'Browse Cars',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(ThemeData theme, UserProvider userProvider,
      List<CarEntity> favoriteCars) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(theme, "Favorites (${favoriteCars.length})"),

            // Stats Card
            _buildStatsCard(theme, favoriteCars),

            // Favorites List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadFavorites,
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surface,
                strokeWidth: 3.0,
                displacement: 20.h,
                child: ListView.builder(
                  controller: widget.scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: favoriteCars.length,
                  itemBuilder: (context, index) {
                    final car = favoriteCars[index];
                    return CarLisTile(
                      car: car,
                      index: index,
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: index * 100),
                          duration: 400.ms,
                        )
                        .slideX(
                          begin: 0.3,
                          end: 0,
                          delay: Duration(milliseconds: index * 100),
                          duration: 400.ms,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme, String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : _loadFavorites,
            icon: _isLoading
                ? SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : Icon(
                    Icons.refresh,
                    color: theme.colorScheme.onSurface,
                    size: 24.sp,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, List<CarEntity> favoriteCars) {
    final totalValue = favoriteCars.fold<double>(
      0,
      (sum, car) => sum + (car.price ?? 0),
    );

    final avgPrice =
        favoriteCars.isNotEmpty ? totalValue / favoriteCars.length : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total Cars
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  color: theme.colorScheme.primary,
                  size: 24.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  '${favoriteCars.length}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Cars',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 40.h,
            width: 1,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),

          // Average Price
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.attach_money,
                  color: theme.colorScheme.secondary,
                  size: 24.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'AED ${avgPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Avg Price',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 40.h,
            width: 1,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),

          // Total Value
          Expanded(
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: theme.colorScheme.tertiary,
                  size: 24.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'AED ${totalValue.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Total Value',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3);
  }

  List<CarEntity> _getFavoriteCars(
      UserProvider userProvider, CarsProvider carsProvider) {
    if (carsProvider.cars == null) return [];

    return carsProvider.cars!.where((car) {
      return userProvider.currentFavorites.contains(car.id);
    }).toList();
  }
}
