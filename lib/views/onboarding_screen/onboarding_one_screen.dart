import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/onboarding_screen/onboarding_two_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
            Center(child: Image.asset(whiteLogo,
            height: size.height * 0.3,
          ),
            ),
            //
            SizedBox(
              height: size.height * 0.1,
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
                  text: "BIRDS",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.w900,
                      color: primaryColor),
                  children: [
                    TextSpan(
                      text: 'VIEW',
                      style: TextStyle(
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.w900,
                          color: whiteColor),
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
                          child: const OnboardTwoScreen(),
                          type: PageTransitionType.fade));
                })
          ],
        ),
      ),
    );
  }
}
