import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_textfield/custom_textfield.dart';

class ChangePaasswordScreen extends StatefulWidget {
  const ChangePaasswordScreen({super.key});

  @override
  State<ChangePaasswordScreen> createState() => _ChangePaasswordScreenState();
}

class _ChangePaasswordScreenState extends State<ChangePaasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              //
              Center(
                  child: Image.asset(
                appLogo,
                width: size.width * 0.2,
              )),
              //
              SizedBox(
                height: size.height * 0.04,
              ),
              //
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Change ",
                    style: TextStyle(
                        fontSize: size.height * 0.04, color: Colors.white70),
                    children: [
                      TextSpan(
                        text: 'Password',
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
                  obsecure: true,
                  hintText: 'New Password',
                  labelText: 'New Password'),
              SizedBox(
                height: size.height * 0.01,
              ),
              //
              const CustomTextField(
                  textEditingController: null,
                  obsecure: true,
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password'),
              SizedBox(
                height: size.height * 0.1,
              ),
              CustomButton(
                  text: 'Confirm',
                  ontap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const LogInScreen(),
                            type: PageTransitionType.fade));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
