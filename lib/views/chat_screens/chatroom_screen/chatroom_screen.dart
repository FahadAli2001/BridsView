import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/chat_room_model/chat_room_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
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
  final ChatRoomModel? chatRoomModel;
  final UserModel? user;

  final int index;
  final List<FriendModel?> friendModel;
  const ChatroomScreen(
      {super.key,
      required this.user,
      required this.chatRoomModel,
      required this.index,
      required this.friendModel});

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
                )),
            SizedBox(
              width: size.width * 0.02,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade500,
              backgroundImage:
                  NetworkImage(widget.friendModel[widget.index]!.image!),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendModel[widget.index]!.firstName!,
                  style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.022),
                ),
                // Text(
                //   "",
                //   style: GoogleFonts.urbanist(
                //     fontSize: size.height * 0.015,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Consumer<ChatController>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.chatRoomModel!.roomId)
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
                                    onLongPress: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Column(
                                        crossAxisAlignment: isCurrentUserMessage
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          currentMessage.text == null
                                              ? const SizedBox.shrink()
                                              : Row(
                                                  mainAxisAlignment:
                                                      isCurrentUserMessage
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                  children: [
                                                    if (!isCurrentUserMessage)
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(horizontal: 12,vertical: 5),
                                                        decoration: BoxDecoration(
                                                            color: isCurrentUserMessage
                                                                ? const Color(
                                                                    0xffc18e3c)
                                                                : const Color(
                                                                        0xff232323)
                                                                    .withOpacity(
                                                                        0.9),
                                                            borderRadius: isCurrentUserMessage
                                                                ? const BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8),
                                                                    topLeft:
                                                                        Radius.circular(
                                                                            8),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            8))
                                                                : const BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            8),
                                                                    topRight:
                                                                        Radius.circular(8),
                                                                    bottomRight: Radius.circular(8))),
                                                        child: Text(
                                                          currentMessage.text!,
                                                          style: GoogleFonts
                                                              .urbanist(
                                                                  fontSize: 16,
                                                                  color:
                                                                      whiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                    if (isCurrentUserMessage)
                                                      const SizedBox(
                                                        width:
                                                            5, // Adjust as needed
                                                      ),
                                                  ],
                                                ),
                                          if (currentMessage.videoUrl != null &&
                                              currentMessage
                                                  .videoUrl!.isNotEmpty)
                                            VideoPlayerWidget(
                                                videoUrl:
                                                    currentMessage.videoUrl!)
                                          else
                                            const SizedBox.shrink(),
                                          if (currentMessage.imageUrl != null &&
                                              currentMessage
                                                  .imageUrl!.isNotEmpty)
                                            Image.network(
                                              currentMessage.imageUrl!,
                                              width: 200,
                                              height: 300,
                                              fit: BoxFit.fill,
                                            )
                                          else
                                            const SizedBox.shrink(),
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
                              return   Center(
                                child: Text(
                                    "An error occurred! Please check your internet connection.",
                                    style: GoogleFonts.urbanist(color: whiteColor),),
                              );
                            } else {
                              return   Center(
                                child: Text("Say hi to your new friend",
                                  style: GoogleFonts.urbanist(color: whiteColor)
                                ),
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
                                  value.pickVideo(widget.chatRoomModel);
                                },
                              ),
                              SpeedDialChild(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.photo, color: whiteColor),
                                onTap: () {
                                  value.pickImage(widget.chatRoomModel);
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
                              value.sendMessage(
                                  "", widget.chatRoomModel, "text", "");
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
