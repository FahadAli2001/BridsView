import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomChat extends StatelessWidget {
  const CustomChat({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(
          "Name",
          style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.02),
        ),
        subtitle: Text(
          "last msg sent by you",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
        trailing: Text(
          "9:30",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
