import 'dart:typed_data';

import 'package:birds_view/controller/bookmark_controller/bookmark_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
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
  List<Uint8List> bookmarksBarsImagesList = [];
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
    bookmarksBarsImagesList = bookmarkController.bookmarksBarsImagesList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
        title: Text(
          'Bookmarks',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.03),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (context, index) {
            return const CustomBookmarkWidget();
          },
        ),
      ),
    );
  }
}
