import 'package:birds_view/utils/apis.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import '../../views/forgot_password_screen/otp_verification_screen.dart';
import '../../widgets/custom_error_toast/custom_error_toast.dart';

class VerifyEmailController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  bool _isChecking = false;

  bool get isChecking => _isChecking;

  set isChecking(bool value) {
    _isChecking = value;
    notifyListeners();
  }

  Future<void> verifyEmail(context) async {
    if (!EmailValidator.validate(emailController.text)) {
      showCustomErrorToast(message: 'Invalid Email Format');
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
      print(e);
       _isChecking = false;
        notifyListeners();
    }
  }
}
