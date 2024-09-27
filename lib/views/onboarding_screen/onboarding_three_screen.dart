import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/home_screen/home_screem.dart';
import 'package:birds_view/views/login_screen/login_screen.dart';
import 'package:birds_view/views/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_button/custom_button.dart';

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({super.key});

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      // bottomNavigationBar: SizedBox(
      //   height: size.height * 0.05,
      //   width: size.width,
      //   child: Row(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 15),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.pop(context);
      //               },
      //               child: Text(
      //                 "<< Previous",
      //                 style: TextStyle(color: whiteColor),
      //               ),
      //             ),
      //             SizedBox(
      //               width: size.width * 0.22,
      //             ),
      //             Image.asset(onboardThree),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              whiteLogo,
              height: size.height * 0.3,
            )),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            //
            Center(
              child: RichText(
                text: TextSpan(
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
                          'Check the Vibe, ',
                          style: GoogleFonts.urbanist(
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Then Arrive',
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.w900,
                          color: whiteColor),
                    ),
                  ],
                ),
              ),
            ),

            //
            SizedBox(
              height: size.height * 0.1,
            ),
            CustomButton(
                text: 'Log In',
                ontap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const LogInScreen(),
                          type: PageTransitionType.fade));
                }),
            //
            SizedBox(
              height: size.height * 0.03,
            ),
            //
            CustomButton(
                text: 'Create Account',
                ontap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const SignupScreen(),
                          type: PageTransitionType.fade));
                }),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            //
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const HomeScreen(user: null),
                          type: PageTransitionType.fade));
                },
                child: Text(
                  "continue as a Guest",
                  style: GoogleFonts.urbanist(
                      fontSize: size.height * 0.018,
                      decorationColor: Colors.white,
                      decoration: TextDecoration.underline,
                      color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
