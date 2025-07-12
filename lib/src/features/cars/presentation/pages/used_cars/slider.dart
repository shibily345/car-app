import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/widgets/buttons/bouncing_icon_button.dart';
import 'package:car_app_beta/src/widgets/buttons/icon_animated_button.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:car_app_beta/src/widgets/cards/glass_card.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class SliderHome extends StatelessWidget {
  const SliderHome({
    super.key,
    required this.carData,
  });
  final List<CarEntity> carData;
  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(viewportFraction: 0.95);
    List<String?> firstImages = carData
        .map((car) => car.images!.isNotEmpty ? car.images!.first : null)
        .toList();

    return SizedBox(
      height: 500.h,
      child: PageView.builder(
        controller: pageController,
        itemCount: firstImages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/carDetails",
                  arguments: carData[index]);
              // Navigator.push(
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Tapped on Image ${index + 1}')
              // ),
              // );
            },
            child: AnimatedBuilder(
              animation: pageController,
              builder: (context, child) {
                num value = 1;
                if (pageController.position.haveDimensions) {
                  value = (pageController.page ?? 0) - index;
                } else {
                  value = pageController.initialPage - index.toDouble();
                }

                value = value.clamp(-1, 1);

                double scale = 0.98 - (value.abs() * 0.1);
                double translateX = value * 85;
                double translateZ = value * 40;
                double opacity = (1 - value.toDouble().abs()).clamp(0.3, 1.0);

                return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(scale)
                      ..translate(translateX, 0, translateZ),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: child,
                      ),
                    ));
              },
              child: CarSlideWidget(
                firstImages: firstImages,
                carData: carData,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarSlideWidget extends StatelessWidget {
  const CarSlideWidget({
    super.key,
    required this.firstImages,
    required this.carData,
    required this.index,
  });
  final int index;
  final List<String?> firstImages;
  final List<CarEntity> carData;

  @override
  Widget build(BuildContext context) {
    bool isLoggedin = context.watch<UserProvider>().firebaseUser != null;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: "${Ac.baseUrl}${firstImages[index]!}",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter, // Gradient starts from the top
              end: Alignment.bottomLeft, // Gradient ends at the bottom-left
              colors: [
                Colors.transparent,
                Colors.black, // Black at the end
              ],
              stops: [0.38, 0.8], // 20% green, 80% black
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          height: 600.h,
        ),
        Positioned(
          bottom: 30.h,
          right: 30.w,
          child: BouncingIconButton(
            // activeColor: Theme.of(context).colorScheme.primary,
            // label: 'Like',
            onPressed: () {
              if (!isLoggedin) {
                StyledDialog.show(
                    context: context, content: const LoginButton());
                return;
              }
              if (context
                  .read<UserProvider>()
                  .currentFavorites
                  .contains(carData[index].id!)) {
                context
                    .read<UserProvider>()
                    .removeProductFromFavorites(carData[index].id!);
              } else {
                context
                    .read<UserProvider>()
                    .addProductToFavorites(carData[index].id!);
              }
            },
            icon: context
                    .read<UserProvider>()
                    .currentFavorites
                    .contains(carData[index].id!)
                ? FontAwesomeIcons.heartCircleCheck
                : FontAwesomeIcons.heart,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Positioned(
            bottom: 30.h,
            left: 30.w,
            child: SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ctext(
                    carData[index].make!,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                  Ctext(
                    "${carData[index].model!} ${carData[index].year!}",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  10.h.spaceY,
                  GlassCard(
                      padding: const EdgeInsets.all(10),
                      radius: 10,
                      opacity: 0.2,
                      // width: 10,
                      // height: 20,
                      child: Ctext(
                        "\$ ${carData[index].price!}",
                        fontSize: 24,
                        color: Colors.white,
                      ))
                ],
              ),
            )),
      ],
    );
  }
}
