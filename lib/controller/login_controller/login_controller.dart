import 'dart:convert';
import 'dart:developer';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/utils/apis.dart';
import 'package:birds_view/views/onboarding_screen/onboarding_one_screen.dart';
import 'package:birds_view/widgets/custom_error_toast/custom_error_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../views/home_screen/home_screem.dart';

class LoginController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

    if (emailController.text == "" || passwordController.text == "") {
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

  Future<void> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? userDetail = authResult.user;

        if (userDetail != null) {
          String? userEmail = userDetail.email;
          String? userName = userDetail.displayName;

          String? userProfileImage = userDetail.photoURL;
          registerUser(userDetail.displayName!, '', userDetail.email!, 'google',
              '', context, userDetail.photoURL!.toString(), '');
          log('User Email: $userEmail');
          log('User Name: $userName');
          log('User Profile Image: $userProfileImage');
        }
      }
    } catch (error) {
      log('Error signing in with Google: $error');
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final OAuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? userDetail = authResult.user;

      if (userDetail != null) {
        String? userEmail = userDetail.email;
        String? userName = userDetail.displayName ??
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}';
        String? userProfileImage = userDetail.photoURL;

        log(userDetail.displayName.toString());

        registerUser(
            userName,
            '',
            userEmail ?? '',
            'apple',
            '',
            // ignore: use_build_context_synchronously
            context,
            userProfileImage ?? '',
            '');

        log('User Email: $userEmail');
        log('User Name: $userName');
        log('User Profile Image: $userProfileImage');
      }
    } catch (error) {
      log('Error signing in with Apple: $error');
    }
  }

  Future<void> registerUser(
      String firstName,
      String lastName,
      String email,
      String platform,
      String? dob,
      context,
      String image,
      String? gender) async {
    try {
      var body = {
        'first_name': firstName.toString(),
        'last_name': lastName.toString(),
        'email': email.toString(),
        'password': '',
        'date_of_birth': dob ?? '',
        'gender': gender ?? ' ',
        'image': image.toString(),
        'platfrom': platform.toString(),
        'track_my_visits': '1'
      };
      var response = await http
          .post(Uri.parse("https://zemfar.com/owl-api/api/social"), body: body);
      log(response.statusCode.toString());
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        log(data.toString());
        log('user register successfully');

        UserModel user = UserModel.fromJson(data);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )),
            (route) => false);
      } else if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )),
            (route) => false);
      } else {
        log('response status code${response.statusCode}');
        var data = jsonDecode(response.body);
        log(data.toString());
      }
    } catch (e) {
      log('social register $e');
    }
  }

  Future<void> signOutFromSocialPlatforms(context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await _googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        PageTransition(
            child: const OnboardingOneScreen(), type: PageTransitionType.fade),
        (route) => false);
    sp.clear();
  }
}
