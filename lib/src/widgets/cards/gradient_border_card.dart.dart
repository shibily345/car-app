import 'package:flutter/material.dart';

class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final EdgeInsets? padding;
  final double borderWidth;
  final double radius;

  const GradientBorderCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.padding,
    this.borderWidth = 2,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultGradient = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? defaultGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(radius - 2),
        ),
        child: child,
      ),
    );
  }
}
