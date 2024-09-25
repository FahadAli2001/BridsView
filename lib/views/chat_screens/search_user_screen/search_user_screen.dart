import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_chat_screen_widgets/custom_my_friends/custom_my_friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
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
              )),
          centerTitle: true,
          title: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: AssetImage(whiteLogo),
          )),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<ChatController>(
            builder: (context, value, child) {
              return Column(
                children: [
                  TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          fillColor: const Color(0xff252525),
                          filled: true,
                          prefixIcon: const Icon(CupertinoIcons.search),
                          prefixIconColor: Colors.white,
                          hintText: "Search Friends",
                          hintStyle: TextStyle(
                              color: whiteColor.withOpacity(0.9),
                              fontSize: 14))),
                  //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      width: size.width,
                      child: Divider(
                        color: whiteColor.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                  ),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          value.handleMyFriends();
                        },
                        child: Column(
                          children: [
                            Text(
                              "My Friends",
                              style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.022),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            value.myFriends == true
                                ? Container(
                                    height: 3,
                                    width: size.width / 4,
                                    decoration:
                                        BoxDecoration(gradient: gradientColor),
                                  )
                                : SizedBox(
                                    height: 3,
                                    width: size.width / 4,
                                  )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          value.handleChats();
                        },
                        child: Column(
                          children: [
                            Text(
                              "Chats",
                              style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.022),
                            ),
                            value.chats == true
                                ? Container(
                                    height: 3,
                                    width: size.width / 4,
                                    decoration:
                                        BoxDecoration(gradient: gradientColor),
                                  )
                                : SizedBox(
                                    height: 3,
                                    width: size.width / 4,
                                  )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          value.handleGroups();
                        },
                        child: Column(
                          children: [
                            Text(
                              "Groups",
                              style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.022),
                            ),
                            value.groups == true
                                ? Container(
                                    height: 3,
                                    width: size.width / 4,
                                    decoration:
                                        BoxDecoration(gradient: gradientColor),
                                  )
                                : SizedBox(
                                    height: 3,
                                    width: size.width / 4,
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                  //
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  //
                  if(value.myFriends==true)
                    const CustomMyFriends()
                ],
              );
            },
          )),
    );
  }
}
