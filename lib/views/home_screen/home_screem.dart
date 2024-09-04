import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/review_controller/review_controller.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/views/detail_screen/detail_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_heading_text/custom_heading_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/search_bars_controller/search_bars_controller.dart';
import '../../model/bar_details_model/bar_details_model.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';
import '../../model/nearby_bars_model/nearby_bars_model.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../../widgets/custom_explore_widget/custom_explore_widget.dart';
import '../../widgets/custom_recommended_widget/custom_recommended_widget.dart';
import '../explore_screen/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();
  List<Uint8List?> exploreBarsImages = [];
  List<Results> exploreBar = [];
  List<Results> recomendedBarList = [];
  List<Uint8List?> recomdedBarsImages = [];
  List<Results> nearestBarList = [];
  List<Uint8List?> nearestBarsImages = [];
  List<Rows> nearsetBarsDistanceList = [];
  List<Rows> exploreBarsDistanceList = [];
  List<Rows> recomendedBarsDistanceList = [];

  bool isSearchBarOpen = false;
  bool isReview = true;
  bool isTextFieldFocused = false;

  String lastVisitedBar = "";

  Future<void> getLastBar()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    lastVisitedBar= sp.getString("lastVisitedBar")!;
    setState(() {
      
    });
    log(lastVisitedBar);
  }

  @override
  void initState() {
    super.initState();
    final searchController =
        Provider.of<SearchBarsController>(context, listen: false);
    searchController.getCordinateds();
    clearAllList();
    exploreBarByMap();
    recomendedBars();
    nearestBar();
    getLastBar();
    isSearchBarOpen;

    _focusNode.addListener(() {
      setState(() {
        isTextFieldFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void clearAllList() {
    exploreBarsImages.clear();
    exploreBar.clear();
    recomendedBarList.clear();
    recomdedBarsImages.clear();
    nearestBarList.clear();
    nearestBarsImages.clear();
    nearsetBarsDistanceList.clear();
    exploreBarsDistanceList.clear();
    recomendedBarsDistanceList.clear();
  }


  Future<void> exploreBarByMap() async {
    final mapController = Provider.of<MapsController>(context, listen: false);

    var data = await mapController.exploreNearbyBarsMethod();
    exploreBar.addAll(data as Iterable<Results>);
    exploreBarsImages = mapController.exploreBarsImages;
    exploreBarsDistanceList = mapController.exploreBarsDistanceList;
    setState(() {});
  }

  Future<void> nearestBar() async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    var data = await mapController.nearsetBarsMethod();
    nearestBarList.addAll(data as Iterable<Results>);
    nearestBarsImages = mapController.nearestBarsImages;
    nearsetBarsDistanceList = mapController.nearestBarsDistanceList;
    setState(() {});
  }

  Future<void> recomendedBars() async {
    final mapController = Provider.of<MapsController>(context, listen: false);

    var data = await mapController.recommendedBarsMethod();
    recomendedBarList.addAll(data as Iterable<Results>);
    recomdedBarsImages = mapController.recomdedBarsImages;
    recomendedBarsDistanceList = mapController.recomendedBarsDistanceList;
    setState(() {});
  }

  Future<void> refreshData() async {
    clearAllList();
    await Future.wait([
      exploreBarByMap(),
      recomendedBars(),
      nearestBar(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: AssetImage(whiteLogo),
          )),
      drawer: CustomDrawer(
        user: widget.user,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              widget.user == null ||
                                      widget.user!.data!.image == ' '
                                  ? CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: const Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                          widget.user!.data!.image!),
                                    ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              SizedBox(
                                width: size.width * 0.4,
                                child: RichText(
                                  text: TextSpan(
                                    text: widget.user == null ||
                                            widget.user!.data!.username == ''
                                        ? "Guest "
                                        : '${widget.user!.data!.username} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.026,
                                        color: Colors.white),
                                    // children: [
                                    //   TextSpan(
                                    //     text: widget.user == null ||
                                    //             widget.user!.data!.lastName == ''
                                    //         ? "User"
                                    //         : '${widget.user!.data!.lastName} ',
                                    //     style: TextStyle(
                                    //         fontSize: size.height * 0.026,
                                    //         color: Colors.white),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearchBarOpen = true;
                            });
                          },
                          child: Icon(
                            Icons.search_sharp,
                            color: Colors.white,
                            size: size.height * 0.04,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomHeadingText(heading: "Explore"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const ExploreScreen(),
                                    type: PageTransitionType.fade));
                          },
                          child: Text(
                            'More > ',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: size.height * 0.018),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    exploreBar.isEmpty
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade700,
                            child: Center(
                                child: Container(
                              color: Colors.white,
                              width: size.width,
                              height: size.height * 0.15,
                            )),
                          )
                        : Container(
                            width: size.width,
                            height: size.height * 0.15,
                            color: Colors.black,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: exploreBarsImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: DetailScreen(
                                                fromSearchScreen: false,
                                                barDetail: exploreBar,
                                                index: index,
                                                barImages: exploreBarsImages,
                                                distance: exploreBarsDistanceList,
                                              ),
                                              type: PageTransitionType.fade));
                                    },
                                    child: Container(
                                      width: size.width * 0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                              exploreBarsImages[index]!),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.3),
                                            BlendMode.darken,
                                          ),
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            exploreBar[index].name ?? "UnKnown",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.height * 0.016),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: CustomHeadingText(heading: "Recommended")),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    recomendedBarList.isEmpty
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade700,
                            child: Center(
                                child: Container(
                              color: Colors.white,
                              width: size.width,
                              height: size.height * 0.25,
                            )),
                          )
                        : Container(
                            width: size.width,
                            height: size.height * 0.25,
                            color: Colors.black,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recomendedBarList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: DetailScreen(
                                                fromSearchScreen: false,
                                                barDetail: recomendedBarList,
                                                index: index,
                                                barImages: recomdedBarsImages,
                                                distance:
                                                    recomendedBarsDistanceList,
                                              ),
                                              type: PageTransitionType.fade));
                                    },
                                    child: CustomRecommendedWidget(
                                      recomendedBar: recomendedBarList,
                                      index: index,
                                      recomdedBarsImages: recomdedBarsImages,
                                    ));
                              },
                            ),
                          ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: CustomHeadingText(heading: "Nearest")),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    nearestBarList.isEmpty
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade700,
                            child: Center(
                                child: Container(
                              color: Colors.white,
                              width: size.width,
                              height: size.height * 0.2,
                            )),
                          )
                        : Container(
                            width: size.width,
                            height: size.height * 0.2,
                            color: Colors.black,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: nearestBarList.length,
                              itemBuilder: (context, index) {
                                // Ensure that all lists have valid data for the current index
                                if (index < nearestBarsImages.length &&
                                    index < nearsetBarsDistanceList.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: DetailScreen(
                                              fromSearchScreen: false,
                                              index: index,
                                              barDetail: nearestBarList,
                                              barImages: nearestBarsImages,
                                              distance: nearsetBarsDistanceList,
                                            ),
                                            type: PageTransitionType.fade,
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: size.width * 0.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: size.height * 0.15,
                                              width: size.width * 0.5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: MemoryImage(
                                                          nearestBarsImages[
                                                              index]!),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.25,
                                                  child: Text(
                                                    nearestBarList[index].name ??
                                                        'Unknown',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            size.height * 0.016),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      locationIcon,
                                                      height: size.height * 0.015,
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.01,
                                                    ),
                                                    Text(
                                                      (double.parse(nearsetBarsDistanceList[
                                                                          index]
                                                                      .elements![
                                                                          0]
                                                                      .distance
                                                                      ?.text
                                                                      ?.split(
                                                                          " ")[0] ??
                                                                  '0') *
                                                              0.621371)
                                                          .toStringAsFixed(1),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.width * 0.027,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' Miles',
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize:
                                                            size.width * 0.03,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
            if (isSearchBarOpen)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Consumer<SearchBarsController>(
                    builder: (context, value, child) {
                      return Container(
                        color: Colors.black.withOpacity(0.6),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customSearchBarWidget(),
                              value.searchingBar
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      ),
                                    )
                                  : value.barDetail.isEmpty
                                      ? const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 20),
                                          child: Text(
                                            "Search Bars Or Clubs",
                                            style:
                                                TextStyle(color: Colors.white60),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                value.searcbarsImage.length,
                                            itemBuilder: (context, index) {
                                              final nonNullBarDetail = value
                                                  .barDetail
                                                  .where((item) => item != null)
                                                  .cast<Result>()
                                                  .toList();
                                              return CustomExploreWidget(
                                                barsOrClubsImages:
                                                    value.searcbarsImage,
                                                barsOrClubsDistanceList:
                                                    value.searcbarsDistance,
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
            if (lastVisitedBar.isNotEmpty || lastVisitedBar != "")
              Positioned(
                top: size.height * 0.15,
                left: size.width * 0.03,
                right: size.width * 0.03,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child:Consumer<ReviewController>(builder:(context, value, child) {
                    return  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: size.width,
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bar/Club Reviews',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.026),
                                    ),
                                    GestureDetector(
                                      onTap: ()async {
                                        SharedPreferences sp = await SharedPreferences.getInstance();
                                        sp.remove("lastVisitedBar");
                                        lastVisitedBar = 
                                        "";
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RatingBar.builder(
                                      unratedColor: Colors.grey,
                                      initialRating: 0,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemSize: size.height * 0.031,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        // log(reviewController.rating.toString());
                                        value.rating = rating.toString();
                                      },
                                    ),
                                    if (isTextFieldFocused)
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.keyboard,
                                          color: Colors.grey,
                                          size:
                                              MediaQuery.of(context).size.height *
                                                  0.03,
                                        ),
                                      ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            focusNode: _focusNode,
                                            controller: value.reviewController,
                                            maxLines: null,
                                            expands: true,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintText: 'Your Comments',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                CustomButton(
                                    text: 'Submit',
                                    ontap: () async {
                                      
                                      value.postReview().then((val){
                                           lastVisitedBar = 
                                        "";
                                        setState(() {
                                          
                                        });
                                      });
                                      
                                     
                                    })
                              ],
                            ),
                          ),
                        )),
                  );
                  },)
                ),
              ),
          ],
        ),
      ),
    );
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
                    value.barDetail.clear();
                    value.searchTextFieldController.clear();
                    setState(() {
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
