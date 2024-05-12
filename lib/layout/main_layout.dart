import 'dart:async';
import 'dart:convert';
import 'dart:ui';

// import 'package:dash_bubble/dash_bubble.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/subject_response_model.dart';
import 'package:spt/services/SubjectLessonService.dart';
import 'package:spt/services/authenticationService.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/view/student/focus_mode_page.dart';
import 'package:spt/view/student/home_page.dart';
import 'package:spt/view/student/leaderboard_page.dart';
import 'package:spt/view/student/lecture_page.dart';
import 'package:spt/view/student/login_page.dart';
import 'package:spt/view/student/notification_page.dart';
import 'package:spt/view/student/student_paper_position_view.dart';
import 'package:spt/view/student/subject_select_page.dart';
import 'package:spt/view/student/view_paper.dart';
import 'package:toggle_switch/toggle_switch.dart';
//import math
import 'dart:math' as math;

import '../model/Paper.dart';
import '../model/paper_attempt.dart';
import '../provider/paperProvider.dart';
import '../services/mark_service.dart';
import '../util/notification_controller.dart';
import '../view/student/show_profile.dart';

class MainLayout extends StatefulWidget {

  int mainIndex = 0;
  int subIndex = 0;

  MainLayout({super.key, this.mainIndex = 0, this.subIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver{
  Timer? countTimer, focusTimer,reminderTimer;
  StreamController<int> indexController = StreamController<int>.broadcast();
  StreamController<int> subjectSelectionController =
      StreamController<int>.broadcast();
  Lessons? lesson;
  String lessonContent = '';
  String subjectName = '';
  bool enabledFocus = false;
  late AppLifecycleListener lifecycleListener;
  bool unknown = true;
  bool timerShow = false;

  getPapers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role')!;
    if(role == 'unknown'){
      return;
    }
    Map<ExamPaper,AttemptPaper?> p = await PaperMarksService.getStudentPapers();
    if (!mounted) return;
    Provider.of<paperProvider>(context, listen: false).setPapers(p);
  }

  selectSubject(int index, Lessons lesson, String lessonContent,
      String subjectName) {
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
      if (countDown['seconds']! > 0) {
        countDown['seconds'] = countDown['seconds']! - 1;
      } else if (countDown['minutes']! > 0) {
        countDown['minutes'] = countDown['minutes']! - 1;
        countDown['seconds'] = 59;
      } else {
        timer.cancel();
      }
      prefs.setString('countDown', jsonEncode(countDown));
    });
  }

