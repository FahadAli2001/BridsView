import 'dart:ui';

import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/detail_screen/detail_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_drawer/custom_drawer.dart';
import '../../widgets/custom_recommended_widget/custom_recommended_widget.dart';
import '../explore_screen/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();
  final List<String> exploreBars = [
    "assets/explore_bar1.png",
    "assets/explore_bar2.png",
    "assets/explore_bar3.png"
  ];
  final List<String> exploreBarNames = ['Cubix Bar', 'Ruby Bar', 'Cubix Bar'];

  final List<String> nearestBars = [
    'assets/nearest_bar1.png',
    'assets/nearest_bar2.png',
  ];

  bool isSearchBarOpen = false;
  bool isReview = true;
  bool isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
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
            backgroundImage: AssetImage(appLogo),
          )),
      drawer: const CustomDrawer(),
      body: Stack(
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
                            CircleAvatar(
                              backgroundColor: primaryColor,
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Text(
                              "Guest",
                              style: TextStyle(
                                  fontSize: size.height * 0.022,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
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
                      Text(
                        'Explore',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: size.height * 0.026),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const ExploreScreen(),
                                  type: PageTransitionType.fade));
                        },
                        child: Text(
                          'see all',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: size.height * 0.02),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                      width: size.width,
                      height: size.height * 0.15,
                      color: Colors.black,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: exploreBars.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const DetailScreen(),
                                        type: PageTransitionType.fade));
                              },
                              child: Container(
                                width: size.width * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(exploreBars[index]),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      exploreBarNames[index],
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: size.height * 0.026),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.25,
                    color: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const DetailScreen(),
                                      type: PageTransitionType.fade));
                            },
                            child: const CustomRecommendedWidget());
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Nearest',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: size.height * 0.026),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.2,
                    color: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nearestBars.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const DetailScreen(),
                                      type: PageTransitionType.fade));
                            },
                            child: SizedBox(
                              width: size.width * 0.5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    nearestBars[index],
                                    height: size.height * 0.15,
                                    width: size.width * 0.5,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cubix Bar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: size.width * 0.03),
                                      ),
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              color: primaryColor,
                                              size: size.width * 0.04,
                                            ),
                                            Text(
                                              "1.5 KM",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * 0.027),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isSearchBarOpen)
            Positioned.fill(
              // top: 0,
              // left: 0,
              // right: 0,
              // bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customSearchBarWidget(),
                          // Expanded(
                          //           child: ListView.builder(
                          //             scrollDirection: Axis.vertical,
                          //             itemCount: searchController
                          //                     .searchedBars.data?.length ??
                          //                 0,
                          //             itemBuilder: (context, index) {
                          //               return CustomExploreWidget(
                          //                 bars:
                          //                     searchController.searchedBars,
                          //                 index: index,
                          //                 user: widget.user,
                          //               );
                          //             },
                          //           ),
                          //         ),
                        ],
                      )),
                ),
              ),
            ),
          if (isReview == true)
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.03,
              right: size.width * 0.03,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
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
                                    onTap: () {
                                      isReview = false;
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
                                          controller: null,
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
                              CustomButton(text: 'Submit', ontap: () async {})
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget customSearchBarWidget() {
    return TextField(
      controller: null,
      onChanged: (val) {},
      textInputAction: TextInputAction.done,
      onSubmitted: (val) {
        FocusScope.of(context).unfocus();
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
            FocusScope.of(context).unfocus(); // Dismiss the keyboard
          },
          child: Icon(
            Icons.cancel_outlined,
            color: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
