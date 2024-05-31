import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/onboarding_screen/onboarding_three_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/images.dart';

class OnboardTwoScreen extends StatefulWidget {
  const OnboardTwoScreen({super.key});

  @override
  State<OnboardTwoScreen> createState() => _OnboardTwoScreenState();
}

class _OnboardTwoScreenState extends State<OnboardTwoScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: size.height * 0.05,
        width: size.width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "<< Previous",
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.22,
                  ),
                  Image.asset(onboardTwo),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(logoWithName)),
            //
            SizedBox(
              height: size.height * 0.1,
            ),
            //
            Center(
              child: Text(
                "Would You Like",
                style: TextStyle(
                    fontSize: size.height * 0.04,
                    color: whiteColor.withOpacity(.7)),
              ),
            ),
            //
        
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Explore ",
                  style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.w900,
                      color: primaryColor),
                  children: [
                    TextSpan(
                      text: 'Place',
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
            Center(
              child: Text(
                'Nearby',
                style: TextStyle(
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.w900,
                    color: whiteColor),
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            CustomButton(
                text: 'Enable Your Location',
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
