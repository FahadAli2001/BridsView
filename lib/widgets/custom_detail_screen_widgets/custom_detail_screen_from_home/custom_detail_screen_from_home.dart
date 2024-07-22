import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_crowd_image_widget/custom_bar_crowd_image_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_distance_widget/custom_bar_distance_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_heading_widget/custom_bar_heading_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_hot_badge_widget/custom_bar_hot_badge_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_image_widget/custom_bar_image_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_rating_widget/custom_bar_rating_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_mix_crowd_heading_widget/custom_mix_crowd_heading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/deatil_screen_controller/detail_screen_controller.dart';
import '../../../utils/colors.dart';
import '../../custom_description_rich_text/custom_description_rich_text.dart';

class CustomDetailScreenFromHome extends StatelessWidget {
  final List<Uint8List?> barImage;
  final int index;
  final List<Result>? barDetail;
  final List<Rows> distance;
  final AnimationController controller;
  final Animation<double> animation;
  const CustomDetailScreenFromHome(
      {super.key,
      required this.barImage,
      required this.index,
      required this.barDetail,
      required this.distance,
      required this.animation,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            CustomBarImageWidget(barImage: barImage, index: index),

            SizedBox(
              height: size.height * 0.02,
            ),
            //

            CustomBarRatingWidget(
                barDetail: barDetail, index: index, size: size),
            //
            SizedBox(
              height: size.height * 0.01,
            ),
            //
            CustomBarHeadingWidget(
                barDetail: barDetail, index: index, size: size),

            //
            SizedBox(
              height: size.height * 0.01,
            ),
            //
            distance[index].elements == null
                ? const Text('')
                : CustomBarDistanceWidget(
                    distance: distance, index: index, size: size),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            //
            SizedBox(
              width: size.width,
              height: size.height * 0.15,
              child: Stack(
                children: [
                  CustomMixCrowdHeadingWidget(size: size),
                  barDetail != null &&
                          barDetail!.isNotEmpty &&
                          barDetail![0].rating != null &&
                          barDetail![0].rating! >= 4.0
                      ? CustomBarHotBadgeWidget(
                          animation: animation,
                          controller: controller,
                          size: size)
                      : const SizedBox(),

                  //

                  //
                  CustomBarCrowdImageWidget(size: size),
                  //
                  Consumer<DetailScreenController>(
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
                  ),
                  Positioned(
                      top: size.height * 0.11,
                      left: size.width * 0.2,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: size.width * 0.35,
                          height: size.height * 0.04,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(button), fit: BoxFit.fill)),
                          child: Center(
                            child: Text(
                              "Subscribe Now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.015,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            //
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: size.height * 0.026,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            //

            barDetail![0].editorialSummary == null
                ? const Text('')
                : SizedBox(
                    width: size.width,
                    child: Text(
                      barDetail![0].editorialSummary!.overview!,
                      style: TextStyle(
                          fontSize: size.height * 0.016, color: Colors.white),
                    ),
                  ),
            //
            barDetail![0].editorialSummary == null
                ? Container()
                : SizedBox(
                    height: size.height * 0.02,
                  ),
            CustomDescriptionRichText(
                title: "Address : ", subtitle: barDetail![0].formattedAddress!),
            SizedBox(
              height: size.height * 0.02,
            ),
            barDetail![0].formattedPhoneNumber == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Phone : ",
                        subtitle: barDetail![0].formattedPhoneNumber!)),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            barDetail![0].openingHours == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Open Now : ",
                        subtitle: barDetail![0].openingHours!.openNow! == true
                            ? "Open"
                            : "Closed")),
            //
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            barDetail![0].openingHours == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Timings :\n ",
                        style: TextStyle(
                            fontSize: size.height * 0.016,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                        children: [
                          for (var i = 0;
                              i <
                                  barDetail![0]
                                      .openingHours!
                                      .weekdayText!
                                      .length;
                              i++) ...[
                            TextSpan(
                              text:
                                  "\n ${barDetail![0].openingHours!.weekdayText![i]} \n",
                              style: TextStyle(
                                  fontSize: size.height * 0.016,
                                  fontWeight: FontWeight.normal,
                                  color: whiteColor),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
            //

            //
            barDetail![0].wheelchairAccessibleEntrance == null
                ? const Text(' ')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Wheel Chair Entrance : ",
                        subtitle:
                            barDetail![0].wheelchairAccessibleEntrance == true
                                ? "Available"
                                : "Not Available")),
            //

            barDetail![0].wheelchairAccessibleEntrance == null
                ? const SizedBox()
                : SizedBox(
                    height: size.height * 0.02,
                  ),
            //
            barDetail![0].website == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: Consumer<DetailScreenController>(
                      builder: (context, value, child) {
                        return RichText(
                          text: TextSpan(
                            text: "Website : ",
                            style: TextStyle(
                                fontSize: size.height * 0.016,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                            children: [
                              TextSpan(
                                text: barDetail![0].website ?? '',
                                style: TextStyle(
                                    fontSize: size.height * 0.016,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url = barDetail![0].website;

                                    try {
                                      await value.socialLaunchUrl(url!);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                              ),
                            ],
                          ),
                        );
                      },
                    )),
          ],
        ),
      ),
    );
  }
}
