import 'dart:ui';

import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_explore_widget/custom_explore_widget.dart';
import '../home_screen/home_screem.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isSearchBarOpen = false;
  bool isClubs = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: const HomeScreen(), type: PageTransitionType.fade),
                (route) => false,
              );
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
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

                  isClubs == true
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const CustomExploreWidget();
                            },
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const CustomExploreWidget();
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
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customSearchBarWidget(),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return const CustomExploreWidget();
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
            ],
          )),
    );
  }

  Widget customSearchBarWidget() {
    return TextField(
      controller: null,
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
  }
}
