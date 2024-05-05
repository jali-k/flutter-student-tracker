import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/provider/attemptedPaperProvider.dart';
import 'package:spt/provider/paperProvider.dart';
import 'package:spt/screens/bottomBar_screen/bottom_bar_screen.dart';
import 'package:spt/screens/instructor_screen/instructor_entry_screen.dart';
import 'package:spt/view/student/login_page.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug);
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'grouped',
        channelGroupName: 'Grouped notifications',
      )
    ],
  );

  bool permissionGranted = await AwesomeNotifications().isNotificationAllowed();
  if (!permissionGranted) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // FirebaseAuth.instance.signOut();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => paperProvider()),
        ChangeNotifierProvider(create: (_) => attemptedPaperProvider()),
      ],
      child: MyApp(),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (!kIsWeb && Platform.isAndroid) {
      if (kReleaseMode) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    }
  });
}

showOverlay() async {
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  } else {
    await FlutterOverlayWindow.showOverlay(
        height: 500, width: 500, overlayTitle: "");
  }
}

Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('role')) {
    return true;
  }else{
    return false;
  }
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Future<Widget> getLandingPage(BuildContext context) async {
    bool isMobile = TargetPlatform.android == defaultTargetPlatform ||
        TargetPlatform.iOS == defaultTargetPlatform;
    if (!isMobile) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('This app is only available for mobile devices'),
        ),
      );
    }

    if (await isUserLoggedIn()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('role')) {
        String role = prefs.getString('role')!;
        if (role == 'role_student') {
          return MainLayout();
        }
        else if (role == 'role_instructor') {
          return const InstructorEntryScreen();
        }
        else if (role == 'admin') {
          return const BottomBarScreen(
            isEntryScreen: false,
            isInstructorScreen: false,
            isAddFolderScreen: false,
          );
        }
        return MainLayout();
      }
    }
    return const LoginPage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      title: 'Studo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: getLandingPage(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              return snapshot.data!;
            }
          }
        },
      ),
    );
  }
}
