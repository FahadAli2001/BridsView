import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/chat_room_model/chat_room_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/group_model/group_model.dart';
import 'package:birds_view/model/message_model/message_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../widgets/video_player_widget/video_player_widget.dart';

class ChatroomScreen extends StatefulWidget {
  final List<GroupModel?>? groupModel;
  final ChatRoomModel? chatRoomModel;
  final UserModel? user;

  final int index;
  final List<FriendModel?>? friendModel;
  const ChatroomScreen(
      {super.key,
      required this.user,
      this.chatRoomModel,
      this.groupModel,
      required this.index,
      this.friendModel});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            // If it's a group chat, show group details, otherwise show friend's details
            widget.groupModel != null ||
                    widget.groupModel![widget.index] != null
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: NetworkImage(
                            widget.groupModel![widget.index]!.groupImage),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Text(
                        widget.groupModel![widget.index]!.groupName,
                        style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.022),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade500,
                        backgroundImage: NetworkImage(
                            widget.friendModel![widget.index]!.image!),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Text(
                        widget.friendModel![widget.index]!.firstName!,
                        style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.022),
                      ),
                    ],
                  ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            String roomId = widget.groupModel != null
                ? widget.groupModel![widget.index]!.groupId
                : widget.chatRoomModel!.roomId!;
            return Consumer<ChatController>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(roomId)
                            .collection("messages")
                            .orderBy("createdOn", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              QuerySnapshot dataSnapshot =
                                  snapshot.data as QuerySnapshot;

                              return ListView.builder(
                                reverse: true,
                                itemCount: dataSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel currentMessage =
                                      MessageModel.fromJson(
                                    dataSnapshot.docs[index].data()
                                        as Map<String, dynamic>,
                                  );

                                  bool isCurrentUserMessage =
                                      currentMessage.sender ==
                                          widget.user!.data!.id.toString();

                                  return InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Column(
                                        crossAxisAlignment: isCurrentUserMessage
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          if (!isCurrentUserMessage &&
                                              widget.groupModel![widget.index]!
                                                      .groupName !=
                                                  "")
                                            FutureBuilder<DocumentSnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(currentMessage.sender)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                if (snapshot.hasData &&
                                                    snapshot.data != null) {
                                                  var senderData = snapshot
                                                          .data!
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  String? senderName =
                                                      senderData['first_name'];

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4.0),
                                                    child: Text(
                                                      senderName ?? "Unknown",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              },
                                            ),

                                          if (currentMessage.text != null &&
                                              currentMessage.text!.isNotEmpty &&
                                              currentMessage.imageUrl == "" &&
                                              currentMessage.videoUrl == "")
                                            Row(
                                              mainAxisAlignment:
                                                  isCurrentUserMessage
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                              children: [
                                                if (!isCurrentUserMessage)
                                                  const SizedBox(width: 5),
                                                Flexible(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: isCurrentUserMessage
                                                          ? const Color(
                                                              0xffc18e3c)
                                                          : const Color(
                                                                  0xff232323)
                                                              .withOpacity(1),
                                                      borderRadius: isCurrentUserMessage
                                                          ? const BorderRadius
                                                              .only(
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              bottomRight: Radius
                                                                  .circular(8))
                                                          : const BorderRadius
                                                              .only(
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              topRight: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    child: Text(
                                                      currentMessage.text!,
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 16,
                                                              color:
                                                                  whiteColor),
                                                    ),
                                                  ),
                                                ),
                                                if (isCurrentUserMessage)
                                                  const SizedBox(width: 5),
                                              ],
                                            ),

                                          // Video Player widget for video messages
                                          if (currentMessage.videoUrl != null &&
                                              currentMessage
                                                  .videoUrl!.isNotEmpty)
                                            VideoPlayerWidget(
                                                videoUrl:
                                                    currentMessage.videoUrl!),

                                          // Image widget for image messages
                                          if (currentMessage.imageUrl != null &&
                                              currentMessage
                                                  .imageUrl!.isNotEmpty)
                                            Image.network(
                                              currentMessage.imageUrl!,
                                              width: 200,
                                              height: 300,
                                              fit: BoxFit.fill,
                                            ),

                                          // Display timestamp for all messages
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                              value.formatTime(currentMessage
                                                  .createdOn
                                                  .toString()),
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 10,
                                                  color: whiteColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "An error occurred! Please check your internet connection.",
                                  style:
                                      GoogleFonts.urbanist(color: whiteColor),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text("Say hi to your new friend",
                                    style: GoogleFonts.urbanist(
                                        color: whiteColor)),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        style: TextStyle(color: whiteColor),
                        controller: value.messageController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          fillColor: const Color(0xff252525),
                          filled: true,
                          prefixIcon: SpeedDial(
                            gradientBoxShape: BoxShape.circle,
                            icon: Icons.add,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            mini: true,
                            buttonSize: const Size(25, 25),
                            visible: true,
                            overlayColor: Colors.black,
                            overlayOpacity: 0,
                            spacing: 10,
                            spaceBetweenChildren: 10,
                            closeManually: false,
                            children: [
                              SpeedDialChild(
                                elevation: 20,
                                child: Icon(Icons.video_camera_back_outlined,
                                    color: whiteColor),
                                backgroundColor: Colors.black,
                                onTap: () {
                                  value.pickVideo(widget.chatRoomModel,
                                      widget.groupModel![widget.index]);
                                },
                              ),
                              SpeedDialChild(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.photo, color: whiteColor),
                                onTap: () {
                                  value.pickImage(widget.chatRoomModel,
                                      widget.groupModel![widget.index]);
                                },
                              ),
                            ],
                          ),
                          prefixIconColor: Colors.white,
                          hintText: "Type Here",
                          hintStyle: TextStyle(
                              color: whiteColor.withOpacity(0.9), fontSize: 14),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send,
                                color: Color(0xffE5B569)),
                            onPressed: () {
                              if (widget.groupModel != null ||
                                  widget.groupModel![widget.index] != null) {
                                value.sendMessage("", null, "text",
                                    widget.groupModel![widget.index], "");
                              } else {
                                value.sendMessage(
                                    "", widget.chatRoomModel, "text", null, "");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
