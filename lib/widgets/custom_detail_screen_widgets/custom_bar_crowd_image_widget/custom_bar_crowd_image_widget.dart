import 'package:birds_view/utils/images.dart';
import 'package:flutter/cupertino.dart';

class CustomBarCrowdImageWidget extends StatelessWidget {
  final Size size;
  const CustomBarCrowdImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.07,
      child: Image.asset(
        crowdImage,
        height: size.height * 0.08,
      ),
    );
  }
}
