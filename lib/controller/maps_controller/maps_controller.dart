import 'dart:convert';
import 'dart:ui' as ui;
import 'package:birds_view/model/nearby_bars_model/nearby_bars_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

class MapsController extends ChangeNotifier {
  // String googleAPiKey = "AIzaSyAl8_GZb77k5io7_DCkAFYJHgGqDnzeH2k";
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  final List<Marker> _markers = <Marker>[];
  List<Result> onMapNearestBar = [];
  String _dropDownValue = "Bars";
  String get dropDownValue => _dropDownValue;
  List<String> dropDownList = ["Bars", "Clubs", "Restaurants"];

  set dropDownValue(String val) {
    _dropDownValue = val;
    notifyListeners();
  }

  double? _lat;
  double? _lon;
  bool _isGettingDirection = false;
  bool _exploring = false;

  List<Marker> get markers => _markers;
  Map<PolylineId, Polyline> get polylines => _polylines;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  PolylinePoints get polylinePoints => _polylinePoints;
  bool get isGettingDirection => _isGettingDirection;
  bool get exploring => _exploring;

  set isGettingDirection(bool val) {
    _isGettingDirection = val;
    notifyListeners();
  }

  List<Uint8List?> exploreScreenbarsOrClubsImages = [];
  List<Results>? exploreScreenbarsOrClubsData = [];
  List<Rows> exploreScreenbarsOrClubsDistanceList = [];
  List<Result> exploreScreenbarAndClubsDetails = [];

  List<Uint8List?> homeScreennearsetbarsOrClubsImages = [];
  List<Results>? homeScreennearestbarsOrClubsData = [];
  List<Rows> homeScreennearestbarsOrClubsDistanceList = [];

  List<Uint8List?> homeScreenRecommendedbarsOrClubsImages = [];
  List<Results>? homeScreenRecommendedbarsOrClubsData = [];
  List<Rows> homeScreenRecommendedbarsOrClubsDistanceList = [];

  List<Uint8List?> homeScreenExplorebarsOrClubsImages = [];
  List<Results>? homeScreenExplorebarsOrClubsData = [];
  List<Rows> homeScreenExplorebarsOrClubsDistanceList = [];

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

