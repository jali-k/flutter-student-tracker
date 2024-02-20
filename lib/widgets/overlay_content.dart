import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:spt/util/overlayUtil.dart';

class MyOverlaContent extends StatefulWidget {
  const MyOverlaContent({Key? key}) : super(key: key);

  @override
  State<MyOverlaContent> createState() => _MyOverlaContentState();
}

class _MyOverlaContentState extends State<MyOverlaContent> {
  String _dataFromApp = "Hey send data";
  Map<String, int>? countDown = {"minutes": 25, "seconds": 0};
  Timer? timer;


  initTimer() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();

    if (prefs.containsKey('countDown')) {
      Map<String, dynamic> countDownData = jsonDecode(
          prefs.getString('countDown')!);
      countDown = countDownData.cast<String, int>();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countDown!["seconds"]! > 0) {
          setState(() {
            countDown!["seconds"] = countDown!["seconds"]! - 1;
          });
        } else if (countDown!["minutes"]! > 0) {
          setState(() {
            countDown!["minutes"] = countDown!["minutes"]! - 1;
            countDown!["seconds"] = 59;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      if(event is Map){
        setState(() {
          countDown = event.cast<String, int>();
        });
      }
    });
    initTimer();

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF1A201A),
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      // color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF1A201A),
          // color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFC3E2C2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A201A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF6C9263),
                      width: 4,
                    ),

                  ),
                  child: Center(
                    child: Text(
                      '${countDown!["minutes"]! < 10 ? '0' : ''}${countDown!["minutes"]}:${countDown!["seconds"]! < 10 ? '0' : ''}${countDown!["seconds"]}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 25,
                child: ElevatedButton(
                  onPressed: () async {
                    //close the overlay
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await FlutterOverlayWindow.closeOverlay();
                  },
                  child: const Text('Close', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC3E2C2),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fixedSize: Size(100, 20),

                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}