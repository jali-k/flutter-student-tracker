

// import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'package:spt/model/student_all_mark_response_model.dart';
import 'package:spt/provider/attemptedPaperProvider.dart';
import 'package:spt/provider/paperProvider.dart';
import 'package:spt/services/mark_service.dart';
import 'package:spt/view/student/paper_leaderboard_page.dart';
import 'package:spt/view/student/student_paper_position_view.dart';

import '../../model/Paper.dart';
import '../../model/leaderboard_entries.dart';
import '../../model/paper_attempt.dart';
import '../../services/leaderboard_service.dart';
import '../../util/overlayUtil.dart';

class PaperDetailPage extends StatefulWidget {
  final List<MarkData> paperMarks;
  const PaperDetailPage({super.key, required this.paperMarks});

  @override
  State<PaperDetailPage> createState() => _PaperDetailPageState();
}

class _PaperDetailPageState extends State<PaperDetailPage> {
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

  ShowReleaseSoonBanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: //create fancy content with images
          Container(
            width: 300,
            height: 230,
            child: Column(
              children: [
                Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/cs.gif',width: 100,height: 100,)),
                Text('This feature will be ',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200)),
                Text('available soon',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200)),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF00C897),
                )
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPaperLeaderBoard();


    // _requestOverlayPermission(context);
    // showBubble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Papers'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                height: MediaQuery.of(context).size.height - 300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    itemCount: widget.paperMarks.length,
                                    itemBuilder: (context,index){
                                      MarkData markData = widget.paperMarks[index];
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        //Linear Color 00C897 to 245247
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF001906),
                                              Color(0xEE022720),
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
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    markData.markId != null ? '${markData.totalMark!} %' : 'N/A',
                                                    style: TextStyle(
                                                      /*
                                                      * background: linear-gradient(180deg, #1A8D71 0%, #FAFAFA 100%);
                                                      * */
                                                        foreground: Paint()..shader =LinearGradient(
                                                          colors: <Color>[Color(0xff1A8D71), Color(0xffFAFAFA)],
                                                        ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 40),
                                                    Text(
                                                      '${markData.paper!.paperName!}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    'MCQ Marks : ${markData.totalMark}',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),

                                                  child: Text(
                                                    'Structured Marks : ${markData.totalMark}',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),

                                                  child: Text(
                                                    'Essay Marks : ${markData.totalMark}',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      child: TextButton(
                                                        onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaperLeaderBoardPage(
                                                              selectedPaper: markData.paper!,
                                                              papers: widget.paperMarks.map((e) => e.paper!).toList()
                                                          )));
                                                        },
                                                        child: Text('Leader Board',style: TextStyle(color: Colors.white),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.local_fire_department_rounded,
                                                        color: Color(0xFFF2513B),
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '120',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ),

                                          ],
                                        ),
                                      );
                                    }
                                )
                            ),
                          ]),
                    ],
                  ),
                )),
          ],
        ),
      )
    );

  }
}
