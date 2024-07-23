import 'package:flutter/material.dart';

class CustomBarDescriptionHeadingWidget extends StatelessWidget {
  final Size size;

  const CustomBarDescriptionHeadingWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Description',
          style: TextStyle(
              fontSize: size.height * 0.026,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ));
  }
}
