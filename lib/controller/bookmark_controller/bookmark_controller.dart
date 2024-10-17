import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/model/get_bookmarks_model/get_bookmarks_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
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
  final List<Rows> _bookmarksBarsDistanceList = [];
  double? _lat;
  double? _lon;
  bool? _loading = false;

  String? _userId;
  String? _token;
  String? get userId => _userId;
  String? get token => _token;
  bool? get loading => _loading;
  List<Result> get bookmarksBarsDetailList => _bookmarksBarsDetailList;
  List<Uint8List?> get bookmarksBarsImagesList => _bookmarksBarsImagesList;
  List<Rows> get bookmarksBarsDistanceList => _bookmarksBarsDistanceList;

  double? get lat => _lat;
  double? get lon => _lon;

  Future<void> getCordinateds() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _lat = double.parse(sp.getString('latitude')!);
    _lon = double.parse(sp.getString('longitude')!);
  }

  Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    _token = sp.getString("token")!;
    log("user id : $userId");
    log("user token : $token");
    notifyListeners();
  }

  void _setLoading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getBookMarkStatus(String placeId, UserModel? user) async {
    var headers = {'Authorization': 'Bearer ${user!.token}'};
    try {
      var response = await http.get(
        Uri.parse('$checkBookmarkApi${user.data!.id.toString()}&bar_type_id=$placeId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var bookmark = jsonDecode(response.body);
        log(bookmark.toString());

        return bookmark;
      } else {
        throw Exception("Failed to load bookmark status");
      }
    } catch (e) {
      log("Error fetching bookmark status: $e");
      return {"status": -1, "error": e.toString()};
    }
  }
  

  Future<bool> handleBookmarkAction(String placeId, bool isAdding , UserModel? user) async {
     log("$placeId : place id");
    log("${user!.data!.id.toString()} : user id");
    _setLoading(true);
    try {
      var header = {"Authorization": "Bearer ${user.token}"};
      var body = {"user_id": user.data!.id.toString(), "bar_type_id": placeId};
      var url = isAdding ? addBookmarkApi : deleteBookmarkApi;

      if (!isAdding) {
        body["bar_place_id"] = placeId;
        body.remove("bar_type_id");
      }

       var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: body,
      );
      log(response.body.toString());

      if (response.statusCode == 200) {
        return true;
      } else {
        log("Error ${isAdding ? 'adding' : 'deleting'} bookmark: ${response.body}");
        
        return false;
      }
    } catch (e) {
       log("${isAdding ? 'Adding' : 'Delete'} Bookmark call error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Stream getBookMarkStream(String placeId) async* {
  //   var headers = {'Authorization': 'Bearer $token'};
  //   try {
  //     var response = await http.get(
  //       Uri.parse('$checkBookmarkApi$userId&bar_type_id=$placeId'),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       var bookmark = jsonDecode(response.body);
  //       log(bookmark.toString());
  //       yield bookmark;
  //     } else {
  //       throw Exception("Failed to load bookmark status");
  //     }

  //     await Future.delayed(const Duration(
  //         milliseconds: 1000)); // Slight delay to control polling frequency
  //   } catch (e) {
  //     log("Error fetching bookmark status: $e");
  //     yield {};
  //   }
  // }

  Future<void> addBookmark(String placeId) async {
    log("$placeId : place id");
    log("$userId : user id");
    _setLoading(true);
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_type_id": placeId};

      var response = await http.post(
        Uri.parse(addBookmarkApi),
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        // await Future.delayed(const Duration(seconds: 5));

        showCustomSuccessToast(message: "Bookmark Added");
      } else {
        log("Error adding bookmark: ${response.body}");
      }
    } catch (e) {
      log("Add Bookmark call error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBookmark(String placeId) async {
    _setLoading(true);
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_place_id": placeId};

      var response = await http.post(
        Uri.parse(deleteBookmarkApi),
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        // await Future.delayed(const Duration(seconds: 5));

        showCustomSuccessToast(message: "Bookmark Removed");
      } else {
        log("Error deleting bookmark: ${response.body}");
      }
    } catch (e) {
      log("Delete Bookmark call error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBookmarks(String placeId, context, int index) async {
    _setLoading(true);
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_place_id": placeId};

      var response = await http.post(
        Uri.parse(deleteBookmarkApi),
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        // await getAllBookmarks(context);
        _bookmarksBarsDetailList.removeAt(index);
        _bookmarksBarsImagesList.removeAt(index);
        showCustomSuccessToast(message: "Bookmark Removed");
        notifyListeners();
      } else {
        log("Error deleting bookmark: ${response.body}");
      }
    } catch (e) {
      log("Delete Bookmark call error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> addBookmark(String placeId) async {
  //   _loading = true;
  //   notifyListeners();
  //   try {
  //     var header = {"Authorization": "Bearer $token"};
  //     var body = {"user_id": userId, "bar_type_id": placeId};
  //     var response = await http.post(Uri.parse(addBookmarkApi),
  //         headers: header, body: body);
  //     if (response.statusCode == 200) {
  //       showCustomSuccessToast(message: "Bookmark Added");
  //       _loading = false;
  //       notifyListeners();
  //     } else {
  //       log("error ${response.body}");
  //       _loading = false;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     log("add Bookmak call error : ${e.toString()}");
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  // Stream getBookMarkStream(String placeId) async* {
  //   var headers = {
  //     'Authorization': 'Bearer $token',
  //   };

  //   while (true) {
  //     // ignore: prefer_typing_uninitialized_variables
  //     var bookmark;
  //     try {
  //       var response = await http.get(
  //         Uri.parse('$checkBookmarkApi$userId&bar_type_id=$placeId'),
  //         headers: headers,
  //       );

  //       if (response.statusCode == 200) {
  //         bookmark = jsonDecode(response.body);
  //       } else {
  //         bookmark = jsonDecode(response.body);
  //       }
  //     } catch (e) {
  //       log(e.toString());
  //     }

  //     yield bookmark;

  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  // Future<void> deleteBookmark(String placeId) async {
  //   _loading = true;
  //   notifyListeners();
  //   try {
  //     var header = {"Authorization": "Bearer $token"};
  //     var body = {"user_id": userId, "bar_place_id": placeId};
  //     var response = await http.post(Uri.parse(deleteBookmarkApi),
  //         headers: header, body: body);
  //     if (response.statusCode == 200) {
  //       _loading = false;
  //       notifyListeners();
  //       showCustomSuccessToast(message: "Bookmark Removed");
  //     } else {
  //       _loading = false;
  //       notifyListeners();
  //       log("error ${response.body}");
  //     }
  //   } catch (e) {
  //     _loading = false;
  //     notifyListeners();
  //     log("delete Bookmak call error : ${e.toString()}");
  //   }
  // }

  Future<void> getAllBookmarks(BuildContext context) async {
    await getUserCredential();
    var header = {"Authorization": "Bearer $token"};

    try {
      var response = await http.get(
        Uri.parse(getAllBookmarksApi + userId!),
        headers: header,
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        GetBookmarksModel getBookmarksModel = GetBookmarksModel.fromJson(data);

        // ignore: use_build_context_synchronously
        await getBookmarkDetails(getBookmarksModel, context);
      } else {
        log("Failed to fetch bookmarks: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching bookmarks: $e");
    }
  }

  Future<void> getBookmarkDetails(
      GetBookmarksModel getBookmarksModel, BuildContext context) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    _bookmarksBarsImagesList.clear();
    _bookmarksBarsDetailList.clear();
    _bookmarksBarsDistanceList.clear();
    try {
      if (getBookmarksModel.data != null &&
          getBookmarksModel.data!.isNotEmpty) {
        _bookmarksBarsDetailList.clear();
        _bookmarksBarsDistanceList.clear();

        List<Future> futures = [];

        for (var i = 0; i < getBookmarksModel.data!.length; i++) {
          if (getBookmarksModel.data![i].barPlaceId != null) {
            var barPlaceId = getBookmarksModel.data![i].barPlaceId!;

            futures.add(mapController
                .barsDetailMethod(barPlaceId)
                .then((barsDetails) async {
              if (barsDetails != null) {
                _bookmarksBarsDetailList.add(barsDetails);
                log("${_bookmarksBarsDetailList.length} detail ");
                notifyListeners();

                var distanceData = await mapController.getDistanceBetweenPoints(
                  barsDetails.geometry!.location!.lat.toString(),
                  barsDetails.geometry!.location!.lng.toString(),
                  _lat,
                  _lon,
                );

                _bookmarksBarsDistanceList.addAll(distanceData);

                // log(_bookmarksBarsDistanceList.toString());

                if (barsDetails.photos != null &&
                    barsDetails.photos!.isNotEmpty) {
                  var barsImages = await mapController
                      .exploreImages(barsDetails.photos![0].photoReference!);
                  _bookmarksBarsImagesList.addAll(barsImages);
                  log("${_bookmarksBarsImagesList.length} images");
                  notifyListeners();
                } else {
                  log("No photos available for barPlaceId: $barPlaceId");
                }
              } else {
                log("barsDetailMethod returned null for barPlaceId: $barPlaceId");
              }
            }));
          } else {
            log("barPlaceId is null for index $i");
          }
        }

        await Future.wait(futures);

        notifyListeners();
      } else {
        log("getBookmarksModel.data is null or empty");
      }
    } catch (e) {
      log("Error fetching bookmark details: $e");
    }
  }

  // Future<void> getBookmarkDetails(
  //     GetBookmarksModel getBookmarksModel, BuildContext context) async {
  //   final mapController = Provider.of<MapsController>(context, listen: false);

  //   try {
  //     if (getBookmarksModel.data != null) {
  //       _bookmarksBarsDetailList.clear(); // Clear the previous list

  //       for (var i = 0; i < getBookmarksModel.data!.length; i++) {
  //         if (getBookmarksModel.data![i].barPlaceId != null) {
  //           var barsDetails = await mapController
  //               .barsDetailMethod(getBookmarksModel.data![i].barPlaceId!);

  //           if (barsDetails != null) {
  //             _bookmarksBarsDetailList.add(barsDetails);

  //             if (barsDetails.photos != null &&
  //                 barsDetails.photos!.isNotEmpty) {
  //               var barsImages = await mapController
  //                   .exploreImages(barsDetails.photos![0].photoReference!);

  //               _bookmarksBarsImagesList.addAll(barsImages);
  //               notifyListeners();
  //             } else {
  //               log("No photos available for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
  //             }
  //           } else {
  //             log("barsDetailMethod returned null for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
  //           }
  //         } else {
  //           log("barPlaceId is null for index $i");
  //         }
  //       }
  //     } else {
  //       log("getBookmarksModel.data is null");
  //     }

  //     // Update listeners to refresh the UI
  //     notifyListeners();
  //   } catch (e) {
  //     log("Error fetching bookmark details: $e");
  //   }
  // }

  // Future<void> getAllBookmarks(context) async {
  //   await getUserCredential();
  //   var header = {"Authorization": "Bearer $token"};
  //   try {
  //     var response = await http.get(Uri.parse(getAllBookmarksApi + userId!),
  //         headers: header);
  //     var data = jsonDecode(response.body);
  //     // log(data.toString());
  //     if (response.statusCode == 200) {
  //       GetBookmarksModel getBookmarksModel = GetBookmarksModel.fromJson(data);
  //       log(data.toString());
  //       await getBookmarkDetails(getBookmarksModel, context);
  //     } else {
  //       log(response.statusCode.toString());
  //     }
  //   } catch (e) {
  //     log("get all bookmarks call : $e");
  //   }
  // }

  // Future<void> getBookmarkDetails(
  //     GetBookmarksModel getBookmarksModel, BuildContext context) async {
  //   final mapController = Provider.of<MapsController>(context, listen: false);
  //   try {
  //     if (getBookmarksModel.data != null) {
  //       for (var i = 0; i < getBookmarksModel.data!.length; i++) {

  //         if (getBookmarksModel.data![i].barPlaceId != null) {
  //           var barsDetails = await mapController
  //               .barsDetailMethod(getBookmarksModel.data![i].barPlaceId!);

  //           if (barsDetails != null) {
  //             _bookmarksBarsDetailList.add(barsDetails);

  //             if (barsDetails.photos != null &&
  //                 barsDetails.photos!.isNotEmpty) {
  //               var barsImages = await mapController
  //                   .exploreImages(barsDetails.photos![0].photoReference!);

  //               _bookmarksBarsImagesList.addAll(barsImages);
  //               notifyListeners();
  //             } else {
  //               log("No photos available for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
  //             }
  //           } else {
  //             log("barsDetailMethod returned null for barPlaceId: ${getBookmarksModel.data![i].barPlaceId}");
  //           }
  //         } else {
  //           log("barPlaceId is null for index $i");
  //         }
  //       }
  //     } else {
  //       log("getBookmarksModel.data is null");
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log("get bookmarks detail call : $e");
  //   }
  // }
}
