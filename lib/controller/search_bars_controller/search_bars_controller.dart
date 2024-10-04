import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/utils/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/bars_distance_model/bars_distance_model.dart';

class SearchBarsController extends ChangeNotifier {
  TextEditingController searchTextFieldController = TextEditingController();
  List<Uint8List?> searcbarsImage = [];
  List<Rows> searcbarsDistance = [];
  List<Result?> barDetail = [];
  bool _searchingBar = false;
  double? _lat;
  double? _lon;
  double? get lat => _lat;
  double? get lon => _lon;
  bool get searchingBar => _searchingBar;

   set searchingBar(val){
    _searchingBar = val;
    notifyListeners();
   } 

  Future<void> getCordinateds() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _lat = double.tryParse(sp.getString('latitude') ?? '');
    _lon = double.tryParse(sp.getString('longitude') ?? '');

    notifyListeners();
  }

  Future<void> searchBarsOrClubs(String placeName, context) async {
    _searchingBar = true;
    notifyListeners();
    log(searchingBar.toString());
    List<Results> searchResultList = [];
    searchResultList.clear();
    clearFields();

    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$placeName&type=bar|night_club&location=$lat,$lon&radius=7500&key=$googleMapApiKey"
          // "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lon&radius=2500&type=bar|night_club&key=$googleMapApiKey"
          ));
      // log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data['results'].toString());

        if (data['results'] != null && data['results'] is List) {
          var list = data['results'] as List;
          searchResultList = list.map((e) => Results.fromJson(e)).toList();
          // log("search bar method :  ${searchResultList.length.toString()}");
          if (searchResultList.isNotEmpty) {
            await getSearchBarsDetail(
              searchResultList,
              context,
            );
            _searchingBar = false;
            notifyListeners();
            log(searchingBar.toString());
            log("searchBarDetail is not empty");
          } else {
            _searchingBar = false;
            notifyListeners();
            log("searchBarDetail is empty");
          }
        } else {
          _searchingBar = false;
          notifyListeners();
          log("No predictions found or predictions is not a list.");
        }
      } else {
        _searchingBar = false;
        notifyListeners();
        log("response.statusCode.toString()");
      }
    } catch (e) {
      _searchingBar = false;
      notifyListeners();
      log("search method error: ${e.toString()}");
    }
  }

  Future<void> getSearchBarsDetail(
    List<Results> searchResult,
    context,
  ) async {
    final mapController = Provider.of<MapsController>(context, listen: false);
    List<Future<void>> fetchTasks = [];

    try {
      for (var prediction in searchResult) {
        fetchTasks.add(Future(() async {
          var data = await mapController.barsDetailMethod(prediction.placeId!);

          if (data != null &&
              !barDetail.any((item) => item?.placeId == data.placeId)) {
            barDetail.add(data);

            if (data.photos != null && data.photos!.isNotEmpty) {
              var imageData = await mapController
                  .exploreImages(data.photos![0].photoReference!);
              searcbarsImage.addAll(imageData);
            }

            if (data.geometry != null && data.geometry!.location != null) {
              var distanceData = await mapController.getDistanceBetweenPoints(
                data.geometry!.location!.lat.toString(),
                data.geometry!.location!.lng.toString(),
                lat,
                lon,
              );
              searcbarsDistance.addAll(distanceData);
            }
          }
        }));
      }

     
      await Future.wait(fetchTasks);

      notifyListeners();
    } catch (e) {
      log("get detail method error: $e");
    }
  }

  // Future<void> getSearchBarsDetail(
  //   List<Predictions> searchResult,
  //   context,
  // ) async {
  //   final mapController = Provider.of<MapsController>(context, listen: false);
  //   log("get search bar detail method :  ${searchResult.length.toString()}");
  //   try {
  //     for (var i = 0; i < searchResult.length; i++) {
  //       var data =
  //           await mapController.barsDetailMethod(searchResult[i].placeId!);
  //       barDetail.add(data);
  //       log("bar detail : ${barDetail.length}");
  //       if (data != null) {
  //         // Check if the item already exists in the list
  //         if (!barDetail.any((item) => item?.placeId == data.placeId)) {
  //           barDetail.add(data);
  //           log("Added to barDetail: ${data.name}");
  //         } else {
  //           log("Item already exists in barDetail: ${data.name}");
  //         }

  //         if (data.photos != null && data.photos!.isNotEmpty) {
  //           var imageData = await mapController
  //               .exploreImages(data.photos![0].photoReference!);
  //           searcbarsImage.addAll(imageData);
  //         }

  //         if (data.geometry != null && data.geometry!.location != null) {
  //           var distanceData = await mapController.getDistanceBetweenPoints(
  //             data.geometry!.location!.lat.toString(),
  //             data.geometry!.location!.lng.toString(),
  //             lat,
  //             lon,
  //           );

  //           searcbarsDistance.addAll(distanceData);
  //         }
  //       } else {
  //         log("Received null data from barsDetailMethod for placeId: ${searchResult[i].placeId.toString()}");
  //       }
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log("get detail method error: ${e.toString()}");
  //   }
  // }

  void clearFields() {
    barDetail.clear();
    searcbarsImage.clear();
    searcbarsDistance.clear();
    notifyListeners();
  }
}
