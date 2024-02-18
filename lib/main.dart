import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/screens/bottomBar_screen/bottom_bar_screen.dart';
import 'package:spt/screens/initial_screen/initial_screen.dart';
import 'package:spt/screens/instructor_screen/existing_instructor_screen.dart';
import 'package:spt/screens/instructor_screen/instructor_entry_screen.dart';
import 'package:spt/services/auth_services.dart';
import 'package:spt/view/student/home_page.dart';
import 'package:spt/view/student/login_page.dart';
import 'package:spt/widgets/overlay_content.dart';
import 'firebase_options.dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
if (!await FlutterOverlayWindow.isPermissionGranted()) {
  await FlutterOverlayWindow.requestPermission();
}
  // FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() async {
  debugPrint("Starting Alerting Window Isolate!");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyOverlaContent()));

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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

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
