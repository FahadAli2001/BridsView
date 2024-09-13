import 'package:birds_view/controller/reset_password_controller/reset_password.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../widgets/custom_button/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    final resetPasswordController =
        Provider.of<ResetPasswordController>(context, listen: false);
    super.initState();
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: 300000,
      onChange: (value) {},
      onEnded: () {
        resetPasswordController.isCountDownDone = true;
      },
    );

    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

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
                whiteLogo,
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
                    style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.04, color: Colors.white70),
                    children: [
                      TextSpan(
                        text: 'OTP',
                        style: GoogleFonts.urbanist(
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
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.015, color: Colors.white70),
              ),
              //
              SizedBox(
                height: size.height * 0.02,
              ),
              //
              StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snapshot) {
                  final value = snapshot.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: false, milliSecond: false);
                  return Text(displayTime,
                      style: TextStyle(
                          fontSize: size.height * 0.03, color: primaryColor));
                },
              ),
              //
              SizedBox(
                height: size.height * 0.02,
              ),
              //
              Consumer<ResetPasswordController>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      OtpTextField(
                        textStyle: const TextStyle(color: Colors.white60),
                        numberOfFields: 6,
                        borderColor: primaryColor,
                        focusedBorderColor: primaryColor,
                        showFieldAsBox: false,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          value.otp = verificationCode;
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      CustomButton(
                          text: 'Verify',
                          ontap: () {
                            value.checkOtpConditions(context);
                          })
                    ],
                  );
                },
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
