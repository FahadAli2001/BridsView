import 'dart:typed_data';

import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRecommendedWidget extends StatelessWidget {
  final List<Results> recomendedBar;
  final int index;
  final List<Uint8List?> recomdedBarsImages;
  const CustomRecommendedWidget(
      {super.key,
      required this.recomendedBar,
      required this.index,
      required this.recomdedBarsImages});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: size.height * 0.2,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: MemoryImage(recomdedBarsImages[index]!),
                      fit: BoxFit.cover)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.5,
                  child: Text(
                    recomendedBar[index].name!,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: size.height * 0.016),
                  ),
                ),
                RatingBarIndicator(
                  unratedColor: Colors.grey,
                  rating: recomendedBar[index].rating! * 1.0,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  itemCount: 5,
                  itemSize: size.width * 0.05,
                  direction: Axis.horizontal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
