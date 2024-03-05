// import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'package:spt/provider/attemptedPaperProvider.dart';
import 'package:spt/provider/paperProvider.dart';
import 'package:spt/services/mark_service.dart';
import 'package:spt/view/student/student_paper_position_view.dart';

import '../../model/Paper.dart';
import '../../model/leaderboard_entries.dart';
import '../../model/paper_attempt.dart';
import '../../services/leaderboard_service.dart';
import '../../util/overlayUtil.dart';

class StudentMarksPage extends StatefulWidget {
  const StudentMarksPage({super.key});

  @override
  State<StudentMarksPage> createState() => _StudentMarksPageState();
}

class _StudentMarksPageState extends State<StudentMarksPage> {
  final isSelected = [true, false, false, false, false];
  bool isLoadingPapers = true;
  int selected = 0;
  final myID = 5;
  Map<ExamPaper,AttemptPaper?> papers = {};
  void handleSelected(int i) {
    for (int j = 0; j < isSelected.length; j++) {
      if (j == i) {
        isSelected[j] = true;
      } else {
        isSelected[j] = false;
      }
    }
    setState(() {
      selected = i;
    });
  }

  Future<void> _runMethod(
      BuildContext context,
      Future<void> Function() method,
      ) async {
    try {
      await method();
    } catch (error) {
      print('Error: $error');
    }
  }

  showOverlay() async {
    if(!await FlutterOverlayWindow.isPermissionGranted()){
      await FlutterOverlayWindow.requestPermission();
    }else{
      await FlutterOverlayWindow.showOverlay(overlayTitle: "",height: 1100,width: 800,enableDrag: true);
    }
  }

  showFloat() async {
    final bool status = await FlutterOverlayWindow.isPermissionGranted();
    showOverlay();
  }

  getPapers() async {
    Map<ExamPaper,AttemptPaper?> p = await PaperMarksService.getStudentPapers();
    setState(() {
      papers = p;
      isLoadingPapers = false;
    });
  }

  void getPaperLeaderBoard() async {
    Map<String, List<LeaderBoardEntries>> leaderBoard =
    await LeaderBoardService.getLeaderBoard();
    List<ExamPaper> papers = await LeaderBoardService.getAttemptedPapers();
    if(!mounted) return;
    Provider.of<attemptedPaperProvider>(context,listen: false).setPapers(papers,leaderBoard);
  }

        @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPapers();
    getPaperLeaderBoard();


    // _requestOverlayPermission(context);
    // showBubble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 60,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/student_marks_background.png',
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: MediaQuery.of(context).size.height - 70,
              width: MediaQuery.of(context).size.width ,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Title : What’s catching your interest today?
                        children: [
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            //Linear Color 00C897 to 245247
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF00C897),
                                  Color(0x55245247),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              //Linear Color 00C897 to 245247 border
                              border: Border.all(
                                color: const Color(0xFF00C897),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white54,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            width: 280,
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      'Daily Reminder',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    '\“ Work hard in silence. Let your success be the noise. \"',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Container(
                                //       child: Text(
                                //         'Lord Buddha',
                                //         textAlign: TextAlign.right,
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height - 370,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var paper in context.watch<paperProvider>().paperController.entries)
                                    Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width - 60,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Paper Number and arks
                                              Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.white54,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 5),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          paper.key.paperName,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              paper.value == null ? '__' : paper.value!.totalMarks.toString(),
                                                              style: const TextStyle(
                                                                fontSize: 40,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFFA30A0A),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // 25 and LeaderBoard Link
                                              const SizedBox(width: 10),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.white54,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 5),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/icons/fire_overall.png',
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                            Text(paper.value == null ? '__' : paper.value!.position.toString(),
                                                              style: const TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        //MCQ,Structured,Essay Marks with the name
                                                        Column(
                                                          children: [
                                                            const SizedBox(height: 5),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'MCQ',
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 10),
                                                                Text(
                                                                  paper.value == null ? '__' : paper.value!.mcqMarks == null ? '__' : paper.value!.mcqMarks.toString(),
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Structured',
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 10),
                                                                Text(
                                                                  paper.value == null ? '__' : paper.value!.structuredMarks == null ? '__' : paper.value!.structuredMarks.toString(),
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Essay',
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 10),
                                                                Text(
                                                                  paper.value == null ? '__' : paper.value!.essayMarks == null ? '__' : paper.value!.essayMarks.toString(),
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.only(top: 10,left:10,bottom: 0,right: 0),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF2F8F2),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push
                                                    (context,
                                                      MaterialPageRoute(builder: (context) => StudentPaperPositionPage(paper.key.paperId))
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF00C897),
                                                  foregroundColor: Colors.white,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                    )
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Text('LeaderBoard'),
                                                    SizedBox(width: 10),
                                                    Icon(Icons.arrow_forward),
                                                  ],
                                                ),

                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
