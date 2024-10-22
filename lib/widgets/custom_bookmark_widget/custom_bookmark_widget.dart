import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


class CustomBookmarkWidget extends StatelessWidget {
  final UserModel? userModel;
  final int index;
  final List<Result> bookmarksBarsDetailList;
  final List<Uint8List>? bookmarksBarsImagesList;
  const CustomBookmarkWidget(
      {super.key,
      required this.userModel,
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
              onTap: () {
                log(bookmarksBarsDetailList[index].placeId.toString());
                Navigator.push(
                    context,
                    PageTransition(
                        child: DetailScreen(
                          fromBookmark: true,
                          searchBarDetail: bookmarksBarsDetailList,
                          index: index,
                          barImages: bookmarksBarsImagesList!,
                          fromSearchScreen: false,
                          user: userModel,
                          distance:
                              bookmarkController.bookmarksBarsDistanceList,
                        ),
                        type: PageTransitionType.fade));
              },
              onLongPress: () {
                bookmarkController.deleteBookmarks(
                    bookmarksBarsDetailList[index].placeId.toString(),
                    context,
                    index);
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
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: size.width * 0.5),
                            child: AutoSizeText(
                              bookmarksBarsDetailList[index].name!,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.urbanist(color: Colors.white),
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
                              style: GoogleFonts.urbanist(color: Colors.white),
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
