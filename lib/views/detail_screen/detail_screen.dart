import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';

import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_detail_screen_from_home/custom_detail_screen_from_home.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_detail_screen_from_search_screen/custom_detail_screen_from_search_screen.dart';
import 'package:flutter/material.dart';

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
            ? CustomDetailScreenFromSearchScreen(
                barImage: widget.barImages,
                index: widget.index,
                searchBarDetail: widget.searchBarDetail,
                distance: widget.distance,
                controller: _controller,
                animation: _animation)
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
                : CustomDetailScreenFromHome(
                    barImage: widget.barImages,
                    index: widget.index,
                    barDetail: barDetail,
                    distance: widget.distance,
                    animation: _animation,
                    controller: _controller));
  }
}
