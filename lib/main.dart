import 'package:birds_view/controller/edit_profile_controller/edit_profile_controller.dart';
import 'package:birds_view/controller/maps_controller/maps_controller.dart';
import 'package:birds_view/controller/reset_password_controller/reset_password.dart';
import 'package:birds_view/controller/signup_controller/signup_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controller/bookmark_controller/bookmark_controller.dart';
import 'controller/deatil_screen_controller/detail_screen_controller.dart';
import 'controller/login_controller/login_controller.dart';
import 'controller/review_controller/review_controller.dart';
import 'controller/search_bars_controller/search_bars_controller.dart';
import 'controller/splash_controller/splash_controller.dart';
import 'controller/visited_bars_controller/visited_bars_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => ResetPasswordController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_) => EditProfileController()),
        ChangeNotifierProvider(create: (_) => MapsController()),
        ChangeNotifierProvider(create: (_) => SearchBarsController()),
        ChangeNotifierProvider(create: (_) => DetailScreenController()),
        ChangeNotifierProvider(create: (_) => BookmarkController()),
        ChangeNotifierProvider(create: (_) => ReviewController()),
        ChangeNotifierProvider(create: (_) => VisitedBarsController())
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
