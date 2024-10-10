import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomBarCrowdImageWidget extends StatelessWidget {
  final Size size;

  const CustomBarCrowdImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailScreenController>(
      builder: (context, value, child) {
        return SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.13,
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    maleCrowd,
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    value.randomPopulation.toString(),
                    style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.026,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Column(
                children: [
                  Image.asset(
                    femaleCrowd,
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    value.female.toString(),
                    style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.026,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              //
              Container(
                height: size.height * 0.15,
                width: 5,
                color: Colors.grey.withOpacity(0.5),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Column(
                children: [
                  Image.asset(
                    "assets/mix.png",
                    height: size.height * 0.08,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    value.totalPerson.toString(),
                    style: GoogleFonts.urbanist(
                        fontSize: size.height * 0.026,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// class CustomBarCrowdImageWidget extends StatelessWidget {
//   final Size size;
//   const CustomBarCrowdImageWidget({super.key, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(

//         top: size.height * 0.07,
//         child: Consumer<DetailScreenController>(
//           builder: (context, value, child) {
//             return Container(
//               width: size.width  ,
//               height: size.height*0.13,
//                color: whiteColor,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Column(
//                       children: [
//                         Image.asset(
//                           maleCrowd,
//                           height: size.height * 0.08,
//                         ),
//                         CustomBarRandomPopulationWidget(
//                             size: size, text: value.randomPopulation.toString())
//                       ],
//                     ),
//                     // SizedBox(
//                     //   width: size.width * 0.06,
//                     // ),
//                     Column(
//                       children: [
//                         Image.asset(
//                           femaleCrowd,
//                           height: size.height * 0.08,
//                         ),
//                         CustomBarRandomPopulationWidget(
//                             size: size, text: value.female.toString())
//                       ],
//                     ),

//                     GradientText(
//                         text: value.totalPerson.toString(),
//                         fontSize: size.height * 0.02,
//                         fontWeight: FontWeight.bold)
//                   ],
//                 ),
//               ),
//             );
//           },
//         ));
//   }
// }
