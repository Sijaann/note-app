import 'package:flutter/material.dart';
import 'package:notes_app/utils/colors.dart';

void showSnackBar(
    {required BuildContext context,
    required String text,
    required Color textColor,
    required Color backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      showCloseIcon: true,
      closeIconColor: AppColors.textColor,
      dismissDirection: DismissDirection.horizontal,
      elevation: 4,
      content: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
