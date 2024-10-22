import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSize;
  final TextDecoration? underline;
  final Color? decorationColor;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;

  const TextWidget({
    super.key,
    required this.text,
    required this.color,
    this.fontSize,
    this.underline,
    this.decorationColor,
    this.fontWeight,
    this.maxLines,
    this.textOverflow
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      overflow: textOverflow,
      text,
      style: GoogleFonts.urbanist(
        color: color,
        fontWeight: fontWeight,
        decorationColor: decorationColor,
        decoration: underline,
        fontSize: fontSize ?? 14.0,
      ),
    );
  }
}
