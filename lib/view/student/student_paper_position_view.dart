import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../layout/main_layout.dart';
import '../../model/Paper.dart';
import '../../model/leaderboard_entries.dart';
import '../../services/leaderboard_service.dart';

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
  final myID = FirebaseAuth.instance.currentUser!.uid;
  Map<String, List<LeaderBoardEntries>> _leaderBoard = {};
  List<ExamPaper> _papers = [];
  bool _loading = true;

  final StreamController<String> _paperBloc = StreamController<String>();
  final StreamController<int> _paperSelectorBloc = StreamController<int>();
  ScrollController _scrollController = ScrollController();

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
    Map<String, List<LeaderBoardEntries>> leaderBoard =
        await LeaderBoardService.getLeaderBoard();
    List<ExamPaper> papers = await LeaderBoardService.getAttemptedPapers();
    setState(() {
      _leaderBoard = leaderBoard;
      _papers = papers;
      _loading = false;
    });
  }

  getLeaderBoardForPaper(String paperId) {
    _paperBloc.add(paperId);
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height:
                      ((MediaQuery.of(context).size.height - 70) * 0.9) - 75,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    top: 50,
                  ),
                  color: Color(0xFFFAFAFA),
                  child: _loading
                      ? const CircularProgressIndicator()
                      : Column(
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
                            StreamBuilder<int>(
                                stream: _paperSelectorBloc.stream,
                                initialData: 0,
                                builder: (context, snapshot) {
                                  int index = snapshot.data!;
                                  ExamPaper paper = _papers[index];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (index > 0) {
                                              _paperSelectorBloc.sink
                                                  .add(index - 1);
                                              getLeaderBoardForPaper(
                                                  _papers[index - 1].paperId);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.arrow_left,
                                            color: Color(0xFF00C897),
                                          ),
                                        style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                            Size(10, 10),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 200,
                                        alignment: Alignment.center,
                                        child: Text(
                                          paper.paperName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (index < _papers.length - 1) {
                                            _paperSelectorBloc.sink.add(index + 1);
                                            getLeaderBoardForPaper(
                                                _papers[index + 1].paperId);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_right,
                                          color: Color(0xFF00C897),
                                        ),
                                        style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                            Size(10, 10),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 520,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              alignment: Alignment.topCenter,
                              // Leaderboard
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: StreamBuilder<Object>(
                                  stream: _paperBloc.stream,
                                  initialData: _papers[0].paperId,
                                  builder: (context, snapshot) {
                                    List<LeaderBoardEntries> entries =
                                        _leaderBoard[snapshot.data]!;
                                    return ListView.builder(
                                      controller: _scrollController,
                                      itemBuilder: (context, index) {
                                        if (entries[index].uid == myID) {
                                          navigateToPosition(
                                              entries[index].position);
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: CircleAvatar(
                                                    minRadius: 30,
                                                    backgroundColor:
                                                        Color(0xFF00C897),
                                                    child: Text(
                                                      '${entries[index].position}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${entries[index].name.length > 20 ? '${entries[index].name.substring(0, 20)}...' : entries[index].name}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              width: 10,
                                                            )),
                                                        Text(
                                                          '${entries[index].marks}',
                                                          style: TextStyle(
                                                            fontSize: 14,
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
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '${entries[index].position}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        entries[index].name.length > 20 ? '${entries[index].name.substring(0, 20)}...' : entries[index].name,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const Expanded(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            width: 10,
                                                          )),
                                                      Text(
                                                        '${entries[index].marks}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
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
                                      itemCount: entries.length,
                                      shrinkWrap: true,
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
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
                ))
          ],
        ),
      ),
    );
  }

  void changeIndex(int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 0)));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 1)));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 2)));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 3)));
        break;
      default:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainLayout(mainIndex: 0)));
        break;
    }
  }

  void navigateToPosition(int position) {
    _scrollController.animateTo(
      position * 70.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }
}
