import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:birds_view/views/views.dart';


class DetailScreenController extends ChangeNotifier {
  math.Random random = math.Random();
  int? _randomPopulation;
  int? _female;
  int? _totalPerson;

  int? get randomPopulation => _randomPopulation;
  int? get totalPerson => _totalPerson;
  int? get female => _female;

  Future<void> socialLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> getRandomNumbers() async {
    // ignore: await_only_futures
    _randomPopulation = await random.nextInt(201) + 100;
    _female = random.nextInt(201) + 100;
    _totalPerson = _randomPopulation! + _female!;
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
      if (barPop == null ||
          barPop.isEmpty && barFemale == null ||
          barFemale!.isEmpty) {
        await getRandomNumbers();
        await saveBarId(barPlaceId);
      } else {
        int barPopulation = int.parse(barPop);
        if (barPopulation % 2 == 0) {
          _randomPopulation = barPopulation + random.nextInt(10);
          _female = barPopulation + random.nextInt(10);
          _totalPerson = _randomPopulation! + _female!;
          notifyListeners();
        } else {
          _randomPopulation = barPopulation - random.nextInt(10);
          _female = barPopulation - random.nextInt(10);
          _totalPerson = _randomPopulation! + _female!;
          log("${totalPerson}total person");
          notifyListeners();
        }
        await saveBarId(barPlaceId);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
