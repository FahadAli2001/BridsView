import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:birds_view/model/bar_details_model/bar_details_model.dart';
import 'package:birds_view/model/bars_distance_model/bars_distance_model.dart';
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:birds_view/utils/api_keys.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:birds_view/views/onboarding_screen/onboarding_three_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsController extends ChangeNotifier {
  // String googleAPiKey = "AIzaSyAl8_GZb77k5io7_DCkAFYJHgGqDnzeH2k";
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final List<Marker> _markers = <Marker>[];
  List<Result> onMapNearestBar = [];
  double? _lat;
  double? _lon;
  bool _isGettingDirection = false;

  List<Marker> get markers => _markers;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  PolylinePoints get polylinePoints => _polylinePoints;
  bool get isGettingDirection => _isGettingDirection;

  set isGettingDirection(bool val){
    _isGettingDirection = val;
    notifyListeners();
  }

  List<Uint8List?> exploreBarsImages = [];
  List<Uint8List?> barsAndClubImages = [];
  List<Uint8List?> recomdedBarsImages = [];
  List<Uint8List?> nearestBarsImages = [];
  List<Rows> barsAndClubsDistanceList = [];
  List<Rows> nearestBarsDistanceList = [];
  List<Rows> exploreBarsDistanceList = [];
  List<Rows> recomendedBarsDistanceList = [];

  bool _isGettingLocation = false;
  bool get isGettingLocation => _isGettingLocation;
  double? get lat => _lat;
  double? get lon => _lon;

  Future<void> getCordinateds() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _lat = double.parse(sp.getString('latitude')!);
    _lon = double.parse(sp.getString('longitude')!);
  }

  loadData(lat, lon, List<Result> selectedBar, int index,List<Uint8List> barImage,context) async {
    onMapNearestBar.clear();
    markers.clear();
    nearestBarsImages.clear();
    nearestBarsDistanceList.clear();
    var nearestBar = await nearsetBarsMethodForMap();
    onMapNearestBar.addAll(nearestBar as Iterable<Result>);
    try {
      final Uint8List markerIcon =
          await getUserImageFromAssets(currentLocationIcon, 150);
      
      final Uint8List barsIcon = await getUserImageFromAssets(currentLocationIcon, 70);

      _markers.add(Marker(
        markerId: const MarkerId("user"),
        position: LatLng(lat, lon),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));

      _markers.add(Marker(
        markerId: const MarkerId("bar"),
        position: LatLng(selectedBar[index].geometry!.location!.lat!,
            selectedBar[index].geometry!.location!.lng!),
        icon: BitmapDescriptor.fromBytes(barsIcon),
        onTap: () {
                      customInfoWindowController.addInfoWindow!(
              GestureDetector(
                onTap: () {
                  clearPolylines();
                  getPolyline(nearestBar.cast<Result>(), index);
                },
                child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                     
                     SizedBox(
                          width: 100,
                          height: 200,
                          child: Image.memory(
                          barImage[index]  ,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                selectedBar[index].name ?? '',
                                maxLines: 2,
                                style: const TextStyle(
                                  
                                  color: Colors.black,
                                  
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                         selectedBar[index].rating == null ?
                       const  Text("Ratings Not Available",
                         style:   TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                         )
                         :   Align(
                          alignment: Alignment.topLeft,
                           child: RatingBarIndicator(
                                unratedColor: Colors.grey,
                                rating: selectedBar[index].rating! * 1.0  ,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: primaryColor,
                                ),
                                itemCount: 5,
                                itemSize: 15,
                                direction: Axis.horizontal,
                              ),
                         ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                selectedBar[index].vicinity ?? '',
                                maxLines: 4,
                                style: const TextStyle(
                                  color: Colors.black,
                                   fontSize: 10
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              LatLng(selectedBar[index].geometry!.location!.lat!,
                 selectedBar[index].geometry!.location!.lng!),
            );
        },
      ));

    try {
        for (var i = 0; i < nearestBarsImages.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(onMapNearestBar[i].geometry!.location!.lat!,
              onMapNearestBar[i].geometry!.location!.lng!),
          icon: BitmapDescriptor.fromBytes(barsIcon),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              GestureDetector(
                onTap: () {
                  clearPolylines();
                  getPolyline(nearestBar.cast<Result>(), i);
                },
                child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                      nearestBarsImages[i] == null ?
                       SizedBox(
                          width: 100,
                          height: 200,
                          child: Image.network(
                            nearestBar[i].icon!,
                            fit: BoxFit.cover,
                          ),
                        )
                      :  SizedBox(
                          width: 100,
                          height: 200,
                          child: Image.memory(
                            nearestBarsImages[i]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                nearestBar[i].name ?? '',
                                maxLines: 2,
                                style: const TextStyle(
                                  
                                  color: Colors.black,
                                  
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                         nearestBar[i].rating == null ?
                       const  Text("Ratings Not Available",
                         style:   TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                         )
                         :   Align(
                          alignment: Alignment.topLeft,
                           child: RatingBarIndicator(
                                unratedColor: Colors.grey,
                                rating: nearestBar[i].rating! * 1.0  ,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: primaryColor,
                                ),
                                itemCount: 5,
                                itemSize: 15,
                                direction: Axis.horizontal,
                              ),
                         ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                onMapNearestBar[i].vicinity ?? '',
                                maxLines: 4,
                                style: const TextStyle(
                                  color: Colors.black,
                                   fontSize: 10
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              LatLng(onMapNearestBar[i].geometry!.location!.lat!,
                  onMapNearestBar[i].geometry!.location!.lng!),
            );
          },
        ));
      } 
    } catch (e) {
      log("custom box ${e.toString()}"); 
    }
      notifyListeners();
    } catch (e) {
      log("$e load data");
    }
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        jointType: JointType.bevel,
        endCap: Cap.roundCap,
        geodesic: true,
        polylineId: id,
        color: Colors.blue.shade800,
        points: _polylineCoordinates);
    _polylines[id] = polyline;
    notifyListeners();
  }

  getPolyline(List<Result> bars, int index) async {
    _isGettingDirection = true;
    notifyListeners();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapApiKey,
      PointLatLng(lat!, lon!),
      PointLatLng(bars[index].geometry!.location!.lat!,
          bars[index].geometry!.location!.lng!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      _isGettingDirection = false;
      notifyListeners();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();

    notifyListeners();
  }

  void clearPolylines() {
    _polylines.clear();
    _polylineCoordinates.clear();
    notifyListeners();
  }

  Future<Uint8List> getUserImageFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

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

  Future<List<Results>> exploreNearbyBarsMethod() async {
    List<Results> exploreNearbyBars = [];

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      log(latitude);
      log(longitude);
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=3000&type=bar&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        exploreNearbyBars = list.map((i) => Results.fromJson(i)).toList();

        for (var bar in exploreNearbyBars) {
          if (bar.photos != null && bar.photos!.isNotEmpty) {
            var exploreBardata =
                await exploreImages(bar.photos![0].photoReference!);
            var distanceData = await getDistanceBetweenPoints(
                bar.geometry!.location!.lat.toString(),
                bar.geometry!.location!.lng.toString(),
                latitude,
                longitude);
            exploreBarsDistanceList.addAll(distanceData);
            exploreBarsImages.addAll(exploreBardata);
          }
        }
      } else {
        log(response.body);
      }
    } catch (e) {
      log(e.toString());
    }

    return exploreNearbyBars;
  }

  Future<List<Uint8List?>> exploreImages(String ref) async {
    List<Uint8List?> exploreNearbyBarsImagesList = [];
    exploreNearbyBarsImagesList.clear();
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$ref&key=$googleMapApiKey"));

      if (response.statusCode == 200) {
        var data = response.bodyBytes;
        exploreNearbyBarsImagesList.add(data);

        // log("Image retrieved successfully");
      } else {
        log("Image retrieval failed. Status Code: ${response.statusCode}");
        log("Error Message: ${response.body}");
      }
    } catch (e) {
      log("getImageFromMap error: $e");
    }
    notifyListeners();
    return exploreNearbyBarsImagesList;
  }

  Future<List<Results>> recommendedBarsMethod() async {
    List<Results> bars = [];
    List<Results> recomnededBars = [];
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=bar&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        bars = list.map((i) => Results.fromJson(i)).toList();

        // Fetch images for the places
        for (var bar in bars) {
          if (bar.rating != null && bar.rating! >= 4.0) {
            if (bar.photos != null && bar.photos!.isNotEmpty) {
              var imageData =
                  await exploreImages(bar.photos![0].photoReference!);
              if (imageData.isNotEmpty) {
                recomdedBarsImages.addAll(imageData);
              }
              var distanceData = await getDistanceBetweenPoints(
                  bar.geometry!.location!.lat.toString(),
                  bar.geometry!.location!.lng.toString(),
                  latitude,
                  longitude);
              recomendedBarsDistanceList.addAll(distanceData);
              recomnededBars.add(bar);
            }
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return recomnededBars;
  }

  Future<List<Rows>> getDistanceBetweenPoints(
      String destinationLat, destinationLong, originLat, originLong) async {
    List<Rows> distanceList = [];
    try {
      var response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=$googleMapApiKey'));
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var list = data['rows'] as List;
        distanceList = list.map((i) => Rows.fromJson(i)).toList();
      } else {}
    } catch (e) {
      log('error $e');
    }

    return distanceList;
  }

  Future<List<Results>> nearsetBarsMethod() async {
    List<Results> nearestBars = [];

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=bar&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        nearestBars = list.map((i) => Results.fromJson(i)).toList();

        for (var bar in nearestBars) {
          if (bar.photos != null && bar.photos!.isNotEmpty) {
            var nearestBardata =
                await exploreImages(bar.photos![0].photoReference!);
            nearestBarsImages.addAll(nearestBardata);
          }
          var distanceData = await getDistanceBetweenPoints(
              bar.geometry!.location!.lat.toString(),
              bar.geometry!.location!.lng.toString(),
              latitude,
              longitude);
          nearestBarsDistanceList.addAll(distanceData);
        }
      } else {
        log("Error");
      }
    } catch (e) {
      log(e.toString());
    }

    return nearestBars;
  }

  Future<List<Result>> nearsetBarsMethodForMap() async {
    log("nearsetBarsMethodForMap");
    List<Result> nearestBars = [];

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1000&type=restaurant&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        List<Results> resultsList = list
            .map(
              (e) => Results.fromJson(e),
            )
            .toList();
        log("result list length : ${resultsList.length}");
        // nearestBars = list.map((i) => Result.fromJson(i)).toList();

        for (var i = 0; i < resultsList.length; i++) {
          if (resultsList[i].photos != null &&
              resultsList[i].photos!.isNotEmpty) {
            var nearestBardata =
                await exploreImages(resultsList[i].photos![0].photoReference!);
            nearestBarsImages.addAll(nearestBardata);
          }
          var barDetail =await barsDetailMethod(resultsList[i].placeId!);
          nearestBars.add(barDetail!);
          var distanceData = await getDistanceBetweenPoints(
              resultsList[i].geometry!.location!.lat.toString(),
              resultsList[i].geometry!.location!.lng.toString(),
              latitude,
              longitude);
          nearestBarsDistanceList.addAll(distanceData);
        }
      } else {
        log("Error");
      }
    } catch (e) {
      log("nearest bar method :  ${e.toString()}");
    }
    log(nearestBars.length.toString());
    return nearestBars;
  }

  Future<Result?> barsDetailMethod(String placeId) async {
    Result? result;
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapApiKey"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var detailResponse = data['result'];
        result = Result.fromJson(detailResponse as Map<String, dynamic>);
      } else {
        log(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<List<Results>> exploreBarsOrClubs(String type) async {
    List<Results> nearestBars = [];
    nearestBars.clear();
    barsAndClubImages.clear();
    barsAndClubsDistanceList.clear();

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=2000&type=$type&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        nearestBars = list.map((i) => Results.fromJson(i)).toList();

        for (var bar in nearestBars) {
          if (bar.photos != null && bar.photos!.isNotEmpty) {
            var nearestBardata =
                await exploreImages(bar.photos![0].photoReference!);
            barsAndClubImages.addAll(nearestBardata);
          }
          var distanceData = await getDistanceBetweenPoints(
              bar.geometry!.location!.lat.toString(),
              bar.geometry!.location!.lng.toString(),
              latitude,
              longitude);
          barsAndClubsDistanceList.addAll(distanceData);
        }
      } else {
        log("Error");
      }
    } catch (e) {
      log(e.toString());
    }

    return nearestBars;
  }
}
