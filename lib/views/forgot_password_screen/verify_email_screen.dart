import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("VerifyEmail"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
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
                    whiteLogo,
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
                        style: GoogleFonts.urbanist(
                            fontSize: size.height * 0.04,
                            color: Colors.white70),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Color(0xFFC59241),
                                        Color(0xFFFEF6D1),
                                        Color(0xFFC49138),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.0, 0.5, 1.0],
                                    ).createShader(Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height)),
                                child: TextWidget(
                                  text: 'Email ',
                                  color: whiteColor,
                                  fontSize: size.height * 0.04,
                                  fontWeight: FontWeight.w900,
                                )),
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
                              textEditingController: value.emailController,
                              obsecure: false,
                              hintText: 'Email',
                              labelText: 'Email'),
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          //
                          value.isChecking == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : CustomButton(
                                  text: 'Submit',
                                  ontap: () {
                                    value.verifyEmail(context);
                                  })
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
