

import 'dart:async';
import 'dart:convert';

// import 'package:dash_bubble/dash_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/services/SubjectLessonService.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/view/focus_mode_page.dart';
import 'package:spt/view/home_page.dart';
import 'package:spt/view/leaderboard_page.dart';
import 'package:spt/view/login_page.dart';
import 'package:spt/view/student_paper_position_view.dart';
import 'package:spt/view/subject_select_page.dart';
import 'package:spt/view/view_paper.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainLayout extends StatefulWidget {
  int mainIndex = 0;
  int subIndex = 0;
  MainLayout({super.key, this.mainIndex = 0,this.subIndex = 0});


  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Timer? countTimer, focusTimer;
  StreamController<int> indexController = StreamController<int>.broadcast();
  StreamController<int> subjectSelectionController = StreamController<int>.broadcast();
  QueryDocumentSnapshot? lesson;
  String lessonContent = '';
  String subjectName = '';
  bool enabledFocus = false;
  late AppLifecycleListener lifecycleListener;
  
  selectSubject(int index,QueryDocumentSnapshot lesson,String lessonContent,String subjectName) {
    setState(() {
      this.lesson = lesson;
      this.lessonContent = lessonContent;
      this.subjectName = subjectName;
    });
    subjectSelectionController.sink.add(index);
  }

  setCountDownTimer(Map<String, int> countDown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('countDown', jsonEncode(countDown));
    countTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if(countDown['seconds']! > 0){
        countDown['seconds'] = countDown['seconds']! - 1;
      }else if(countDown['minutes']! > 0){
        countDown['minutes'] = countDown['minutes']! - 1;
        countDown['seconds'] = 59;
      }else{
        timer.cancel();
      }
      prefs.setString('countDown', jsonEncode(countDown));
    });
  }

  Future<bool> checkAndSetFocusMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    if(prefs.containsKey('enabledFocus')){
      bool enabledFocus = prefs.getBool('enabledFocus')!;
      if(enabledFocus){
        Map<String, dynamic> focusData = jsonDecode(prefs.getString('focusData')!);
        String focusID = focusData['focusID'];
        String lessonId = focusData['lessonID'];
        String _lessonContent = focusData['lessonContent'];
        String _subjectName = focusData['subjectName'];
        DateTime startAt = DateTime.parse(focusData['startAt']);
        DateTime endAt = DateTime.now();
        //duration in minutes
        int duration = endAt.difference(startAt).inSeconds;
        QueryDocumentSnapshot _lesson = await SubjectLessonService.getLessonById(_subjectName,lessonId);
        subjectSelectionController.add(1);
        setState(() {
          lesson = _lesson;
          lessonContent = _lessonContent;
          subjectName = _subjectName;
          enabledFocus = true;
          widget.mainIndex = 1;
        });
        return true;
      }

      return false;
    }
    return false;
  }

  changeIndex(int index) {
    indexController.sink.add(index);
  }

  showOverlay() async {
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('countDown')){
        await FlutterOverlayWindow.showOverlay(
            overlayTitle: "", height: 420, width: 400, enableDrag: true);
        String? countDown = prefs.getString('countDown');
        if(countDown != null) {
          Map<String,dynamic> countDownMap = jsonDecode(countDown);
          await FlutterOverlayWindow.shareData(countDownMap);
        }

      }
    }
  }


  _showFocusModeTimer(){
    countTimer?.cancel();
    showOverlay();
  }

  _hideFocusModeTimer() async {
    bool? r = await FlutterOverlayWindow.closeOverlay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> countDown = jsonDecode(prefs.getString('countDown')!);
    setCountDownTimer(countDown.cast<String,int>());
  }

  @override
  void initState() {
    super.initState();
    lifecycleListener = AppLifecycleListener(
      onShow: () async {
        await _hideFocusModeTimer();
      },
      onHide: () async {
        await _showFocusModeTimer();
      },
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginPage())
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                bottom: 70,
                height: MediaQuery.of(context).size.height - 50,
                child: StreamBuilder<int>(
                  stream: indexController.stream,
                  initialData: widget.mainIndex,
                  // initialData: 2,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      int index = snapshot.data!;
                      switch(index){
                        case 0:
                          return const HomePage();
                        case 1:
                          return StreamBuilder(
                              stream: subjectSelectionController.stream,
                              initialData: widget.subIndex,
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  int index = snapshot.data!;
                                  if(enabledFocus){
                                    return FocusMode(
                                        lesson: lesson!,
                                        lessonContent: lessonContent,
                                        subject:subjectName,
                                        enableFocus:true,
                                        setCountDownTimer: setCountDownTimer,
                                    );
                                  }
                                  switch(index){
                                    case 0:
                                      return FutureBuilder(
                                        future: checkAndSetFocusMode(),
                                        builder: (context,snapshot){

                                          if(snapshot.hasData){
                                            if(snapshot.data == true){
                                              return Container();
                                            }else{
                                              return SubjectSelectionPage(
                                                selectSubject: selectSubject,
                                              );
                                            }
                                          }
                                          return const Center(child: CircularProgressIndicator(),);
                                        }
                                      );
                                    case 1:
                                      return FocusMode(
                                          lesson: lesson!,
                                          lessonContent: lessonContent,
                                          subject:subjectName,
                                          setCountDownTimer: setCountDownTimer,
                                      );
                                      case 2:
                                        return LeaderBoardPage();
                                    default:
                                      return const Center(child: CircularProgressIndicator(), );
                                  }
                                }
                                else{
                                  return const Center(child: CircularProgressIndicator(), );
                                }
                              }
                          );
                        case 2:
                          return StudentMarksPage();
                        case 3:
                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth.signOut();
                          return Text('Page 4');
                        default:
                          return const Center(child: Text('Home Page'),);
                      }
                    }
                    else{
                      return const Center(child: CircularProgressIndicator(), );
                    }
                  },
                )
            ),
            Positioned(
                bottom: 0,
                height: 70,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 2,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ToggleSwitch(
                      minWidth: MediaQuery.of(context).size.width * 0.9 / 4,
                      minHeight: 50,
                      initialLabelIndex: widget.mainIndex,
                      cornerRadius: 4.0,
                      inactiveBgColor: Colors.white,
                      inactiveFgColor: Colors.black,
                      activeFgColor: Color(0xFF00C897),
                      activeBgColor: [Colors.white],
                      dividerColor: Colors.white,
                      iconSize: 24,
                      icons: [
                        Icons.home,
                        Icons.book,
                        Icons.star,
                        Icons.notifications,
                      ],
                      onToggle: (index) {
                        changeIndex(index!);
                      },
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
