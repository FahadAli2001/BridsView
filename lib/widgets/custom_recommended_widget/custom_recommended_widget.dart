import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRecommendedWidget extends StatelessWidget {
  const CustomRecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
             "assets/recomended_bar.png",
              height: size.height * 0.2,
              width: size.width * 0.8,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cubix Bar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: size.height * 0.02),
                ),
                RatingBarIndicator(
                  unratedColor: Colors.grey,
                  rating:
                      4.0,
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