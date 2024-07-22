import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomMixCrowdHeadingWidget extends StatelessWidget {
  final Size size;
  const CustomMixCrowdHeadingWidget({super.key ,required this.size});

  @override
  Widget build(BuildContext context) {
    return  Positioned(
                    top: 18,
                    left: 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Mix ",
                          style: TextStyle(
                              fontSize: size.height * 0.026,
                              fontWeight: FontWeight.bold,
                              color: whiteColor),
                          children: [
                            TextSpan(
                              text: 'Crowd',
                              style: TextStyle(
                                  fontSize: size.height * 0.026,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}