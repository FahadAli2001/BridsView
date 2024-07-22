import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomBarRatingWidget extends StatelessWidget {
  final Size size;
  final int index;
  final List<Result>? barDetail;
  const CustomBarRatingWidget(
      {super.key,
      required this.barDetail,
      required this.index,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RatingBarIndicator(
          unratedColor: Colors.white,
          rating: barDetail![index].rating?.toDouble() ?? 0.0,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: primaryColor,
          ),
          itemCount: 5,
          itemSize: size.width * 0.06,
          direction: Axis.horizontal,
        ),
        // GestureDetector(
        //     onTap: () {},
        //     child: Image.asset(instaLink,
        //         width: size.height * 0.04))
      ],
    );
  }
}
