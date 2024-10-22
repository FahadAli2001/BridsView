import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:birds_view/views/views.dart';


class ResetPasswordController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isChecking = false;
  bool _isChangingPassword = false;
  String _otp = '';
  bool _isCountDownDone = false;

  bool get isCountDownDone => _isCountDownDone;
  bool get isChecking => _isChecking;
  bool get isChangingPassword => _isChangingPassword;
  String get otp => _otp;

  set isChecking(bool value) {
    _isChecking = value;
    notifyListeners();
  }

  set isCountDownDone(bool value) {
    _isCountDownDone = value;
    notifyListeners();
  }

  set otp(String value) {
    _otp = value;
    notifyListeners();
  }

  Future<void> verifyEmail(context) async {
    if (!EmailValidator.validate(emailController.text)) {
      showCustomErrorToast(message: 'Invalid Email Format');
      _isChecking = false;
      notifyListeners();
    }
    _isChecking = true;
    notifyListeners();
    try {
      var response = await http.post(Uri.parse(checkEmailApi),
          body: {"email": emailController.text});
      if (response.statusCode == 200) {
        emailController.clear();
        Navigator.push(
            context,
            PageTransition(
                child: const OtpVerificationScreen(),
                type: PageTransitionType.fade));
        _isChecking = false;
        notifyListeners();
      } else {
        emailController.clear();
        showCustomErrorToast(message: 'Email Not Found');
        _isChecking = false;
        notifyListeners();
      }
    } catch (e) {
      emailController.clear();
      log(e.toString());
      _isChecking = false;
      notifyListeners();
    }
  }

  void checkChangePasswordConditions(context) {
    if (newPasswordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty) {
      showCustomErrorToast(message: "Enter Password & Comfirm Password");
    } else if (newPasswordController.text != confirmPasswordController.text) {
      showCustomErrorToast(message: "Password Doesn't Match");
    } else {
      changePassword(context);
    }
  }

  Future<void> changePassword(context) async {
    var body = {
      "email": emailController.text,
      "otp": otp,
      "password": newPasswordController.text
    };
    _isChangingPassword = true;
    notifyListeners();
    try {
      var response = await http.post(Uri.parse(resetPasswordApi), body: body);
      if (response.statusCode == 200) {
        showCustomSuccessToast(message: "Password Changed Successfully");
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const LogInScreen(), type: PageTransitionType.fade),
            (route) => false);
        _isChangingPassword = false;
        notifyListeners();
      } else {
        showCustomErrorToast(message: 'Invalid OTP');
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const VerifyEmailScreen(),
                type: PageTransitionType.fade),
            (route) => false);
        _isChangingPassword = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      _isChangingPassword = false;
      notifyListeners();
    }
  }

  void checkOtpConditions(context) {
    if (isCountDownDone == true) {
      showCustomErrorToast(message: 'OTP Expired');
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const VerifyEmailScreen(), type: PageTransitionType.fade),
          (route) => false);
    } else if (otp == '') {
      showCustomErrorToast(message: 'Please Enter OTP');
    } else {
      Navigator.push(
          context,
          PageTransition(
              child: const ChangePaasswordScreen(),
              type: PageTransitionType.fade));
    }
  }
}
