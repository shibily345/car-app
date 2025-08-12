import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/favarates/favarites.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/profile/profile_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/search/search.dart';
import 'package:car_app_beta/src/features/home/home_page.dart';
import 'package:car_app_beta/src/features/skeleton/model/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rive/rive.dart' as rive;

class SkeletonNav extends StatefulWidget {
  const SkeletonNav({super.key});

  @override
  _SkeletonNavState createState() => _SkeletonNavState();
}

class _SkeletonNavState extends State<SkeletonNav> {
  final PageController _pageController = PageController();

  List<rive.SMIBool> riveIconInputs = [];
  List<rive.StateMachineController?> controllers = [];
  int selctedNavIndex = 0;

  // Added for scroll-to-hide functionality
  late ScrollController _scrollController;
  bool _isNavBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isNavBarVisible) {
        setState(() {
          _isNavBarVisible = false;
        });
      }
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isNavBarVisible) {
        setState(() {
          _isNavBarVisible = true;
        });
      }
    }
  }

  void animateTheIcon(int index) {
    riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index].change(false);
      },
    );
  }

  void riveOnInIt(rive.Artboard artboard,
      {required String stateMachineName}) async {
    rive.StateMachineController? controller =
        rive.StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as rive.SMIBool);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    bool isLight = th.brightness == Brightness.light;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selctedNavIndex = index;
          });
        },
        // IMPORTANT: Pass the scroll controller to your pages.
        // Your pages must use this controller in their primary scrollable widget.
        children: [
          HomePage(scrollController: _scrollController),
          SearchPage(scrollController: _scrollController),
          FavoritePage(scrollController: _scrollController),
          ProfilePage(scrollController: _scrollController),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(
            0, _isNavBarVisible ? 0 : 120, 0), // Hides/shows the nav bar
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: th.shadowColor.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
              color: th.colorScheme.surface,
              border: Border.all(
                color: th.colorScheme.outline.withOpacity(0.1),
              ),
              gradient: LinearGradient(
                colors: isLight
                    ? [
                        const Color.fromARGB(255, 255, 255, 255),
                        const Color.fromARGB(255, 210, 231, 255)
                      ]
                    : [
                        const Color.fromARGB(255, 38, 60, 81),
                        const Color.fromARGB(255, 41, 40, 40)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(bottomNavItemsDark.length, (index) {
                  final riveIcon = bottomNavItemsDark[index];
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      animateTheIcon(index);
                      setState(() {
                        selctedNavIndex = index;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(isActive: selctedNavIndex == index),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity: selctedNavIndex == index ? 1 : 0.4,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                th.primaryColor,
                                BlendMode.modulate,
                              ),
                              child: rive.RiveAnimation.asset(
                                artboard: riveIcon.artboard,
                                riveIcon.src,
                                onInit: (artboard) {
                                  riveOnInIt(artboard,
                                      stateMachineName:
                                          riveIcon.stateMachineName);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}