import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatefulWidget {
  final UserModel? user;
  const FriendRequestScreen({super.key, required this.user});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  void initState() {
    super.initState();
    getFriendRequest();
  }

  void getFriendRequest() async {
    final chatCon = Provider.of<ChatController>(context, listen: false);
    await chatCon.getUserCredential();
    await chatCon.fetchFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              )),
          centerTitle: true,
          title: Center(
            child: RichText(
              text: TextSpan(
                text: "Friend ",
                style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.026,
                    color: Colors.white),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFC59241),
                          Color(0xFFFEF6D1),
                          Color(0xFFC49138),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.5, 1.0],
                      ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(
                        'Request ',
                        style: GoogleFonts.urbanist(
                            fontSize: size.height * 0.026,
                            fontWeight: FontWeight.w900,
                            color: whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<ChatController>(
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: value.friendRequests.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: value.friendRequests.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: size.width * 9,
                          height: 100,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade600,
                                backgroundImage: NetworkImage(value
                                    .friendRequests[index]!.requesterImage!),
                              ),
                              title: Text(
                                "${value.friendRequests[index]!.requesterFirstName} ${value.friendRequests[index]!.requesterLastName} }",
                                style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.02),
                              ),
                              subtitle: Text(
                                value.friendRequests[index]!.requesterEmail!,
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 90,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          value.acceptFriendRequest(
                                              value.friendRequests,
                                              index,
                                              widget.user);
                                        },
                                        child: SvgPicture.asset(acceptIcon)),
                                    GestureDetector(
                                        onTap: () {
                                          value.rejectFriendRequest(
                                              value.friendRequests, index);
                                        },
                                        child: SvgPicture.asset(rejectIcon))
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
            );
          },
        ));
  }
}
