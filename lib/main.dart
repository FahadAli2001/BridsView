import 'package:birds_view/controller/edit_profile_controller/edit_profile_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/reset_password_controller/reset_password.dart';
import 'package:birds_view/controller/signup_controller/signup_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller/login_controller.dart';
import 'controller/splash_controller/splash_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_)=> ResetPasswordController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_)=> EditProfileController()),
        ChangeNotifierProvider(create: (_)=> MapsController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Birds  View',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme:
              const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
