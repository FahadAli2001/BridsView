import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/widgets/custom_gradient_text/custom_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/images.dart';

class CustomBarSubscribeNowButtonWidget extends StatelessWidget {
  final Size size;
  final VoidCallback ontap;
  const CustomBarSubscribeNowButtonWidget(
      {super.key, required this.size, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailScreenController>(
      builder: (context, value, child) {
        return Row(
          children: [
            GestureDetector(
              onTap: ontap,
              child: SizedBox(
                child: Row(
                  children: [
                    Image.asset(subscribeBtn),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    const GradientText(
                        text: "Subscribe Now",
                        fontSize: 0.026,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Container(
              height: size.height * 0.1,
              width: 5,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Column(
              children: [
                Image.asset(
                  "assets/mix.png",
                  height: size.height * 0.08,
                  fit: BoxFit.contain,
                ),
                Text(
                  value.totalPerson.toString(),
                  style: GoogleFonts.urbanist(
                      fontSize: size.height * 0.026,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
