import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/search_bars_model/search_bars_model.dart';
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
  double? _lat;
  double? _lon;
  double? get lat => _lat;
  double? get lon => _lon;

  Future<void> getCordinateds() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _lat = double.tryParse(sp.getString('latitude') ?? '');
    _lon = double.tryParse(sp.getString('longitude') ?? '');
  }

  Future<void> searchBarsOrClubs(String placeName, BuildContext context) async {
    List<Predictions> searchResultList = [];
    searchResultList.clear();
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$googleMapApiKey&sessiontoken=123456&components=country:pk"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // log("Response data: $data");

        if (data['predictions'] != null && data['predictions'] is List) {
          var list = data['predictions'] as List;
          searchResultList = list.map((e) {
            if (e != null) {
              return Predictions.fromJson(e as Map<String, dynamic>);
            } else {
              log("Encountered null element in predictions list");
              return null;
            }
          }).where((element) => element != null).cast<Predictions>().toList();
          
          // log("Parsed predictions: $searchResultList");

          if (searchResultList.isNotEmpty) {
             // ignore: use_build_context_synchronously
             await getSearchBarsDetail(searchResult: searchResultList, context:  context);
            log("searchBarDetail is not empty");
          } else {
            log("searchBarDetail is empty");
          }
        } else {
          log("No predictions found or predictions is not a list.");
        }
      } else {
        log(response.body);
      }
    } catch (e) {
      log("search method error: ${e.toString()}");
    }
  }

  Future<List<Result?>> getSearchBarsDetail(
      {List<Predictions>? searchResult,   context}) async {
    
    barDetail.clear();
    searcbarsImage.clear();
    searcbarsDistance.clear();
    final mapController = Provider.of<MapsController>(context, listen: false);

    try {
      for (var i = 0; i < searchResult!.length; i++) {
        var data = await mapController.barsDetailMethod(searchResult[i].placeId!);
        if (data != null) {
          barDetail.add(data);

          if (data.photos != null && data.photos!.isNotEmpty) {
            var imageData = await mapController.exploreImages(data.photos![0].photoReference!);
            searcbarsImage.addAll(imageData);
          }

          if (data.geometry != null && data.geometry!.location != null) {
            var distanceData = await mapController.getDistanceBetweenPoints(
              data.geometry!.location!.lat.toString(),
              data.geometry!.location!.lng.toString(),
              lat,
              lon
            );
            searcbarsDistance.addAll(distanceData);
          }
        } else {
          log("Received null data from barsDetailMethod for placeId: ${searchResult[i].placeId}");
        }
      }
      log(barDetail.toString());
    } catch (e) {
      log("get detail method error: ${e.toString()}");
    }
    return barDetail;
  }
}