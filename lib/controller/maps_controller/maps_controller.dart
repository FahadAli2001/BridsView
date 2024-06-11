import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:http/http.dart' as http;
import 'package:birds_view/views/onboarding_screen/onboarding_three_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsController extends ChangeNotifier {
  String googleAPiKey = "AIzaSyAl8_GZb77k5io7_DCkAFYJHgGqDnzeH2k";
  List<Uint8List?> exploreNearbyBarsImagesList = [];
  bool _isGettingLocation = false;
  bool get isGettingLocation => _isGettingLocation;

  Future<void> getCurrentLocation(context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _isGettingLocation = true;
    notifyListeners();
    try {
      LocationPermission locationPermission =
          await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.whileInUse ||
          locationPermission == LocationPermission.always) {
        Position currentPosition = await Geolocator.getCurrentPosition();

        sp.setString("latitude", currentPosition.latitude.toString());
        sp.setString("longitude", currentPosition.longitude.toString());

        log(currentPosition.latitude.toString());
        log(currentPosition.longitude.toString());
        Navigator.push(
            context,
            PageTransition(
                child: const OnboardingThree(), type: PageTransitionType.fade));
      } else if (locationPermission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
        log('denied forever');
      } else if (locationPermission == LocationPermission.denied) {
        log('denied ');
      }
      _isGettingLocation = false;
      notifyListeners();
    } catch (e) {
      _isGettingLocation = false;
      notifyListeners();
      log('catch current location error : $e');
    }
  }

  Future<List<Results>> exploreNearbyBars() async {
    List<Results> nearbyBars = [];
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude')!;
      String longitude = sp.getString('longitude')!;
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=3000&type=restaurant&key=$googleAPiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var list = values['results'] as List;
        nearbyBars = list.map((i) => Results.fromJson(i)).toList();

        for (var i = 0; i < nearbyBars.length; i++) {
          List<Uint8List?> image = [];
          image.clear();

          if (nearbyBars[i].photos != null &&
              nearbyBars[i].photos!.isNotEmpty) {
          await exploreNearbyBarsImages(
                nearbyBars[i].photos![0].photoReference!);
            
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
    log(nearbyBars.length.toString());
    return nearbyBars;
  }

  Future<List<Uint8List?>> exploreNearbyBarsImages(String ref) async {
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$ref&key=$googleAPiKey"));

      if (response.statusCode == 200) {
        // Return the image data as a string
        var data = response.bodyBytes;
        exploreNearbyBarsImagesList.add(data);
        // Log that image retrieval was successful

        log("Image retrieved successfully");
      } else {
        // Log the status code and body for debugging in case of an error
        log("Image retrieval failed. Status Code: ${response.statusCode}");
        log("Error Message: ${response.body}");
      }
    } catch (e) {
      // Log any exceptions that occur during the image retrieval process
      log("getImageFromMap error: $e");
    }
    notifyListeners();
    return exploreNearbyBarsImagesList;
  }
}
