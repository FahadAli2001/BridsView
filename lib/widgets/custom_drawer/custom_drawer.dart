import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


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
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.026,
                              color: Colors.white),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFFC59241),
                                    Color(0xFFFEF6D1),
                                    Color(0xFFC49138),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.5, 1.0],
                                ).createShader(Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height)),
                                child: Text(
                                  user == null || user!.data!.subscribe == '0'
                                      ? " "
                                      : 'Pro',
                                  style: GoogleFonts.urbanist(
                                      fontSize: size.height * 0.012,
                                      color: whiteColor),
                                ),
                              ),
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
              leading: Image.asset(
                homeIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: Text(
                'Home',
                style: GoogleFonts.urbanist(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
              title: Text(
                'Profile',
                style: GoogleFonts.urbanist(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                if (user == null) {
                  customRegisterAlertBox(context);
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: BookmarkScreen(
                            userModel: user,
                          ),
                          type: PageTransitionType.fade));
                }
              },
              leading: SvgPicture.asset(
                bookmarksIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: Text(
                'Bookmarks',
                style: GoogleFonts.urbanist(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                if (user == null) {
                  customRegisterAlertBox(context);
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const VisitedBar(),
                          type: PageTransitionType.fade));
                }
              },
              leading: Image.asset(
                visitedLocationIcon,
                height: size.height * 0.03,
                fit: BoxFit.fill,
              ),
              title: Text(
                'Visited Places',
                style: GoogleFonts.urbanist(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            //
            //  ListTile(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         PageTransition(
            //             child:   SearchUserScreen(
            //               userModel: user,
            //             ),
            //             type: PageTransitionType.fade));
            //   },
            //   leading: SvgPicture.asset(
            //     addFriendIcon,
            //     height: size.height * 0.03,
            //     fit: BoxFit.fill,
            //   ),
            //   title: Text(
            //     'Friends',
            //     style: GoogleFonts.urbanist(
            //         color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            // ),

            //
            const Spacer(),

            user == null || user!.data!.id == null
                ? Center(
                    child: CustomButton(
                        text: 'Log In',
                        ontap: () async {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: const LogInScreen(),
                                  type: PageTransitionType.fade),
                              (route) => false);
                        }),
                  )
                : Consumer<LoginController>(
                    builder: (context, value, child) {
                      return Center(
                        child:
                            //     Container(
                            //   height: size.height * 0.06,
                            //   width: size.width * 0.5,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(30),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       "Log Out",
                            //       style: GoogleFonts.urbanist(
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: size.height * 0.019,
                            //           color: Colors.black),
                            //     ),
                            //   ),
                            // )
                            CustomButton(
                                text: 'Log Out',
                                ontap: () async {
                                  value.signOutFromSocialPlatforms(context);
                                }),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
