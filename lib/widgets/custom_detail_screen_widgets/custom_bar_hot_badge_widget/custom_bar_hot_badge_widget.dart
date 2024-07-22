import 'package:birds_view/utils/images.dart';
import 'package:flutter/material.dart';

class CustomBarHotBadgeWidget extends StatelessWidget {
  final Size size;
  final AnimationController controller;
  final Animation<double> animation;
  const CustomBarHotBadgeWidget(
      {super.key,
      required this.animation,
      required this.controller,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: size.width * 0.33,
          child: ScaleTransition(
            scale: animation,
            child: Image.asset(
              banner,
              height: size.height * 0.07,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
