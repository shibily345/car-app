import 'package:car_app_beta/core/widgets/text.dart';
import 'package:flutter/material.dart';

class ButtonDef extends StatelessWidget {
  const ButtonDef({
    super.key,
    this.things,
    this.height,
    this.width,
    this.onTap,
  });
  final Widget? things;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(width ?? 200, height ?? 30),
        ),
      ),
      child: things ?? const TextDef('Example'),
    );
  }
}

class SpaceX extends StatelessWidget {
  const SpaceX(this.space, {super.key});
  final double? space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space ?? 20,
    );
  }
}

class SpaceY extends StatelessWidget {
  const SpaceY(this.space, {super.key});
  final double? space;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space ?? 20,
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final DecorationImage? image;
  final AlignmentGeometry? alignment;
  final Gradient? gradient;
  final VoidCallback? ontap;
  const CustomContainer({
    super.key,
    this.child,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.gradient,
    this.ontap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        alignment: alignment,
        padding: padding,
        margin: margin ?? const EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary.withAlpha(80),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          border: border,
          image: image,
          // gradient: gradient ??
          //     LinearGradient(
          //       colors: [
          //         // Colors.white,
          //         // Theme.of(context).colorScheme.primary.withOpacity(0.7)
          //       ],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
        ),
        child: child,
      ),
    );
  }
}
