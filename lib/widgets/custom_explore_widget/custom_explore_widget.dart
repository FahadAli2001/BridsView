import 'package:birds_view/views/detail_screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/icons.dart';

class CustomExploreWidget extends StatelessWidget {
  const CustomExploreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: const DetailScreen(), type: PageTransitionType.fade));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
            width: size.width,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                  image: const AssetImage("assets/recomended_bar.png"),
                  fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: size.height * 0.07,
                    width: size.height * 0.07,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            exploreIcon,
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Positioned(
                    bottom: size.height * 0.1,
                    left: size.height * 0.03,
                    child: Text(
                      "Cubix Bar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.035),
                    )),
                //
                Positioned(
                    bottom: size.height * 0.03,
                    left: size.height * 0.03,
                    child: SizedBox(
                      width: size.width * 0.8,
                      // height: size.height * 0.03,
                      child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.02),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
