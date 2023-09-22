// ignore_for_file: avoid_print

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:playandearnmoney/Screens/SplashScreen.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/cubit/internetcubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging fMessaging = FirebaseMessaging.instance;
var serverkey =
    'AAAAfyXVCkI:APA91bEjfbD7d5Hb2PJD9xsWQGkffLuRxVIU8a1ipjqdexdOViDVm3Uwwpja3lDBdjv04x3FABezkELq_mzAxbRK6ehBE3_bowxi5x_eQ3vULvRCNLscn8VQcDctKhOlQVONxysINaDn';
var senderid = '546095565378';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  _getFirebaseMessagingToken();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

Future<void> _getFirebaseMessagingToken() async {
  await fMessaging.requestPermission();

  await fMessaging.getToken().then((t) {
    if (t != null) {
      prefs.setString('token', t);
      print('Push Token: $t');
    }
  });
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  var adnroidinit = const AndroidInitializationSettings('@drawable/cart');
  var initsetting = InitializationSettings(android: adnroidinit);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initsetting);
  var androiddetails = const AndroidNotificationDetails(
      'moneyarena', 'moneyarena', 'moneyarena',
      importance: Importance.high, priority: Priority.high);
  var generalnotify = NotificationDetails(android: androiddetails);

  // for handling foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          generalnotify);
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");

  // Initialize the notification plugin
  var androidInit = const AndroidInitializationSettings('@drawable/cart');
  var initSettings = InitializationSettings(android: androidInit);
  flutterLocalNotificationsPlugin.initialize(initSettings);

  // Define the notification details
  var androidDetails = const AndroidNotificationDetails(
    'moneyarena',
    'moneyarena',
    'moneyarena',
    importance: Importance.high,
    priority: Priority.high,
  );
  var generalNotify = NotificationDetails(android: androidDetails);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          generalNotify);
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetCubit(),
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, state) {
          if (state == InternetStates.gained) {
            return MaterialApp(
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                theme: ThemeData(
                    primaryColor: schemecolor,
                    appBarTheme: AppBarTheme(
                        iconTheme: const IconThemeData(color: Colors.white),
                        backgroundColor: Colors.white,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: schemecolor,
                        )),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                          primary: schemecolor, onPrimary: Colors.white),
                    ),
                    textTheme: GoogleFonts.almaraiTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: schemecolor,
                    ),
                    scaffoldBackgroundColor: Colors.white,
                    fontFamily: GoogleFonts.almarai().fontFamily),
                darkTheme: ThemeData(
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: Colors.black,
                ),
                home: const SplashScreen());
          } else {
            return Container(
              height: double.infinity,
              color: Colors.white,
              child: Center(child: Image.asset("assets/images/nointernet.jpg")),
            );
          }
        },
      ),
    );
  }
}
