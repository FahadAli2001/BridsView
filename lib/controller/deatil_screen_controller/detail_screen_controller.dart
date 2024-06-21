import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreenController extends ChangeNotifier {
  Random random = Random();
  int? _randomPopulation;

  int? get randomPopulation => _randomPopulation;

  Future<void> socialLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> getRandomNumbers() async {
    // ignore: await_only_futures
    _randomPopulation = await random.nextInt(201) + 100;

    notifyListeners();
  }

  Future<void> saveBarId(String barPlaceId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(barPlaceId, randomPopulation.toString());
  }

  Future<void> checkBarPlaceIdExist(String? barPlaceId) async {
    if (barPlaceId == null) return;

    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      String? barPop = sp.getString(barPlaceId);
      if (barPop == null || barPop.isEmpty) {
        await getRandomNumbers();
        await saveBarId(barPlaceId);
      } else {
        int barPopulation = int.parse(barPop);
        if (barPopulation % 2 == 0) {
          _randomPopulation = barPopulation + random.nextInt(10);
        } else {
          _randomPopulation = barPopulation - random.nextInt(10);
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
