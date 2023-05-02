import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: AppColors.primaryColor,
            value: value,
            onChanged: (bool? newValue) {
              onChanged(newValue!);
            },
          ),
          (value == false)
              ? Expanded(
                  child: AppText(
                    text: label,
                    color: AppColors.textColor,
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                )
              : Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
