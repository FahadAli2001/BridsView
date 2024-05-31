import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/forgot_password_screen/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_button/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              //
              Center(
                  child: Image.asset(
                appLogo,
                width: size.width * 0.2,
              )),
              //
              SizedBox(
                height: size.height * 0.05,
              ),
              //
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Verify ",
                    style: TextStyle(
                        fontSize: size.height * 0.04, color: Colors.white70),
                    children: [
                      TextSpan(
                        text: 'OTP',
                        style: TextStyle(
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.w900,
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              //
              Text(
                'send to your registered email',
                style: TextStyle(
                    fontSize: size.height * 0.015, color: Colors.white70),
              ),
              //
              SizedBox(
                height: size.height * 0.02,
              ),

              //
              OtpTextField(
                textStyle: const TextStyle(color: Colors.white60),
                numberOfFields: 6,
                borderColor: primaryColor,
                focusedBorderColor: primaryColor,
                showFieldAsBox: false,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {},
              ),
              //
              SizedBox(
                height: size.height * 0.1,
              ),

              CustomButton(
                  text: 'Verify',
                  ontap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const ChangePaasswordScreen(),
                            type: PageTransitionType.fade));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
