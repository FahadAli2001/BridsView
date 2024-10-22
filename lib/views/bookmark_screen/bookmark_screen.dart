import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


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
                  ? const Center(
                      child:
                          TextWidget(text: "No Bookmarks", color: Colors.grey))
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: bookmarksBarsImagesList.length,
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
