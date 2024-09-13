import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreenController extends ChangeNotifier {
  Random random = Random();
  int? _randomPopulation;
  int? _female;

  int? get randomPopulation => _randomPopulation;
  int? get female => _female;

  Future<void> socialLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> getRandomNumbers() async {
    // ignore: await_only_futures
    _randomPopulation = await random.nextInt(201) + 100;
    _female =   random.nextInt(201) + 100;

    notifyListeners();
  }

  Future<void> saveBarId(String barPlaceId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(barPlaceId, randomPopulation.toString());
    sp.setString("${barPlaceId}female", female.toString());
  }

  Future<void> checkBarPlaceIdExist(String? barPlaceId) async {
    if (barPlaceId == null) return;

    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      String? barPop = sp.getString(barPlaceId);
      String? barFemale = sp.getString("${barPlaceId}female");
      if (barPop == null || barPop.isEmpty && barFemale == null || barFemale!.isEmpty) {
        await getRandomNumbers();
        await saveBarId(barPlaceId);
        
      } else {
        int barPopulation = int.parse(barPop);
        if (barPopulation % 2 == 0) {
          _randomPopulation = barPopulation + random.nextInt(10);
          _female = barPopulation + random.nextInt(12);
        } else {
          _randomPopulation = barPopulation - random.nextInt(10);
          _female = barPopulation - random.nextInt(10);
        }
        await saveBarId(barPlaceId);

        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
