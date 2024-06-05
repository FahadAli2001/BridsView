import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomVisitedPlace extends StatelessWidget {
  CustomVisitedPlace({super.key});

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          width: size.width,
          height: size.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade900),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.35,
                height: size.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage("assets/recomended_bar.png"),
                        fit: BoxFit.fill)),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: Text(
                        'Cubix Bar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.02),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: primaryColor,
                          size: size.height * 0.02,
                        ),
                        const Text(
                          "4.5 ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "(10 Review's)",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: size.width * 0.3),
                      child: const AutoSizeText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit ...',
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: size.height * 0.025,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.015,
                      ),
                      Icon(
                        Icons.favorite,
                        color: primaryColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
