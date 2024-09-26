import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGroups extends StatelessWidget {
  const CustomGroups({super.key});

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(
          "Night Club Friends",
          style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.02),
        ),
        subtitle: Text(
          "you sent an message",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
        trailing: Text(
          "9:03",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}