import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';

class CustomImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback cameraontap;
  final VoidCallback galleryontap;
  const CustomImagePickerBottomSheet({super.key,required this.cameraontap, required this.galleryontap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: size.height * 0.25,
        color: Colors.black,
        child: Padding(
          padding:
            const  EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Choose ",
                  style: TextStyle(
                      fontSize: size.height * 0.03, color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Image ',
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Source ',
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ],
                ),
              ),
             const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                        text: 'From Gallery', ontap: galleryontap),
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                            text: 'From Camera', ontap: cameraontap),
                  )
                ],
              ),
             const Spacer(),
            ],
          ),
        ),
      ));
  }
}