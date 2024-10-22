import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:birds_view/views/views.dart';


class SplashController extends ChangeNotifier {
  Future<void> fetchUserProfile(String id, String token, context) async {
    log(fetchProfileApi + id);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var response =
          await http.get(Uri.parse(fetchProfileApi + id), headers: headers);

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);

        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: const Duration(seconds: 1),
            child: HomeScreen(user: user),
            type: PageTransitionType.fade,
          ),
          (route) => false,
        );
      } else {
        log('Failed to fetch user profile: ${response.statusCode}');
        log(response.body);
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    }
  }
}