  loadData(lat, lon, List<Result> selectedBar, int index,
      List<Uint8List> barImage, context) async {
    onMapNearestBar.clear();
    markers.clear();
    nearestBarsImages.clear();
    nearestBarsDistanceList.clear();
    var nearestBar = await nearsetBarsMethodForMap();
    onMapNearestBar.addAll(nearestBar as Iterable<Result>);
    try {
      // final Uint8List markerIcon =
      //     await getUserImageFromAssets(currentLocationIcon, 150);

      // final Uint8List barsIcon =
      //     await getUserImageFromAssets(currentLocationIcon, 70);

      _markers.add(Marker(
          markerId: const MarkerId("user"),
          position: LatLng(lat, lon),
          // icon: BitmapDescriptor.fromBytes(markerIcon),
          icon: BitmapDescriptor.defaultMarker));

      _markers.add(Marker(
        markerId: const MarkerId("bar"),
        position: LatLng(selectedBar[index].geometry!.location!.lat!,
            selectedBar[index].geometry!.location!.lng!),
        // icon: BitmapDescriptor.fromBytes(barsIcon),
        icon: BitmapDescriptor.defaultMarker,
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
                      barImage[index].isEmpty
                          ? SizedBox(
                              width: 100,
                              height: 200,
                              child: Image.asset(
                                emptyImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                barImage[index],
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
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          selectedBar[index].rating == null
                              ? Text(
                                  "Ratings Not Available",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: RatingBarIndicator(
                                    unratedColor: Colors.grey,
                                    rating: selectedBar[index].rating! * 1.0,
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
                              style: GoogleFonts.urbanist(
                                  color: Colors.black, fontSize: 10
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
            // icon: BitmapDescriptor.fromBytes(barsIcon),
            icon: BitmapDescriptor.defaultMarker,
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
                          nearestBarsImages[i] == null
                              ? SizedBox(
                                  width: 100,
                                  height: 200,
                                  child: Image.network(
                                    nearestBar[i].icon!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(
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
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              nearestBar[i].rating == null
                                  ? Text(
                                      "Ratings Not Available",
                                      style: GoogleFonts.urbanist(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: RatingBarIndicator(
                                        unratedColor: Colors.grey,
                                        rating: nearestBar[i].rating! * 1.0,
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
                                  style: GoogleFonts.urbanist(
                                      color: Colors.black, fontSize: 10
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

  void clearCurrentLocationMarker() {
    markers.removeWhere((marker) => marker.markerId == const MarkerId('user'));
    notifyListeners();
  }

  _addPolyLine() {
    // _polylines.clear();
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

  getPolyline(List<Result> bars, int index,
      {double? userLat, double? userLng}) async {
    log("user lat : ${userLat ?? 'n/a'}");

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleMapApiKey,
        request: PolylineRequest(
          origin: userLat != null && userLng != null
              ? PointLatLng(userLat, userLng)
              : PointLatLng(lat!, lon!),
          destination: PointLatLng(
              bars[index].geometry!.viewport!.southwest!.lat!,
              bars[index].geometry!.viewport!.southwest!.lng!),
          mode: TravelMode.driving,
        ),
      );
      sp.setString("lastVisitedBar", bars[index].placeId.toString());
      if (result.points.isNotEmpty) {
        notifyListeners();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLine();

      notifyListeners();
    } catch (e) {
      log("polyline error : $e");
    }
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
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         child: const OnboardingThree(), type: PageTransitionType.fade));
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

  // Future<void> exploreNearbyBarsMethod() async {
  //   try {
  //     SharedPreferences sp = await SharedPreferences.getInstance();
  //     String latitude = sp.getString('latitude') ?? '';
  //     String longitude = sp.getString('longitude') ?? '';
  //     log('Latitude: $latitude, Longitude: $longitude');

  //     String url =
  //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club|liquor_store&keyword=bar|club&key=$googleMapApiKey';
  //     http.Response response = await http.get(Uri.parse(url));
  //     final values = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       var list = values['results'] as List;
  //       homeScreenExplorebarsOrClubsData =
  //           list.map((i) => Results.fromJson(i)).toList();

  //       // Prepare futures for fetching images and distances
  //       var fetchTasks = <Future>[];

  //       for (var bar in homeScreenExplorebarsOrClubsData!) {
  //         if (bar.photos != null && bar.photos!.isNotEmpty) {
  //           fetchTasks.add(Future.wait([
  //             exploreImages(bar.photos![0].photoReference!).then((imageData) {
  //               homeScreenExplorebarsOrClubsImages.addAll(imageData);
  //             }),
  //             getDistanceBetweenPoints(
  //                     bar.geometry!.location!.lat.toString(),
  //                     bar.geometry!.location!.lng.toString(),
  //                     latitude,
  //                     longitude)
  //                 .then((distanceData) {
  //               homeScreenExplorebarsOrClubsDistanceList.addAll(distanceData);
  //             }),
  //           ]));
  //         }
  //       }
  //       await Future.wait(fetchTasks);
  //     } else {
  //       log('Error response: ${response.body}');
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log('Error in exploreNearbyBarsMethod: ${e.toString()}');
  //   }
  // }
  Future<void> exploreNearbyBarsMethod() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      log('Latitude: $latitude, Longitude: $longitude');

      // Get the selected filter from your dropdown
      String selectedFilter =
          dropDownValue; // Make sure dropDownValue reflects your dropdown selection

      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club|liquor_store|restaurant|establishment&keyword=bar|night_club|liquor_store|restaurant|establishment&key=$googleMapApiKey';

      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        var places = list.map((i) => Results.fromJson(i)).toList();
        log('Total places fetched: ${places.length}');

        // Prepare the lists for storing the filtered results
        var fetchTasks = <Future>[];

        for (var place in places) {
          // Apply the filtering logic based on the selected filter (Bars, Clubs, or Restaurants)
          if (selectedFilter == "Bars" || selectedFilter == "Clubs") {
            // Only include results that are bars or clubs
            if (!place.types!.contains("bar") &&
                !place.types!.contains("night_club")) {
              continue; // Skip if it's not a bar or club
            }
          }

          if (selectedFilter == "Restaurants") {
            
            if (!place.types!.contains("restaurant")) {
              continue;  
            }
          }

           
          fetchTasks.add(() async {
            Uint8List? imageData;
            Rows? distanceData;

            // If the place has photos, fetch the image
            if (place.photos != null && place.photos!.isNotEmpty) {
              var imageResults =
                  await exploreImages(place.photos![0].photoReference!);
              imageData =
                  imageResults.isNotEmpty ? imageResults[0] : Uint8List(0);
            } else {
              imageData = Uint8List(0);
            }

            // If the place has a geometry, calculate the distance
            if (place.geometry != null && place.geometry!.location != null) {
              var distanceResults = await getDistanceBetweenPoints(
                place.geometry!.location!.lat.toString(),
                place.geometry!.location!.lng.toString(),
                latitude,
                longitude,
              );
              distanceData = distanceResults.isNotEmpty
                  ? distanceResults[0]
                  : const Rows();
            }

            // Add the place and its corresponding data to the lists
            homeScreenExplorebarsOrClubsData!.add(place);
            homeScreenExplorebarsOrClubsImages.add(imageData ?? Uint8List(0));
            homeScreenExplorebarsOrClubsDistanceList
                .add(distanceData ?? const Rows());
          }());
        }

        // Wait for all the tasks to complete
        await Future.wait(fetchTasks);
        log(homeScreenExplorebarsOrClubsData
            .toString()); // Log the filtered data
      } else {
        log('Error response: ${response.body}');
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      log('Error in exploreNearbyBarsMethod: ${e.toString()}');
    }
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

  // Future<void> recommendedBarsMethod() async {
  //   clearHomeScreenList(); // Clears the previous list

  //   List<Future<void>> fetchTasks = [];

  //   try {
  //     SharedPreferences sp = await SharedPreferences.getInstance();
  //     String latitude = sp.getString('latitude') ?? '';
  //     String longitude = sp.getString('longitude') ?? '';
  //     String url =
  //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club&keyword=bar|night_club|liquor_store&key=$googleMapApiKey';

  //     http.Response response = await http.get(Uri.parse(url));
  //     final values = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       var list = values['results'] as List;
  //       var bars = list.map((i) => Results.fromJson(i)).toList();

  //       for (var bar in bars) {
  //         // Check rating and ensure the bar has photos
  //         if (bar.rating != null &&
  //             bar.rating! >= 4.0 &&
  //             bar.photos != null &&
  //             bar.photos!.isNotEmpty) {
  //           fetchTasks.add(() async {
  //             // Fetch image and distance for each bar in sequence
  //             var imageData =
  //                 await exploreImages(bar.photos![0].photoReference!);
  //             var distanceData = await getDistanceBetweenPoints(
  //               bar.geometry!.location!.lat.toString(),
  //               bar.geometry!.location!.lng.toString(),
  //               latitude,
  //               longitude,
  //             );

  //             if (imageData.isNotEmpty) {
  //               homeScreenRecommendedbarsOrClubsImages.add(imageData.first);
  //               homeScreenRecommendedbarsOrClubsDistanceList
  //                   .add(distanceData.first);
  //               homeScreenRecommendedbarsOrClubsData!.add(bar);
  //             }
  //           }());
  //         }
  //       }

  //       await Future.wait(fetchTasks);
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> recommendedBarsMethod() async {
  clearHomeScreenList(); // Clears the previous list
  List<Future<void>> fetchTasks = [];

  try {
    // Get the user's latitude and longitude from shared preferences
    SharedPreferences sp = await SharedPreferences.getInstance();
    String latitude = sp.getString('latitude') ?? '';
    String longitude = sp.getString('longitude') ?? '';

    // Check if coordinates are valid
    if (latitude.isEmpty || longitude.isEmpty) {
      log('Latitude or Longitude is empty');
      return;
    }

    log('Latitude: $latitude, Longitude: $longitude');

    // Define the API endpoint
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club&keyword=bar|night_club|liquor_store&key=$googleMapApiKey';

    // Make the API request
    http.Response response = await http.get(Uri.parse(url));
    final values = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var list = values['results'] as List;
      var bars = list.map((i) => Results.fromJson(i)).toList();
      log('Total bars fetched: ${bars.length}');

      for (var bar in bars) {
        // Log the bar details for debugging
        log('Bar: ${bar.name}, Rating: ${bar.rating}, Photos: ${bar.photos}');

        // Check if the bar meets the criteria (rating >= 4.0 and has photos)
        if (bar.rating != null &&
            bar.rating! >= 4.0 &&
            bar.photos != null &&
            bar.photos!.isNotEmpty) {
          fetchTasks.add(() async {
            // Fetch image and distance for each bar
            try {
              // Fetch image
              var imageData = await exploreImages(bar.photos![0].photoReference!);
              if (imageData.isEmpty) {
                log('No image found for ${bar.name}');
                return; // Skip if no image found
              }

              // Fetch distance
              var distanceData = await getDistanceBetweenPoints(
                bar.geometry!.location!.lat.toString(),
                bar.geometry!.location!.lng.toString(),
                latitude,
                longitude,
              );

              if (distanceData.isEmpty) {
                log('No distance data for ${bar.name}');
                return; // Skip if no distance data
              }

              // Add fetched data to respective lists
              homeScreenRecommendedbarsOrClubsImages.add(imageData.first);
              homeScreenRecommendedbarsOrClubsDistanceList.add(distanceData.first);
              homeScreenRecommendedbarsOrClubsData!.add(bar);
            } catch (e) {
              log('Error fetching image or distance for ${bar.name}: ${e.toString()}');
            }
          }());
        } else {
          log('Bar does not meet criteria (Rating >= 4.0 and has photos): ${bar.name}');
        }
      }

      // Wait for all the fetch tasks to complete
      await Future.wait(fetchTasks);
      log('Total recommended bars: ${homeScreenRecommendedbarsOrClubsData!.length}');
    } else {
      log('Error fetching data: ${response.body}');
    }

    // Notify listeners to update the UI
    notifyListeners();
  } catch (e) {
    log('Error in recommendedBarsMethod: ${e.toString()}');
  }
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

  // Future<void> nearsetBarsMethod() async {
  //   clearHomeScreenList();

  //   List<Future> fetchTasks = [];

  //   try {
  //     SharedPreferences sp = await SharedPreferences.getInstance();
  //     String latitude = sp.getString('latitude') ?? '';
  //     String longitude = sp.getString('longitude') ?? '';

  //     String url =
  //         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club|liquor_store&keyword=bar|club&key=$googleMapApiKey';
  //     http.Response response = await http.get(Uri.parse(url));
  //     final values = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       var list = values['results'] as List;
  //       var bars = list.map((i) => Results.fromJson(i)).toList();
  //       log('Total nearest bars: ${bars.length}');

  //       for (var bar in bars) {
  //         fetchTasks.add(() async {
  //           Uint8List? imageData;
  //           Rows? distanceData;

  //           if (bar.photos != null && bar.photos!.isNotEmpty) {
  //             var imageResults =
  //                 await exploreImages(bar.photos![0].photoReference!);
  //             if (imageResults.isNotEmpty) {
  //               imageData = imageResults[0];
  //             } else {
  //               imageData = Uint8List(0);
  //             }
  //           } else {
  //             imageData = Uint8List(0);
  //           }

  //           if (bar.geometry != null && bar.geometry!.location != null) {
  //             var distanceResults = await getDistanceBetweenPoints(
  //               bar.geometry!.location!.lat.toString(),
  //               bar.geometry!.location!.lng.toString(),
  //               latitude,
  //               longitude,
  //             );
  //             if (distanceResults.isNotEmpty) {
  //               distanceData = distanceResults[0];
  //             }
  //           }

  //           homeScreennearestbarsOrClubsData!.add(bar);
  //           homeScreennearsetbarsOrClubsImages.add(imageData ?? Uint8List(0));
  //           homeScreennearestbarsOrClubsDistanceList
  //               .add(distanceData ?? const Rows());
  //         }());
  //       }

  //       await Future.wait(fetchTasks);
  //     } else {
  //       log("Error: ${response.statusCode}");
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     log("Error in fetching nearest bars: $e");
  //   }
  // }

  Future<void> nearsetBarsMethod() async {
    clearHomeScreenList();

    List<Future> fetchTasks = [];

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';

      String selectedFilter = dropDownValue; // Get the selected filter

      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=bar|night_club|liquor_store|restaurant|establishment&keyword=bar|night_club|liquor_store|restaurant|establishment&key=$googleMapApiKey';

      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);
      log(selectedFilter);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        var places = list.map((i) => Results.fromJson(i)).toList();
        log('Total nearest places: ${places.length}');

        for (var place in places) {
          // Apply the filtering based on the selected filter (Bars, Clubs, or Restaurants)
          if (selectedFilter == "Bars" || selectedFilter == "Clubs") {
            // Only include results that are bars or clubs
            if (!place.types!.contains("bar") &&
                !place.types!.contains("night_club")) {
              continue; // Skip if it's not a bar or club
            }
          }

          if (selectedFilter == "Restaurants") {
            // Only include results that are restaurants
            if (!place.types!.contains("restaurant")) {
              continue; // Skip if it's not a restaurant
            }
          }

          // Add the valid result to the list of fetch tasks for image and distance retrieval
          fetchTasks.add(() async {
            Uint8List? imageData;
            Rows? distanceData;

            if (place.photos != null && place.photos!.isNotEmpty) {
              var imageResults =
                  await exploreImages(place.photos![0].photoReference!);
              imageData =
                  imageResults.isNotEmpty ? imageResults[0] : Uint8List(0);
            } else {
              imageData = Uint8List(0);
            }

            if (place.geometry != null && place.geometry!.location != null) {
              var distanceResults = await getDistanceBetweenPoints(
                place.geometry!.location!.lat.toString(),
                place.geometry!.location!.lng.toString(),
                latitude,
                longitude,
              );
              distanceData = distanceResults.isNotEmpty
                  ? distanceResults[0]
                  : const Rows();
            }

            homeScreennearestbarsOrClubsData!.add(place);
            homeScreennearsetbarsOrClubsImages.add(imageData ?? Uint8List(0));
            homeScreennearestbarsOrClubsDistanceList
                .add(distanceData ?? const Rows());
          }());
        }

        await Future.wait(fetchTasks); // Wait for all fetch tasks to complete
        log(homeScreennearestbarsOrClubsData.toString()); // Log the final list
      } else {
        log("Error: ${response.statusCode}");
      }

      notifyListeners(); // Notify listeners that data has been updated
    } catch (e) {
      log("Error in fetching nearest places: $e");
    }
  }

  Future<List<Result>> nearsetBarsMethodForMap() async {
    log("nearsetBarsMethodForMap");
    List<Result> nearestBars = [];

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=3000&type=night_club|bar|liquor_store&keyword=bar|club&key=$googleMapApiKey';

      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        List<Results> resultsList =
            list.map((e) => Results.fromJson(e)).toList();
        log("result list length : ${resultsList.length}");

        List<Future> fetchTasks = [];
        List<Uint8List?> imageList = List.filled(resultsList.length, null);
        List<Rows?> distanceList = List.filled(resultsList.length, null);

        for (int i = 0; i < resultsList.length; i++) {
          var bar = resultsList[i];

          if (bar.photos != null && bar.photos!.isNotEmpty) {
            fetchTasks.add(() async {
              var imageData =
                  await exploreImages(bar.photos![0].photoReference!);
              if (imageData.isNotEmpty) {
                imageList[i] = imageData[0];
              }
            }());
          }

          fetchTasks.add(() async {
            var barDetail = await barsDetailMethod(bar.placeId!);
            if (barDetail != null) {
              nearestBars.add(barDetail);
            }

            var distanceData = await getDistanceBetweenPoints(
                bar.geometry!.location!.lat.toString(),
                bar.geometry!.location!.lng.toString(),
                latitude,
                longitude);
            if (distanceData.isNotEmpty) {
              distanceList[i] = distanceData[0];
            }
          }());
        }

        await Future.wait(fetchTasks);

        nearestBarsImages = imageList.whereType<Uint8List>().toList();
        nearestBarsDistanceList = distanceList.whereType<Rows>().toList();
      } else {
        log("Error: ${response.statusCode}");
      }
      notifyListeners();
    } catch (e) {
      log("nearest bar method error: ${e.toString()}");
    }

    log("Nearest bars count: ${nearestBars.length}");
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

  Future<void> exploreBarsOrClubs(String type) async {
    log('exploreBarsOrClubs: Started');
    clearExploreScreenList();
    // Clear previous data
    _exploring = true;
    notifyListeners();

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String latitude = sp.getString('latitude') ?? '';
      String longitude = sp.getString('longitude') ?? '';

      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&keyword=bar|club&key=$googleMapApiKey';
      http.Response response = await http.get(Uri.parse(url));
      final values = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var list = values['results'] as List;
        exploreScreenbarsOrClubsData =
            list.map((i) => Results.fromJson(i)).toList();

        for (var element in exploreScreenbarsOrClubsData!) {
          log(element.toString());
        }

        log('Number of bars/clubs found: ${exploreScreenbarsOrClubsData!.length}');

        List<Result?> detailsList =
            List.filled(exploreScreenbarsOrClubsData!.length, null);

        await Future.wait(
            exploreScreenbarsOrClubsData!.asMap().entries.map((entry) async {
          int index = entry.key;
          Results bar = entry.value;

          List<Future> fetchTasks = [];
          fetchTasks.clear();

          if (bar.photos != null && bar.photos!.isNotEmpty) {
            fetchTasks.add(exploreImages(bar.photos![0].photoReference!)
                .then((imageResults) {
              if (index < exploreScreenbarsOrClubsImages.length) {
                exploreScreenbarsOrClubsImages[index] =
                    imageResults.isNotEmpty ? imageResults[0] : null;
              } else {
                exploreScreenbarsOrClubsImages.addAll(imageResults);
              }
            }));
          } else {
            if (index >= exploreScreenbarsOrClubsImages.length) {
              exploreScreenbarsOrClubsImages.add(null);
            }
          }

          fetchTasks.add(barsDetailMethod(bar.reference!).then((detail) {
            if (detail != null) {
              detailsList[index] = detail;
            }
          }));

          fetchTasks.add(getDistanceBetweenPoints(
            bar.geometry!.location!.lat.toString(),
            bar.geometry!.location!.lng.toString(),
            latitude,
            longitude,
          ).then((distanceData) {
            if (index < exploreScreenbarsOrClubsDistanceList.length) {
              exploreScreenbarsOrClubsDistanceList[index] =
                  (distanceData.isNotEmpty ? distanceData[0] : null)!;
            } else {
              exploreScreenbarsOrClubsDistanceList.addAll(distanceData);
            }
          }));

          await Future.wait(fetchTasks);
          _exploring = false;
          notifyListeners();
        }));

        // Remove null values from detailsList and assign to exploreScreenbarAndClubsDetails
        exploreScreenbarAndClubsDetails =
            detailsList.whereType<Result>().toList();

        log('All tasks completed.');
        log('details: ${exploreScreenbarAndClubsDetails.isNotEmpty ? exploreScreenbarAndClubsDetails[0].name : 'No details available'}');
        log('Total details: ${exploreScreenbarAndClubsDetails.length}');
        log('Total images: ${exploreScreenbarsOrClubsImages.length}');
      } else {
        log("Error: ${response.statusCode}");
        _exploring = false;
        notifyListeners();
      }

      // Notify the listeners after all data has been fetched
      notifyListeners();
    } catch (e) {
      _exploring = false;
      notifyListeners();
      log(e.toString());
    }
  }

  //

  void clearExploreScreenList() {
    exploreScreenbarsOrClubsDistanceList.clear();
    exploreScreenbarAndClubsDetails.clear();
    exploreScreenbarsOrClubsData?.clear();
    exploreScreenbarsOrClubsImages.clear();
    notifyListeners();
  }

  void clearHomeScreenList() {
    homeScreennearestbarsOrClubsData!.clear();
    homeScreennearestbarsOrClubsDistanceList.clear();
    homeScreennearsetbarsOrClubsImages.clear();

    homeScreenRecommendedbarsOrClubsData!.clear();
    homeScreenRecommendedbarsOrClubsDistanceList.clear();
    homeScreenRecommendedbarsOrClubsImages.clear();

    homeScreenExplorebarsOrClubsImages.clear();
    homeScreenExplorebarsOrClubsData!.clear();
    homeScreenExplorebarsOrClubsDistanceList.clear();
    notifyListeners();
  }

  List<LatLng> routeCoords = [];

  Future<List<String>> getTurnByTurnDirections(
      double endLat, double endLng) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json';
    const String apiKey = googleMapApiKey; // Replace with your API key
    String url =
        '$baseUrl?origin=$_lat,$_lon&destination=$endLat,$endLng&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> steps = jsonResponse['routes'][0]['legs'][0]['steps'];

      // Extracting the turn-by-turn instructions
      List<String> instructions =
          steps.map((step) => step['html_instructions'].toString()).toList();
      routeCoords = steps
          .map((step) => LatLng(
                step['end_location']['lat'],
                step['end_location']['lng'],
              ))
          .toList();
      log(instructions.toString());

      return instructions;
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
