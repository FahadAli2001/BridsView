import 'dart:typed_data';

import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/widgets/custom_heading_text/custom_heading_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_bookmark_widget/custom_bookmark_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Result> bookmarksBarsDetailList = [];
  List<Uint8List>? bookmarksBarsImagesList = [];
  @override
  void initState() {
    super.initState();
    getAllbookmarks();
  }

  Future<void> getAllbookmarks() async {
    final bookmarkController =
        Provider.of<BookmarkController>(context, listen: false);
    bookmarkController.getAllBookmarks(context);
    bookmarksBarsDetailList = bookmarkController.bookmarksBarsDetailList;
    bookmarksBarsImagesList = bookmarkController.bookmarksBarsImagesList.cast<Uint8List>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const CustomHeadingText(heading: "Bookmarks")),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<BookmarkController>(
            builder: (context, value, child) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: bookmarksBarsDetailList.length,
                itemBuilder: (context, index) {
                  return   CustomBookmarkWidget(
                    index: index,
                    bookmarksBarsDetailList: bookmarksBarsDetailList,
                    bookmarksBarsImagesList: bookmarksBarsImagesList,
                  );
                },
              );
            },
          )),
    );
  }
}
