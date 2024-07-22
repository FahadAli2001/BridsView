import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/icons.dart';

class CustomBarDistanceWidget extends StatelessWidget {
  final Size size;
  final int index;
  final List<Rows> distance;
  const CustomBarDistanceWidget(
      {super.key,
      required this.distance,
      required this.index,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              locationIcon,
              height: size.height * 0.02,
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Text(
              (double.parse(distance[index]
                              .elements![0]
                              .distance
                              ?.text
                              ?.split(" ")[0]
                              .replaceAll(',', '') ??
                          '0') *
                      0.621371)
                  .toStringAsFixed(3),
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.027,
              ),
            ),
            const Text(
              ' Miles',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: size.width * 0.1,
            ),
            SvgPicture.asset(
              watchIcon,
              height: size.height * 0.02,
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Text(
              distance[index].elements![0].duration!.text.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        // GestureDetector(
        //     onTap: () {},
        //     child: Image.asset(twitterLink,
        //         width: size.height * 0.04))
      ],
    );
  }
}
