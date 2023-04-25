import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color color;
  final double height;
  final double radius;
  const AppButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.color,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 4,
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
      height: height,
      minWidth: 70,
      color: color,
      child: child,
    );
  }
}
