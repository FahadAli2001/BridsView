import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDescriptionRichText extends StatelessWidget {
  final String title;
  final String subtitle;
  const CustomDescriptionRichText(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RichText(
      text: TextSpan(
        text: title,
        style: GoogleFonts.urbanist(
            fontSize: size.height * 0.016,
            fontWeight: FontWeight.bold,
            height: 2,
            color: primaryColor),
        children: [
          TextSpan(
            text: subtitle,
            style: GoogleFonts.urbanist(
                fontSize: size.height * 0.016,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
