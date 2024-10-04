import 'dart:typed_data';
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/views/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../model/bar_details_model/bar_details_model.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';
import '../../views/detail_screen/detail_screen.dart';

class CustomExploreWidget extends StatelessWidget {
  final UserModel? user;
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
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    // Determine if there is an image for the current index
    bool hasImage =
        index < barsOrClubsImages.length && barsOrClubsImages[index] != null;

    return GestureDetector(
      onTap: () {
        if (barsOrClubsData == null || barsOrClubsData!.isEmpty) {
          Navigator.push(
            context,
            PageTransition(
              child: DetailScreen(
                fromBookmark: false,
                user: user,
                fromSearchScreen: true,
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
                fromBookmark: false,
                user: user,
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
              image: hasImage
                  ? DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                      image: MemoryImage(barsOrClubsImages[index]!),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(image: AssetImage(emptyImage))),
          child: Stack(
            children: [
              if (hasImage)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      List<Uint8List> nonNullableList = barsOrClubsImages
                          .where((image) => image != null)
                          .cast<Uint8List>()
                          .toList();
                      Navigator.push(
                        context,
                        PageTransition(
                          child: MapScreen(
                            bar: barAndClubsDetails,
                            index: index,
                            barImage: nonNullableList,
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
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
                ),
              Positioned(
                bottom: size.height * 0.1,
                left: size.height * 0.03,
                child: SizedBox(
                  width: size.width * 0.85,
                  child: Text(
                    barAndClubsDetails[index].name ?? "",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.026,
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
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: size.height * 0.016,
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
