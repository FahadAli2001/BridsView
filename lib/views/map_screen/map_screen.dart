import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';

class MapScreen extends StatefulWidget {
  final List<Uint8List> barImage;
  final List<Result> bar;
  final int index;

  const MapScreen({
    super.key,
    required this.bar,
    required this.index,
    required this.barImage,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String mapTheme = '';
  late StreamSubscription<Position> _positionStream;
  //
  List<String> turnByTurnInstructions = [];
  List<LatLng> routeCoords = [];
  int currentInstructionIndex = 0;
  String remainingTime = "0";
  List<Rows>? distanceList = [];
  //
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    // Cancel the position stream when the widget is disposed
    _positionStream.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final mapController = Provider.of<MapsController>(context, listen: false);
      await mapController.getCordinateds().then((val) async {
        mapController.loadData(
          mapController.lat!,
          mapController.lon!,
          widget.bar,
          widget.index,
          widget.barImage,
          // ignore: use_build_context_synchronously
          context,
        );
        log("${widget.bar[widget.index].geometry!.location!.lat!} bar lat");
        log("${widget.bar[widget.index].geometry!.location!.lng!} bar lng");
        mapController.clearPolylines();
        await mapController.getPolyline(widget.bar, widget.index);
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(mapController.lat!, mapController.lon!),
          zoom: 16,
        );
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
        setState(() {});
      });
    } catch (e) {
      log("map screen ${e.toString()}");
    }
  }

  Future<void> _startLiveLocationTracking(MapsController mapController) async {
    final mapController = Provider.of<MapsController>(context, listen: false);

    try {
      String theme = await DefaultAssetBundle.of(context)
          .loadString("assets/map_theme/night_map_theme.json");

      setState(() {
        mapTheme = theme;
      });

      final GoogleMapController controller = await _controller.future;
      // ignore: deprecated_member_use
      controller.setMapStyle(mapTheme);

      List<String> directions = await mapController.getTurnByTurnDirections(
        widget.bar[widget.index].geometry!.location!.lat!,
        widget.bar[widget.index].geometry!.location!.lng!,
      );

      setState(() {
        turnByTurnInstructions = directions;
      });

      Position? previousPosition;
      DateTime? lastUpdateTime;

      _positionStream =
          Geolocator.getPositionStream().listen((Position position) async {
        if (lastUpdateTime != null &&
            DateTime.now().difference(lastUpdateTime!) <
                const Duration(seconds: 5)) {
          return;
        }
        lastUpdateTime = DateTime.now();

        log("Current Location: ${position.latitude}, ${position.longitude}");

        if (previousPosition == null ||
            _isUserMovedSignificantly(previousPosition!, position)) {
          previousPosition = position;

          await controller.moveCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude),
              20.0,
            ),
          );

          mapController.clearPolylines();
          await mapController.getPolyline(widget.bar, widget.index,
              userLat: position.latitude, userLng: position.longitude);

          distanceList!.clear();

          var data = await mapController.getDistanceBetweenPoints(
              widget.bar[widget.index].geometry!.location!.lat.toString(),
              widget.bar[widget.index].geometry!.location!.lng!,
              position.latitude,
              position.longitude);
          distanceList!.addAll(data);
          setState(() {});

          if (_isUserCloseToNextStep(position.latitude, position.longitude)) {
            _showNextInstruction();
          }
        }
      });
    } catch (e) {
      log("Live location tracking error: $e");
    }
  }

  bool _isUserMovedSignificantly(Position previous, Position current) {
    const double threshold =
        10.0; // 10 meters threshold for significant movement
    double distance = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      current.latitude,
      current.longitude,
    );
    return distance > threshold;
  }

  // Future<void> _startLiveLocationTracking(MapsController mapController) async {
  //   final mapController = Provider.of<MapsController>(context, listen: false);
  //   mapController.clearPolylines();
  //   try {
  //     String theme = await DefaultAssetBundle.of(context)
  //         .loadString("assets/map_theme/night_map_theme.json");

  //     setState(() {
  //       mapTheme = theme;
  //     });

  //     final GoogleMapController controller = await _controller.future;
  //     // ignore: deprecated_member_use
  //     controller.setMapStyle(mapTheme);

  //     List<String> directions = await mapController.getTurnByTurnDirections(
  //       widget.bar[widget.index].geometry!.location!.lat!,
  //       widget.bar[widget.index].geometry!.location!.lng!,
  //     );

  //     setState(() {
  //       turnByTurnInstructions = directions;
  //     });

  //     _positionStream =
  //         Geolocator.getPositionStream().listen((Position position) async {
  //       log("Current Location: ${position.latitude}, ${position.longitude}");

  //       controller.animateCamera(
  //         CameraUpdate.newLatLngZoom(
  //           LatLng(position.latitude, position.longitude),
  //           20.0,
  //         ),
  //       );

  //       await mapController.getPolyline(widget.bar, widget.index,
  //           userLat: position.latitude, userLng: position.longitude);
  //       distanceList!.clear();

  //       var data = await mapController.getDistanceBetweenPoints(
  //           widget.bar[widget.index].geometry!.location!.lat.toString(),
  //           widget.bar[widget.index].geometry!.location!.lng!,
  //           position.latitude,
  //           position.longitude);
  //       distanceList!.addAll(data);
  //       setState(() {});

  //       if (_isUserCloseToNextStep(position.latitude, position.longitude)) {
  //         _showNextInstruction();
  //       }
  //     });
  //   } catch (e) {
  //     log("Live location tracking error: $e");
  //   }
  // }

  bool _isUserCloseToNextStep(double userLat, double userLng) {
    if (currentInstructionIndex >= routeCoords.length) return false;

    LatLng nextStep = routeCoords[currentInstructionIndex];
    double distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      nextStep.latitude,
      nextStep.longitude,
    );

    return distance < 50.0;
  }

  void _showNextInstruction() {
    if (currentInstructionIndex < turnByTurnInstructions.length - 1) {
      setState(() {
        currentInstructionIndex++;
      });
    }
  }

  String removeHtmlTags(String input) {
    final RegExp exp = RegExp(r'<[^>]*>');
    return input.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Consumer<MapsController>(
        builder: (context, value, child) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: GoogleMap(
                    initialCameraPosition: kGooglePlex,
                    padding:
                        EdgeInsets.only(bottom: 50, top: size.height * 0.04),
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: true,
                    buildingsEnabled: true,
                    onTap: (argument) {
                      value.customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      value.customInfoWindowController.onCameraMove!();
                    },
                    markers: Set<Marker>.of(value.markers),
                    polylines: Set<Polyline>.of(value.polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      // ignore: deprecated_member_use
                      controller.setMapStyle(mapTheme);
                      _controller.complete(controller);
                      value.customInfoWindowController.googleMapController =
                          controller;
                    },
                  ),
                ),
                turnByTurnInstructions.isNotEmpty
                    ? Positioned(
                        left: 20,
                        right: 20,
                        top: 120,
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            removeHtmlTags(
                                "${turnByTurnInstructions[currentInstructionIndex]} , Time Left: ${distanceList!.isEmpty ? '' : distanceList![0].elements![0].duration!.text} "),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox(),

                value.onMapNearestBar.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const SizedBox(),
                CustomInfoWindow(
                  controller: value.customInfoWindowController,
                  width: 300,
                  height: 120,
                  offset: 50,
                ),
                // value.isGettingDirection == true
                //     ? Positioned(
                //         bottom: 15,
                //         left: size.width * 0.45,
                //         right: size.width * 0.45,
                //         child: CircularProgressIndicator(
                //           color: primaryColor,
                //         ),
                //       )
                //     :
                turnByTurnInstructions.isEmpty
                    ? Positioned(
                        left: size.width * 0.3,
                        right: size.width * 0.3,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: GestureDetector(
                            onTap: () {
                              // Start tracking live location when the direction button is tapped
                              _startLiveLocationTracking(value);
                            },
                            child: Image.asset(directionBtn),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                  top: size.height * 0.06,
                  left: size.width * 0.03,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      value.isGettingDirection = false;

                      await _positionStream.cancel();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
