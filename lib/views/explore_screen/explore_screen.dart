import 'dart:ui';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/search_bars_controller/search_bars_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_explore_widget/custom_explore_widget.dart';

class ExploreScreen extends StatefulWidget {
  final UserModel? user;
  const ExploreScreen({super.key, required this.user});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isSearchBarOpen = false;
  bool isClubs = true;
  @override
  void initState() {
    super.initState();
    final searchController =
        Provider.of<SearchBarsController>(context, listen: false);
    searchController.getCordinateds();

    getBarsAndClubs('night_club');
  }

  Future<void> getBarsAndClubs(String type) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    mapController.clearExploreScreenList();
    await mapController.exploreBarsOrClubs(type);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("Explore"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
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
                style: GoogleFonts.urbanist(
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
                    child: Icon(Icons.search,
                        color: Colors.white, size: size.height * 0.04),
                  ),
                )
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(15),
                child: Consumer<MapsController>(
                  builder: (context, mapController, child) {
                    return Stack(
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
                                      mapController.clearExploreScreenList();
                                      getBarsAndClubs('night_club');
                                      setState(() {
                                        isClubs = true;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Clubs',
                                          style: GoogleFonts.urbanist(
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
                                      mapController.clearExploreScreenList();
                                      getBarsAndClubs('bar');
                                      setState(() {
                                        isClubs = false;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Bars',
                                          style: GoogleFonts.urbanist(
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

                            mapController
                                    .exploreScreenbarAndClubsDetails.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : isClubs == true
                                    ? Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: mapController
                                              .exploreScreenbarsOrClubsData!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return CustomExploreWidget(
                                              user: widget.user,
                                              barsOrClubsImages: mapController
                                                  .exploreScreenbarsOrClubsImages,
                                              barsOrClubsData: mapController
                                                  .exploreScreenbarsOrClubsData,
                                              barsOrClubsDistanceList: mapController
                                                  .exploreScreenbarsOrClubsDistanceList,
                                              index: index,
                                              barAndClubsDetails: mapController
                                                  .exploreScreenbarAndClubsDetails,
                                            );
                                          },
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                        itemCount: mapController
                                            .exploreScreenbarsOrClubsData!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return CustomExploreWidget(
                                            user: widget.user,
                                            barsOrClubsImages: mapController
                                                .exploreScreenbarsOrClubsImages,
                                            barsOrClubsData: mapController
                                                .exploreScreenbarsOrClubsData,
                                            barsOrClubsDistanceList: mapController
                                                .exploreScreenbarsOrClubsDistanceList,
                                            index: index,
                                            barAndClubsDetails: mapController
                                                .exploreScreenbarAndClubsDetails,
                                          );
                                        },
                                      ))
                          ],
                        ),
                        //
                        if (isSearchBarOpen)
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Consumer<SearchBarsController>(
                                builder: (context, value, child) {
                                  return Container(
                                    color: Colors.black.withOpacity(0.6),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          customSearchBarWidget(),
                                          value.searchingBar
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ),
                                                )
                                              : value.barDetail.isEmpty
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 20),
                                                      child: Text(
                                                        "Search Bars Or Clubs",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                color: Colors
                                                                    .white60),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: ListView.builder(
                                                        itemCount: value
                                                            .searcbarsImage
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final nonNullBarDetail =
                                                              value.barDetail
                                                                  .where(
                                                                      (item) =>
                                                                          item !=
                                                                          null)
                                                                  .cast<
                                                                      Result>()
                                                                  .toList();
                                                          return CustomExploreWidget(
                                                            user: widget.user,
                                                            barsOrClubsImages: value
                                                                .searcbarsImage,
                                                            barsOrClubsDistanceList:
                                                                value
                                                                    .searcbarsDistance,
                                                            index: index,
                                                            barAndClubsDetails:
                                                                nonNullBarDetail,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ))));
  }

  Widget customSearchBarWidget() {
    return Consumer<SearchBarsController>(
      builder: (context, value, child) {
        return TextField(
          controller: value.searchTextFieldController,
          onSubmitted: (val) {
            if (val.isEmpty || isSearchBarOpen == false) {
              value.clearFields();
              setState(() {});
            } else {
              value.searchBarsOrClubs(val, context);

              setState(() {});
            }
          },
          onChanged: (val) {},
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade900,
                size: 30,
              ),
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      value.barDetail.clear();
                      value.searchTextFieldController.clear();
                      isSearchBarOpen = false;
                    });
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.grey.shade900,
                    size: 30,
                  ))),
        );
      },
    );
  }
}
