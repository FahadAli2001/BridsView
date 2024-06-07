import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/edit_profile_screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            backgroundImage: AssetImage(appLogo),
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
            Center(
              child: CircleAvatar(
                radius: size.height * 0.07,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.person,
                  size: size.height * 0.05,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Guest ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:size.height * 0.03,
                      color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'User',
                      style: TextStyle(
                          fontSize: size.height * 0.03, color: primaryColor),
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
                          child: const EditProfileScreen(),
                          type: PageTransitionType.fade));
                },
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontSize: size.height * 0.02,
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
                  style: TextStyle(
                      fontSize: size.height * 0.022,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                  style: TextStyle(
                      fontSize: size.height * 0.022,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
    );
  }
}
