import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
