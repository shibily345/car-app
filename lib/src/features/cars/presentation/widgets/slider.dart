import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../extensions.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../business/entities/car_list_entity.dart';
import '../../../../widgets/buttons/bouncing_icon_button.dart';
import '../../../../widgets/buttons/login_button.dart';
import '../../../../widgets/overlays/styled_overlays.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({super.key, required this.carData});
  final List<CarEntity> carData;

  @override
  State<SliderHome> createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.88);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String?> firstImages = widget.carData
        .map((car) => car.images?.isNotEmpty == true ? car.images!.first : null)
        .toList();

    return Column(
      children: [
        SizedBox(
          height: 500.h,
          child: PageView.builder(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: firstImages.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 0;
                  if (pageController.position.haveDimensions) {
                    value = pageController.page! - index;
                  } else {
                    value = (pageController.initialPage - index).toDouble();
                  }
                  value = (1 - (value.abs() * 0.2)).clamp(0.9, 1.0);

                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/carDetails",
                    arguments: widget.carData[index],
                  ),
                  child: CarSlideWidget(
                    car: widget.carData[index],
                    imageUrl: "${Ac.baseUrl}${firstImages[index]!}",
                  ),
                ),
              );
            },
          ),
        ),

        // Modern Indicator
        if (widget.carData.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.carData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentIndex == index ? 22.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CarSlideWidget extends StatelessWidget {
  const CarSlideWidget({
    super.key,
    required this.car,
    required this.imageUrl,
  });

  final CarEntity car;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    bool isLoggedin = context.watch<UserProvider>().firebaseUser != null;
    bool isFavorite =
        context.watch<UserProvider>().currentFavorites.contains(car.id!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Stack(
        children: [
          // Car Image
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (_, __) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => const Icon(Icons.error_outline),
          ),

          // Gradient overlay for better readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Car Info
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16.r),
                // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.make!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.spaceY,
                  Text(
                    "${car.model!} ${car.year!}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16.sp,
                    ),
                  ),
                  10.spaceY,
                  Row(
                    children: [
                      _FeatureChip(icon: Icons.speed, text: "${car.mileage}km"),
                      8.spaceX,
                      _FeatureChip(
                          icon: Icons.local_gas_station, text: car.fuel!),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Favorite & Share Buttons
          Positioned(
            top: 20.h,
            right: 20.w,
            child: Column(
              children: [
                _CircleButton(
                  color: isFavorite
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  icon: isFavorite
                      ? FontAwesomeIcons.heartCircleCheck
                      : FontAwesomeIcons.heart,
                  iconColor: isFavorite
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  onTap: () {
                    if (!isLoggedin) {
                      StyledDialog.show(
                          context: context, content: const LoginButton());
                      return;
                    }
                    if (isFavorite) {
                      context
                          .read<UserProvider>()
                          .removeProductFromFavorites(car.id!);
                    } else {
                      context
                          .read<UserProvider>()
                          .addProductToFavorites(car.id!);
                    }
                  },
                ),
                12.spaceY,
                _CircleButton(
                  color: Colors.white,
                  icon: Icons.share,
                  iconColor: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    // Share logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.white),
          6.spaceX,
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 46.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 18.sp, color: iconColor),
      ),
    );
  }
}
