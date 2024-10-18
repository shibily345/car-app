import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    final ap = Provider.of<AuthenticationProvider>(context, listen: false);
    final up = Provider.of<UserProvider>(context, listen: false);
    if (user != null) {
      up.eitherFailureOrAllSellers();
      Provider.of<CarsProvider>(context, listen: false)
          .eitherFailureOrCars()
          .then((ok) async {
        bool isSeller = await ap.checkSeller(user.uid);
        if (isSeller) {
          up.updateSeller(true);
          // debugPrint("----------------   yessssss it Issssss  ------------");
          up.eitherFailureOrSeller(value: user.uid);
          Navigator.pushReplacementNamed(
            context,
            '/s',
          );
        } else {
          ap.updateUser(user);
          Navigator.pushReplacementNamed(
            context,
            '/s',
          );
        }
      });

      // context.read<CarCreateProvider>().clearAll;

      // Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SpaceY(
              MediaQuery.of(context).size.height * 0.35,
            ),
            SizedBox(
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
                          th.indicatorColor,
                          BlendMode.srcATop,
                        ),
                      ),
                    ],
                  ),
                )),
            const Spacer(),
            // const TextDef("By"),
            Image.asset(
              "assets/images/sfdb.png",
              height: 80,
              color: Theme.of(context).indicatorColor,
            ),
            const SpaceY(20)
          ],
        ),
      ),
    );
  }
}
