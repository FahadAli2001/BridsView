import 'dart:convert';
import 'dart:developer';

import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/apis.dart';
import 'package:birds_view/widgets/custom_error_toast/custom_error_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/home_screen/home_screem.dart';

class LoginController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isHide = false;
  bool _isLoging = false;
  bool _rememberMe = false;

  bool get isHide => _isHide;
  bool get isLoging => _isLoging;
  bool get rememberMe => _rememberMe;

  set rememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  set isHide(bool value) {
    _isHide = value;
    notifyListeners();
  }

  void loginWithEmailAndPassword(context) async {
    if (!EmailValidator.validate(emailController.text)) {
      showCustomErrorToast(message: 'Invalid Email Format');
    }

    if(emailController.text == "" || passwordController.text == ""){
      showCustomErrorToast(message: "Enter Email And Password");
    }

    _isLoging = true;
    notifyListeners();

    var body = {
      "email": emailController.text,
      "password": passwordController.text
    };

    try {
      var response = await http.post(Uri.parse(loginApi), body: body);
      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        UserModel user = UserModel.fromJson(data);

        saveUserIdAndToken(user.data!.id.toString(), user.token.toString());

        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: HomeScreen(
                  user: user,
                ),
                type: PageTransitionType.fade),
                (route) => false,
                );
        clearTextField();

        _isLoging = false;
        notifyListeners();
      } else {
        showCustomErrorToast(message: 'Invalid Email or Password');

        _isLoging = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());

      _isLoging = false;
      notifyListeners();
    }
  }

  void saveUserIdAndToken(String id, String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('user_id', id);
    sp.setString('token', token);
  }

  void clearTextField() {
    emailController.clear();
    passwordController.clear();
  }
}
