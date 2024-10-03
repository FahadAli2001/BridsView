import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_gradient_text/custom_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_button/custom_button.dart';

void customBookmarkAlertBox(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.7),
          icon: Image.asset(
            whiteLogo,
            height: 70,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const GradientText(
              text: "BirdsView", fontSize: 0.026, fontWeight: FontWeight.bold),
          content: Text(
            'To add your bookmarked, please upgrade to our premium option for full access. Stay connected to all your favorite places and enjoy exclusive features!',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomButton(
                    text: 'Upgrade',
                    ontap: () {
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     PageTransition(
                      //         child: const SignupScreen(),
                      //         type: PageTransitionType.fade),
                      //     (route) => false);
                    }),
              ),
            )
          ],
        );
      });
}
