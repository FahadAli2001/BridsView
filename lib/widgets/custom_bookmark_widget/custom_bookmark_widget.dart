import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomBookmarkWidget extends StatelessWidget {
  final int index;
  final List<Result> bookmarksBarsDetailList;
  final List<Uint8List>? bookmarksBarsImagesList;
  const CustomBookmarkWidget(
      {super.key,
      required this.bookmarksBarsDetailList,
      required this.bookmarksBarsImagesList,
      required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Consumer<BookmarkController>(
          builder: (context, bookmarkController, child) {
            return GestureDetector(
              onLongPress: () {
                bookmarkController.deleteBookmark(
                    bookmarksBarsDetailList[index].plusCode.toString());
              },
              child: Container(
                width: size.width,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade900),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.35,
                      height: size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: MemoryImage(
                                bookmarksBarsImagesList![index],
                              ),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: Text(
                              bookmarksBarsDetailList[index].name!,
                              style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.025),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.5),
                            child: AutoSizeText(
                              bookmarksBarsDetailList[index].formattedAddress!,
                              maxLines: 3,
                              overflow: TextOverflow.fade,
                              style:   GoogleFonts.urbanist(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
