// import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:spt/services/mark_service.dart';
import 'package:spt/view/student/student_paper_position_view.dart';

import '../../model/Paper.dart';
import '../../model/paper_attempt.dart';
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
  Map<ExamPaper,AttemptPaper> papers = {};
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
    Map<ExamPaper,AttemptPaper> p = await PaperMarksService.getStudentPapers();
    setState(() {
      papers = p;
      isLoadingPapers = false;
    });
  }

        @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPapers();


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
                            height: 220,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            //Linear Color 00C897 to 245247
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
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
                                color: Color(0xFF00C897),
                                width: 2,
                              ),
                              boxShadow: [
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      'Welcome',
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
                                    '\“ The whole secret of existence is to have no fear. Never fear what will become of you, depend on no one. Only the moment you reject all help are you freed \"',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Lord Buddha',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.height - 370,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var paper in papers.entries)
                                    Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width - 60,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
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
                                                      boxShadow: [
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
                                                          style: TextStyle(
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
                                                              paper.value.totalMarks.toString(),
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFFA30A0A),
                                                              ),
                                                            ),
                                                            Text(
                                                              '%',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight.bold,
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
                                              SizedBox(width: 10),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.white54,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 5),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/icons/fire_overall.png',
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                            Text(paper.value.position.toString(),
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
                                            padding: EdgeInsets.only(top: 10,left:10,bottom: 0,right: 0),
                                            decoration: BoxDecoration(
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
                                                child: Row(
                                                  children: [
                                                    Text('LeaderBoard'),
                                                    SizedBox(width: 10),
                                                    Icon(Icons.arrow_forward),
                                                  ],
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFF00C897),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                    )
                                                  ),
                                                ),

                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  if(!isLoadingPapers && papers.isEmpty)
                                    Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width - 60,
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
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
                                                        boxShadow: [
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
                                                            'No Papers Attempted',
                                                            style: TextStyle(
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
                                                                '0',
                                                                style: TextStyle(
                                                                  fontSize: 40,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Color(0xFFA30A0A),
                                                                ),
                                                              ),
                                                              Text(
                                                                '%',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                ),
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
                                        ],
                                      ),
                                    ),
                                  if(isLoadingPapers)
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width - 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 5,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white54,
                                              blurRadius: 5,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Loading Papers',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Center(child: CircularProgressIndicator())

                                          ],
                                        ),
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
