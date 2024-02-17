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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1A201A),
              // color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: 70,
                        height: 70,
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
                    // Container(
                    //   width: 200,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // send data to the main app
                    //     },
                    //     child: const Text('PAUSE', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Color(0xFFC3E2C2),
                    //       foregroundColor: Colors.black,
                    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //     )
                    //   ),
                    // ),
                  ],
                ),
            ),
          ),
          //close Button on top right
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              constraints: BoxConstraints.tight(const Size(25, 25)),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
              ),

              onPressed: () {
                // close overlay
                // FlutterOverlayApps.closeOverlay();
                FlutterOverlayWindow.closeOverlay();
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 10,),
            ),
          ),
        ],
      ),
    );
  }
}