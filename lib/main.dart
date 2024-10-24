import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:birds_view/controller/push_notification_controller/push_notification_controller.dart';
import 'package:birds_view/firebase_options.dart';
import 'package:birds_view/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';
 
void main() async {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const MyApp());
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
     await initializeService(); 
     

    Stripe.publishableKey =
        "pk_test_51PYYmlFwqpbZ1f3dMZyxLHPjGJzGT6S1SBgbRO2pZ3DFuRewfwdHEHdfQsOGy2FrjCdavvqyMBdJljqAtVorzDVk00TM57AjlT";
    Stripe.merchantIdentifier = 'merchant.birds.view.app';
    Stripe.urlScheme = 'flutterstripe';

    await Stripe.instance.applySettings();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const MyApp());
  }
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
        ChangeNotifierProvider(create: (_) => VisitedBarsController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => PushNotificationController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BirdsView',
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
