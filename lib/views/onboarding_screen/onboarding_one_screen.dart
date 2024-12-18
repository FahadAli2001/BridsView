import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'onboarding_three_screen.dart';

class OnboardingOneScreen extends StatefulWidget {
  const OnboardingOneScreen({super.key});

  @override
  State<OnboardingOneScreen> createState() => _OnboardingOneScreenState();
}

class _OnboardingOneScreenState extends State<OnboardingOneScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      // bottomNavigationBar: SizedBox(
      //   height: size.height * 0.05,
      //   child: Image.asset(onboardOne),
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
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            //
            Center(
              child: Text(
                "Welcome To",
                style: TextStyle(
                    fontSize: size.height * 0.04,
                    color: whiteColor.withOpacity(.7)),
              ),
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
                          'BIRDS',
                          style: GoogleFonts.urbanist(
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'VIEW',
                      style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.04,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            SizedBox(
              height: size.height * 0.03,
            ),
            //
            Center(
              child: Text(
                "Start your night Journey",
                style: TextStyle(
                    fontSize: size.height * 0.02,
                    color: whiteColor.withOpacity(.7)),
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            CustomButton(
                text: 'Get Started',
                ontap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const OnboardingThree(),
                          type: PageTransitionType.fade));
                })
          ],
        ),
      ),
    );
  }
}
