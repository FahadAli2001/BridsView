import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../home_screen/home_screem.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
            text: 'Locate',
            ontap: () async {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const MapScreen(), type: PageTransitionType.fade));
            }),
      ),
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
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
      body: SingleChildScrollView(
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
                    image: const DecorationImage(
                        image: AssetImage("assets/recomended_bar.png"),
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
                  Text(
                    "Cubix Bar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.03,
                        color: Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        facebookLink,
                        width: size.height * 0.04,
                      ))
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
                    rating: 1.0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: primaryColor,
                    ),
                    itemCount: 5,
                    itemSize: size.width * 0.06,
                    direction: Axis.horizontal,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(instaLink, width: size.height * 0.04))
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
                  Row(
                    children: [
                      SvgPicture.asset(locationIcon),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      const Text(
                        '2.2 km away',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  GestureDetector(
                      onTap: () {},
                      child:
                          Image.asset(twitterLink, width: size.height * 0.04))
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
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width,
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin rhoncus et lacus in fringilla. Sed tempus semper turpis, ac malesuada quam proin. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin rhoncus et lacus in fringilla. Sed tempus semper turpis, ac malesuada quam proin luctus. Sed tempus semper turpis, ac malesuada quam proin.',
                  style: TextStyle(
                      fontSize: size.height * 0.018, color: Colors.white),
                ),
              ),
              //
              SizedBox(
                height: size.height * 0.05,
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/persons.svg',
                        // width: size.width * 0.26,
                        height: size.width * 0.07,
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      SizedBox(
                        width: size.width * 0.26,
                        child: Center(
                          child: AutoSizeText(
                            'Guy And Boy',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: size.height * 0.016,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/glass.svg",
                        // width: size.width * 0.26,
                        height: size.width * 0.07,
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      SizedBox(
                        width: size.width * 0.26,
                        child: Center(
                          child: Text(
                            maxLines: 1,
                            'Good Ambiance',
                            style: TextStyle(
                              fontSize: size.height * 0.016,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        musicIcon,
                        // width: size.width * 0.26,
                        height: size.width * 0.07,
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      SizedBox(
                        width: size.width * 0.26,
                        child: Center(
                          child: Text(
                            maxLines: 1,
                            'Live Music',
                            style: TextStyle(
                              fontSize: size.height * 0.016,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
