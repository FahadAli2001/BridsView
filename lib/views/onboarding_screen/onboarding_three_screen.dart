import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

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
            const Center(
                child:
                    CustomHeadingText(heading: "Check The Vibe, Then Arrive")),

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
                  child: TextWidget(
                      text: 'continue as a Guest',
                      color: whiteColor,
                      fontSize: size.height * 0.018,
                      decorationColor: whiteColor,
                      underline: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}
