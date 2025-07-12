import 'dart:async';

import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/model/onboard_model.dart';
import 'package:car_app_beta/src/widgets/buttons/animated_press_button.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);
    return Scaffold(
      body: BuildBody(size: size, th: th),
    );
  }
}

class BuildBody extends StatefulWidget {
  const BuildBody({
    super.key,
    required this.size,
    required this.th,
  });

  final Size size;
  final ThemeData th;

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  late Future<OnboardingData> onboardingData;
  final PageController _pageControllerImage = PageController();
  final PageController _pageControllerText = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    onboardingData = loadOnboardingData();
    _startAutoScroll();
  }



  @override
  void dispose() {
    _timer?.cancel();
    _pageControllerImage.dispose();
    _pageControllerText.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageControllerImage.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _pageControllerText.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OnboardingData>(
        future: onboardingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading onboarding data'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: widget.size.width,
                    height: widget.size.height * 0.6,
                    color: widget.th.splashColor,
                    child: SizedBox(
                      height: widget.size.height * 0.23,
                      child: PageView.builder(
                        controller: _pageControllerImage,
                        itemCount: data.onboarding.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 0.8,
                                colors: [
                                  Colors.white,
                                  widget.th.primaryColor.withOpacity(0.4),
                                ],
                                stops: const [0.3, 1.0],
                              ),
                            ),
                            child: Center(
                                child:
                                    Lottie.asset(data.onboarding[index].image)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.size.height * 0.23,
                  child: PageView.builder(
                    controller: _pageControllerText,
                    itemCount: data.onboarding.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 45.h,
                          left: 40.w,
                          right: 40.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDef(
                              maxLines: 2,
                              data.onboarding[index].title,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                            ),
                            TextDef(
                              fontSize: 16,
                              data.onboarding[index].paragraph,
                              maxLines: 4,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AnimatedPressButton(
                    height: 60.h,
                    borderRadius: 50,
                    icon: FontAwesomeIcons.arrowRight,
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login2');
                    },
                    width: screenWidth(context),
                  ),
                ),
                const SpaceY(30),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 4,
        size.height - 40,
        size.width / 2,
        size.height - 20,
      )
      ..quadraticBezierTo(
        3 / 4 * size.width,
        size.height,
        size.width,
        size.height - 30,
      )
      ..lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
