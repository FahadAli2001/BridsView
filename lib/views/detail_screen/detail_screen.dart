import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/payment_controller/payment_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/bookmark_screen/bookmark_screen.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:birds_view/widgets/custom_bookmark_alert/custom_bookmark_alert.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_hot_badge_widget/custom_bar_hot_badge_widget.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_mix_crowd_heading_widget/custom_mix_crowd_heading_widget.dart';
import 'package:birds_view/widgets/custom_error_toast/custom_error_toast.dart';
import 'package:birds_view/widgets/custom_register_alertbox/custom_register_alertbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/nearby_bars_model/nearby_bars_model.dart';
import '../../widgets/custom_description_rich_text/custom_description_rich_text.dart';
import '../../widgets/custom_detail_screen_widgets/custom_bar_crowd_image_widget/custom_bar_crowd_image_widget.dart';
import '../../widgets/custom_detail_screen_widgets/custom_bar_description_heading_widget/custom_bar_description_heading_widget.dart';
import '../../widgets/custom_detail_screen_widgets/custom_bar_subscribe_now_button_widget/custom_bar_subscribe_now_button_widget.dart';
import '../../widgets/custom_showpro_subscription_popup_widget/custom_showpro_subscription_popup.dart';
import '../../widgets/custom_success_toast/custom_success_toast.dart';

class DetailScreen extends StatefulWidget {
  final UserModel? user;
  final bool fromBookmark;
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
      required this.fromBookmark,
      required this.index,
      required this.barImages,
      required this.fromSearchScreen,
      required this.user,
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

