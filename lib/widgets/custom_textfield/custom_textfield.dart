import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String hintText;
  final String labelText;
  final bool? obsecure;
  final Icon? icon;
  final VoidCallback? iconOnTap;
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.labelText,
      this.textEditingController,
      this.icon,
      this.obsecure,
      this.iconOnTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextField(
        obscureText: obsecure!,
        style: const TextStyle(color: Colors.white60),
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.urbanist(color: Colors.black),
          labelText: labelText,
          labelStyle: GoogleFonts.urbanist(color: Colors.white60),
          suffixIcon: icon != null
              ? GestureDetector(
                  onTap: iconOnTap,
                  child: icon!,
                )
              : null,
        ),
      ),
    );
  }
}
