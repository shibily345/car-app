import 'dart:async';
import 'dart:math' as math;

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
    return const OnboardingScreen();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late Future<OnboardingData> onboardingData;
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _gradientController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _gradientAnimation;

  int _currentPage = 0;
  bool _isLastPage = false;

  // Darker gradient colors
  final List<Color> _gradientColors = [
    const Color(0xFF000000), // Pure black
    const Color(0xFF0A0A0A), // Very dark gray
    const Color(0xFF1A1A1A), // Dark gray
    const Color(0xFF2C2C2C), // Medium dark gray
    const Color(0xFF1E3A8A), // Dark blue
  ];

  @override
  void initState() {
    super.initState();
    onboardingData = loadOnboardingData();

    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<OnboardingData>(
        future: onboardingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            return _buildErrorScreen();
          } else if (snapshot.hasData) {
            return _buildOnboardingContent(snapshot.data!);
          } else {
            return _buildErrorScreen();
          }
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: const Center(
        child: Text(
          'Error loading onboarding data',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(OnboardingData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          _buildAnimatedBackground(),

          // Main content
          Column(
            children: [
              // Skip button
              _buildSkipButton(),

              // Main content area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: data.onboarding.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _isLastPage = index == data.onboarding.length - 1;
                    });
                    _animationController.reset();
                    _animationController.forward();
                  },
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(data.onboarding[index], index);
                  },
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(data.onboarding.length),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating circles
              Positioned(
                top:
                    100 + math.sin(_gradientAnimation.value * 2 * math.pi) * 20,
                left:
                    50 + math.cos(_gradientAnimation.value * 2 * math.pi) * 30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top:
                    200 + math.cos(_gradientAnimation.value * 2 * math.pi) * 15,
                right:
                    80 + math.sin(_gradientAnimation.value * 2 * math.pi) * 25,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.cyan.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Additional floating elements for more visual interest
              Positioned(
                top:
                    300 + math.sin(_gradientAnimation.value * 3 * math.pi) * 10,
                left:
                    200 + math.cos(_gradientAnimation.value * 3 * math.pi) * 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.purple.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 40.h, right: 20.w),
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login2');
          },
          child: Text(
            'Skip',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingContent content, int index) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(_slideAnimation.value, 0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated image container
                  _buildAnimatedImageContainer(content.image),

                  SizedBox(height: 50.h),

                  // Title with modern typography
                  _buildAnimatedTitle(content.title),

                  SizedBox(height: 20.h),

                  // Description with elegant styling
                  _buildAnimatedDescription(content.paragraph),

                  SizedBox(height: 40.h),

                  // Feature highlights
                  _buildFeatureHighlights(index),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedImageContainer(String imagePath) {
    return Container(
      width: 280.w,
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.blue.withOpacity(0.1),
            Colors.cyan.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: Lottie.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(String title) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Colors.blue.shade300,
          Colors.cyan.shade300,
        ],
      ).createShader(bounds),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnimatedDescription(String description) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.white.withOpacity(0.8),
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFeatureHighlights(int index) {
    final features = [
      '🚗 All-in-One Platform',
      '💰 Best Deals',
      '⚡ Instant Access',
      '🔧 Quality Service',
      '📍 Local Support',
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        features[index],
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomNavigation(int totalPages) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentPage == index ? 30.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: _currentPage == index
                        ? [Colors.blue.shade600, Colors.blue.shade400]
                        : [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.05)
                          ],
                  ),
                  boxShadow: _currentPage == index
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              if (_currentPage > 0)
                _buildNavigationButton(
                  icon: FontAwesomeIcons.arrowLeft,
                  onPressed: _previousPage,
                  isPrimary: false,
                )
              else
                SizedBox(width: 60.w),

              // Next/Get Started button
              _buildNavigationButton(
                icon: _isLastPage
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.arrowRight,
                onPressed: _isLastPage
                    ? () => Navigator.pushReplacementNamed(context, '/login2')
                    : _nextPage,
                isPrimary: true,
                label: _isLastPage ? 'Get Started' : 'Next',
              ),
            ],
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
    String? label,
  }) {
    return Container(
      width: label != null ? 140.w : 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: isPrimary
              ? [Colors.blue.shade600, Colors.blue.shade400]
              : [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02)
                ],
        ),
        border: Border.all(
          color: isPrimary ? Colors.transparent : Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: label != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ],
                  )
                : Icon(
                    icon,
                    color: isPrimary
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    size: 20.sp,
                  ),
          ),
        ),
      ),
    );
  }
}
