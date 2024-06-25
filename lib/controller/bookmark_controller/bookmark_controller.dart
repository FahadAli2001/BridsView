import 'dart:convert';
import 'dart:developer';
import 'package:birds_view/utils/apis.dart';
import 'package:birds_view/widgets/custom_success_toast/custom_success_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookmarkController extends ChangeNotifier {
  String? _userId;
  String? _token;
  String? get userId => _userId;
  String? get token => _token;


  Future<void> getUserCredential()async{
     SharedPreferences sp = await SharedPreferences.getInstance();
      _userId = sp.getString("user_id")!;
      _token = sp.getString("token")!;
      log("user id : $userId");
      log("user token : $token");
      notifyListeners();
  }

  Future<void> addBookmark(String placeId) async {
    try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_place_id": placeId};
      var response = await http.post(Uri.parse(addBookmarkApi),
          headers: header, body: body);
      if (response.statusCode == 200) {
        showCustomSuccessToast(message: "Bookmark Added");
      } else {
        log("error ${response.body}");
      }
    } catch (e) {
      log("add Bookmak call error : ${e.toString()}");
    }
    notifyListeners();
  }

 Stream getBookMarkStream(String placeId) async* {
  
    var headers = {
      'Authorization': 'Bearer $token',
    };
    while (true) {
      // ignore: prefer_typing_uninitialized_variables
      var bookmark;
      try {
        var response = await http.get(
            Uri.parse('$checkBookmarkApi$userId&bar_place_id=$placeId'),
            headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          bookmark = data;
          
        } else {
          bookmark = data;
           
        }
      } catch (e) {
        log(e.toString());
      }
      yield bookmark;
    }
  }

  Future<void> deleteBookmark(String placeId)async{
     try {
      var header = {"Authorization": "Bearer $token"};
      var body = {"user_id": userId, "bar_place_id": placeId};
      var response = await http.post(Uri.parse(deleteBookmarkApi),
          headers: header, body: body);
      if (response.statusCode == 200) {
         showCustomSuccessToast(message: "Bookmark Removed");
      } else {
        log("error ${response.body}");
      }
    } catch (e) {
      log("delete Bookmak call error : ${e.toString()}");
    }
    notifyListeners();
  }
}
