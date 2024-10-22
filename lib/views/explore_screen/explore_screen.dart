import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


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
              title: TextWidget(
                text: 'Explore',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
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
                                        TextWidget(
                                          text: 'Clubs',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.03,
                                        ),
                                        Container(
                                          height: size.height * 0.006,
                                          decoration: BoxDecoration(
                                            gradient: isClubs == true
                                                ? gradientColor
                                                : null,
                                            color: isClubs == false
                                                ? Colors.white
                                                : null,
                                          ),
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
                                        TextWidget(
                                          text: 'Bars',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.03,
                                        ),
                                        Container(
                                          height: size.height * 0.006,
                                          decoration: BoxDecoration(
                                            gradient: isClubs == false
                                                ? gradientColor
                                                : null,
                                            color: isClubs == true
                                                ? Colors.white
                                                : null,
                                          ),
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

                            mapController.exploring == true
                                ? const Center(child: LoadingWidget())
                                : mapController
                                        .exploreScreenbarAndClubsDetails.isEmpty
                                    ? const Center(
                                        child: TextWidget(
                                            text: 'No Bar Or Club Found',
                                            color: Colors.white60))
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
                                                  barsOrClubsDistanceList:
                                                      mapController
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
                                                barsOrClubsDistanceList:
                                                    mapController
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
                                            MainAxisAlignment.start,
                                        children: [
                                          customSearchBarWidget(),
                                          value.searchingBar
                                              ? const Center(
                                                  child: LoadingWidget())
                                              : value.barDetail.isEmpty
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 20),
                                                      child: TextWidget(
                                                          text:
                                                              'Search Bars Or Clubs',
                                                          color:
                                                              Colors.white60))
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
