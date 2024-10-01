import 'dart:async';
import 'dart:developer';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/utils/images.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/bar_details_model/bar_details_model.dart';

class MapScreen extends StatefulWidget {
  final List<Uint8List> barImage;
  final List<Result> bar;
  final int index;
  const MapScreen(
      {super.key,
      required this.bar,
      required this.index,
      required this.barImage});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String mapTheme = '';

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString("assets/map_theme/night_map_theme.json")
        .then((value) {
      mapTheme = value;
      setState(() {});
      try {
        final mapController =
            Provider.of<MapsController>(context, listen: false);
        mapController.getCordinateds().then((value) async {
          mapController.loadData(mapController.lat!, mapController.lon!,
              widget.bar, widget.index, widget.barImage, context);
          mapController.clearPolylines();
          CameraPosition cameraPosition = CameraPosition(
            target: LatLng(mapController.lat!, mapController.lon!),
            zoom: 16,
          );
          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

          setState(() {});
        });
      } catch (e) {
        log("map screen ${e.toString()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(body: Consumer<MapsController>(
        builder: (context, value, child) {
          return Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: GoogleMap(
                  initialCameraPosition: kGooglePlex,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  trafficEnabled: true,
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
                    // controller.setMapStyle(mapTheme);
                    _controller.complete(controller);
                    value.customInfoWindowController.googleMapController =
                        controller;
                  },
                ),
              ),
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
              value.isGettingDirection == true
                  ? Positioned(
                      bottom: 15,
                      left: size.width * 0.45,
                      right: size.width * 0.45,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Positioned(
                      left: size.width * 0.3,
                      right: size.width * 0.3,
                      bottom: 0,
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: GestureDetector(
                              onTap: () {
                                value.isGettingDirection = false;
                                value.clearPolylines();
                                value.getPolyline(widget.bar, widget.index);
                              },
                              child: Image.asset(directionBtn))),
                    ),
              Positioned(
                  top: size.height * 0.015,
                  left: size.width * 0.03,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        value.isGettingDirection = false;
                      },
                      child: const CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Center(
                              child: Icon(CupertinoIcons.back,
                                  color: Colors.white))))),
            ],
          );
        },
      )),
    );
  }
}
