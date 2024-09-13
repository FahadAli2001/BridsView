import 'package:birds_view/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  const CustomButton({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: size.width,
        height: size.height * 0.06,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(button), fit: BoxFit.fill)),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.018,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
