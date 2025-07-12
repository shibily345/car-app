import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkInternetConnectivity();
    await _navigateBasedOnLoginStatus();
  }

  Future<void> _checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content:
            const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateBasedOnLoginStatus() async {
    // await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _handleAuthenticatedUser(user);
    } else {
      _navigateToLogin();
    }
  }

  Future<void> _handleAuthenticatedUser(User user) async {
    final authProvider = context.read<AuthenticationProvider>();
    final userProvider = context.read<UserProvider>();
    // final carsProvider = context.read<CarsProvider>();

    userProvider.eitherFailureOrAllSellers();
    // await carsProvider.eitherFailureOrCars();

    final isSeller = await authProvider.checkSeller(user.uid);
    if (isSeller) {
      userProvider.updateSeller(true);
      userProvider.eitherFailureOrSeller(value: user.uid);
    }

    context.read<CarCreateProvider>().clearAll();
    _navigateToMain();
  }

  void _navigateToMain() {
    Navigator.pushReplacementNamed(context, '/s');
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          _BackgroundLogo(),
          _MainContent(),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SpaceY(MediaQuery.of(context).size.height * 0.35),
          _LoadingAnimation(theme: theme),
          const Spacer(),
          _FooterLogo(theme: theme),
          const SpaceY(20),
        ],
      ),
    );
  }
}

class _LoadingAnimation extends StatelessWidget {
  final ThemeData theme;

  const _LoadingAnimation({required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Lottie.asset(
        'assets/data/carLoading.json',
        fit: BoxFit.contain,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.colorFilter(
              ['**'],
              value: ColorFilter.mode(
                theme.primaryColor,
                BlendMode.srcATop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLogo extends StatelessWidget {
  final ThemeData theme;

  const _FooterLogo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/sfdb.png",
      height: 80,
      color: theme.primaryColor,
    );
  }
}

class _BackgroundLogo extends StatelessWidget {
  const _BackgroundLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: 50,
      left: 0,
      child: Image.asset(
        "assets/images/logoc.png",
        width: 900,
        height: 900,
        color: theme.primaryColor.withAlpha(10),
      ),
    );
  }
}
