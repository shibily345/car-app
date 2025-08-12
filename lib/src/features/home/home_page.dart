import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/partner_tile.dart';
import 'package:car_app_beta/src/widgets/buttons/animated_press_button.dart';
import 'package:car_app_beta/src/widgets/cards/glass_card.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final ScrollController? scrollController;
  const HomePage({super.key, this.scrollController});

  Future<void> _onRefresh(BuildContext context) async {
    // Refresh user data and sellers
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.eitherFailureOrAllSellers();
    // Add a small delay to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF),

            Color.fromARGB(255, 100, 111, 184),

            Color.fromARGB(255, 65, 46, 131), // White
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Image.asset(
              'assets/images/logoc.png',
              height: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.solidBell,
                size: 30,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
            horizontalSpaceSmall,
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                RichText(
                  text: TextSpan(
                    text: 'What Can We ',
                    style: const TextStyle(
                      fontSize: 32, // Increased font size for height
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Montserrat', // Styled with a different font
                    ),
                    children: [
                      TextSpan(
                        text: 'Help You Drive',
                        style: TextStyle(
                          fontSize: 32, // Increased font size for height
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily:
                              'Montserrat', // Styled with a different font
                        ),
                      ),
                      const TextSpan(
                        text: ' Today?',
                        style: TextStyle(
                          fontSize: 32, // Increased font size for height
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily:
                              'Montserrat', // Styled with a different font
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms),
                verticalSpaceSmall,
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildFeatureCard(
                      context,
                      title: 'Used Cars',
                      description:
                          'Explore a wide range of used cars at affordable prices.',
                      icon: Icons.directions_car,
                      onPressed: () {
                        Navigator.pushNamed(context, '/usedCars');
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Rent a Car',
                      description:
                          'Find the perfect car rental for your needs.',
                      icon: Icons.car_rental,
                      onPressed: () {
                        Navigator.pushNamed(context, '/rentCar');
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Spare Parts',
                      description: 'Get genuine spare parts for your vehicle.',
                      icon: Icons.build,
                      onPressed: () {
                        Navigator.pushNamed(context, '/spareParts');
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Book Service',
                      description: 'Book a service appointment for your car.',
                      icon: Icons.miscellaneous_services,
                      onPressed: () {
                        Navigator.pushNamed(context, '/bookService');
                      },
                    ),
                  ]
                      .animate()
                      .scale(duration: 400.ms, curve: Curves.easeInOut)
                      .fadeIn(duration: 400.ms, curve: Curves.easeInOut),
                ),
                verticalSpaceMedium,
                const Text(
                  'Partners',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpaceMedium,
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    List<SellerModel> allSellers =
                        userProvider.allSellers ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allSellers.length,
                      itemBuilder: (context, index) {
                        final seller = allSellers[index];
                        if (seller.photoURL.startsWith('http')) {
                          return const SizedBox.shrink();
                        }
                        return PartnerTile(seller: seller);
                      },
                    ).animate().moveY(duration: 300.ms);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Stack(
      children: [
        GlassCard(
          padding: EdgeInsets.zero,
          opacity: 0.8,
          // height: 230.h,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Icon(
            icon,
            size: 388,
            color: Theme.of(context).primaryColor.withAlpha(30),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: AnimatedPressButton(
            onPressed: onPressed,
            label: 'Explore',
          ),
        ),
      ],
    );
  }
}
