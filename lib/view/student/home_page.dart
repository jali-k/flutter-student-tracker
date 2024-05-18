import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/Subject.dart';
import 'package:spt/model/paper_attempt.dart';
import 'package:spt/provider/attemptedPaperProvider.dart';
import 'package:spt/provider/paperProvider.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/services/mark_service.dart';
import 'package:spt/services/paper_mark_service.dart';
import 'package:spt/util/toast_util.dart';
import 'package:spt/view/student/login_page.dart';
import 'package:spt/view/student/paper_detail.dart';

import '../../model/Paper.dart';
import '../../model/focus_session_in_week_stat_data_model.dart';
import '../../model/focus_session_leaderboard_response_model.dart';
import '../../model/leaderboard_entries.dart';
import '../../model/model.dart';
import '../../model/student_all_mark_response_model.dart';
import '../../model/subject_focus_session_leaderboard_response.dart';
import '../../services/focus_service.dart';
import '../../services/leaderboard_service.dart';
import '../../services/student_leaderboard_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _BiologyFocus=-1;
  int _ChemistryFocus=-1;
  int _PhysicsFocus=-1;
  int _AgricultureFocus=-1;
  int _overallFocus=-1;
  List<MarkData> paperMarks = [];
  bool unknown = true;

  List<FSLeaderboardPosition> overallPositions=[];
  List<FSLeaderboardPosition> biologyEntries=[];
  List<FSLeaderboardPosition> chemistryEntries=[];
  List<FSLeaderboardPosition> physicsEntries=[];
  List<FSLeaderboardPosition> agricultureEntries=[];
  List<FSLeaderboardPosition> leaderBoardEntries = [];


  getSubjectFocus() async {
    int BiologyFocus, ChemistryFocus, PhysicsFocus, AgricultureFocus, overallFocus;
    BiologyFocus = await FocusService.getStudentSubjectFocus(Subject.BIOLOGY);
    ChemistryFocus = await FocusService.getStudentSubjectFocus(Subject.CHEMISTRY);
    PhysicsFocus = await FocusService.getStudentSubjectFocus(Subject.PHYSICS);
    AgricultureFocus = await FocusService.getStudentSubjectFocus(Subject.AGRICULTURE);
    overallFocus = BiologyFocus + ChemistryFocus + PhysicsFocus + AgricultureFocus;
    if (!mounted) return;
    setState(() {
      _BiologyFocus = BiologyFocus;
      _ChemistryFocus = ChemistryFocus;
      _PhysicsFocus = PhysicsFocus;
      _AgricultureFocus = AgricultureFocus;
      _overallFocus = overallFocus;
    });
  }

  getMarks() async{
    try{
      StudentAllMarkResponseModel? marks = await PaperMarkService.getStudentAllMarks();
      if(marks != null){
        List<MarkData> data = marks!.data!;
        setState(() {
          paperMarks = data;
        });
      }
    }catch(e){
      rethrow;
    }
  }

  getFocusSessionSummary() async{
    try{
      FocusSessionsInWeekStatsDataModel? data = await FocusSessionService.getInMonthFocusSessionStat(context);
      if(data != null){
        int month = DateTime.now().month;
        int year = DateTime.now().year;
        InWeekData? inWeekData = data.data?.firstWhere((element) => DateTime.fromMillisecondsSinceEpoch(element.day!).year == year && DateTime.fromMillisecondsSinceEpoch(element.day!).month == month);
        print(inWeekData);
      }

    }catch(e){
      print(e);
    }
  }


  getLeaderboard() async{
    FocusSessionLeaderboardResponseModel? focusSessionLeaderboardResponseModel = await StudentLeaderboardService.getFocusSessionOverallLeaderBoard();
    if(focusSessionLeaderboardResponseModel != null){
      setState(() {
        overallPositions = focusSessionLeaderboardResponseModel.data!;
        _overallFocus = focusSessionLeaderboardResponseModel.data!.firstWhere((element) => element.currentUser == true).leaderBoardRank!;
        leaderBoardEntries = overallPositions;
      });
    }
  }
  getSubjectLeaderboard() async{
    SubjectFocusSessionLeaderboardResponse? focusSessionLeaderboardResponseModel = await StudentLeaderboardService.getSubjectFocusSessionOverallLeaderBoard();
    if(focusSessionLeaderboardResponseModel != null){
      setState(() {
        biologyEntries = focusSessionLeaderboardResponseModel.data!.biology!;
        int BiologyFocus = focusSessionLeaderboardResponseModel.data!.biology!.indexWhere((element) => element.currentUser == true);
        if(BiologyFocus != -1){
          _BiologyFocus = focusSessionLeaderboardResponseModel.data!.biology![BiologyFocus].leaderBoardRank ?? -1;
        }
        chemistryEntries = focusSessionLeaderboardResponseModel.data!.chemistry!;
        int ChemistryFocus = focusSessionLeaderboardResponseModel.data!.chemistry!.indexWhere((element) => element.currentUser == true);
        if(ChemistryFocus != -1){
          _ChemistryFocus = focusSessionLeaderboardResponseModel.data!.chemistry![ChemistryFocus].leaderBoardRank ?? -1;
        }
        physicsEntries = focusSessionLeaderboardResponseModel.data!.physics!;
        int PhysicsFocus = focusSessionLeaderboardResponseModel.data!.physics!.indexWhere((element) => element.currentUser == true);
        if(PhysicsFocus != -1){
          _PhysicsFocus = focusSessionLeaderboardResponseModel.data!.physics![PhysicsFocus].leaderBoardRank ?? -1;
        }
        agricultureEntries = focusSessionLeaderboardResponseModel.data!.agriculture!;
        int AgricultureFocus = focusSessionLeaderboardResponseModel.data!.agriculture!.indexWhere((element) => element.currentUser == true);
        if(AgricultureFocus != -1){
          _AgricultureFocus = focusSessionLeaderboardResponseModel.data!.agriculture![AgricultureFocus].leaderBoardRank ?? -1;
        }
      });
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    // getUserState();
    getMarks();
    getFocusSessionSummary();
    super.initState();
    getLeaderboard();
    getSubjectLeaderboard();
    // getSubjectFocus();
    // getPaperLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: 0,
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Title : What’s catching your interest today?
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'What’s catching your',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'interest ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF00C897),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'today?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8 - 100,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department_rounded,
                                                      color: Color(0xFFECA11B),
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(_overallFocus == -1 ? "__":_overallFocus.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Overall")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department_rounded,
                                                      color: Color(0xFF1BEC3E),
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(_BiologyFocus == -1 ? "__":_BiologyFocus.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Biology")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department_rounded,
                                                      color: Color(0xFF1BECCD),
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(_ChemistryFocus == -1 ? "__":_ChemistryFocus.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Chemistry")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department_rounded,
                                                      color: Color(0xFFDEEC1B),
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(_PhysicsFocus == -1 ? "__":_PhysicsFocus.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Physics")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.local_fire_department_rounded,
                                                      color: Color(0xFFD71BEC),
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(_AgricultureFocus == -1 ? "__":_AgricultureFocus.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text("Agriculture")
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            margin: const EdgeInsets.only(left: 40),
                                            child: Image.asset(
                                              'assets/animation/study.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Study Now',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 1,rank: _overallFocus,)));
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child:
                                          ListView.builder(
                                            itemCount: paperMarks.length,
                                            itemBuilder: (context, index) {
                                              MarkData mark = paperMarks[index];
                                              return Container(
                                                margin: const EdgeInsets.only(top: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.local_fire_department_rounded,
                                                        color: Color(0xFFECA11B),
                                                        size: 25,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text((mark.markId != null  && mark.rank !=0) ?mark.rank.toString().padLeft(2,"0") : "__",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(mark.paper!.paperName!,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            margin: const EdgeInsets.only(left: 40),
                                            child: Image.asset(
                                              'assets/animation/paper.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'View Marks',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => MainLayout(
                                                            mainIndex: 2
                                                          )));
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.local_fire_department_rounded,
                                                color: Color(0xFFECA11B),
                                                size: 30,
                                              ),
                                              SizedBox(width: 5),
                                              Text('Lessons',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            margin: const EdgeInsets.only(left: 40),
                                            child: Image.asset(
                                              'assets/animation/greet.gif',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Lectures',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => MainLayout(
                                                            mainIndex: 5,
                                                          )));
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              
                  ]
              )),
        ],
      ),
    );
  }
}
