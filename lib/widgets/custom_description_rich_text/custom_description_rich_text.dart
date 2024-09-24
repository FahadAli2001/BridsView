import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDescriptionRichText extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomDescriptionRichText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFC59241), // Left side color
                  Color(0xFFFEF6D1), // Center color
                  Color(0xFFC49138), // Right side color
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.016,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    color: Colors.white),
              ),
            ),
          ),
          TextSpan(
            text: subtitle,
            style: GoogleFonts.urbanist(
              fontSize: size.height * 0.016,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
