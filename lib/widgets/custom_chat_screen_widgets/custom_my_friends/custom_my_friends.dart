import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomMyFriends extends StatelessWidget {
  final int index;
  final List<FriendModel?> friendModel;
  const CustomMyFriends(
      {super.key, required this.index, required this.friendModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      child: Consumer<ChatController>(builder:(context, value, child) {
        return ListTile(
        onTap: () {
          value.startChat(friendModel[index]!.friendId.toString(), context, index,friendModel);
        },
        leading:   CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.5),
          backgroundImage: NetworkImage(friendModel[index]!.image),
        ),
        title: Text(
          "${friendModel[index]!.firstName} ${friendModel[index]!.lastName}",
          style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.02),
        ),
        subtitle: Text(
         friendModel[index]!.email,
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: whiteColor,
        ),
      );
      },)
    );
  }
}
