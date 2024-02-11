import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/view/home_page.dart';
import 'package:spt/view/login_page.dart';
import 'package:spt/widgets/overlay_content.dart';
import 'firebase_options.dart';


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: isUserLoggedIn() ? MainLayout() : const LoginPage(),
    );
  }
}
