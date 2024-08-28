import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/get_bookmarks_model/get_bookmarks_model.dart';
import 'package:birds_view/utils/apis.dart';
import 'package:birds_view/widgets/custom_success_toast/custom_success_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model/bar_details_model/bar_details_model.dart';

class BookmarkController extends ChangeNotifier {
  final List<Result> _bookmarksBarsDetailList = [];
  final List<Uint8List?> _bookmarksBarsImagesList = [];

  String? _userId;
  String? _token;
  String? get userId => _userId;
  String? get token => _token;
  List<Result> get bookmarksBarsDetailList => _bookmarksBarsDetailList;
  List<Uint8List?> get bookmarksBarsImagesList => _bookmarksBarsImagesList;

  Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    _token = sp.getString("token")!;
    log("user id : $userId");
    log("user token : $token");
    notifyListeners();
  }

  Future<void> addBookmark(String placeId) async {
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_type_id": placeId};
      var response = await http.post(Uri.parse(addBookmarkApi),
          headers: header, body: body);
      if (response.statusCode == 200) {
        showCustomSuccessToast(message: "Bookmark Added");
      } else {
        log("error ${response.body}");
      }
    } catch (e) {
      log("add Bookmak call error : ${e.toString()}");
    }
  }

  Stream getBookMarkStream(String placeId) async* {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    while (true) {
      // ignore: prefer_typing_uninitialized_variables
      var bookmark;
      try {
        var response = await http.get(
            Uri.parse('$checkBookmarkApi$userId&bar_type_id=$placeId'),
            headers: headers);
        var data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          bookmark = data;
        } else {
          bookmark = data;
        }
      } catch (e) {
        log(e.toString());
      }
      yield bookmark;
    }
  }

  Future<void> deleteBookmark(String placeId) async {
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_place_id": placeId};
      var response = await http.post(Uri.parse(deleteBookmarkApi),
          headers: header, body: body);
      if (response.statusCode == 200) {
        showCustomSuccessToast(message: "Bookmark Removed");
      } else {
        log("error ${response.body}");
      }
    } catch (e) {
      log("delete Bookmak call error : ${e.toString()}");
    }
  }

  Future<void> getAllBookmarks(context) async {
    await getUserCredential();
    var header = {"Authorization": "Bearer $token"};
    try {
      var response = await http.get(Uri.parse(getAllBookmarksApi + userId!),
          headers: header);
      var data = jsonDecode(response.body);
      log(data.toString());
      if (response.statusCode == 200) {
        GetBookmarksModel getBookmarksModel = GetBookmarksModel.fromJson(data);
        log(data.toString());
        await getBookmarkDetails(getBookmarksModel, context);
      } else {
        log(response.statusCode.toString());
      }
    } catch (e) {
      log("get all bookmarks call : $e");
    }
  }

  // Future<void> getBookmarkDetails(
  //     GetBookmarksModel getBookmarksModel, context) async {
  //   final mapController = Provider.of<MapsController>(context, listen: false);
  //   try {
  //     for (var i = 0; i < getBookmarksModel.data!.length; i++) {
  //       var barsDetails = await mapController
  //           .barsDetailMethod(getBookmarksModel.data![i].barPlaceId!);
  //       _bookmarksBarsDetailList.add(barsDetails!);
  //       var barsImages = await mapController.exploreImages(
  //           _bookmarksBarsDetailList[i].photos![0].photoReference!);
  //       _bookmarksBarsImagesList.addAll(barsImages);
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log("get bookmarks detail call : $e");
  //   }
  // }

  Future<void> getBookmarkDetails(
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
              _bookmarksBarsDetailList.add(barsDetails);

              // Check if photos list is not null and has elements
              if (barsDetails.photos != null &&
                  barsDetails.photos!.isNotEmpty) {
                var barsImages = await mapController
                    .exploreImages(barsDetails.photos![0].photoReference!);

                _bookmarksBarsImagesList.addAll(barsImages);
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
