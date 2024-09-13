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
                "Would You Like",
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.04,
                    color: whiteColor.withOpacity(.7)),
              ),
            ),
            //

            Center(
              child: RichText(
                text: TextSpan(
                  text: "Explore ",
                  style: GoogleFonts.urbanist(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.w900,
                      color: primaryColor),
                  children: [
                    TextSpan(
                      text: 'Place',
                      style: GoogleFonts.urbanist(
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.w900,
                          color: whiteColor),
                    ),
                  ],
                ),
              ),
            ),

            //
            Center(
              child: Text(
                'Nearby',
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
