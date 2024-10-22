import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


class CustomImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback cameraontap;
  final VoidCallback galleryontap;
  const CustomImagePickerBottomSheet(
      {super.key, required this.cameraontap, required this.galleryontap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Material(
        type: MaterialType.transparency,
        child: Container(
          height: size.height * 0.25,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeadingText(heading: 'Choose Image Source'),
                // RichText(
                //   text: TextSpan(
                //     text: "Choose ",
                //     style: GoogleFonts.urbanist(
                //         fontSize: size.height * 0.03, color: Colors.white),
                //     children: [
                //       TextSpan(
                //         text: 'Image ',
                //         style: GoogleFonts.urbanist(
                //             fontSize: size.height * 0.03,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       WidgetSpan(
                //         alignment: PlaceholderAlignment.baseline,
                //         baseline: TextBaseline.alphabetic,
                //         child: ShaderMask(
                //           shaderCallback: (bounds) => const LinearGradient(
                //             colors: [
                //               Color(0xFFC59241),
                //               Color(0xFFFEF6D1),
                //               Color(0xFFC49138),
                //             ],
                //             begin: Alignment.centerLeft,
                //             end: Alignment.centerRight,
                //             stops: [0.0, 0.5, 1.0],
                //           ).createShader(
                //               Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                //           child: Text(
                //             'Source ',
                //             style: GoogleFonts.urbanist(
                //                 fontSize: size.height * 0.03,
                //                 fontWeight: FontWeight.bold,
                //                 color: whiteColor),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: CustomButton(
                          text: 'From Gallery', ontap: galleryontap),
                    ),
                    Flexible(
                      flex: 1,
                      child:
                          CustomButton(text: 'From Camera', ontap: cameraontap),
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
}
