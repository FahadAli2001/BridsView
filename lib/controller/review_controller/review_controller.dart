import 'dart:convert';
import 'dart:developer';
import 'package:birds_view/utils/apis.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewController extends ChangeNotifier{
  TextEditingController reviewController = TextEditingController();
  String? _userId;
  String? _token;
  String? _rating;
  String? get userId => _userId;
   String? get token => _token;
   String? get rating => _rating;

   set rating(val){
    _rating = val;
    notifyListeners();
   }

  Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    _token = sp.getString("token")!;
    log("user id : $userId");
    log("user token : $token");
    notifyListeners();
  }


    Future<String> postReview() async {
     await getUserCredential();
      log(token.toString());
    SharedPreferences sp = await SharedPreferences.getInstance();
    String lastVisitedBar= sp.getString("lastVisitedBar")!;
    final url = Uri.parse(postReviewApi);
    log(lastVisitedBar);
 
    final Map<String, dynamic> requestData = {
      'user_id': userId,
      'bar_type_id': lastVisitedBar.toString(),
      'comment': reviewController.text,
      "rating":rating
    };

    try {
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',  // Add this if your server expects JSON
    },
    body: jsonEncode(requestData),
  );

  // Log the raw response body
  log(response.body);

  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
     
                                      sp.remove("lastVisitedBar");
    log(responseBody.toString());
    return 'POST Request was successful: ${responseBody.toString()}';
  } else {
    return 'Failed to send POST request: ${response.statusCode}';
  }
} catch (e) {
  log(e.toString());
  return 'Error sending POST request: $e';
}
  }
}