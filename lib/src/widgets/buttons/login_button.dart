import 'package:car_app_beta/src/widgets/buttons/animated_press_button.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Lottie.asset('assets/images/login.json'),
          ),
          // const TextDef(
          //   "It seems you are not logged in.",
          //   fontSize: 16,
          //   fontWeight: FontWeight.bold,
          // ),
          const SizedBox(height: 20),
          AnimatedPressButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            label: "Login",
          ),
          verticalSpace(30)
        ],
      ),
    );
  }
}
