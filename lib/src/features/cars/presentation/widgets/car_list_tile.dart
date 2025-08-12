import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/cached_image.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as ta;
import 'package:url_launcher/url_launcher.dart';

class CarLisTile extends StatefulWidget {
  final CarEntity car;
  final int? index;

  const CarLisTile({
    super.key,
    required this.car,
    this.index,
  });

  @override
  State<CarLisTile> createState() => _CarLisTileState();
}

class _CarLisTileState extends State<CarLisTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _animationController.forward();
  }

  void _onTapUp() {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      onTap: () {
        Navigator.pushNamed(context, "/carDetails", arguments: widget.car);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section with Gradient Overlay
                    _buildImageSection(theme),

                    // Content Section
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price and Date Row
                          _buildPriceDateRow(theme),
                          SizedBox(height: 16.h),

                          // Car Title
                          _buildCarTitle(theme),
                          SizedBox(height: 8.h),

                          // Car Details
                          _buildCarDetails(theme),
                          SizedBox(height: 16.h),

                          // Location and Features
                          _buildLocationAndFeatures(theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: (widget.index ?? 0) * 100),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.3,
          end: 0,
          delay: Duration(milliseconds: (widget.index ?? 0) * 100),
          duration: 400.ms,
        );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Stack(
      children: [
        // Car Image
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          child: widget.car.images!.isEmpty
              ? Container(
                  height: 220.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 48.sp,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'No Image Available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : CachedImageWithShimmer(
                  imageUrl: Ac.baseUrl + widget.car.images!.first,
                  height: 220.h,
                  width: double.infinity,
                ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),

        // Year Badge
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              widget.car.type ?? 'N/A',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Transmission Badge
        Positioned(
          top: 16.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              widget.car.transmission ?? 'N/A',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDateRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        Text(
          'AED ${widget.car.price?.toStringAsFixed(0) ?? '0'}',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Date
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            ta.format(widget.car.updatedAt ?? DateTime.now()),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarTitle(ThemeData theme) {
    return Text(
      "${widget.car.make ?? 'Unknown'} ${widget.car.model ?? 'Car'}",
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCarDetails(ThemeData theme) {
    return Row(
      children: [
        _buildDetailChip(
          theme,
          Icons.local_gas_station,
          widget.car.fuel ?? 'N/A',
          theme.colorScheme.secondary,
        ),
        SizedBox(width: 8.w),
        _buildDetailChip(
          theme,
          Icons.speed,
          '${widget.car.mileage?.toString() ?? '0'} km',
          theme.colorScheme.tertiary,
        ),
        SizedBox(width: 8.w),
        _buildDetailChip(
          theme,
          Icons.calendar_today,
          '${widget.car.year ?? 'N/A'}',
          theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildDetailChip(
      ThemeData theme, IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndFeatures(ThemeData theme) {
    return Row(
      children: [
        // Location
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  widget.car.location ?? 'Location not specified',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Quick Actions
        Row(
          children: [
            _buildFavoriteButton(theme),
            SizedBox(width: 8.w),
            _buildShareButton(theme),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(ThemeData theme) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final isLoggedin = userProvider.firebaseUser != null;
        final isFavorite =
            userProvider.currentFavorites.contains(widget.car.id);

        return GestureDetector(
          onTap: () {
            if (!isLoggedin) {
              StyledDialog.show(
                context: context,
                content: const LoginButton(),
              );
              return;
            }

            if (isFavorite) {
              userProvider.removeProductFromFavorites(widget.car.id!);
            } else {
              userProvider.addProductToFavorites(widget.car.id!);
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 18.sp,
              color: isFavorite
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareButton(ThemeData theme) {
    return GestureDetector(
      onTap: () => _shareCar(),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.share,
          size: 18.sp,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Future<void> _shareCar() async {
    final car = widget.car;
    final title = "${car.make ?? 'Car'} ${car.model ?? ''}";
    final price = "AED ${car.price?.toStringAsFixed(0) ?? '0'}";
    final year = car.year?.toString() ?? 'N/A';
    final transmission = car.transmission ?? 'N/A';
    final fuel = car.fuel ?? 'N/A';
    final mileage = "${car.mileage?.toString() ?? '0'} km";
    final location = car.location ?? 'Location not specified';

    final shareText = '''
🚗 $title
💰 Price: $price
📅 Year: $year
⚙️ Transmission: $transmission
⛽ Fuel: $fuel
🛣️ Mileage: $mileage
📍 Location: $location

Check out this amazing car! 🚀
    '''
        .trim();

    final uri = Uri.parse(
        'mailto:?subject=$title&body=${Uri.encodeComponent(shareText)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback: copy to clipboard
      // You can add clipboard functionality here if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Share text copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

class CarListLoadingTile extends StatelessWidget {
  final int? index;

  const CarListLoadingTile({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 220.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 48.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),

          // Content placeholder
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and date placeholders
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 28.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      height: 20.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Title placeholder
                Container(
                  height: 20.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 8.h),

                // Details placeholder
                Row(
                  children: [
                    Container(
                      height: 16.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      height: 16.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      height: 16.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Location placeholder
                Container(
                  height: 16.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: (index ?? 0) * 100),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.3,
          end: 0,
          delay: Duration(milliseconds: (index ?? 0) * 100),
          duration: 400.ms,
        );
  }
}

class CarShortListLoadingTile extends StatelessWidget {
  const CarShortListLoadingTile({super.key});
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.read<CarsProvider>().eitherFailureOrCars();
        Navigator.pushNamed(context, "/carDetails");
      },
      child: Container(
        width: sz.width,
        padding: const EdgeInsets.all(10),
        color: th.splashColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: th.scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                height: 100,
                width: 100,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    height: 20,
                    width: 250,
                  ),
                  SpaceY(10),
                  CustomContainer(
                    height: 20,
                    width: 200,
                  ),
                  SpaceY(20),
                  CustomContainer(
                    height: 20,
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarShortListTile extends StatelessWidget {
  final CarEntity car;
  final VoidCallback? onTap;
  final Widget? delete;
  const CarShortListTile({
    super.key,
    required this.car,
    this.onTap,
    this.delete,
  });
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    final sz = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.pushNamed(context, "/carUpdate", arguments: car);
          },
      child: Container(
        width: sz.width,
        padding: const EdgeInsets.all(10),
        color: th.splashColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: th.scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedImageWithShimmer(
                imageUrl:
                    car.images!.isEmpty ? '' : Ac.baseUrl + car.images!.first,
                height: 100,
                width: 100,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDef("${car.make} ${car.model}"),
                  const SpaceY(10),
                  TextDef("${car.year}, ${car.transmission}"),
                  const SpaceY(20),
                  TextDef("AED ${car.price}"),
                ],
              ),
              const Spacer(),
              delete ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
