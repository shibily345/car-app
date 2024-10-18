import 'package:car_app_beta/src/features/auth/presentation/pages/widgets.dart';
import 'package:flutter/material.dart';

class DecisionPage extends StatelessWidget {
  const DecisionPage({super.key});
  static const routeName = "/decision";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginBar(
              ontap: () {
                Navigator.pushNamed(context, "/addSeller");
              },
              text: "Be A Seller",
            ),
            LoginBar(
              ontap: () {
                Navigator.pushNamed(context, "/");
              },
              text: "Just Explore Or Buy",
            )
          ],
        ),
      ),
    );
  }
}
