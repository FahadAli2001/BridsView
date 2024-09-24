import 'package:birds_view/widgets/custom_gradient_text/custom_gradient_text.dart';
import 'package:flutter/material.dart';

import '../../../utils/images.dart';

class CustomBarSubscribeNowButtonWidget extends StatelessWidget {
  final Size size;
  final VoidCallback ontap;
  const CustomBarSubscribeNowButtonWidget(
      {super.key, required this.size, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: SizedBox(
          width: size.width,
          height: size.height * 0.1,
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
        ));
  }
}
