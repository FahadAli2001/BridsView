import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_groupchat_name_alertbox/custom_groupchat_name_alertbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddMembersToGroupScreen extends StatefulWidget {
  const AddMembersToGroupScreen({super.key});

  @override
  State<AddMembersToGroupScreen> createState() =>
      _AddMembersToGroupScreenState();
}

class _AddMembersToGroupScreenState extends State<AddMembersToGroupScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: AssetImage(whiteLogo),
        ),
      ),
      floatingActionButton: Consumer<ChatController>(
        builder: (context, value, child) {
          return
              //  value.selectedFriendsForGroup!.length > 2
              //     ?
              GestureDetector(
            onTap: () {
              customGroupChatNameAlertBox(context);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  gradient: gradientColor, shape: BoxShape.circle),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
            ),
          );
          // : const SizedBox.shrink();
        },
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<ChatController>(
            builder: (context, value, child) {
              return Column(
                children: [
                  value.selectedFriendsForGroup!.isEmpty
                      ? const SizedBox.shrink()
                      : SizedBox(
                          width: size.width,
                          height: size.height * 0.1,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: value.selectedFriendsForGroup!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    value.selectedFriendsForGroup!
                                        .remove(value.friendsList[index]!);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: size.width * 0.2,
                                    height: size.height * 0.1,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage: NetworkImage(value
                                                .selectedFriendsForGroup![index]
                                                .image!),
                                          ),
                                        ),
                                        Positioned(
                                          top: size.height * 0.06,
                                          left: size.width * 0.12,
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            size: 30,
                                            color: whiteColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  //
                  value.selectedFriendsForGroup!.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(gradient: gradientColor),
                            height: 2,
                            width: size.width,
                          ),
                        ),
                  //
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.friendsList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onLongPress: () {
                            value.selectedFriendsForGroup!
                                .add(value.friendsList[index]!);
                            setState(() {});
                          },
                          onTap: () async {
                            // ChatRoomModel? chatRoomModel = await value
                            //     .getChatRoomModel(friendModel[index]!.friendId.toString());
                            // if (chatRoomModel != null) {
                            //   // ignore: use_build_context_synchronously
                            //   Navigator.pop(context);
                            //   Navigator.push(
                            //       // ignore: use_build_context_synchronously
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => ChatroomScreen(
                            //                 friendModel: friendModel,
                            //                 user: userModel,
                            //                 index: index,
                            //                 chatRoomModel: chatRoomModel,
                            //               )));
                            // }
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            backgroundImage:
                                NetworkImage(value.friendsList[index]!.image!),
                          ),
                          title: Text(
                            "${value.friendsList[index]!.firstName} ${value.friendsList[index]!.lastName}",
                            style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.02),
                          ),
                          subtitle: Text(
                            value.friendsList[index]!.email!,
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
