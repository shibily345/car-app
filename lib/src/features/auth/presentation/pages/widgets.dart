import 'package:flutter/material.dart';

class LoginBar extends StatelessWidget {
  final String? text;
  final GestureTapCallback? ontap;
  const LoginBar({
    super.key,
    this.text,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(5)),
        child: Text(text ?? "Google"),
      ),
    );
  }
}
