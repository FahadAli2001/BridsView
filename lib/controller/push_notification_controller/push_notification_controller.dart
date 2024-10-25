import 'dart:async';
import 'dart:developer';

import 'package:birds_view/model/user_model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math' as math;

class PushNotificationController extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  // Messages for all users
  final List<String> allUserMessages = [
    "Ready to vibe? Check the latest hotspots near you",
    "Your favorite club is getting busy. Head over now",
    "Looking for a lively spot? See where the crowd's at",
    "Skip the guessing. Know the vibe before you arrive",
    "Want to avoid a dead night out? BirdsView’s got you covered",
    "Girls night? See where the scene is poppin’ right now",
    "Up for a chill night? Find the perfect spot with BirdsView",
    "Planning your night out? See the real-time crowd count now",
    "New in town? Find the best spots without the hassle",
    "Check the vibe before you arrive. Make tonight count",
    "Don’t waste a night. Find the action with BirdsView",
    "Bar hopping is overrated. See where to go next",
    "Your go-to spot is heating up. Get there now",
    "Ready to make moves? Find the perfect place tonight",
    "Find your vibe, avoid the duds. BirdsView has you covered"
  ];

  final List<String> nonAccountMessages = [
    "Ready to see the nightlife scene? Create an account and unlock full access",
    "Don’t miss out. Sign up now and find the best spots around you",
    'Ready to see the nightlife scene? Create an account and unlock full access',
    "Don’t miss out. Sign up now and find the best spots around you",
    "Get the full experience. Create an account and see real-time club vibes",
    "Want to know where the crowd's at? Make an account to see it all",
    "Sign up today and find your perfect night out spot in seconds",
    "Unlock the full BirdsView experience by creating an account now"
  ];

  Future<void> initialize(UserModel? user) async {
    await _fcm.requestPermission();
    String? token = await _fcm.getToken();
    log("FCM Token: $token");

    // Initialize local notifications
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _localNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(
          message.notification!.title, message.notification!.body);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Start periodic notifications using the background service
    _scheduleRandomNotifications(user);
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("randomChannelId", "high",
            channelDescription:
                "Background service for BirdsView notifications",
            importance: Importance.low, // Use low importance
            priority: Priority.low, // Use low priority
            ongoing: true, // Keeps the notification ongoing
            visibility: NotificationVisibility.secret, // Hide the notification
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  void _scheduleRandomNotifications(UserModel? user) async {
    FlutterBackgroundService().on('sendRandomNotification').listen((event) {
      _sendRandomNotification(user);
    });
  }

  void _sendRandomNotification(UserModel? user) {
    final random = math.Random();
    String message;

    if (user != null && user.data != null && user.data!.id != null) {
      message = allUserMessages[random.nextInt(allUserMessages.length)];
    } else {
      message = nonAccountMessages[random.nextInt(nonAccountMessages.length)];
    }

    _showNotification("BirdsView", message);
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: (message) => onIosBackground(message),
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await _localNotificationsPlugin.initialize(initializationSettings);

  service.on('setAsForeground').listen((event) {
    // service.setAsForegroundService();
  });

  service.on('setAsBackground').listen((event) {
    // service.();
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(hours: 6), (timer) async {
    final random = math.Random();
    final message = [
      "Time to check the nightlife!",
      "Discover the latest spots near you!",
      "Plan your night out with BirdsView!"
    ][random.nextInt(3)];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("randomChannelId", "high",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
        0, "BirdsView", message, platformChannelSpecifics);
  });
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:birds_view/model/user_model/user_model.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';

// class PushNotificationController extends ChangeNotifier {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

//   // Messages for all users
//   final List<String> allUserMessages = [
//     "Ready to vibe? Check the latest hotspots near you",
//     "Your favorite club is getting busy. Head over now",
//     "Looking for a lively spot? See where the crowd's at",
//     "Skip the guessing. Know the vibe before you arrive",
//     "Want to avoid a dead night out? BirdsView’s got you covered",
//     "Girls night? See where the scene is poppin’ right now",
//     "Up for a chill night? Find the perfect spot with BirdsView",
//     "Planning your night out? See the real-time crowd count now",
//     "New in town? Find the best spots without the hassle",
//     "Check the vibe before you arrive. Make tonight count",
//     "Don’t waste a night. Find the action with BirdsView",
//     "Bar hopping is overrated. See where to go next",
//     "Your go-to spot is heating up. Get there now",
//     "Ready to make moves? Find the perfect place tonight",
//     "Find your vibe, avoid the duds. BirdsView has you covered"
//   ];

//   final List<String> nonAccountMessages = [
//     "Ready to see the nightlife scene? Create an account and unlock full access",
//     "Don’t miss out. Sign up now and find the best spots around you",
//     "Get the full experience. Create an account and see real-time club vibes",
//     "Want to know where the crowd's at? Make an account to see it all",
//     "Sign up today and find your perfect night out spot in seconds",
//     "Unlock the full BirdsView experience by creating an account now",
//     "Ready to elevate your nights out? Create an account to see what’s trending nearby"
//   ];

//   Future<void> initialize(UserModel? user) async {
//     await _fcm.requestPermission();
//     String? token = await _fcm.getToken();
//     log("FCM Token: $token");

//     // Initialize local notifications
//     _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await _localNotificationsPlugin.initialize(
//       initializationSettings,
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(
//           message.notification!.title, message.notification!.body);
//     });

//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     _scheduleRandomNotifications(user);
//   }

//   // Future<void> initialize(UserModel? user) async {
//   //   await _fcm.requestPermission();

//   //   String? token = await _fcm.getToken();
//   //   log("FCM Token: $token");

//   //   // Initialize local notifications
//   //   _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   //   const AndroidInitializationSettings initializationSettingsAndroid =
//   //       AndroidInitializationSettings('@mipmap/ic_launcher');
//   //   const DarwinInitializationSettings initializationSettingsIOS =
//   //       DarwinInitializationSettings();
//   //   const InitializationSettings initializationSettings =
//   //       InitializationSettings(
//   //     android: initializationSettingsAndroid,
//   //     iOS: initializationSettingsIOS,
//   //   );
//   //   await _localNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //   );

//   //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     _showNotification(
//   //         message.notification?.title, message.notification?.body);
//   //   });

//   //   _scheduleRandomNotifications(user);
//   // }

//   // Future<void> _showNotification(String? title, String? body) async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //       AndroidNotificationDetails("randomChannelId", "high",
//   //           importance: Importance.max,
//   //           priority: Priority.high,
//   //           ticker: 'ticker');
//   //   const NotificationDetails platformChannelSpecifics =
//   //       NotificationDetails(android: androidPlatformChannelSpecifics);

//   //   await _localNotificationsPlugin.show(
//   //       0, title, body, platformChannelSpecifics);
//   // }

//   Future<void> _showNotification(String? title, String? body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails("randomChannelId", "high",
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await _localNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//   }

//   void _scheduleRandomNotifications(UserModel? user) async {
//     while (true) {
//       await Future.delayed(const Duration(seconds: 5));
//       _sendRandomNotification(user);
//     }
//   }

//   void _sendRandomNotification(UserModel? user) {
//     final random = math.Random();
//     String message;

//     if (user != null && user.data != null && user.data!.id != null) {
//       message = allUserMessages[random.nextInt(allUserMessages.length)];
//     } else {
//       message = nonAccountMessages[random.nextInt(nonAccountMessages.length)];
//     }

//     _showNotification("BirdsView", message);
//   }
// }

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
  final controller = PushNotificationController();
  await controller._showNotification(
      "BirdsView", "${message.notification?.body}");
  if (message.notification != null) {
    await controller._showNotification(
        message.notification!.title, message.notification!.body);
  }
}

// const simpleTask = "simpleTask";

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     // Initialize notification settings
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     if (task == simpleTask) {
//       final random = math.Random();
//       final message = [
//         "Time to check the nightlife!",
//         "Discover the latest spots near you!",
//         "Plan your night out with BirdsView!",
//       ][random.nextInt(3)];

//       const AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//         "randomChannelId",
//         "high",
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       );
//       const NotificationDetails platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);

//       await flutterLocalNotificationsPlugin.show(
//           0, "BirdsView", message, platformChannelSpecifics);
//     }

//     return Future.value(true);
//   });
// }


// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) async {
// //     if (task == simpleTask) {
// //       final random = math.Random();
// //       final message = [
// //         "Time to check the nightlife!",
// //         "Discover the latest spots near you!",
// //         "Plan your night out with BirdsView!",
// //       ][random.nextInt(3)];

// //       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //           FlutterLocalNotificationsPlugin();

// //       const AndroidInitializationSettings initializationSettingsAndroid =
// //           AndroidInitializationSettings('@mipmap/ic_launcher');
// //       const InitializationSettings initializationSettings =
// //           InitializationSettings(android: initializationSettingsAndroid);

// //       await flutterLocalNotificationsPlugin.initialize(initializationSettings);

// //       const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //           AndroidNotificationDetails("randomChannelId", "high",
// //               importance: Importance.max,
// //               priority: Priority.high,
// //               ticker: 'ticker');
// //       const NotificationDetails platformChannelSpecifics =
// //           NotificationDetails(android: androidPlatformChannelSpecifics);

// //       await flutterLocalNotificationsPlugin.show(
// //           0, "BirdsView", message, platformChannelSpecifics);
// //     }
// //     return Future.value(true);
// //   });
// // }



