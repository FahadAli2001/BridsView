import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/chat_screens/chatroom_screen/chatroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class CustomMyFriends extends StatelessWidget {
  const CustomMyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const ChatroomScreen(),
                  type: PageTransitionType.fade));
        },
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
        trailing: Icon(
          Icons.more_vert,
          color: whiteColor,
        ),
      ),
    );
  }
}
