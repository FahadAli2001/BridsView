import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:birds_view/model/get_bookmarks_model/get_bookmarks_model.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


class VisitedBarsController extends ChangeNotifier {
  final List<Result> _visitedBarsDetailList = [];
  final List<Uint8List?> _visitedBarsImagesList = [];
  String? _userId;
  String? _token;
  String? get userId => _userId;
  String? get token => _token;
  List<Result> get visitedBarsDetailList => _visitedBarsDetailList;
  List<Uint8List?> get visitedBarsImagesList => _visitedBarsImagesList;

  Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    _token = sp.getString("token")!;
    log("user id : $userId");
    log("user token : $token");
    notifyListeners();
  }

  Future<void> getAllVisitedBars(context) async {
    await getUserCredential();
    var header = {"Authorization": "Bearer $token"};
    try {
      var response =
          await http.get(Uri.parse(visitedBarsApi + userId!), headers: header);
      var data = jsonDecode(response.body);
      log(data.toString());
      if (response.statusCode == 200) {
        GetBookmarksModel getBookmarksModel = GetBookmarksModel.fromJson(data);
        log(data.toString());
        await getVisitedBarDetails(getBookmarksModel, context);
        notifyListeners();
      } else {
        log(response.statusCode.toString());
      }
    } catch (e) {
      log("get all bookmarks call : $e");
    }
  }

  Future<void> getVisitedBarDetails(
      GetBookmarksModel getBookmarksModel, BuildContext context) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    try {
      if (getBookmarksModel.data != null) {
        for (var i = 0; i < getBookmarksModel.data!.length; i++) {
          // Check if barPlaceId is not null
          if (getBookmarksModel.data![i].barPlaceId != null) {
            var barsDetails = await mapController
                .barsDetailMethod(getBookmarksModel.data![i].barPlaceId!);

            if (barsDetails != null) {
              _visitedBarsDetailList.add(barsDetails);

              // Check if photos list is not null and has elements
              if (barsDetails.photos != null &&
                  barsDetails.photos!.isNotEmpty) {
                var barsImages = await mapController
                    .exploreImages(barsDetails.photos![0].photoReference!);

                _visitedBarsImagesList
                    .addAll(barsImages as Iterable<Uint8List?>);
              } else {
                log("No photos available for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
              }
            } else {
              log("barsDetailMethod returned null for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
            }
          } else {
            log("barPlaceId is null for index $i");
          }
        }
      } else {
        log("getBookmarksModel.data is null");
      }
      notifyListeners();
    } catch (e) {
      log("get bookmarks detail call : $e");
    }
  }
}
