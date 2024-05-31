import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/forgot_password_screen/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_textfield/custom_textfield.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              //
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              //
              Center(
                  child: Image.asset(
                appLogo,
                width: size.width * 0.2,
              )),
              //
              SizedBox(
                height: size.height * 0.07,
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
                        text: 'Email',
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
              SizedBox(
                height: size.height * 0.05,
              ),
              //
              const CustomTextField(
                  textEditingController: null,
                  obsecure: false,
                  hintText: 'Email',
                  labelText: 'Email'),
              SizedBox(
                height: size.height * 0.1,
              ),
              //
              CustomButton(
                  text: 'Submit',
                  ontap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const OtpVerificationScreen(),
                            type: PageTransitionType.fade));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
