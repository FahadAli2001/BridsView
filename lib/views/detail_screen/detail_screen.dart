import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_description_rich_text/custom_description_rich_text.dart';
import 'package:flutter/cupertino.dart';
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

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<Result>? barDetail = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    if (widget.fromSearchScreen == false) {
      getBarsDetails(widget.barDetail![widget.index].placeId!);
      checkBarId();
      getUserCredential();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getUserCredential() async {
    final bookmarkController =
        Provider.of<BookmarkController>(context, listen: false);
    await bookmarkController.getUserCredential();
  }

  Future<void> checkBarId() async {
    final detailController =
        Provider.of<DetailScreenController>(context, listen: false);

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
              List<Uint8List> nonNullableList = widget.barImages
                  .where((image) => image != null)
                  .cast<Uint8List>()
                  .toList();
              try {
                if (widget.fromSearchScreen == true) {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MapScreen(
                            bar: widget.searchBarDetail!,
                            index: widget.index,
                            barImage: nonNullableList,
                          ),
                          type: PageTransitionType.fade));
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MapScreen(
                            bar: barDetail!,
                            index: widget.index,
                            barImage: nonNullableList,
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
                                        right: size.width * 0.035,
                                        child: const Icon(
                                          CupertinoIcons.bookmark_fill,
                                          color: Colors.black,
                                        )
                                        // Consumer<BookmarkController>(
                                        //   builder: (context, value, child) {
                                        //     return StreamBuilder(
                                        //       stream: value.getBookMarkStream(
                                        //           widget
                                        //               .searchBarDetail![
                                        //                   widget.index]
                                        //               .placeId!),
                                        //       builder: (context, snapshot) {
                                        //         if (snapshot.connectionState ==
                                        //             ConnectionState.waiting) {
                                        //           return Shimmer.fromColors(
                                        //             baseColor: primaryColor,
                                        //             highlightColor:
                                        //                 Colors.white10,
                                        //             child: Center(
                                        //                 child: Container(
                                        //               color: Colors.white,
                                        //             )),
                                        //           );
                                        //         } else if (snapshot.hasError) {
                                        //           return Text(
                                        //               'Error: ${snapshot.error}');
                                        //         } else {
                                        //           return GestureDetector(
                                        //               onTap: () {
                                        //                 if (snapshot.data[
                                        //                         "status"] ==
                                        //                     0) {
                                        //                   value.addBookmark(widget
                                        //                       .searchBarDetail![
                                        //                           widget.index]
                                        //                       .placeId!);
                                        //                 } else if (snapshot
                                        //                             .data[
                                        //                         "status"] ==
                                        //                     1) {
                                        //                   value.deleteBookmark(widget
                                        //                       .searchBarDetail![
                                        //                           widget.index]
                                        //                       .placeId!);
                                        //                 }
                                        //               },
                                        //               child: snapshot.data[
                                        //                           "status"] ==
                                        //                       1
                                        //                   ? const Icon(
                                        //                       CupertinoIcons
                                        //                           .bookmark_fill,
                                        //                       color:
                                        //                           Colors.black,
                                        //                     )
                                        //                   : const Icon(
                                        //                       CupertinoIcons
                                        //                           .bookmark,
                                        //                       color:
                                        //                           Colors.black,
                                        //                     ));
                                        //         }
                                        //       },
                                        //     );
                                        //   },
                                        // )
                                        )
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
                                    (double.parse(widget.distance[widget.index]
                                                    .elements![0].distance?.text
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
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 18,
                            left: 0,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: "Mix ",
                                  style: TextStyle(
                                      fontSize: size.height * 0.026,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                  children: [
                                    TextSpan(
                                      text: 'Crowd',
                                      style: TextStyle(
                                          fontSize: size.height * 0.026,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          widget.searchBarDetail![widget.index].rating !=
                                      null &&
                                  widget.searchBarDetail![widget.index]
                                          .rating! >=
                                      4.0
                              ? AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Positioned(
                                      left: size.width * 0.33,
                                      child: ScaleTransition(
                                        scale: _animation,
                                        child: Image.asset(
                                          banner,
                                          height: size.height * 0.07,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          //

                          //
                          Positioned(
                            top: size.height * 0.07,
                            child: Image.asset(
                              crowdImage,
                              height: size.height * 0.08,
                            ),
                          ),

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
                    widget.searchBarDetail![widget.index].editorialSummary ==
                            null
                        ? const Text('')
                        : SizedBox(
                            width: size.width,
                            child: Text(
                              widget.searchBarDetail![widget.index]
                                  .editorialSummary!.overview!,
                              style: TextStyle(
                                  fontSize: size.height * 0.016,
                                  color: Colors.white),
                            ),
                          ),
                    //
                    widget.searchBarDetail![widget.index].editorialSummary ==
                            null
                        ? Container()
                        : SizedBox(
                            height: size.height * 0.01,
                          ),
                    CustomDescriptionRichText(
                        title: "Address : ",
                        subtitle: widget
                            .searchBarDetail![widget.index].formattedAddress!),

                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.searchBarDetail![widget.index]
                                .formattedPhoneNumber ==
                            null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: CustomDescriptionRichText(
                                title: "Phone : ",
                                subtitle: widget.searchBarDetail![widget.index]
                                    .formattedPhoneNumber!)),
                    //
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    widget.searchBarDetail![widget.index].openingHours == null
                        ? const Text('')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: CustomDescriptionRichText(
                                title: "Open Now : ",
                                subtitle: widget.searchBarDetail![widget.index]
                                            .openingHours!.openNow! ==
                                        true
                                    ? "Open"
                                    : "Closed")),
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
                                text: "Timings :\n ",
                                style: TextStyle(
                                    fontSize: size.height * 0.016,
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
                                          "\n ${widget.searchBarDetail![widget.index].openingHours!.weekdayText![i]} \n",
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
                    widget.searchBarDetail![widget.index]
                                .wheelchairAccessibleEntrance ==
                            null
                        ? const Text(' ')
                        : Align(
                            alignment: Alignment.topLeft,
                            child: CustomDescriptionRichText(
                                title: "Wheel Chair Entrance",
                                subtitle: widget.searchBarDetail![widget.index]
                                            .wheelchairAccessibleEntrance ==
                                        true
                                    ? "Available"
                                    : "Not Available")),

                    //

                    widget.searchBarDetail![widget.index]
                                .wheelchairAccessibleEntrance ==
                            null
                        ? const SizedBox()
                        : SizedBox(
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
                                        fontSize: size.height * 0.016,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                    children: [
                                      TextSpan(
                                        text: widget
                                                .searchBarDetail![widget.index]
                                                .website ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                            fontSize: size.height * 0.016,
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
                                            right: size.width * 0.035,
                                            child: const Icon(
                                              CupertinoIcons.bookmark_fill,
                                              color: Colors.black,
                                            )
                                            //  Consumer<BookmarkController>(
                                            //   builder: (context, value, child) {
                                            //     return StreamBuilder(
                                            //       stream: value
                                            //           .getBookMarkStream(widget
                                            //               .barDetail![
                                            //                   widget.index]
                                            //               .placeId!),
                                            //       builder: (context, snapshot) {
                                            //         if (snapshot
                                            //                 .connectionState ==
                                            //             ConnectionState
                                            //                 .waiting) {
                                            //           return Shimmer.fromColors(
                                            //             baseColor: primaryColor,
                                            //             highlightColor:
                                            //                 Colors.white10,
                                            //             child: Center(
                                            //                 child: Container(
                                            //               color: Colors.white,
                                            //             )),
                                            //           );
                                            //         } else if (snapshot
                                            //             .hasError) {
                                            //           return Text(
                                            //               'Error: ${snapshot.error}');
                                            //         } else {
                                            //           return GestureDetector(
                                            //               onTap: () {
                                            //                 if (snapshot.data[
                                            //                         "status"] ==
                                            //                     0) {
                                            //                   value.addBookmark(widget
                                            //                       .barDetail![
                                            //                           widget
                                            //                               .index]
                                            //                       .placeId!);
                                            //                 } else if (snapshot
                                            //                             .data[
                                            //                         "status"] ==
                                            //                     1) {
                                            //                   value.deleteBookmark(widget
                                            //                       .barDetail![
                                            //                           widget
                                            //                               .index]
                                            //                       .placeId!);
                                            //                 }
                                            //               },
                                            //               child: snapshot.data[
                                            //                           "status"] ==
                                            //                       1
                                            //                   ? const Icon(
                                            //                       CupertinoIcons
                                            //                           .bookmark_fill,
                                            //                       color: Colors
                                            //                           .black,
                                            //                     )
                                            //                   : const Icon(
                                            //                       CupertinoIcons
                                            //                           .bookmark,
                                            //                       color: Colors
                                            //                           .black,
                                            //                     ));
                                            //         }
                                            //       },
                                            //     );
                                            //   },
                                            // )
                                            )
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
                                        (double.parse(widget
                                                        .distance[widget.index]
                                                        .elements![0]
                                                        .distance
                                                        ?.text
                                                        ?.split(" ")[0] ??
                                                    '0') *
                                                0.621371)
                                            .toStringAsFixed(3),
                                        style: const TextStyle(
                                            color: Colors.white),
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
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.15,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 18,
                                left: 0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Mix ",
                                      style: TextStyle(
                                          fontSize: size.height * 0.026,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor),
                                      children: [
                                        TextSpan(
                                          text: 'Crowd',
                                          style: TextStyle(
                                              fontSize: size.height * 0.026,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              barDetail != null &&
                                      barDetail!.isNotEmpty &&
                                      barDetail![0].rating != null &&
                                      barDetail![0].rating! >= 4.0
                                  ? AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Positioned(
                                          left: size.width * 0.33,
                                          child: ScaleTransition(
                                            scale: _animation,
                                            child: Image.asset(
                                              banner,
                                              height: size.height * 0.07,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox(),

                              //

                              //
                              Positioned(
                                top: size.height * 0.07,
                                child: Image.asset(
                                  crowdImage,
                                  height: size.height * 0.08,
                                ),
                              ),

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
                                              image: AssetImage(button),
                                              fit: BoxFit.fill)),
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
                                      fontSize: size.height * 0.016,
                                      color: Colors.white),
                                ),
                              ),
                        //
                        barDetail![0].editorialSummary == null
                            ? Container()
                            : SizedBox(
                                height: size.height * 0.02,
                              ),
                        CustomDescriptionRichText(
                            title: "Address : ",
                            subtitle: barDetail![0].formattedAddress!),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        barDetail![0].formattedPhoneNumber == null
                            ? const Text('')
                            : Align(
                                alignment: Alignment.topLeft,
                                child: CustomDescriptionRichText(
                                    title: "Phone : ",
                                    subtitle:
                                        barDetail![0].formattedPhoneNumber!)),
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
                                    subtitle:
                                        barDetail![0].openingHours!.openNow! ==
                                                true
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
                                    subtitle: barDetail![0]
                                                .wheelchairAccessibleEntrance ==
                                            true
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
