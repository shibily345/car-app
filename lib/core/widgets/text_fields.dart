import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "$labelText Can't be empty";
              }
              return null;
            },
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: Theme.of(context).splashColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
