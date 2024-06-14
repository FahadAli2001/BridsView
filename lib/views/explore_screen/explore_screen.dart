import 'dart:typed_data';
import 'dart:ui';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/search_bars_controller/search_bars_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';
import '../../model/nearby_bars_model/nearby_bars_model.dart';
import '../../widgets/custom_explore_widget/custom_explore_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Uint8List?> barsOrClubsImages = [];
  List<Results> barsOrClubsData = [];
  List<Rows> barsOrClubsDistanceList = [];
  List<Result> barsOrClubsDetail = [];

  // List<Uint8List?> searchBarImages = [];
  // List<Result> searchBarDetail = [];
  // List<Rows> searchBarDistanceList = [];
  bool isSearchBarOpen = false;
  bool isClubs = true;

  @override
  void initState() {
    super.initState();
    clearList();
    getBarsAndClubs('restaurant');
  }

  void clearList() {
    barsOrClubsData.clear();
    barsOrClubsImages.clear();
    barsOrClubsDistanceList.clear();
    barsOrClubsDetail.clear();
  }

  // Future<void> getSearchBars() async {
  //   searchBarDetail.clear();
  //   searchBarDistanceList.clear();
  //   searchBarImages.clear();
  //   final searchBarsController =
  //       Provider.of<SearchBarsController>(context, listen: false);

  //   var data = searchBarsController.getSearchBarsDetail(context: context);
  //   searchBarDetail.addAll(data as Iterable<Result>);
  //   searchBarImages = searchBarsController.searcbarsImage;
  //   searchBarDistanceList = searchBarsController.searcbarsDistance;
  //   setState(() {});
  // }

  Future<void> getBarsAndClubs(String type) async {
    clearList();

    final mapController = Provider.of<MapsController>(context, listen: false);
    mapController.barsAndClubImages.clear();
    mapController.barsAndClubImages.clear();
    var data = await mapController.exploreBarsOrClubs(type);

    barsOrClubsData.addAll(data as Iterable<Results>);
    barsOrClubsImages = mapController.barsAndClubImages;
    barsOrClubsDistanceList = mapController.barsAndClubsDistanceList;

    for (var i = 0; i < barsOrClubsData.length; i++) {
      var detail =
          await mapController.barsDetailMethod(barsOrClubsData[i].reference!);
      barsOrClubsDetail.add(detail!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
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
        title: Text(
          'Explore',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.03),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                isSearchBarOpen = true;
                setState(() {});
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            clearList();
                            getBarsAndClubs('restaurant');
                            setState(() {
                              isClubs = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'Clubs',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.03),
                              ),
                              Divider(
                                color: isClubs == true
                                    ? primaryColor
                                    : Colors.white,
                                thickness: size.height * 0.006,
                              )
                            ],
                          ),
                        ),
                      ),
                      //
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            clearList();
                            getBarsAndClubs('restaurant');
                            setState(() {
                              isClubs = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'Bars',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.03),
                              ),
                              Divider(
                                color: isClubs == true
                                    ? Colors.white
                                    : primaryColor,
                                thickness: size.height * 0.006,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  barsOrClubsData.isEmpty
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade800,
                          highlightColor: Colors.grey.shade700,
                          child: Center(
                              child: Container(
                            color: Colors.white,
                            width: size.width,
                            height: size.height * 0.3,
                          )),
                        )
                      : isClubs == true
                          ? Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: barsOrClubsData.length,
                                itemBuilder: (context, index) {
                                  return CustomExploreWidget(
                                    barsOrClubsImages: barsOrClubsImages,
                                    barsOrClubsData: barsOrClubsData,
                                    barsOrClubsDistanceList:
                                        barsOrClubsDistanceList,
                                    index: index,
                                    barAndClubsDetails: barsOrClubsDetail,
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                              itemCount: barsOrClubsData.length,
                              itemBuilder: (context, index) {
                                return CustomExploreWidget(
                                  barsOrClubsImages: barsOrClubsImages,
                                  barsOrClubsData: barsOrClubsData,
                                  barsOrClubsDistanceList:
                                      barsOrClubsDistanceList,
                                  index: index,
                                  barAndClubsDetails: barsOrClubsDetail,
                                );
                              },
                            ))
                ],
              ),
              //
              if (isSearchBarOpen)
                Positioned.fill(
                  // top: 0,
                  // left: 0,
                  // right: 0,
                  // bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Consumer<SearchBarsController>(builder: (context, value, child) {
                      return Container(
                      color: Colors.black.withOpacity(0.6),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customSearchBarWidget(),
                              value.barDetail.isEmpty
                                  ? const Text("")
                                  : Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: value.barDetail.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            color: Colors.orange,
                                            height: 300,
                                            width: 300,
                                            child: Text(value.barDetail[index]!.name!),
                                          );
                                          //  CustomExploreWidget(
                                          //   barsOrClubsImages:
                                          //       searchBarImages,
                                          //   // barsOrClubsData: searchBarDetail,
                                          //   barsOrClubsDistanceList:
                                          //       searchBarDistanceList,
                                          //   index: index,
                                          //   barAndClubsDetails:
                                          //       searchBarDetail,
                                          // );
                                        },
                                      ),
                                    ),
                            ],
                          )),
                    );
                    },)
                  ),
                ),
            ],
          )),
    );
  }

  Widget customSearchBarWidget() {
    return Consumer<SearchBarsController>(
      builder: (context, value, child) {
        return TextField(
          controller: value.searchTextFieldController,
          onChanged: (val) {
            value.searchBarsOrClubs(val, context);
            setState(() {
              
            });
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade900,
              ),
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchBarOpen = false;
                    });
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey.shade900,
                  ))),
        );
      },
    );
  }
}
