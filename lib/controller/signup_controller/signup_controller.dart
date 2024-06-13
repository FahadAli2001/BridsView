import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:birds_view/utils/apis.dart';
import 'package:birds_view/views/login_screen/login_screen.dart';
import 'package:birds_view/widgets/custom_error_toast/custom_error_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_success_toast/custom_success_toast.dart';

class SignUpController extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final List<String> _gendersList = ['Male', 'Female', 'Other'];
  String? _pickedGender;
  DateTime? _selectedDate;
  bool _isHidePassword = true;
  bool _acceptPrivacyPolicy = false;
  File? _pickedFile;
  bool _isCreatingAccount = false;

  List<String> get gendersList => _gendersList;
  String? get pickedGender => _pickedGender;
  DateTime? get selectedDate => _selectedDate;
  bool get isHidePassword => _isHidePassword;
  bool get acceptPrivacyPolicy => _acceptPrivacyPolicy;
  File? get pickedFile => _pickedFile;
  bool get isCreatingAccount => _isCreatingAccount;

  set isHidePassword(bool value) {
    _isHidePassword = value;
    notifyListeners();
  }

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  set pickedGender(String? value) {
    _pickedGender = value;
    notifyListeners();
  }

  set acceptPrivacyPolicy(bool value) {
    _acceptPrivacyPolicy = value;
    notifyListeners();
  }

  void pickedProfileImage(ImageSource source, context) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _pickedFile = File(pickedFile.path);
      Navigator.pop(context);
    }
    notifyListeners();
  }

  void checkSignUpConditions(context) {
    if (firstNameController.text != '' &&
        lastNameController.text != '' &&
        emailController.text != '' &&
        passwordController.text != '' &&
        selectedDate != null &&
        pickedFile != null &&
        pickedGender != null) {
      checkPrivacyPlicy(context);
    } else {
      showCustomErrorToast(message: "Provide All Information");
    }
  }

  void checkPrivacyPlicy(context) {
    if (acceptPrivacyPolicy == true) {
      createAccount(context);
    } else {
      showCustomErrorToast(message: 'Accept Privacy Policy');
    }
  }

  Future<void> createAccount(context) async {
    try {
      if (!EmailValidator.validate(emailController.text)) {
        showCustomErrorToast(message: 'Invalid email format.');
      }
      String formattedDate =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

      _isCreatingAccount = true;
      notifyListeners();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(registerApi),
      );

      var image = await http.MultipartFile.fromPath('image', pickedFile!.path);
      request.files.add(image);

      request.fields['first_name'] = firstNameController.text;
      request.fields['last_name'] = lastNameController.text;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['date_of_birth'] = formattedDate;
      request.fields['gender'] = pickedGender!;
      request.fields['platform'] = 'app';
      request.fields['track_my_visit'] = '1';
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        _isCreatingAccount = false;
        clearAllFields();
        _selectedDate;
        String responseBody = response.body;
        String jsonDataString =
            responseBody.substring(responseBody.indexOf('{'));
        var jsonData = json.decode(jsonDataString);
        showCustomSuccessToast(message: 'User Created Successfully');

        log(jsonData.toString());
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const LogInScreen(), type: PageTransitionType.fade),
            (route) => false);
        notifyListeners();
      } else {
        String responseBody = response.body;
        String jsonDataString =
            responseBody.substring(responseBody.indexOf('{'));
        var jsonData = json.decode(jsonDataString);
        // log(jsonData['data']['email'][0]);
        if (jsonData['data']['email'][0] ==
            'The email has already been taken.') {
          showCustomErrorToast(message: 'The email has already been taken.');
          notifyListeners();
        } else {
          showCustomErrorToast(message: 'Some Thing Went Wrong');
          notifyListeners();
        }
        _isCreatingAccount = false;
        notifyListeners();
      }
    } catch (e) {
      _isCreatingAccount = false;
      notifyListeners();
      log('catch error : $e');
      showCustomErrorToast(message: 'Some Thing Went Wrong');
    }
  }

  void clearAllFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    _acceptPrivacyPolicy = false;
    _selectedDate = null;
    _pickedFile = null;
    notifyListeners();
  }
}