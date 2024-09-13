import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/edit_profile_screen/edit_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("Profile Screen"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                widget.user == null || widget.user!.data!.image == ""
                    ? Center(
                        child: CircleAvatar(
                          radius: size.height * 0.07,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.person,
                            size: size.height * 0.05,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: size.height * 0.07,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.user!.data!.image!),
                      ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: widget.user == null ||
                              widget.user!.data!.username == ''
                          ? 'Guest '
                          : widget.user!.data!.username,
                      style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.026,
                          color: Colors.white),
                      children: [
                        TextSpan(
                          text: widget.user == null ||
                                  widget.user!.data!.subscribe == '0'
                              ? ""
                              : " Pro",
                          style: GoogleFonts.urbanist(
                              fontSize: size.height * 0.012,
                              color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: EditProfileScreen(
                                user: widget.user,
                              ),
                              type: PageTransitionType.fade));
                    },
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.022,
                          decorationColor: Colors.white,
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Bookmarks",
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.022, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Divider(
                  color: Colors.grey.shade700,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Visited Places",
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.022, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Divider(
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ));
  }
}
