import 'package:flutter/material.dart';

class CustomHeadingText extends StatelessWidget {
  final String heading;
  const CustomHeadingText({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Text(
      heading,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size.height * 0.026),
    );
  }
}
