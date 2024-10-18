import 'package:flutter/material.dart';

class TextDef extends StatelessWidget {
  const TextDef(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.textDecoration,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.overflow,
    this.maxLines,
    this.style,
    this.opacity,
  });
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextStyle? style;
  final double? opacity;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      style: style?.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color ??
                Theme.of(context).indicatorColor.withOpacity(opacity ?? 1),
            decoration: textDecoration,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            height: height,
          ) ??
          TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            decoration: textDecoration,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            height: height,
          ),
    );
  }
}

class FaqText extends StatelessWidget {
  const FaqText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(children: []),
    );
  }
}
