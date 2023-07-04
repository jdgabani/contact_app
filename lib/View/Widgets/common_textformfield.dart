import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField(
      {super.key,
      this.controller,
      required this.lable,
      this.keyboardType,
      this.textInputAction,
      this.suffixIcon,
      this.prefixIcon});

  final controller;
  final String lable;
  final keyboardType;
  final textInputAction;
  final suffixIcon;
  final prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        labelText: lable,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
