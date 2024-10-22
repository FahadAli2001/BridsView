import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


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
                whiteLogo,
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
                    style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.04, color: Colors.white70),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFC59241),
                              Color(0xFFFEF6D1),
                              Color(0xFFC49138),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child:
                          TextWidget(
                                  text: 'Password ',
                                  color: whiteColor,
                                  fontSize: size.height * 0.04,
                                  fontWeight: FontWeight.w900,
                                )
                        ),
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
              Consumer<ResetPasswordController>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      CustomTextField(
                          textEditingController: value.newPasswordController,
                          obsecure: true,
                          hintText: 'New Password',
                          labelText: 'New Password'),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      //
                      CustomTextField(
                          textEditingController:
                              value.confirmPasswordController,
                          obsecure: true,
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password'),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      value.isChangingPassword == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : CustomButton(
                              text: 'Confirm',
                              ontap: () {
                                value.checkChangePasswordConditions(context);
                              })
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
