import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomVisitedPlace extends StatelessWidget {
  final int index;
  final List<Result> visitedBarsDetailList;
  final List<Uint8List>? visitedBarsImagesList;
  CustomVisitedPlace(
      {super.key,
      required this.visitedBarsDetailList,
      required this.visitedBarsImagesList,
      required this.index});

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          width: size.width,
          height: size.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade900),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.35,
                height: size.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: MemoryImage(visitedBarsImagesList![index]),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: Text(
                        visitedBarsDetailList[index].name!,
                        style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.02),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: primaryColor,
                          size: size.height * 0.02,
                        ),
                        Text(
                          visitedBarsDetailList[index].rating.toString(),
                          style:   GoogleFonts.urbanist(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          " (${visitedBarsDetailList[index].userRatingsTotal.toString()} Review's)",
                          style: GoogleFonts.urbanist(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: size.width * 0.3),
                      child: AutoSizeText(
                        visitedBarsDetailList[index].formattedAddress!,
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style:   GoogleFonts.urbanist(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Spacer(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: Row(
              //       children: [
              //         GestureDetector(
              //           onTap: () {},
              //           child: Icon(
              //             Icons.share,
              //             color: Colors.white,
              //             size: size.height * 0.025,
              //           ),
              //         ),
              //         SizedBox(
              //           width: size.width * 0.015,
              //         ),
              //         Icon(
              //           Icons.favorite,
              //           color: primaryColor,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: size.width * 0.01,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
