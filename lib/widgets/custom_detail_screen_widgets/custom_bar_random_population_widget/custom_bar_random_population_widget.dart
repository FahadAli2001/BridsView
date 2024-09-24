import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBarRandomPopulationWidget extends StatelessWidget {
  final String text;
  final Size size;
  const CustomBarRandomPopulationWidget(
      {super.key, required this.size, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.07,
      left: size.width * 0.32,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
            fontSize: size.height * 0.026,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
