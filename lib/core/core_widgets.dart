import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Ctext extends StatelessWidget {
  const Ctext(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  final List<TextSegment> segments;

  const CustomRichText({
    super.key,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: TextStyle(
              fontWeight: segment.fontWeight,
              color: segment.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Define a model for the text segments
class TextSegment {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;

  final Color color;

  TextSegment({
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.fontSize = 14,
  });
}

class ThickDevider extends StatelessWidget {
  const ThickDevider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 10,
      color: Color.fromARGB(255, 230, 230, 230),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  const OutlineButton({
    super.key,
    this.onPressed,
    this.label,
    this.icon,
    this.backgroundColor,
    this.padding,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton.icon(
          onPressed: onPressed ?? () {},
          //  style: ButtonStyle(),
          icon: Icon(
            icon ?? Icons.phone,
            size: 20,
          ),
          label: Ctext(label ?? "Call")),
    );
  }
}

class SpContainer extends StatelessWidget {
  const SpContainer({
    super.key,
    this.height,
    this.child,
    this.width,
  });
  final double? height;
  final Widget? child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height ?? 200,
      width: width ?? MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(35),
        ),
        color: Color.fromARGB(255, 2, 62, 111),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 3),
        //   height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 235, 243, 255),
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}

class CTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  const CTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        cursorColor:
            Theme.of(context).primaryColor, // Match cursor color to theme
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText ?? 'Toyota',
          labelStyle: TextStyle(color: Colors.grey[700]), // Subtle label color
          hintStyle: TextStyle(color: Colors.grey[400]), // Faded hint color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            borderSide: BorderSide(
                color: Colors.grey[200]!, width: 2.0), // Light border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0), // Border highlights on focus
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
                color: Colors.red, width: 2.0), // Red border for errors
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
                color: Colors.red[900]!,
                width: 2.0), // Darker red border for emphasized errors
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 14.0), // Adjust padding for comfort
          suffixIcon: suffixIcon, // Optional suffix icon placement
        ),
        validator: validator,
        focusNode: focusNode,
        onChanged: onChanged,
      ),
    );
  }
}

const List<String> _list = [
  'Manual',
  'Automatic',
  'Hybride',
];

class CDropDown extends StatelessWidget {
  const CDropDown({super.key, this.label, this.items, this.onChanged});
  final String? label;
  final List<String>? items;
  final ValueChanged<dynamic>? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CustomDropdown<String>(
        decoration: CustomDropdownDecoration(
          closedFillColor: Theme.of(context).splashColor,
          closedBorderRadius: BorderRadius.circular(12.0),
        ),
        hintText: label ?? 'Select',
        hintBuilder: (context, hint, enabled) {
          return Text(hint);
        },
        items: items ?? _list,
        onChanged: onChanged ??
            (value) {
              print('changing value to: $value');
            },
      ),
    );
  }
}
