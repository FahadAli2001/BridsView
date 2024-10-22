import 'package:flutter/material.dart';
import '../views.dart';

class VisitedBar extends StatefulWidget {
  const VisitedBar({super.key});

  @override
  State<VisitedBar> createState() => _VisitedBarState();
}

class _VisitedBarState extends State<VisitedBar> {
  List<Result> visitedBarsDetailList = [];
  List<Uint8List>? visitedBarsImagesList = [];
  @override
  void initState() {
    super.initState();
    getAllVisitedBars();
  }

  Future<void> getAllVisitedBars() async {
    final bookmarkController =
        Provider.of<VisitedBarsController>(context, listen: false);
    bookmarkController.getAllVisitedBars(context);
    visitedBarsDetailList = bookmarkController.visitedBarsDetailList;
    visitedBarsImagesList =
        bookmarkController.visitedBarsImagesList.cast<Uint8List>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: const Key("Visited Place"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
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
              title: const CustomHeadingText(heading: "Visited Place")
               
              ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: visitedBarsDetailList.length,
              itemBuilder: (context, index) {
                return CustomVisitedPlace(
                  index: index,
                  visitedBarsDetailList: visitedBarsDetailList,
                  visitedBarsImagesList: visitedBarsImagesList,
                );
              },
            ),
          ),
        ));
  }
}
