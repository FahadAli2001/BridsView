import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:birds_view/views/views.dart';


class EditProfileController extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? _pickedFile;
  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;
  File? get pickedFile => _pickedFile;

  void checkRequirments(UserModel user, context) {
    if (passwordController.text == '') {
      showCustomErrorToast(message: 'Password is required');
    } else {
      updateUser(user, context);
    }
  }

  void pickedProfileImage(ImageSource source, context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        _pickedFile = File(pickedFile.path);
        Navigator.pop(context);
      }
      log(pickedFile!.path.toString());

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void callExistingValue(UserModel? user) {
    if (user != null) {
      firstNameController.text = user.data!.firstName!;
      lastNameController.text = user.data!.lastName!;
      emailController.text = user.data!.email!;
    } else {
      firstNameController.text = '';
      lastNameController.text = '';
      emailController.text = '';
    }
  }

  Future<void> updateUser(UserModel? user, context) async {
    // ignore: prefer_typing_uninitialized_variables
    var data;

    try {
      _isUpdating = true;
      notifyListeners();

      var userToken = user?.token;
      if (userToken == null) {
        log('User token is null');
      } else {
        log('User token: $userToken');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(editProfileApi),
      );

      request.headers['Authorization'] = 'Bearer ${userToken ?? ''}';

      if (pickedFile != null) {
        var image =
            await http.MultipartFile.fromPath('image', pickedFile!.path);
        request.files.add(image);
      } else if (user!.data!.image != '' && user.data!.image!.isNotEmpty) {
        request.fields['image'] = user.data!.image!;
      }

      request.fields['first_name'] = firstNameController.text;
      request.fields['last_name'] = lastNameController.text;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      data = json.decode(response.body);

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        _isUpdating = false;
        log(response.statusCode.toString());

        log('Response JSON: $data');

        UserModel updatedUser = UserModel.fromJson(data);

        notifyListeners();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: updatedUser,
            ),
          ),
          (route) => false,
        );

        showCustomSuccessToast(message: 'User Updated Successfully');
      } else {
        log(response.statusCode.toString());
        log('${data}else');
        _isUpdating = false;
        notifyListeners();
      }
    } catch (e) {
      _isUpdating = false;

      notifyListeners();
      log('catch error : $e');
      log(data.toString());
      showCustomErrorToast(message: 'Something Went Wrong');
    }
  }
}
