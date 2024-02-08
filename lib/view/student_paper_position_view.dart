import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../layout/main_layout.dart';
import '../model/Paper.dart';
import '../model/leaderboard_entries.dart';
import '../services/leaderboard_service.dart';

class StudentPaperPositionPage extends StatefulWidget {
  final String paperId;
  const StudentPaperPositionPage(this.paperId, {super.key});

  @override
  State<StudentPaperPositionPage> createState() =>
      _StudentPaperPositionPageState();
}

class _StudentPaperPositionPageState extends State<StudentPaperPositionPage> {
  final isSelected = [true, false, false, false, false];
  int selected = 0;
  final myID = 5;
  Map<Paper,List<LeaderBoardEntries>> _leaderBoard = {};

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

  void getPaperLeaderBoard() async {
    Map<Paper,List<LeaderBoardEntries>> leaderBoard = await LeaderBoardService.getLeaderBoard();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaperLeaderBoard();
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
                child:  Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    top: 50,
                  ),
                  color: Color(0xFFFAFAFA),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // See Where You Stand
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'where',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00C897),
                              ),
                            ),
                            Text(
                              ' You Stand',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        // Overall, Biology, Chemistry, Physics, Agriculture Buttons
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Color(0xFF00C897),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_left,
                                    color: Color(0xFF00C897),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Paper 1"),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Color(0xFF00C897),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_right,
                                    color: Color(0xFF00C897),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 620,
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                        alignment: Alignment.center,
                        // Leaderboard
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == myID) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                        minRadius: 30,
                                        backgroundColor: Color(0xFF00C897),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00C897),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Student ${index + 1}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: 10,
                                                )),
                                            Text(
                                              '100',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index * 1000 + 1}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Student ${index + 1}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: 10,
                                              )),
                                          Text(
                                            '100',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: 100,
                          shrinkWrap: true,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
                      initialLabelIndex: 2,
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

  void changeIndex(int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 0)));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 1)));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 2)));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 3)));
        break;
      default:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 0)));
        break;
    }
  }
}
