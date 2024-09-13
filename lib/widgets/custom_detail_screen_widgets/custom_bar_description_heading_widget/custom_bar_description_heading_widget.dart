import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBarDescriptionHeadingWidget extends StatelessWidget {
  final Size size;

  const CustomBarDescriptionHeadingWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Description',
          style: GoogleFonts.urbanist(
              fontSize: size.height * 0.026,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ));
  }
}
