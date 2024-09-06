// ignore: file_names
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';

void showProSubscriptionPopup(BuildContext context,VoidCallback ontap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.7),
         icon: Image.asset(whiteLogo,
         height: 70,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'BirdsView Pro Benefits',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        content:const Text(
          '- Get real-time information on how many girls and guys are at the bar or club.\n\n- 100\$ per/year',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // TextButton(
          //   onPressed:  ontap,
          //   child:  Center(child: Text('Proceed to Purchase', style: TextStyle(color: primaryColor)))
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: 'Proceed to Purchase', ontap: ontap),
          )
        ],
      );
    },
  );
}
