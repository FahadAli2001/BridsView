import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({super.key});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Makes the layout adjust when the keyboard opens
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
              const CircleAvatar(),
              SizedBox(
                width: size.width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.02),
                  ),
                  Text(
                    "Online",
                    style: GoogleFonts.urbanist(
                      fontSize: size.height * 0.015,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer()
            ],
          )),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        fillColor: const Color(0xff252525),
                        filled: true,
                        prefixIcon: SpeedDial(
                         gradientBoxShape: BoxShape.circle,   
                        icon: Icons.add,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          mini: true,
                          buttonSize:const Size(25, 25),
                          
                          visible: true,
                          overlayColor: Colors.black,
                          overlayOpacity: 0,
                          spacing: 10,
                          spaceBetweenChildren: 10,
                          closeManually: false,
                          children: [
                            SpeedDialChild(
                              elevation: 20,
                              child: Icon(Icons.camera_alt, color: whiteColor),
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
                        suffixIcon: const Icon(
                          Icons.send,
                          color: Color(0xffE5B569),
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
