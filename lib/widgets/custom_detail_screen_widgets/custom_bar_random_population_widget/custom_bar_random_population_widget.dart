import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/deatil_screen_controller/detail_screen_controller.dart';

class CustomBarRandomPopulationWidget extends StatelessWidget {
  final Size size;
  const CustomBarRandomPopulationWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailScreenController>(
      builder: (context, value, child) {
        return Positioned(
          top: size.height * 0.07,
          left: size.width * 0.32,
          child: Text(
            value.randomPopulation.toString(),
            style: TextStyle(
                fontSize: size.height * 0.026,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
