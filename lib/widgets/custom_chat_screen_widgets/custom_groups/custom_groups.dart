import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/group_model/group_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/views/chat_screens/chatroom_screen/chatroom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomGroups extends StatelessWidget {
  final UserModel? userModel;
  final int index;
  final List<GroupModel?> groupDetail;
  const CustomGroups(
      {super.key,
      required this.index,
      required this.groupDetail,
      required this.userModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
        width: size.width,
        child: Consumer<ChatController>(
          builder: (context, value, child) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatroomScreen(
                              user: userModel,
                              index: index,
                              groupModel: groupDetail,
                            )));
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade500,
                backgroundImage: NetworkImage(groupDetail[index]!.groupImage),
              ),
              title: Text(
                groupDetail[index]!.groupName,
                style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.02),
              ),
              subtitle: value.groupLastMessage == ""
                  ? const Text("")
                  : Text(
                      value.groupLastMessage!,
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                      ),
                    ),
              trailing: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(groupDetail[index]!.groupId)
                    .collection('messages')
                    .orderBy('createdOn', descending: true)
                    .limit(1)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "...",
                      style: TextStyle(color: Colors.white),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      var lastMessageData = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;
                          
                      var lastMessageTime = lastMessageData['createdOn'];
                      value.groupLastMessage = lastMessageData['text'];

                      if (lastMessageTime != null) {
                        return Text(
                          value
                              .formatTime(lastMessageTime.toString())
                              .toString(),
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return const Text(
                          "",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    } else {
                      return const Text(
                        "No messages",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  } else {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            );
          },
        ));
  }
}
