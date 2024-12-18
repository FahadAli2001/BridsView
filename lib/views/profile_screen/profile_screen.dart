import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

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
                                  ).createShader(Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height)),
                              child: TextWidget(
                                text: widget.user == null ||
                                        widget.user!.data!.subscribe == '0'
                                    ? " "
                                    : 'Pro',
                                color: whiteColor,
                                fontSize: size.height * 0.012,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
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
                    child: TextWidget(
                      text: 'Edit Profile',
                      color: whiteColor,
                      fontSize: size.height * 0.022,
                      underline: TextDecoration.underline,
                      decorationColor: whiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: BookmarkScreen(
                                  userModel: widget.user,
                                ),
                                type: PageTransitionType.fade));
                      },
                      child: TextWidget(
                        text: 'Bookmarks',
                        color: Colors.white,
                        fontSize: size.height * 0.022,
                      )),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const VisitedBar(),
                                type: PageTransitionType.fade));
                      },
                      child: TextWidget(
                        text: 'Visited Places',
                        color: Colors.white,
                        fontSize: size.height * 0.022,
                      )),
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
