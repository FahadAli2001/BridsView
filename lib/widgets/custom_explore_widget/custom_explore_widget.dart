import 'dart:developer';
import 'dart:typed_data';

import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../model/bar_details_model/bar_details_model.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';
import '../../views/detail_screen/detail_screen.dart';

class CustomExploreWidget extends StatelessWidget {
  final List<Uint8List?> barsOrClubsImages;
  final List<Results>? barsOrClubsData;
  final List<Rows> barsOrClubsDistanceList;
  final List<Result> barAndClubsDetails;
  final int index;

  const CustomExploreWidget({
    super.key,
    required this.barsOrClubsImages,
    this.barsOrClubsData,
    required this.barsOrClubsDistanceList,
    required this.index,
    required this.barAndClubsDetails,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        log("Index : $index");
        if (barsOrClubsData == null || barsOrClubsData!.isEmpty) {
          Navigator.push(
            context,
            PageTransition(
              child: DetailScreen(
                fromSearchScreen: true,
                // barDetail: barsOrClubsData!,
                searchBarDetail: barAndClubsDetails,
                index: index,
                barImages: barsOrClubsImages,
                distance: barsOrClubsDistanceList,
              ),
              type: PageTransitionType.fade,
            ),
          );
        } else {
          Navigator.push(
            context,
            PageTransition(
              child: DetailScreen(
                fromSearchScreen: false,
                barDetail: barsOrClubsData!,
                index: index,
                barImages: barsOrClubsImages,
                distance: barsOrClubsDistanceList,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
          width: size.width,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              image: MemoryImage(barsOrClubsImages[index]!),
              fit: BoxFit.cover,
            ),
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
                      image: AssetImage(exploreIcon),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.1,
                left: size.height * 0.03,
                child: SizedBox(
                  width: size.width * 0.85,
                  child: Text(
                    barAndClubsDetails[index].name ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.03,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.04,
                left: size.height * 0.03,
                child: SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    barAndClubsDetails[index].formattedAddress ?? " ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.018,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
// import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import '../../model/bar_details_model/bar_details_model.dart';
// import '../../utils/icons.dart';
// import '../../views/detail_screen/detail_screen.dart';

// class CustomExploreWidget extends StatelessWidget {
//   final List<Uint8List?> barsOrClubsImages;
//   final List<Results>? barsOrClubsData;
//   final List<Rows> barsOrClubsDistanceList;
//   final List<Result> barAndClubsDetails;
//   final int index;
//   const CustomExploreWidget(
//       {super.key,
//       required this.barsOrClubsImages,
//       this.barsOrClubsData,
//       required this.barsOrClubsDistanceList,
//       required this.index,
//       required this.barAndClubsDetails});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return GestureDetector(
//       onTap: () {
//         log("Index : $index");
//         Navigator.push(
//             context,
//             PageTransition(
//                 child: DetailScreen(
//                   barDetail: barsOrClubsData!,
//                   index: index,
//                   barImages: barsOrClubsImages,
//                   distance: barsOrClubsDistanceList,
//                 ),
//                 type: PageTransitionType.fade));
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         child: Container(
//             width: size.width,
//             height: size.height * 0.3,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(12),
//               image: DecorationImage(
//                   colorFilter: ColorFilter.mode(
//                     Colors.black.withOpacity(0.3),
//                     BlendMode.darken,
//                   ),
//                   image: MemoryImage(barsOrClubsImages[index]!),
//                   fit: BoxFit.cover),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     height: size.height * 0.07,
//                     width: size.height * 0.07,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage(
//                             exploreIcon,
//                           ),
//                           fit: BoxFit.cover),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                     bottom: size.height * 0.1,
//                     left: size.height * 0.03,
//                     child: SizedBox(
//                       width: size.width * 0.85,
//                       child: Text(
//                         barsOrClubsData![index].name ?? "",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: size.height * 0.03),
//                       ),
//                     )),
//                 //
//                 Positioned(
//                     bottom: size.height * 0.04,
//                     left: size.height * 0.03,
//                     child: SizedBox(
//                       width: size.width * 0.8,
                    
//                       child: Text(
//                               barAndClubsDetails[index].formattedAddress ?? " ",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: size.height * 0.018),
//                             )
                         
//                     ))
//               ],
//             )),
//       ),
//     );
//   }
// }
