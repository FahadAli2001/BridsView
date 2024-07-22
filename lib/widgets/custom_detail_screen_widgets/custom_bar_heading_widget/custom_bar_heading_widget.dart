import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:flutter/material.dart';

class CustomBarHeadingWidget extends StatelessWidget {
  final Size size;
  final int index;
  final List<Result>? barDetail;
  const CustomBarHeadingWidget(
      {super.key,
      required this.barDetail,
      required this.index,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.9,
          child: Text(
            barDetail![index].name!,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.026,
                color: Colors.white),
          ),
        ),
        // GestureDetector(
        //     onTap: () {},
        //     child: Image.asset(
        //       facebookLink,
        //       width: size.height * 0.04,
        //     ))
      ],
    );
  }
}
