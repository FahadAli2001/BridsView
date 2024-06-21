import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/nearby_bars_model/nearby_bars_model.dart';

class DetailScreen extends StatefulWidget {
  final List<Result>? searchBarDetail;
  final bool fromSearchScreen;
  final List<Rows> distance;
  final List<Results>? barDetail;
  final int index;
  final List<Uint8List?> barImages;
  const DetailScreen(
      {super.key,
      this.searchBarDetail,
      this.barDetail,
      required this.index,
      required this.barImages,
      required this.fromSearchScreen,
      required this.distance});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Result>? barDetail = [];
  @override
  void initState() {
    super.initState();
    if (widget.fromSearchScreen == false) {
      getBarsDetails(widget.barDetail![widget.index].placeId!);
      checkBarId();
    }
  }

  Future<void> checkBarId() async {
    final detailController =
        Provider.of<DetailScreenController>(context, listen: false);

    // await detailController.getRandomNumbers();
    await detailController
        .checkBarPlaceIdExist(widget.barDetail![widget.index].placeId!);
  }

  Future<void> getBarsDetails(String placeId) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    var detail = await mapController.barsDetailMethod(placeId);
    barDetail!.add(detail!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
            text: 'Locate',
            ontap: () async {
              //

              try {
                if (widget.fromSearchScreen == true) {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MapScreen(
                            bar: widget.searchBarDetail!,
                            index: widget.index,
                          ),
                          type: PageTransitionType.fade));
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MapScreen(
                            bar: barDetail!,
                            index: widget.index,
                          ),
                          type: PageTransitionType.fade));
                }
              } catch (e) {
                log(e.toString());
              }
            }),
      ),
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          centerTitle: true,
          title: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: AssetImage(appLogo),
          )),
      body: widget.fromSearchScreen == true
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image:
                                  MemoryImage(widget.barImages[widget.index]!),
                              fit: BoxFit.cover),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: size.height * 0.07,
                                width: size.height * 0.07,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        goldenHalf,
                                      ),
                                      fit: BoxFit.fill),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: size.height * 0.015,
                                        right: size.width * 0.028,
                                        child: Icon(
                                          Icons.bookmark_border,
                                          color: Colors.black,
                                          size: size.height * 0.035,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    //
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    //

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.9,
                          child: Text(
                            widget.searchBarDetail![widget.index].name!,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.03,
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
                    ),
                    //
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          unratedColor: Colors.grey,
                          rating: widget.searchBarDetail![widget.index].rating
                                  ?.toDouble() ??
                              0.0,
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
                    ),
                    //
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    //
                    widget.distance[widget.index].elements == null
                        ? const Text('')
                        : Row(
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
                                    widget.distance[widget.index].elements![0]
                                        .distance!.text
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
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
                                    widget.distance[widget.index].elements![0]
                                        .duration!.text
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              // GestureDetector(
                              //     onTap: () {},
                              //     child: Image.asset(twitterLink,
                              //         width: size.height * 0.04))
                            ],
                          ),
                    //

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    //
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              'Mix Crowd ',
                              style: TextStyle(
                                  fontSize: size.height * 0.026,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Consumer<DetailScreenController>(
                              builder: (context, value, child) {
                                return Text(
                                  '(${value.randomPopulation.toString()})',
                                  style: TextStyle(
                                      fontSize: size.height * 0.026,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            )
                          ],
                        )),
                    //
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.man,
                              color: primaryColor,
                              size: size.height * 0.05,
                            ),
                            Text(
                              "Men",
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          height: size.height * 0.1,
                          width: 2,
                          color: primaryColor,
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.woman,
                              color: primaryColor,
                              size: size.height * 0.05,
                            ),
                            Text(
                              "Women",
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ],
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
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    widget.searchBarDetail![widget.index].editorialSummary ==
                            null
                        ? const Text('')
                        : SizedBox(
                            width: size.width,
                            child: Text(
                              widget.searchBarDetail![widget.index]
                                  .editorialSummary!.overview!,
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                          ),
                    //
                    widget.searchBarDetail![widget.index].editorialSummary ==
                            null
                        ? Container()
                        : SizedBox(
                            height: size.height * 0.02,
                          ),
                    RichText(
                      text: TextSpan(
                        text: "Address : ",
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.searchBarDetail![widget.index]
                                .formattedAddress!,
                            style: TextStyle(
                                fontSize: size.height * 0.018,
                                color: whiteColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.searchBarDetail![widget.index]
                                .formattedPhoneNumber ==
                            null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Phone : ",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                                children: [
                                  TextSpan(
                                    text: widget.searchBarDetail![widget.index]
                                            .formattedPhoneNumber ??
                                        "",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    //
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.searchBarDetail![widget.index].openingHours == null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Open Now : ",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                                children: [
                                  TextSpan(
                                    text: widget.searchBarDetail![widget.index]
                                                .openingHours!.openNow! ==
                                            true
                                        ? "Open"
                                        : "Closed",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    //
                    //
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.searchBarDetail![widget.index].openingHours == null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Timings : ",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                                children: [
                                  for (var i = 0;
                                      i <
                                          widget
                                              .searchBarDetail![widget.index]
                                              .openingHours!
                                              .weekdayText!
                                              .length;
                                      i++) ...[
                                    TextSpan(
                                      text:
                                          "${widget.searchBarDetail![widget.index].openingHours!.weekdayText![i]} \n",
                                      style: TextStyle(
                                          fontSize: size.height * 0.018,
                                          color: whiteColor),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                    //

                    //
                    widget.searchBarDetail![widget.index]
                                .wheelchairAccessibleEntrance ==
                            null
                        ? const Text(' ')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Wheel Chair Entrance: ",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                                children: [
                                  TextSpan(
                                    text: widget.searchBarDetail![widget.index]
                                                .wheelchairAccessibleEntrance ==
                                            true
                                        ? "Available"
                                        : "Not Available",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        color: whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    //

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    //
                    widget.searchBarDetail![widget.index].website == null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: Consumer<DetailScreenController>(
                              builder: (context, value, child) {
                                return RichText(
                                  text: TextSpan(
                                    text: "Website : ",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: widget
                                                .searchBarDetail![widget.index]
                                                .website ??
                                            '',
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            color: Colors.white),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final url = widget
                                                .searchBarDetail![widget.index]
                                                .website;

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
            )
          : barDetail!.isEmpty
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade800,
                  highlightColor: Colors.grey.shade700,
                  child: Center(
                      child: Container(
                    color: Colors.white,
                    width: size.width,
                    height: size.height,
                  )),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                            width: size.width,
                            height: size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: MemoryImage(
                                      widget.barImages[widget.index]!),
                                  fit: BoxFit.cover),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            goldenHalf,
                                          ),
                                          fit: BoxFit.fill),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            top: size.height * 0.015,
                                            right: size.width * 0.028,
                                            child: Icon(
                                              Icons.bookmark_border,
                                              color: Colors.black,
                                              size: size.height * 0.035,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        //
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        //

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.9,
                              child: Text(
                                widget.barDetail![widget.index].name!,
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.03,
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
                        ),
                        //
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBarIndicator(
                              unratedColor: Colors.grey,
                              rating: widget.barDetail![widget.index].rating
                                      ?.toDouble() ??
                                  0.0,
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
                        ),
                        //
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        //
                        widget.distance[widget.index].elements == null
                            ? const Text('')
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        widget.distance[widget.index]
                                            .elements![0].distance!.text
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                        widget.distance[widget.index]
                                            .elements![0].duration!.text
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  // GestureDetector(
                                  //     onTap: () {},
                                  //     child: Image.asset(twitterLink,
                                  //         width: size.height * 0.04))
                                ],
                              ),
                        //
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        //
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Text(
                                  'Mix Crowd ',
                                  style: TextStyle(
                                      fontSize: size.height * 0.026,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Consumer<DetailScreenController>(
                                  builder: (context, value, child) {
                                    return Text(
                                      '(${value.randomPopulation.toString()} APROX)',
                                      style: TextStyle(
                                          fontSize: size.height * 0.026,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                )
                              ],
                            )),
                        //
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.man,
                                  color: primaryColor,
                                  size: size.height * 0.05,
                                ),
                                Text(
                                  "Men",
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.white),
                                )
                              ],
                            ),
                            Container(
                              height: size.height * 0.1,
                              width: 2,
                              color: primaryColor,
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.woman,
                                  color: primaryColor,
                                  size: size.height * 0.05,
                                ),
                                Text(
                                  "Women",
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ],
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
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        barDetail![0].editorialSummary == null
                            ? const Text('')
                            : SizedBox(
                                width: size.width,
                                child: Text(
                                  barDetail![0].editorialSummary!.overview!,
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                      color: Colors.white),
                                ),
                              ),
                        //
                        barDetail![0].editorialSummary == null
                            ? Container()
                            : SizedBox(
                                height: size.height * 0.02,
                              ),
                        RichText(
                          text: TextSpan(
                            text: "Address : ",
                            style: TextStyle(
                                fontSize: size.height * 0.018,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                            children: [
                              TextSpan(
                                text: barDetail![0].formattedAddress!,
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        barDetail![0].formattedPhoneNumber == null
                            ? const Text('')
                            : Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Phone : ",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: barDetail![0]
                                                .formattedPhoneNumber ??
                                            "",
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                    text: "Open Now : ",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: barDetail![0]
                                                    .openingHours!
                                                    .openNow! ==
                                                true
                                            ? "Open"
                                            : "Closed",
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                    text: "Timings : ",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
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
                                              "${barDetail![0].openingHours!.weekdayText![i]} \n",
                                          style: TextStyle(
                                              fontSize: size.height * 0.018,
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
                                child: RichText(
                                  text: TextSpan(
                                    text: "Wheel Chair Entrance : ",
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: barDetail![0]
                                                    .wheelchairAccessibleEntrance ==
                                                true
                                            ? "Available"
                                            : "Not Available",
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        //

                        barDetail![0].website == null
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
                                            fontSize: size.height * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                        children: [
                                          TextSpan(
                                            text: barDetail![0].website ?? '',
                                            style: TextStyle(
                                                fontSize: size.height * 0.018,
                                                color: Colors.white),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final url =
                                                    barDetail![0].website;

                                                try {
                                                  await value
                                                      .socialLaunchUrl(url!);
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
                ),
    );
  }
}
