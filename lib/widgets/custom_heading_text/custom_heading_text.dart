import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeadingText extends StatelessWidget {
  final String heading;
  const CustomHeadingText({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Text(
      heading,
      style: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size.height * 0.026),
    );
  }
}
