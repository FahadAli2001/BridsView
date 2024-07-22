import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_distance_widget/custom_bar_distance_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_heading_widget/custom_bar_heading_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_hot_badge_widget/custom_bar_hot_badge_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_image_widget/custom_bar_image_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_rating_widget/custom_bar_rating_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/deatil_screen_controller/detail_screen_controller.dart';
import '../../../model/bars_distance_model/bars_distance_model.dart';
import '../../custom_description_rich_text/custom_description_rich_text.dart';
import '../custom_bar_crowd_image_widget/custom_bar_crowd_image_widget.dart';
import '../custom_mix_crowd_heading_widget/custom_mix_crowd_heading_widget.dart';

class CustomDetailScreenFromSearchScreen extends StatelessWidget {
  final List<Uint8List?> barImage;
  final int index;
  final List<Result>? searchBarDetail;
  final List<Rows> distance;
  final AnimationController controller;
  final Animation<double> animation;
  const CustomDetailScreenFromSearchScreen(
      {super.key,
      required this.barImage,
      required this.index,
      required this.searchBarDetail,
      required this.distance,
      required this.controller,
      required this.animation});

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
            CustomBarHeadingWidget(
                barDetail: searchBarDetail, index: index, size: size),

            //
            SizedBox(
              height: size.height * 0.01,
            ),
            //
            CustomBarRatingWidget(
                barDetail: searchBarDetail, index: index, size: size),

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

                  searchBarDetail![index].rating != null &&
                          searchBarDetail![index].rating! >= 4.0
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
                        top: size.height * 0.09,
                        left: size.width * 0.2,
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
                ],
              ),
            ),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            //

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
            SizedBox(
              height: size.height * 0.01,
            ),
            searchBarDetail![index].editorialSummary == null
                ? const Text('')
                : SizedBox(
                    width: size.width,
                    child: Text(
                      searchBarDetail![index].editorialSummary!.overview!,
                      style: TextStyle(
                          fontSize: size.height * 0.016, color: Colors.white),
                    ),
                  ),
            //
            searchBarDetail![index].editorialSummary == null
                ? Container()
                : SizedBox(
                    height: size.height * 0.01,
                  ),
            CustomDescriptionRichText(
                title: "Address : ",
                subtitle: searchBarDetail![index].formattedAddress!),

            SizedBox(
              height: size.height * 0.02,
            ),
            searchBarDetail![index].formattedPhoneNumber == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Phone : ",
                        subtitle:
                            searchBarDetail![index].formattedPhoneNumber!)),
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            searchBarDetail![index].openingHours == null
                ? const Text('')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Open Now : ",
                        subtitle:
                            searchBarDetail![index].openingHours!.openNow! ==
                                    true
                                ? "Open"
                                : "Closed")),
            //
            //
            SizedBox(
              height: size.height * 0.02,
            ),
            searchBarDetail![index].openingHours == null
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
                                  searchBarDetail![index]
                                      .openingHours!
                                      .weekdayText!
                                      .length;
                              i++) ...[
                            TextSpan(
                              text:
                                  "\n ${searchBarDetail![index].openingHours!.weekdayText![i]} \n",
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
            searchBarDetail![index].wheelchairAccessibleEntrance == null
                ? const Text(' ')
                : Align(
                    alignment: Alignment.topLeft,
                    child: CustomDescriptionRichText(
                        title: "Wheel Chair Entrance",
                        subtitle: searchBarDetail![index]
                                    .wheelchairAccessibleEntrance ==
                                true
                            ? "Available"
                            : "Not Available")),

            //

            searchBarDetail![index].wheelchairAccessibleEntrance == null
                ? const SizedBox()
                : SizedBox(
                    height: size.height * 0.02,
                  ),
            //
            searchBarDetail![index].website == null
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
                                text: searchBarDetail![index].website ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: size.height * 0.016,
                                    color: Colors.white),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url = searchBarDetail![index].website;

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
