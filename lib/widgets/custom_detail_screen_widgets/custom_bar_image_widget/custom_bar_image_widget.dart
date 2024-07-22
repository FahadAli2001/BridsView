import 'dart:typed_data';

import 'package:birds_view/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBarImageWidget extends StatelessWidget {
  final List<Uint8List?> barImage;
  final int index;
  const CustomBarImageWidget(
      {super.key, required this.barImage, required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return             Container(
                width: size.width,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: MemoryImage(barImage[index]!), fit: BoxFit.cover),
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
                                right: size.width * 0.035,
                                child: const Icon(
                                  CupertinoIcons.bookmark_fill,
                                  color: Colors.black,
                                )
                                //  Consumer<BookmarkController>(
                                //   builder: (context, value, child) {
                                //     return StreamBuilder(
                                //       stream: value
                                //           .getBookMarkStream(widget
                                //               .barDetail![
                                //                   widget.index]
                                //               .placeId!),
                                //       builder: (context, snapshot) {
                                //         if (snapshot
                                //                 .connectionState ==
                                //             ConnectionState
                                //                 .waiting) {
                                //           return Shimmer.fromColors(
                                //             baseColor: primaryColor,
                                //             highlightColor:
                                //                 Colors.white10,
                                //             child: Center(
                                //                 child: Container(
                                //               color: Colors.white,
                                //             )),
                                //           );
                                //         } else if (snapshot
                                //             .hasError) {
                                //           return Text(
                                //               'Error: ${snapshot.error}');
                                //         } else {
                                //           return GestureDetector(
                                //               onTap: () {
                                //                 if (snapshot.data[
                                //                         "status"] ==
                                //                     0) {
                                //                   value.addBookmark(widget
                                //                       .barDetail![
                                //                           widget
                                //                               .index]
                                //                       .placeId!);
                                //                 } else if (snapshot
                                //                             .data[
                                //                         "status"] ==
                                //                     1) {
                                //                   value.deleteBookmark(widget
                                //                       .barDetail![
                                //                           widget
                                //                               .index]
                                //                       .placeId!);
                                //                 }
                                //               },
                                //               child: snapshot.data[
                                //                           "status"] ==
                                //                       1
                                //                   ? const Icon(
                                //                       CupertinoIcons
                                //                           .bookmark_fill,
                                //                       color: Colors
                                //                           .black,
                                //                     )
                                //                   : const Icon(
                                //                       CupertinoIcons
                                //                           .bookmark,
                                //                       color: Colors
                                //                           .black,
                                //                     ));
                                //         }
                                //       },
                                //     );
                                //   },
                                // )
                                )
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
  }
}
