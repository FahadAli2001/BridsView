import 'dart:typed_data';

import 'package:birds_view/controller/visited_bars_controller/visited_bars_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/widgets/custom_visited_place/custom_visited_place.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VisitedBar extends StatefulWidget {
  const VisitedBar({super.key});

  @override
  State<VisitedBar> createState() => _VisitedBarState();
}

class _VisitedBarState extends State<VisitedBar> {
  List<Result> visitedBarsDetailList = [];
  List<Uint8List>? visitedBarsImagesList = [];
  @override
  void initState() {
    super.initState();
    getAllVisitedBars();
  }

  Future<void> getAllVisitedBars() async {
    final bookmarkController =
        Provider.of<VisitedBarsController>(context, listen: false);
    bookmarkController.getAllVisitedBars(context);
    visitedBarsDetailList = bookmarkController.visitedBarsDetailList;
    visitedBarsImagesList =
        bookmarkController.visitedBarsImagesList.cast<Uint8List>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("Visited Place"),
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
            title: RichText(
              text: TextSpan(
                text: "Visited ",
                style: GoogleFonts.urbanist(
                    fontSize: size.height * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFC59241),
                          Color(0xFFFEF6D1),
                          Color(0xFFC49138),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.5, 1.0],
                      ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(
                        "Places",
                        style: GoogleFonts.urbanist(
                            fontSize: size.height * 0.03, color: whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: visitedBarsDetailList.length,
              itemBuilder: (context, index) {
                return CustomVisitedPlace(
                  index: index,
                  visitedBarsDetailList: visitedBarsDetailList,
                  visitedBarsImagesList: visitedBarsImagesList,
                );
              },
            ),
          ),
        ));
  }
}
