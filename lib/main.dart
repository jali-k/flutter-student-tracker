import 'dart:ui';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/screens/bottomBar_screen/bottom_bar_screen.dart';
import 'package:spt/screens/instructor_screen/instructor_entry_screen.dart';
import 'package:spt/view/student/login_page.dart';
import 'firebase_options.dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if(Platform.isAndroid){
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
}


showOverlay() async {
  if(!await FlutterOverlayWindow.isPermissionGranted()){
    await FlutterOverlayWindow.requestPermission();
  }else{
    await FlutterOverlayWindow.showOverlay(height:500,width:500,overlayTitle: "");
  }
}

bool isUserLoggedIn(){
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser != null){
    return true;
  }else{
    return false;
  }

}

Future<Widget> getLandingPage() async {
  if(isUserLoggedIn()){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('role')) {
      String role = prefs.getString('role')!;
      if(role == 'student'){
        return MainLayout();
      }else if(role == 'instructor'){
        return const InstructorEntryScreen();
      } else if(role == 'admin') {
        return const BottomBarScreen(
            isEntryScreen: false,
            isInstructorScreen: false,
          isAddFolderScreen: false,
        );
      }
      // Unkown role
      return MainLayout();
    }
    return LoginPage();
  }else{
    return LoginPage();
  }
}




class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

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
        future: getLandingPage(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            if(snapshot.hasError){
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }else{
              return snapshot.data!;
            }
          }
        },
      ),
    );
  }
}
