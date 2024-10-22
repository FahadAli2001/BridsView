import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

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
                  whiteLogo,
                  width: size.height * 0.2,
                )),
                //
                SizedBox(
                  height: size.height * 0.03,
                ),
                //
                const Center(child: CustomHeadingText(heading: "Log In")),
                
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
                                    TextWidget(
                                        text: "Remember Me", color: whiteColor)
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
                                  child: TextWidget(
                                      text: "Forgot Password ?",
                                      color: whiteColor.withOpacity(.7))),
                            ],
                          ),

                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //
                          value.isLoging == true
                              ? const Center(child: LoadingWidget())
                              : Center(
                                  child: CustomButton(
                                    text: "Log In",
                                    ontap: () {
                                      value.loginWithEmailAndPassword(
                                          context,
                                          value.emailController.text,
                                          value.passwordController.text);
                                    },
                                  ),
                                ),
                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //
                          const Center(
                              child: TextWidget(
                                  text: "or login with",
                                  color: Colors.white70)),
                          //
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          //

                          SizedBox(
                              width: size.width * 0.3,
                              child: Consumer<LoginController>(
                                builder: (context, value, child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            value.signInWithGoogle(context);
                                          },
                                          child: Image.asset(googleLoginIcon,
                                              width: size.height * 0.05)),
                                      GestureDetector(
                                        onTap: () {
                                          value.signInWithApple(context);
                                        },
                                        child: Image.asset(appleLoginIcon,
                                            width: size.height * 0.05),
                                      ),
                                    ],
                                  );
                                },
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
                      style: GoogleFonts.urbanist(
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
                          style: GoogleFonts.urbanist(
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
