import 'package:birds_view/controller/login_controller/login_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/forgot_password_screen/verify_email_screen.dart';
import 'package:birds_view/views/signup_screen/signup_screen.dart';
import 'package:birds_view/widgets/custom_textfield/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button/custom_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Center(
                    child: Image.asset(
                  appLogo,
                  width: size.height * 0.15,
                )),
                //
                SizedBox(
                  height: size.height * 0.03,
                ),
                //
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Log ",
                      style: TextStyle(
                          fontSize: size.height * 0.04, color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'In',
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
                  height: size.height * 0.03,
                ),
                Consumer<LoginController>(
                  builder: (context, value, child) {
                    return SizedBox(
                      child: Column(
                        children: [
                          CustomTextField(
                              textEditingController: value.emailController,
                              obsecure: false,
                              hintText: "Email",
                              labelText: "Email"),
                          //

                          CustomTextField(
                              iconOnTap: () {
                                if (value.isHide == true) {
                                  value.isHide = false;
                                } else {
                                  value.isHide = true;
                                }
                              },
                              icon: value.isHide == false
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.white60,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.white60,
                                    ),
                              textEditingController: value.passwordController,
                              obsecure: value.isHide == false ? true : false,
                              hintText: "Password",
                              labelText: "Password"),
                          //
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    CupertinoCheckbox(
                                        activeColor: primaryColor,
                                        value: value.rememberMe,
                                        onChanged: (val) {
                                          value.rememberMe = val!;
                                        }),
                                    Text(
                                      'Remember Me',
                                      style: TextStyle(color: whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: const VerifyEmailScreen(),
                                          type: PageTransitionType.fade));
                                },
                                child: Text(
                                  "Forgot Password ?",
                                  style: TextStyle(
                                      color: whiteColor.withOpacity(.7)),
                                ),
                              ),
                            ],
                          ),

                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //
                          value.isLoging == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : CustomButton(
                                  text: "Log In",
                                  ontap: () {
                                    value.loginWithEmailAndPassword(context);
                                  },
                                ),
                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //
                          const Center(
                            child: Text(
                              "or login with",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //

                          SizedBox(
                              width: size.width * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(googleLoginIcon,
                                          width: size.height * 0.05)),
                                  Image.asset(appleLoginIcon,
                                      width: size.height * 0.05),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      facebookLoginIcon,
                                      width: size.height * 0.05,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
                //

                SizedBox(
                  height: size.height * 0.03,
                ),
                //
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          fontSize: size.height * 0.018, color: whiteColor),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const SignupScreen(),
                                      type: PageTransitionType.fade));
                            },
                          text: 'Create a new one',
                          style: TextStyle(
                              decorationColor: Colors.white,
                              decoration: TextDecoration.underline,
                              fontSize: size.height * 0.018,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                //
              ],
            ),
          ),
        ));
  }
}
