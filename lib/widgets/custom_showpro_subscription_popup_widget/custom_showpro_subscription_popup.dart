// ignore: file_names
import 'package:birds_view/widgets/custom_gradient_text/custom_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

void showProSubscriptionPopup(BuildContext context, VoidCallback ontap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.7),
        icon: Image.asset(
          whiteLogo,
          height: 70,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const GradientText(
            text: "BirdsView Pro Benefits",
            fontSize: 0.026,
            fontWeight: FontWeight.bold),
        content: Text(
          'Upgrade to Premium for just \$9.99/month and gain real-time access to the number of guys and girls in any establishment. Maximize your night with exclusive crowd insights and more!',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          style: GoogleFonts.urbanist(color: Colors.white),
        ),
        actions: [
          // TextButton(
          //   onPressed:  ontap,
          //   child:  Center(child: Text('Proceed to Purchase', style: TextStyle(color: primaryColor)))
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CustomButton(text: 'Proceed to Purchase', ontap: ontap)),
          )
        ],
      );
    },
  );
}
