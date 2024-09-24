import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardTwoScreen extends StatefulWidget {
  const OnboardTwoScreen({super.key});

  @override
  State<OnboardTwoScreen> createState() => _OnboardTwoScreenState();
}

class _OnboardTwoScreenState extends State<OnboardTwoScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      // bottomNavigationBar: SizedBox(
      //   height: size.height * 0.05,
      //   width: size.width,
      //   child: Row(
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 15),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.pop(context);
      //               },
      //               child: Text(
      //                 "<< Previous",
      //                 style: TextStyle(color: whiteColor),
      //               ),
      //             ),
      //             SizedBox(
      //               width: size.width * 0.22,
      //             ),
      //             Image.asset(onboardTwo),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                whiteLogo,
                height: size.height * 0.3,
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.1,
            ),
            //
            Center(
              child: Text(
                "Would You Like To",
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.04,
                    color: whiteColor.withOpacity(.7)),
              ),
            ),
            //

            Center(
              child: RichText(
                text: TextSpan(
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
                        child: Text(
                          'Explore ',
                          style: GoogleFonts.poppins(
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Nearby',
                      style: GoogleFonts.poppins(
                        fontSize: size.height * 0.04,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            Center(
              child: Text(
                'Places?',
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.w900,
                    color: whiteColor),
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.05,
            ),
            Consumer<MapsController>(
              builder: (context, value, child) {
                return value.isGettingLocation == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : CustomButton(
                        text: 'Enable Your Location',
                        ontap: () {
                          value.getCurrentLocation(context);
                        });
              },
            )
          ],
        ),
      ),
    );
  }
}
