

import 'dart:async';

// import 'package:dash_bubble/dash_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spt/view/focus_mode_page.dart';
import 'package:spt/view/home_page.dart';
import 'package:spt/view/leaderboard_page.dart';
import 'package:spt/view/student_paper_position_view.dart';
import 'package:spt/view/subject_select_page.dart';
import 'package:spt/view/view_paper.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainLayout extends StatefulWidget {
  int mainIndex = 2;
  MainLayout({super.key, this.mainIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  StreamController<int> indexController = StreamController<int>.broadcast();
  StreamController<int> subjectSelectionController = StreamController<int>.broadcast();
  QueryDocumentSnapshot? lesson;
  String lessonContent = '';
  String subjectName = '';
  
  selectSubject(int index,QueryDocumentSnapshot lesson,String lessonContent,String subjectName) {
    setState(() {
      this.lesson = lesson;
      this.lessonContent = lessonContent;
      this.subjectName = subjectName;
    });
    subjectSelectionController.sink.add(index);
  }

  changeIndex(int index) {
    indexController.sink.add(index);
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
                  // initialData: widget.mainIndex,
                  initialData: 2,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      int index = snapshot.data!;
                      switch(index){
                        case 0:
                          return const HomePage();
                        case 1:
                          return StreamBuilder(
                              stream: subjectSelectionController.stream,
                              initialData: 0,
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  int index = snapshot.data!;
                                  switch(index){
                                    case 0:
                                      return SubjectSelectionPage(
                                        selectSubject: selectSubject,
                                      );
                                    case 1:
                                      return FocusMode(lesson: lesson!,lessonContent: lessonContent,subject:subjectName);
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
