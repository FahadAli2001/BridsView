import 'package:flutter/material.dart';

import '../../../utils/images.dart';

class CustomBarSubscribeNowButtonWidget extends StatelessWidget {
  final Size size;
  final VoidCallback ontap;
  const CustomBarSubscribeNowButtonWidget(
      {super.key, required this.size, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: size.height * 0.11,
        left: size.width * 0.2,
        child: GestureDetector(
          onTap: ontap,
          child: Container(
            width: size.width * 0.35,
            height: size.height * 0.04,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(button), fit: BoxFit.fill)),
            child: Center(
              child: Text(
                "Subscribe Now",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.015,
                    color: Colors.black),
              ),
            ),
          ),
        ));
  }
}
