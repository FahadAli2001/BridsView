import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_view/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBookmarkWidget extends StatelessWidget {
  const CustomBookmarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onLongPress: () {
          // showCupertinoModalBottomSheet(
          //     context: context,
          //     builder: (context) => CustomBookmarkBottomSheet(
                    
          //         ));
        },
        child: Container(
          width: size.width,
          height: size.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade900),
          child: Row(
            children: [
              Container(
                width: size.width * 0.35,
                height: size.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image:const DecorationImage(
                        image: AssetImage(
                          'assets/recomended_bar.png',
                        ),
                        fit: BoxFit.fill)),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        "Cubix Bar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.025),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: size.width * 0.5),
                      child:const AutoSizeText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit ...',
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                        style:  TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Row(
                      children: [
                      SvgPicture.asset(personsIcon),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                       SvgPicture.asset(musicIcon),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        SvgPicture.asset(glassIcon)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}