  Future<bool> checkAndSetFocusMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    if (prefs.containsKey('enabledFocus')) {
      bool enabledFocus = prefs.getBool('enabledFocus')!;
      if (enabledFocus) {
        Map<String, dynamic> focusData =
            jsonDecode(prefs.getString('focusData')!);
        String focusID = focusData['focusID'];
        String lessonId = focusData['lessonID'];
        String _lessonContent = focusData['lessonContent'];
        String _subjectName = focusData['subjectName'];
        DateTime startAt = DateTime.parse(focusData['startAt']);
        DateTime endAt = DateTime.now();
        //duration in minutes
        int duration = endAt.difference(startAt).inSeconds;
        QueryDocumentSnapshot _lesson =
            await SubjectLessonService.getLessonById(_subjectName, lessonId);
        Lessons l = Lessons();
        subjectSelectionController.add(1);
        setState(() {
          lesson = l;
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

  changeIndex(int index) async {
    if(unknown && index ==4){
      //Logout
      AuthenticationService.logout();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
      //logged out successfully scaffold
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logged out successfully'),
      ));
      return;
    }
    if(unknown && index != 0){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You are not allowed to access this page'),
      ));
      setState(() {
        widget.mainIndex = 0;
      });
      return;
    }
    if(unknown && index != 1){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You are not allowed to access this page'),
      ));
      setState(() {
        widget.mainIndex = 0;
      });
      return;
    }

    indexController.sink.add(index);

  }

  showOverlay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('countDown')) {
      await FlutterOverlayWindow.showOverlay(
          overlayTitle: "", height: 600, width: 400, enableDrag: true);
      String? countDown = prefs.getString('countDown');
      if (countDown != null) {
        Map<String, dynamic> countDownMap = jsonDecode(countDown);
        await FlutterOverlayWindow.shareData(countDownMap);
      }
    }
  }

  getUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    if (role == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  LoginPage()));
    }else if(role == 'unknown'){
      setState(() {
        unknown = true;
      });
    }else{
      setState(() {
        unknown = false;
      });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print("State: $state");
    if(state == AppLifecycleState.detached || state == AppLifecycleState.inactive){
      return;
    }
    final bool isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      SharedPreferences prefs =await  SharedPreferences.getInstance();
      if (prefs.containsKey('focusData')) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              actionType: ActionType.KeepOnTop,
              title: 'Focus Mode',
              body: 'You have a focus mode running',
            )
        );
        reminderTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
          if(!prefs.containsKey('focusData')){
            reminderTimer?.cancel();
            AwesomeNotifications().cancelAll();
          }
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: math.Random().nextInt(1000),
                channelKey: 'basic_channel',
                actionType: ActionType.KeepOnTop,
                title: 'Focus Mode',
                body: 'You have a focus mode running',
              )
          );
        });

      }
    }else{
      AwesomeNotifications().cancelAll();
      reminderTimer?.cancel();
    }
  }

  _showFocusModeTimer() {
    countTimer?.cancel();
    showOverlay();
  }

  _hideFocusModeTimer() async {
    await FlutterOverlayWindow.closeOverlay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> countDown = jsonDecode(prefs.getString('countDown')!);
    setCountDownTimer(countDown.cast<String, int>());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // getPapers();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );


    // getUserState();
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const LoginPage()));
    //   }
    // });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
                height: MediaQuery.of(context).size.height - 70,
                child: StreamBuilder<int>(
                  stream: indexController.stream,
                  initialData: widget.mainIndex,
                  // initialData: 2,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int index = snapshot.data!;
                      switch (index) {
                        case 0:
                          return const HomePage();
                        case 1:
                          return StreamBuilder(
                              stream: subjectSelectionController.stream,
                              initialData: widget.subIndex,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int index = snapshot.data!;
                                  if (enabledFocus) {
                                    return FocusMode(
                                      lesson: lesson!,
                                      lessonContent: lessonContent,
                                      subject: subjectName,
                                      enableFocus: true,
                                      setCountDownTimer: setCountDownTimer,
                                    );
                                  }
                                  switch (index) {
                                    case 0:
                                      return FutureBuilder(
                                          future: checkAndSetFocusMode(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data == true) {
                                                return Container();
                                              } else {
                                                return SubjectSelectionPage(
                                                  selectSubject: selectSubject,
                                                );
                                              }
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          });
                                    case 1:
                                      return FocusMode(
                                        lesson: lesson!,
                                        lessonContent: lessonContent,
                                        subject: subjectName,
                                        setCountDownTimer: setCountDownTimer,
                                      );
                                    case 2:
                                      return LeaderBoardPage();
                                    default:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              });
                        case 2:
                          return StudentMarksPage();
                        case 3:
                          return NotificationPage();
                        case 4:
                          return ProfilePage();
                        case 5:
                          return LecturesPage();
                        default:
                          return const Center(
                            child: Text('Home Page'),
                          );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )),
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
                      minWidth: MediaQuery.of(context).size.width * 0.9 / 5,
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
                        unknown ? Icons.logout : Icons.person,
                      ],
                      onToggle: (index) {
                        changeIndex(index!);
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void clearFocusMode() {
    countTimer?.cancel();
    focusTimer?.cancel();
    FlutterOverlayWindow.closeOverlay();
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('countDown');
      prefs.remove('enabledFocus');
      prefs.remove('focusData');
    });
  }
}
