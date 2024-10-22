import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


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
    return Align(
      alignment: Alignment.topLeft,
      child: RichText(
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFC59241),
                    Color(0xFFFEF6D1),
                    Color(0xFFC49138),
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
              text: subtitle.trim(),
              style: GoogleFonts.urbanist(
                fontSize: size.height * 0.016,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
