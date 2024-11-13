import 'dart:typed_data';
import 'package:birds_view/component/text_widget.dart';
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/views.dart';
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
    bool hasImage =
        index < recomendedBar.length && recomdedBarsImages[index] != null;
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
                  image: hasImage
                      ? DecorationImage(
                          image: MemoryImage(recomdedBarsImages[index]!),
                          fit: BoxFit.cover)
                      : DecorationImage(image: AssetImage(emptyImage))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.5,
                  child: 
                  TextWidget(text: recomendedBar[index].name!, color: Colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.fade,
                  fontWeight: FontWeight.w600,
                  fontSize:size.height * 0.016 ,)
                  
                ),
                RatingBarIndicator(
                  unratedColor: Colors.white,
                  rating: recomendedBar[index].rating! * 1.0,
                  itemBuilder: (context, index) {
                    return ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFC59241),
                          Color(0xFFFEF6D1),
                          Color(0xFFC49138),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    );
                  },
                  itemCount: 5,
                  itemSize: size.width * 0.05,
                  direction: Axis.horizontal,
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GradientText(text: recomendedBar[index].openingHours == null ?'':
              recomendedBar[index].openingHours!.openNow == true?"Open":"Closed",
               fontSize: 0.014, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
