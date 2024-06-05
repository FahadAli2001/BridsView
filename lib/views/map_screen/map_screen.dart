import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button/custom_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset('assets/map.png')),

        //    CustomInfoWindow(
        //   controller:value. customInfoWindowController,
        //   width: 300,
        //   height: 150,
        //   offset: 50,
        // ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: CustomButton(text: 'Direction', ontap: () {}),
          ),
        ),
        Positioned(
            top: size.height * 0.05,
            left: size.width * 0.05,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:const CircleAvatar(
                  backgroundColor: Colors.black,
                  child:   Center(child: Icon(CupertinoIcons.back, color: Colors.white))))),
      ],
    ));
  }
}
