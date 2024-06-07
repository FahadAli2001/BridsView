import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/home_screen/home_screem.dart';
import 'package:birds_view/widgets/custom_visited_place/custom_visited_place.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class VisitedBar extends StatefulWidget {
  const VisitedBar({super.key});

  @override
  State<VisitedBar> createState() => _VisitedBarState();
}

class _VisitedBarState extends State<VisitedBar> {
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
        title: RichText(
          text: TextSpan(
            text: "Visited ",
            style: TextStyle(fontSize: size.height * 0.03, color: Colors.white,fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Places ',
                style: TextStyle(
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return CustomVisitedPlace();
          },
        ),
      ),
    );
  }
}
