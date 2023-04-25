import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/screens/login.dart';

import '../utils/app_text.dart';
import '../utils/colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                "assets/29488-note-icon.json",
                width: 200,
                height: 200,
              ),
            ),
            const AppText(
              text: "Notes",
              color: AppColors.primaryColor,
              size: 24,
              style: FontStyle.italic,
              weight: FontWeight.bold,
            ),
            const AppText(
              text: "App",
              color: AppColors.primaryColor,
              size: 16,
              style: FontStyle.italic,
              weight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}
