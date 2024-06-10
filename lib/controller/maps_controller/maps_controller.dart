import 'dart:convert';
import 'dart:developer';
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

  Future<NearbyBars> exploreNearbyBars() async {
    NearbyBars nearbyBars =   NearbyBars(bars: []);
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude')!;
      String longtitude = sp.getString('longitude')!;
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longtitude&radius=100&type=restaurant&key=$googleAPiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);
      if (response.statusCode == 200) {
        nearbyBars = NearbyBars.fromJson(values);
      } else {}
    } catch (e) {
      log(e.toString());
    }

    return nearbyBars;
  }
}