    if (widget.fromSearchScreen == false && widget.fromBookmark == false) {
      getBarsDetails(widget.barDetail![widget.index].placeId!);
      checkBarId(widget.barDetail![widget.index].placeId!);
      log(widget.barDetail![widget.index].placeId!.toString());
      getUserCredential();
    } else if (widget.fromBookmark == true) {
      getBarsDetails(widget.searchBarDetail![widget.index].placeId!);
      checkBarId(widget.searchBarDetail![widget.index].placeId!);
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

  Future<void> checkBarId(String placeId) async {
    final detailController =
        Provider.of<DetailScreenController>(context, listen: false);

    await detailController.checkBarPlaceIdExist(placeId);
  }

  Future<void> getBarsDetails(String placeId) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    var detail = await mapController.barsDetailMethod(placeId);
    barDetail!.add(detail!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage = widget.index < widget.barImages.length &&
        widget.barImages[widget.index] != null;
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key('barClubScreen'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  right: size.width * 0.25,
                  left: size.width * 0.25),
              child: CustomButton(
                  text: 'Locate',
                  ontap: () async {
                    //
                    List<Uint8List> nonNullableList = widget.barImages
                        .where((image) => image != null)
                        .cast<Uint8List>()
                        .toList();
                    try {
                      if (widget.fromSearchScreen == true ||
                          widget.fromBookmark == true) {
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
                        log(barDetail![0].geometry!.location!.lat.toString());
                        log(barDetail![0].geometry!.location!.lng.toString());
                        Navigator.push(
                            context,
                            PageTransition(
                                child: MapScreen(
                                  bar: barDetail!,
                                  index: 0,
                                  barImage: nonNullableList,
                                ),
                                type: PageTransitionType.fade));
                      }
                    } catch (e) {
                      log("Detail Screen : $e");
                    }
                  }),
            ),
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: GestureDetector(
                    onTap: () {
                      if (widget.fromBookmark == true) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookmarkScreen(userModel: widget.user),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                centerTitle: true,
                title: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage(whiteLogo),
                )),
            body: widget.fromSearchScreen == true || widget.fromBookmark == true
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
                                image: hasImage
                                    ? DecorationImage(
                                        image: MemoryImage(
                                            widget.barImages[widget.index]!),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: AssetImage(emptyImage)),
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
                                              child: widget.user == null
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        customRegisterAlertBox(
                                                            context);
                                                      },
                                                      child: const Icon(
                                                        CupertinoIcons.bookmark,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  : widget.user!.data!
                                                              .subscribe ==
                                                          "0"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            customBookmarkAlertBox(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .bookmark,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Consumer<
                                                          BookmarkController>(
                                                          builder: (context,
                                                              controller,
                                                              child) {
                                                            return FutureBuilder<
                                                                Map<String,
                                                                    dynamic>>(
                                                              future: controller
                                                                  .getBookMarkStatus(widget
                                                                      .searchBarDetail![
                                                                          widget
                                                                              .index]
                                                                      .placeId!),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Text(
                                                                      " ");
                                                                } else if (snapshot
                                                                        .hasError ||
                                                                    snapshot.data?[
                                                                            "status"] ==
                                                                        -1) {
                                                                  return const Text(
                                                                      " ");
                                                                } else {
                                                                  bool
                                                                      isBookmarked =
                                                                      snapshot.data?[
                                                                              "status"] ==
                                                                          1;
                                                                  return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      bool success = await controller.handleBookmarkAction(
                                                                          widget
                                                                              .searchBarDetail![widget.index]
                                                                              .placeId!,
                                                                          !isBookmarked);
                                                                      if (success) {
                                                                        Future.delayed(
                                                                            const Duration(seconds: 1),
                                                                            () {
                                                                          showCustomSuccessToast(
                                                                              message: isBookmarked ? "Bookmark Removed" : "Bookmark Added");
                                                                        });
                                                                      } else {
                                                                        showCustomErrorToast(
                                                                            message:
                                                                                "Action failed");
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                      isBookmarked
                                                                          ? CupertinoIcons
                                                                              .bookmark_fill
                                                                          : CupertinoIcons
                                                                              .bookmark,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          },
                                                        )

                                              // Consumer<
                                              //     BookmarkController>(
                                              //     builder: (context,
                                              //         value, child) {
                                              //       return StreamBuilder(
                                              //         stream: value.getBookMarkStream(widget
                                              //             .searchBarDetail![
                                              //                 widget
                                              //                     .index]
                                              //             .placeId!),
                                              //         builder: (context,
                                              //             snapshot) {
                                              //           if (snapshot
                                              //                   .connectionState ==
                                              //               ConnectionState
                                              //                   .waiting) {
                                              //             return Shimmer
                                              //                 .fromColors(
                                              //               baseColor:
                                              //                   primaryColor,
                                              //               highlightColor:
                                              //                   Colors
                                              //                       .white10,
                                              //               child: Center(
                                              //                   child: Container(
                                              //                 color: Colors
                                              //                     .white,
                                              //               )),
                                              //             );
                                              //           } else if (snapshot
                                              //               .hasError) {
                                              //             return Text(
                                              //                 'Error: ${snapshot.error}');
                                              //           } else {
                                              //             return GestureDetector(
                                              //                 onTap:
                                              //                     () {
                                              //                   if (snapshot.data["status"] ==
                                              //                       0) {
                                              //                     value.addBookmark(widget
                                              //                         .searchBarDetail![widget.index]
                                              //                         .placeId!);
                                              //                   } else if (snapshot.data["status"] ==
                                              //                       1) {
                                              //                     value.deleteBookmark(widget
                                              //                         .searchBarDetail![widget.index]
                                              //                         .placeId!);
                                              //                   }
                                              //                 },
                                              //                 child: snapshot.data["status"] ==
                                              //                         1
                                              //                     ? const Icon(
                                              //                         CupertinoIcons.bookmark_fill,
                                              //                         color: Colors.black,
                                              //                       )
                                              //                     : const Icon(
                                              //                         CupertinoIcons.bookmark,
                                              //                         color: Colors.black,
                                              //                       ));
                                              //           }
                                              //         },
                                              //       );
                                              //     },
                                              //   )
                                              )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          //
                          SizedBox(
                            width: size.width * 0.9,
                            child: Text(
                              widget.searchBarDetail![widget.index].name!,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.026,
                                  color: Colors.white),
                            ),
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
                                unratedColor: Colors.white,
                                rating: widget
                                        .searchBarDetail![widget.index].rating
                                        ?.toDouble() ??
                                    0.0,
                                itemBuilder: (context, index) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
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
                                itemSize: size.width * 0.06,
                                direction: Axis.horizontal,
                              )
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
                                                          .distance[
                                                              widget.index]
                                                          .elements![0]
                                                          .distance
                                                          ?.text
                                                          ?.split(" ")[0]
                                                          .replaceAll(
                                                              ',', '') ??
                                                      '0') *
                                                  0.621371)
                                              .toStringAsFixed(1),
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' Miles',
                                          style: GoogleFonts.urbanist(
                                              fontWeight: FontWeight.bold,
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
                                                          .elements !=
                                                      null &&
                                                  widget.distance[widget.index]
                                                      .elements!.isNotEmpty &&
                                                  widget
                                                          .distance[
                                                              widget.index]
                                                          .elements![0]
                                                          .duration !=
                                                      null
                                              ? widget.distance[widget.index]
                                                  .elements![0].duration!.text
                                                  .toString()
                                              : "N/A", // Fallback if duration or elements is null
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                          ),
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

