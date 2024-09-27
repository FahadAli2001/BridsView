import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/message_model/message_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatId;
  final String friendId;
  final int index;
  final List<FriendModel?> friendModel;
  const ChatroomScreen(
      {super.key,
      required this.chatId,
      required this.friendId,
      required this.index,
      required this.friendModel});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  void initState() {
    super.initState();
    getMessages();
  }

  Future<void> getMessages() async {
    final chatController = Provider.of<ChatController>(context);
    chatController.fetchMessages(widget.friendId, widget.chatId);
  }

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
                  NetworkImage(widget.friendModel[widget.index]!.image),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendModel[widget.index]!.firstName,
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
                            .doc(widget.chatId)
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
                                      currentMessage.sender == value.userId;

                                  return InkWell(
                                     
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Column(
                                        crossAxisAlignment: isCurrentUserMessage
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                isCurrentUserMessage
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              if (!isCurrentUserMessage)
                                                const SizedBox(
                                                    width:
                                                        48), // Spacer for non-user messages
                                              Flexible(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: isCurrentUserMessage
                                                        ? Colors.blue.shade100
                                                        : Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Text(
                                                    currentMessage.text!,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              if (isCurrentUserMessage)
                                                const SizedBox(
                                                    width:
                                                        48), // Spacer for user messages
                                            ],
                                          ),

                                          // Display Image if imageUrl exists
                                          // if (currentMessage.imageUrl != null)
                                          //   Padding(
                                          //     padding: const EdgeInsets.only(top: 8.0),
                                          //     child: FullScreenWidget(
                                          //       disposeLevel: DisposeLevel.Medium,
                                          //       child: Image.network(
                                          //         currentMessage.imageUrl!,
                                          //         width: 200,
                                          //         height: 300,
                                          //         fit: BoxFit.cover,
                                          //       ),
                                          //     ),
                                          //   ),

                                          // Display Video if videoUrl exists
                                          // if (currentMessage.videoUrl != null)
                                          //   Padding(
                                          //     padding: const EdgeInsets.only(top: 8.0),
                                          //     child: GestureDetector(
                                          //       onTap: () {
                                          //         Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) => VideoPlayerScreen(
                                          //               videoUrl: currentMessage.videoUrl!,
                                          //             ),
                                          //           ),
                                          //         );
                                          //       },
                                          //       child: Icon(
                                          //         Icons.play_circle_fill,
                                          //         color: Colors.grey.shade700,
                                          //         size: 50,
                                          //       ),
                                          //     ),
                                          //   ),

                                          // Seen/Unseen Icon for user's messages
                                          if (isCurrentUserMessage)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Icon(
                                                currentMessage.seen == true
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                color:
                                                    currentMessage.seen == true
                                                        ? Colors.blue
                                                        : Colors.black,
                                                size: 18,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    "An error occurred! Please check your internet connection."),
                              );
                            } else {
                              return const Center(
                                child: Text("Say hi to your new friend"),
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
                                child:
                                    Icon(Icons.camera_alt, color: whiteColor),
                                backgroundColor: Colors.black,
                                onTap: () {},
                              ),
                              SpeedDialChild(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.photo, color: whiteColor),
                                onTap: () {},
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
                              value.sendMessage(value.messageController.text,
                                  'text', widget.friendId, widget.chatId);
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
