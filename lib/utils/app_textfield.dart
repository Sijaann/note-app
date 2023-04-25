import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/utils/colors.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final bool hide;
  final Icon? leadingIcon;
  final IconButton? iconButton;
  final double radius;
  final TextEditingController? controller;
  final TextInputType? type;
  final String hintText;
  final int? maxLines;
  final bool? readOnly;
  const AppTextField({
    super.key,
    this.labelText,
    required this.hide,
    this.leadingIcon,
    this.iconButton,
    required this.radius,
    this.controller,
    this.type,
    required this.hintText,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hintText";
        }
      },
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      obscureText: hide,
      readOnly: readOnly!,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        hintStyle: GoogleFonts.raleway(
          fontSize: 15,
          color: AppColors.hintTextColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(width: 2),
        ),
        prefixIcon: leadingIcon,
        suffixIcon: iconButton,
      ),
    );
  }
}