                          widget.user == null ||
                                  widget.user!.data!.subscribe == '0'
                              ? Consumer<PaymentController>(
                                  builder: (context, value, child) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: CustomBarSubscribeNowButtonWidget(
                                          ontap: () {
                                            if (widget.user == null) {
                                              showCustomErrorToast(
                                                  message:
                                                      "Please Login First");
                                            } else {
                                              showProSubscriptionPopup(context,
                                                  () async {
                                                await value
                                                    .makePayment(context);
                                              });
                                            }
                                          },
                                          size: size),
                                    );
                                  },
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      width: size.width,
                                      height: size.height * 0.06,
                                      child: Stack(
                                        children: [
                                          CustomMixCrowdHeadingWidget(
                                              size: size),

                                          widget.searchBarDetail![widget.index]
                                                          .rating !=
                                                      null &&
                                                  widget
                                                          .searchBarDetail![
                                                              widget.index]
                                                          .rating! >=
                                                      4.0
                                              ? CustomBarHotBadgeWidget(
                                                  animation: _animation,
                                                  controller: _controller,
                                                  size: size)
                                              : const SizedBox(),
                                          //

                                          //

                                          //
                                          // CustomBarRandomPopulationWidget(
                                          //     size: size),
                                        ],
                                      ),
                                    ),
                                    CustomBarCrowdImageWidget(size: size),
                                  ],
                                ),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          //

                          //
                          CustomBarDescriptionHeadingWidget(size: size),
                          //
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          widget.searchBarDetail![widget.index]
                                      .editorialSummary ==
                                  null
                              ? const SizedBox()
                              : SizedBox(
                                  width: size.width,
                                  child: Text(
                                    widget.searchBarDetail![widget.index]
                                        .editorialSummary!.overview!
                                        .trim(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.urbanist(
                                        fontSize: size.height * 0.016,
                                        color: Colors.white),
                                  ),
                                ),
                          //
                          widget.searchBarDetail![widget.index]
                                      .editorialSummary ==
                                  null
                              ? const SizedBox()
                              : SizedBox(
                                  height: size.height * 0.01,
                                ),
                          CustomDescriptionRichText(
                              title: "Address : ",
                              subtitle: widget.searchBarDetail![widget.index]
                                  .formattedAddress!
                                  .trim()),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          widget.searchBarDetail![widget.index].openingHours ==
                                  null
                              ? const Text('')
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.searchBarDetail![widget.index]
                                                .openingHours!.openNow! ==
                                            true
                                        ? "Open"
                                        : "Closed",
                                    style: GoogleFonts.urbanist(
                                      fontSize: size.height * 0.016,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //  CustomDescriptionRichText(
                                  //     title: "" ,
                                  //     subtitle:
                                  //         widget.searchBarDetail![widget.index]
                                  //                     .openingHours!.openNow! ==
                                  //                 true
                                  //             ? "Open"
                                  //             : "Closed")
                                ),
                          //
                          //
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          widget.searchBarDetail![widget.index].openingHours ==
                                  null
                              ? const Text('')
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: Stack(
                                    children: [
                                      // Gradient border
                                      Container(
                                        width: size.width,
                                        height: size.height * 0.32,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(1)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFC59241),
                                              Color(0xFFFEF6D1),
                                              Color(0xFFC49138),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      ),

                                      // RichText inside the container
                                      Positioned(
                                        right: 3,
                                        left: 3,
                                        bottom: 3,
                                        top: 3,
                                        child: Container(
                                          width: size.width,
                                          color: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: ShaderMask(
                                                      shaderCallback: (bounds) =>
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(
                                                              0xFFC59241), // Left side color
                                                          Color(
                                                              0xFFFEF6D1), // Center color
                                                          Color(
                                                              0xFFC49138), // Right side color
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ).createShader(bounds),
                                                      child: Text(
                                                        "Hours Of Operation: ",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          fontSize:
                                                              size.height *
                                                                  0.016,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 2,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  for (var i = 0;
                                                      i <
                                                          widget
                                                              .searchBarDetail![
                                                                  widget.index]
                                                              .openingHours!
                                                              .weekdayText!
                                                              .length;
                                                      i++) ...[
                                                    TextSpan(
                                                      text:
                                                          "\n${widget.searchBarDetail![widget.index].openingHours!.weekdayText![i]} \n",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize:
                                                                  size.height *
                                                                      0.016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  whiteColor),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

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
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline: TextBaseline.alphabetic,
                                              child: ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    const LinearGradient(
                                                  colors: [
                                                    Color(0xFFC59241),
                                                    Color(0xFFFEF6D1),
                                                    Color(0xFFC49138),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ).createShader(bounds),
                                                child: Text(
                                                  "Website : ",
                                                  style: GoogleFonts.urbanist(
                                                      fontSize:
                                                          size.height * 0.016,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 2,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Click To Visit Website!",
                                              style: GoogleFonts.urbanist(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: size.height * 0.016,
                                                  color: Colors.white),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  final url = widget
                                                      .searchBarDetail![
                                                          widget.index]
                                                      .website;

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
                                    image: hasImage
                                        ? DecorationImage(
                                            image: MemoryImage(widget
                                                .barImages[widget.index]!),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: AssetImage(emptyImage)),
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
                                                  child: widget.user == null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            showCustomErrorToast(
                                                                message:
                                                                    "Login First");
                                                          },
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .bookmark,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Consumer<
                                                          BookmarkController>(
                                                          builder: (context,
                                                              controller,
                                                              child) {
                                                            return FutureBuilder<
                                                                Map<String,
                                                                    dynamic>>(
                                                              future: controller
                                                                  .getBookMarkStatus(
                                                                      barDetail![
                                                                              0]
                                                                          .placeId!),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Text(
                                                                      " ");
                                                                } else if (snapshot
                                                                        .hasError ||
                                                                    snapshot.data?[
                                                                            "status"] ==
                                                                        -1) {
                                                                  return const Text(
                                                                      " ");
                                                                } else {
                                                                  bool
                                                                      isBookmarked =
                                                                      snapshot.data?[
                                                                              "status"] ==
                                                                          1;
                                                                  return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      bool success = await controller.handleBookmarkAction(
                                                                          barDetail![0]
                                                                              .placeId!,
                                                                          !isBookmarked);
                                                                      setState(
                                                                          () {});
                                                                      if (success) {
                                                                        Future.delayed(
                                                                            const Duration(seconds: 3),
                                                                            () {
                                                                          showCustomSuccessToast(
                                                                              message: isBookmarked ? "Bookmark Removed" : "Bookmark Added");
                                                                        });
                                                                      } else {
                                                                        showCustomErrorToast(
                                                                            message:
                                                                                "Action failed");
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                      isBookmarked
                                                                          ? CupertinoIcons
                                                                              .bookmark_fill
                                                                          : CupertinoIcons
                                                                              .bookmark,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          },
                                                        )

                                                  // Consumer<
                                                  //     BookmarkController>(
                                                  //     builder: (context,
                                                  //         value, child) {
                                                  //       return StreamBuilder(
                                                  //         stream: value
                                                  //             .getBookMarkStream(
                                                  //                 barDetail![
                                                  //                         0]
                                                  //                     .placeId!),
                                                  //         builder: (context,
                                                  //             snapshot) {
                                                  //           int currentStatus = snapshot.data !=
                                                  //                       null &&
                                                  //                   snapshot.data["status"] !=
                                                  //                       null
                                                  //               ? snapshot
                                                  //                       .data[
                                                  //                   "status"]
                                                  //               : 0;

                                                  //           if (snapshot
                                                  //                   .connectionState ==
                                                  //               ConnectionState
                                                  //                   .waiting) {
                                                  //             return Shimmer
                                                  //                 .fromColors(
                                                  //               baseColor:
                                                  //                   primaryColor,
                                                  //               highlightColor:
                                                  //                   Colors
                                                  //                       .white10,
                                                  //               child:
                                                  //                   Center(
                                                  //                 child:
                                                  //                     Container(
                                                  //                   color: Colors
                                                  //                       .white,
                                                  //                 ),
                                                  //               ),
                                                  //             );
                                                  //           } else if (snapshot
                                                  //               .hasError) {
                                                  //             return Text(
                                                  //                 'Error: ${snapshot.error}');
                                                  //           } else {
                                                  //             return GestureDetector(
                                                  //               onTap:
                                                  //                   () async {
                                                  //                 if (currentStatus ==
                                                  //                     0) {
                                                  //                   currentStatus =
                                                  //                       1;
                                                  //                   value.addBookmark(
                                                  //                       barDetail![0].placeId!);
                                                  //                 } else if (currentStatus ==
                                                  //                     1) {
                                                  //                   currentStatus =
                                                  //                       0;
                                                  //                   value.deleteBookmark(
                                                  //                       barDetail![0].placeId!);
                                                  //                 }
                                                  //               },
                                                  //               child: value.loading ==
                                                  //                       true
                                                  //                   ? Shimmer
                                                  //                       .fromColors(
                                                  //                       baseColor:
                                                  //                           primaryColor,
                                                  //                       highlightColor:
                                                  //                           Colors.white10,
                                                  //                       child:
                                                  //                           Center(
                                                  //                         child: Container(
                                                  //                           color: Colors.white,
                                                  //                         ),
                                                  //                       ),
                                                  //                     )
                                                  //                   : currentStatus ==
                                                  //                           1
                                                  //                       ? const Icon(
                                                  //                           CupertinoIcons.bookmark_fill,
                                                  //                           color: Colors.black,
                                                  //                         )
                                                  //                       : const Icon(
                                                  //                           CupertinoIcons.bookmark,
                                                  //                           color: Colors.black,
                                                  //                         ),
                                                  //             );
                                                  //           }
                                                  //         },
                                                  //       );
                                                  //     },
                                                  //   ))

                                                  )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),

                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //
                              SizedBox(
                                width: size.width * 0.9,
                                child: Text(
                                  barDetail![0].name!,
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height * 0.026,
                                      color: Colors.white),
                                ),
                              ),

                              //
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              //
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBarIndicator(
                                    unratedColor: Colors.white,
                                    rating:
                                        barDetail![0].rating?.toDouble() ?? 0.0,
                                    itemBuilder: (context, index) {
                                      return ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
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
                                    itemSize: size.width * 0.06,
                                    direction: Axis.horizontal,
                                  )
                                ],
                              ),

                              //
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              //
                              widget.distance[0].elements == null
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
                                                              .distance[0]
                                                              .elements![0]
                                                              .distance
                                                              ?.text
                                                              ?.split(" ")[0]
                                                              .replaceAll(
                                                                  ',', '') ??
                                                          '0') *
                                                      0.621371)
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.urbanist(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ' Miles',
                                              style: GoogleFonts.urbanist(
                                                  fontWeight: FontWeight.bold,
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
                                            widget.distance[0].elements![0]
                                                        .duration!.text ==
                                                    null
                                                ? const Text(" ")
                                                : Text(
                                                    widget
                                                            .distance[0]
                                                            .elements![0]
                                                            .duration!
                                                            .text ??
                                                        "",
                                                    style: GoogleFonts.urbanist(
                                                        fontWeight:
                                                            FontWeight.bold,
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

                              widget.user == null ||
                                      widget.user!.data!.subscribe == "0"
                                  ? Consumer<PaymentController>(
                                      builder: (context, value, child) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child:
                                              CustomBarSubscribeNowButtonWidget(
                                                  ontap: () {
                                                    if (widget.user == null) {
                                                      showCustomErrorToast(
                                                          message:
                                                              "Please Login First");
                                                    } else {
                                                      showProSubscriptionPopup(
                                                          context, () async {
                                                        await value.makePayment(
                                                            context);
                                                      });
                                                    }
                                                  },
                                                  size: size),
                                        );
                                      },
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          // color: Colors.orange,
                                          width: size.width * 0.9,
                                          height: size.height * 0.06,
                                          child: Stack(
                                            children: [
                                              CustomMixCrowdHeadingWidget(
                                                  size: size),

                                              barDetail![0].rating != null &&
                                                      barDetail![0].rating! >=
                                                          4.0
                                                  ? CustomBarHotBadgeWidget(
                                                      animation: _animation,
                                                      controller: _controller,
                                                      size: size)
                                                  : const SizedBox(),
                                              //
                                            ],
                                          ),
                                        ),
                                        //

                                        CustomBarCrowdImageWidget(size: size)
                                      ],
                                    ),

                              //
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              //

                              //
                              CustomBarDescriptionHeadingWidget(size: size),
                              //
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              barDetail![0].editorialSummary == null
                                  ? const Text('')
                                  : SizedBox(
                                      width: size.width,
                                      child: Text(
                                        barDetail![0]
                                            .editorialSummary!
                                            .overview!,
                                        style: GoogleFonts.urbanist(
                                            fontSize: size.height * 0.016,
                                            color: Colors.white),
                                      ),
                                    ),
                              //
                              barDetail![0].editorialSummary == null
                                  ? Container()
                                  : SizedBox(
                                      height: size.height * 0.01,
                                    ),
                              CustomDescriptionRichText(
                                  title: "Address : ",
                                  subtitle: barDetail![0].formattedAddress!),

                              //
                              barDetail![0].openingHours == null
                                  ? Container()
                                  : SizedBox(
                                      height: size.height * 0.02,
                                    ),
                              barDetail![0].openingHours == null
                                  ? const Text('')
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        barDetail![0].openingHours!.openNow! ==
                                                true
                                            ? "Open"
                                            : "Closed",
                                        style: GoogleFonts.urbanist(
                                          fontSize: size.height * 0.016,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // CustomDescriptionRichText(
                                      //     title: "Open Now : ",
                                      //     subtitle: barDetail![0]
                                      //                 .openingHours!
                                      //                 .openNow! ==
                                      //             true
                                      //         ? "Open"
                                      //         : "Closed")
                                    ),
                              //
                              //
                              barDetail![0].openingHours == null
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: size.height * 0.02,
                                    ),
                              barDetail![0].openingHours == null
                                  ? const Text('')
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: size.width,
                                            height: size.height * 0.318,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(1)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFC59241),
                                                  Color(0xFFFEF6D1),
                                                  Color(0xFFC49138),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 3,
                                            left: 3,
                                            bottom: 3,
                                            top: 3,
                                            child: Container(
                                              width: size.width,
                                              color: Colors.black,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: ShaderMask(
                                                          shaderCallback:
                                                              (bounds) =>
                                                                  const LinearGradient(
                                                            colors: [
                                                              Color(
                                                                  0xFFC59241), // Left side color
                                                              Color(
                                                                  0xFFFEF6D1), // Center color
                                                              Color(
                                                                  0xFFC49138), // Right side color
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ).createShader(
                                                                      bounds),
                                                          child: Text(
                                                            "Hours Of Operation: ",
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize:
                                                                  size.height *
                                                                      0.016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      for (var i = 0;
                                                          i <
                                                              barDetail![0]
                                                                  .openingHours!
                                                                  .weekdayText!
                                                                  .length;
                                                          i++) ...[
                                                        TextSpan(
                                                          text:
                                                              "\n${barDetail![0].openingHours!.weekdayText![i]} \n",
                                                          style: GoogleFonts
                                                              .urbanist(
                                                            fontSize:
                                                                size.height *
                                                                    0.016,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                              //
                              // barDetail![0].wheelchairAccessibleEntrance == null
                              //     ? const SizedBox()
                              //     : SizedBox(
                              //         height: size.height * 0.02,
                              //       ),
                              //
                              barDetail![0].website == null
                                  ? const Text('')
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: Consumer<DetailScreenController>(
                                        builder: (context, value, child) {
                                          return RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .baseline,
                                                  baseline:
                                                      TextBaseline.alphabetic,
                                                  child: ShaderMask(
                                                    shaderCallback: (bounds) =>
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFFC59241),
                                                        Color(0xFFFEF6D1),
                                                        Color(0xFFC49138),
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ).createShader(bounds),
                                                    child: Text(
                                                      "Website : ",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize:
                                                                  size.height *
                                                                      0.016,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 2,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "Click To Visit Website!",
                                                  style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          size.height * 0.016,
                                                      color: Colors.white),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          final url =
                                                              barDetail![0]
                                                                  .website;

                                                          try {
                                                            await value
                                                                .socialLaunchUrl(
                                                                    url!);
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
                      )));
  }
}
