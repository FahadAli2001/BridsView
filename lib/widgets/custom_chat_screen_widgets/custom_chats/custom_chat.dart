import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/chat_room_model/chat_room_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/views/chat_screens/chatroom_screen/chatroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomChat extends StatelessWidget {
  final UserModel? userModel;
  final int index;
  final List<FriendModel?> friendModel;
  const CustomChat(
      {super.key,
      required this.userModel,
      required this.index,
      required this.friendModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
        width: size.width,
        child: Consumer<ChatController>(
          builder: (context, value, child)  {
            return ListTile(
              onTap: ()async {
                   ChatRoomModel? chatRoomModel = await value
                    .getChatRoomModel(friendModel[index]!.friendId.toString());
                if (chatRoomModel != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatroomScreen(
                                friendModel: friendModel,
                                user: userModel,
                                index: index,
                                chatRoomModel: chatRoomModel,
                              )));
              };
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                backgroundImage: NetworkImage(friendModel[index]!.image!),
              ),
              title: Text(
                "${friendModel[index]!.firstName!} ${friendModel[index]!.lastName!}",
                style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.02),
              ),
              subtitle: Text(
             value.lastMessagesAndTime != null ?    value.lastMessagesAndTime!["sender"] ==
                        userModel!.data!.id.toString()
                    ? "You : ${value.lastMessagesAndTime!["text"]}"
                    : "${friendModel[index]!.firstName!} : ${value.lastMessagesAndTime!["text"]}" :"",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                ),
              ),
              trailing: Text(
             value.lastMessagesAndTime?['createdOn'] != null?   value.formatTime(value.lastMessagesAndTime!['createdOn'].toString()).toString():"",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                ),
              ),
            );
          },
        ));
  }
}
