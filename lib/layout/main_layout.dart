

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spt/view/focus_mode_page.dart';
import 'package:spt/view/home_page.dart';
import 'package:spt/view/leaderboard_page.dart';
import 'package:spt/view/student_paper_position_view.dart';
import 'package:spt/view/subject_select_page.dart';
import 'package:spt/view/view_paper.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  StreamController<int> indexController = StreamController<int>.broadcast();
  StreamController<int> subjectSelectionController = StreamController<int>.broadcast();
  
  selectSubject(int index) {
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
                                      return FocusMode();
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
                          // return StudentMarksPage();
                          return StudentPaperPositionPage();
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
                      initialLabelIndex: 0,
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
