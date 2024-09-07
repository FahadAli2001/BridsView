import 'package:birds_view/controller/login_controller/login_controller.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/bookmark_screen/bookmark_screen.dart';
import 'package:birds_view/views/login_screen/login_screen.dart';
import 'package:birds_view/views/profile_screen/profile_screen.dart';
import 'package:birds_view/views/visited_bars/visited_bars.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel? user;
  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Drawer(
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )),
            //
            SizedBox(
              height: size.height * 0.06,
            ),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                user == null || user!.data!.image == ' '
                    ? CircleAvatar(
                        radius: size.height * 0.04,
                        backgroundColor: primaryColor,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: size.height * 0.04,
                        backgroundImage:
                            CachedNetworkImageProvider(user!.data!.image!),
                      ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: RichText(
                        text: TextSpan(
                          text: user == null || user!.data!.username == ''
                              ? "Guest "
                              : '${user!.data!.username} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.026,
                              color: Colors.white),
                          children: [
                            TextSpan(
                              text: user == null || user!.data!.subscribe == '0'
                                  ? " "
                                  : 'Pro',
                              style: TextStyle(
                                  fontSize: size.height * 0.012,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                )
              ],
            ),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: SvgPicture.asset(
                homeIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: const Text(
                'Home',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: ProfileScreen(
                          user: user,
                        ),
                        type: PageTransitionType.fade));
              },
              leading: SvgPicture.asset(
                profileIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: const Text(
                'Profile',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const BookmarkScreen(),
                        type: PageTransitionType.fade));
              },
              leading: SvgPicture.asset(
                bookmarksIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: const Text(
                'Bookmarks',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const VisitedBar(),
                        type: PageTransitionType.fade));
              },
              leading: SvgPicture.asset(
                visitedLocationIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: const Text(
                'Visited Places',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            // ListTile(
            //   leading: Image.asset(
            //     vendorIcon,
            //     height: size.height * 0.03,
            //     fit: BoxFit.fill,
            //   ),
            //   title: Text(
            //     'Become A Vendor',
            //     style:
            //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const Spacer(),

            user == null || user!.data!.id == null
                ? CustomButton(
                    text: 'Log In',
                    ontap: () async {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              child: const LogInScreen(),
                              type: PageTransitionType.fade),
                          (route) => false);
                    })
                :  Consumer<LoginController>(builder:(context, value, child) {
                  return CustomButton(
                    text: 'Log Out',
                    ontap: () async {
                     
                          value.signOutFromSocialPlatforms(context);
                     
                    });
                },)
          ],
        ),
      ),
    );
  }
}
