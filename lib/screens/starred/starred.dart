import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';

class StarredNotes extends StatefulWidget {
  const StarredNotes({super.key});

  @override
  State<StarredNotes> createState() => _StarredNotesState();
}

class _StarredNotesState extends State<StarredNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const AppText(
          text: "Starred",
          color: AppColors.textColor,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
