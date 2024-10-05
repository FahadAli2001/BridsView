import 'dart:typed_data';

import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/views/home_screen/home_screem.dart';
import 'package:birds_view/widgets/custom_bookmark_widget/custom_bookmark_widget.dart';
import 'package:birds_view/widgets/custom_heading_text/custom_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  final UserModel? userModel;
  const BookmarkScreen({super.key, required this.userModel});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    getAllbookmarks();
  }

  Future<void> getAllbookmarks() async {
    final bookmarkController =
        Provider.of<BookmarkController>(context, listen: false);
    bookmarkController.getCordinateds();
    await bookmarkController.getAllBookmarks(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key("bookmark"),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: widget.userModel),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: widget.userModel),
                ),
                (Route<dynamic> route) => false,
              );
              
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const CustomHeadingText(heading: "Bookmarks"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<BookmarkController>(
            builder: (context, bookmarkController, child) {
              final bookmarksBarsDetailList =
                  bookmarkController.bookmarksBarsDetailList;
              final bookmarksBarsImagesList =
                  bookmarkController.bookmarksBarsImagesList.cast<Uint8List>();

              return bookmarksBarsDetailList.isEmpty
                  ? Center(
                      child: Text(
                        "No Bookmarks",
                        style: GoogleFonts.urbanist(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: bookmarksBarsDetailList.length,
                      itemBuilder: (context, index) {
                        return CustomBookmarkWidget(
                          userModel: widget.userModel,
                          index: index,
                          bookmarksBarsDetailList: bookmarksBarsDetailList,
                          bookmarksBarsImagesList: bookmarksBarsImagesList,
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}


// import 'dart:typed_data';

// import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
// import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
// import 'package:birds_view/model/user_model/user_model.dart';
// import 'package:birds_view/widgets/custom_heading_text/custom_heading_text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../widgets/custom_bookmark_widget/custom_bookmark_widget.dart';

// class BookmarkScreen extends StatefulWidget {
//   final UserModel? userModel;
//   const BookmarkScreen({super.key, required this.userModel});

//   @override
//   State<BookmarkScreen> createState() => _BookmarkScreenState();
// }

// class _BookmarkScreenState extends State<BookmarkScreen> {
//   List<Result> bookmarksBarsDetailList = [];
//   List<Uint8List>? bookmarksBarsImagesList = [];
//   @override
//   void initState() {
//     super.initState();
//     getAllbookmarks();
//   }

//   Future<void> getAllbookmarks() async {
//     final bookmarkController =
//         Provider.of<BookmarkController>(context, listen: false);
//     bookmarkController.getCordinateds();
//     bookmarkController.getAllBookmarks(context);
//     bookmarksBarsDetailList = bookmarkController.bookmarksBarsDetailList;
//     bookmarksBarsImagesList =
//         bookmarkController.bookmarksBarsImagesList.cast<Uint8List>();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//         key: const Key("bookmark"),
//         direction: DismissDirection.horizontal,
//         onDismissed: (direction) {
//           Navigator.pop(context);
//         },
//         child: Scaffold(
//           appBar: AppBar(
//               backgroundColor: Colors.black,
//               leading: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.white,
//                   )),
//               centerTitle: true,
//               title: const CustomHeadingText(heading: "Bookmarks")),
//           body: Padding(
//               padding: const EdgeInsets.all(15),
//               child: bookmarksBarsDetailList.isEmpty
//                   ? Center(
//                       child: Text(
//                         "No Bookmarks",
//                         style: GoogleFonts.urbanist(color: Colors.grey),
//                       ),
//                     )
//                   : Consumer<BookmarkController>(
//                       builder: (context, value, child) {
//                         return ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           itemCount: bookmarksBarsDetailList.length,
//                           itemBuilder: (context, index) {
//                             return CustomBookmarkWidget(
//                               userModel: widget.userModel,
//                               index: index,
//                               bookmarksBarsDetailList: bookmarksBarsDetailList,
//                               bookmarksBarsImagesList: bookmarksBarsImagesList,
//                             );
//                           },
//                         );
//                       },
//                     )),
//         ));
//   }
// }
