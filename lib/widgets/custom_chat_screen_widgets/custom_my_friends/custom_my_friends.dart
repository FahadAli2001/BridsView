import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMyFriends extends StatelessWidget {
  const CustomMyFriends({super.key});

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
          "test@gmail.com",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
