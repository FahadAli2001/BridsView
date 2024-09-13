import 'package:birds_view/controller/deatil_screen_controller/detail_screen_controller.dart';
import 'package:birds_view/utils/images.dart';
import 'package:birds_view/widgets/custom_detail_screen_widgets/custom_bar_random_population_widget/custom_bar_random_population_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CustomBarCrowdImageWidget extends StatelessWidget {
  final Size size;
  const CustomBarCrowdImageWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.07,
      child: Consumer<DetailScreenController>(builder:(context, value, child) {
        return Row(
        children: [
          Column(
            children: [
              Image.asset(maleCrowd,height: size.height * 0.08,),
              CustomBarRandomPopulationWidget(size: size, text: value.randomPopulation.toString())
            ],
          ),
          SizedBox(
            width: size.width *0.06,
          ),
           Column(
            children: [
              Image.asset(femaleCrowd,height: size.height * 0.08,),
              CustomBarRandomPopulationWidget(size: size, text: value.female.toString())
            ],
          ),
        ],
      );
      },)
    );
  }
}
