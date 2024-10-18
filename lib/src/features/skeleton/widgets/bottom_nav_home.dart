import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/favarates/favarites.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/home/home_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/profile/profile_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/search/search.dart';
import 'package:car_app_beta/src/features/skeleton/model/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class SkeletonNav extends StatefulWidget {
  const SkeletonNav({super.key});

  @override
  _SkeletonNavState createState() => _SkeletonNavState();
}

class _SkeletonNavState extends State<SkeletonNav> {
  // int _selectedIndex = 0;
  final PageController _pageController = PageController();

  List<rive.SMIBool> riveIconInputs = [];
  List<rive.StateMachineController?> controllers = [];
  int selctedNavIndex = 0;

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
              // _selectedIndex = index;
              selctedNavIndex = index;
            });
          },
          children: [
            const HomePage(),
            const SearchPage(),
            const FavoritePage(),
            ProfilePage(),
            // HabitStatisticsPage(),
            // NewHabitPage(),
            // SettingsPage(),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: CustomContainer(
            gradient: LinearGradient(
              colors: isLight
                  ? [
                      const Color.fromARGB(255, 217, 234, 248),
                      const Color.fromARGB(255, 242, 214, 246)
                    ]
                  : [
                      const Color.fromARGB(255, 38, 60, 81),
                      const Color.fromARGB(255, 77, 45, 82)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            // decoration: BoxDecoration(
            color: th.primaryColorLight,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: BoxShadow(
              color: th.shadowColor.withOpacity(0.3),
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
            // ],
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(bottomNavItemsDark.length, (index) {
                final riveIcon = bottomNavItemsDark[index];
                return GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
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
        ));
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
