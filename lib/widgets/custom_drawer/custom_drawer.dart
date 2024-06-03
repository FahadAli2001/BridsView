import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/home_screen/home_screem.dart';
import 'package:birds_view/views/profile_screen/profile_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
              height: size.height*0.05,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:const Padding(
                  padding:   EdgeInsets.symmetric(horizontal: 10),
                  child:   Icon(
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
                CircleAvatar(
                        radius: size.height * 0.04,
                        backgroundColor: primaryColor,
                        child:const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                    
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: RichText(
                        text: TextSpan(
                          text:  "Guest"
                               ,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.03,
                              color: Colors.white),
                          children: [
                            TextSpan(
                              text: ' User',
                              style: TextStyle(
                                  fontSize: size.height * 0.03,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Night Owl",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.02),
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
                Navigator.push(
                    context,
                  PageTransition(child:const HomeScreen(), type: PageTransitionType.fade)
                 );
              },
              leading: SvgPicture.asset(
                homeIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title:const Text(
                'Home',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                  Navigator.push(
                    context,
                  PageTransition(child:const ProfileScreen(), type: PageTransitionType.fade)
                 );
              },
              leading: SvgPicture.asset(
                profileIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title:const Text(
                'Profile',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
               
              },
              leading: SvgPicture.asset(
                bookmarksIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title:const Text(
                'Bookmarks',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                
              },
              leading: SvgPicture.asset(
                visitedLocationIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title:const Text(
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
          const  Spacer(),

          CustomButton(text: 'Log Out', ontap: (){})
          ],
        ),
      ),
    );
  }
}