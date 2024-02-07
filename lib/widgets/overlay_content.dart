import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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
  late final StreamController overlayStream;
  Timer? timer;


  initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(countDown!["seconds"]! > 0){
        setState(() {
          countDown!["seconds"] = countDown!["seconds"]! - 1;
        });
      }else if(countDown!["minutes"]! > 0){
        setState(() {
          countDown!["minutes"] = countDown!["minutes"]! - 1;
          countDown!["seconds"] = 59;
        });
      }else{
        timer.cancel();
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      print("Overlay Listener: $event");
      if(event is Map){
        setState(() {
          countDown = event.cast<String, int>();
        });
        initTimer();
      }
    });
  }


  @override
  void dispose() {
    overlayStream.close();
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
                      width: 200,
                      height: 200,
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
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A201A),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF6C9263),
                            width: 10,
                          ),

                        ),
                        child: Center(
                          child: Text(
                            '${countDown!["minutes"]}:${countDown!["seconds"]}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // send data to the main app
                        },
                        child: const Text('PAUSE', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC3E2C2),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      ),
                    ),
                  ],
                ),
            ),
          ),
          //close Button on top right
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                // close overlay
                // FlutterOverlayApps.closeOverlay();
                FlutterOverlayWindow.closeOverlay();
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 30,),
            ),
          ),
        ],
      ),
    );
  }
}