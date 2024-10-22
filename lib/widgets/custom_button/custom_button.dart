import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

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
        width: size.width * 0.5,
        height: size.height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white
            // gradient: gradientColor
            ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.019,
                color: Colors.black),
          ),
        ),
      ),
    );
  }
}
