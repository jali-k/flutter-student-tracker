import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/Subject.dart';
import 'package:spt/model/focus_session_leaderboard_response_model.dart';
import 'package:spt/model/student_all_mark_response_model.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/services/student_leaderboard_service.dart';

import '../../model/leaderboard_entries.dart';
import '../../model/subject_focus_session_leaderboard_response.dart';

class PaperLeaderBoardPage extends StatefulWidget {
  List<PaperData> papers;
  PaperData selectedPaper;

  PaperLeaderBoardPage(
      {super.key, required this.papers, required this.selectedPaper});

  @override
  State<PaperLeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<PaperLeaderBoardPage> {
  late List<bool> isSelected ;
  int selected = 0;
  late String myID;
  bool isloding = true;
  bool noData = true;
  late PaperData selectPaper;

  //scroll key
  final ScrollController _scrollController = ScrollController();

  // List<LeaderBoardEntries> leaderBoardEntries = [];
  // List<LeaderBoardEntries> overallEntries = [];
  // List<LeaderBoardEntries> biologyEntries = [];
  // List<LeaderBoardEntries> chemistryEntries = [];
  // List<LeaderBoardEntries> physicsEntries = [];
  // List<LeaderBoardEntries> agricultureEntries = [];

  List<FSLeaderboardPosition> leaderBoardEntries = [];

  Future<void> handleSelected(PaperData i) async {
    setState(() {
      selectPaper = i;
      isSelected[selected] = true;
      getLeaderboard(i.paperId!);
    });
  }

  void navigateToPosition(int position) {
    _scrollController.animateTo(
      position * 70.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = List.generate(widget.papers.length, (index) => false);
    int index = widget.papers.indexWhere((element) => element.paperId == widget.selectedPaper.paperId);
    isSelected[index] = true;
    selectPaper = widget.selectedPaper;
    getLeaderboard(widget.selectedPaper.paperId!);
  }

  getLeaderboard(String paperID) async {
    FocusSessionLeaderboardResponseModel? focusSessionLeaderboardResponseModel =
        await StudentLeaderboardService.getPaperLeaderboard(paperID);
    if (focusSessionLeaderboardResponseModel != null) {
      setState(() {
        leaderBoardEntries = focusSessionLeaderboardResponseModel.data!;
        isloding = false;
        noData = false;
      });
    } else {
      setState(() {
        leaderBoardEntries = [];
        isloding = false;
        noData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectPaper.paperName} Leaderboard', style: TextStyle(color: Colors.black,fontSize: 14),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height - 70,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                // Overall, Biology, Chemistry, Physics, Agriculture Buttons
                child: ListView.builder(
                    itemCount: widget.papers.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              handleSelected(widget.papers[index]!);
                            });
                          },
                          child: Text(
                            widget.papers[index].paperName!.length > 30
                                ? widget.papers[index].paperName!.substring(0, 30)
                                : widget.papers[index].paperName!,
                            style: TextStyle(
                              color:Colors.white
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                widget.papers[index] == selectPaper ? Color(0xFF00C897) : Colors.black87
                            ),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Color(0xFF00C897)),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
            SizedBox(
              height: 20,
            ),
            // Add Heading
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Position',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total Mark',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 300,
              // Leaderboard
              child: leaderBoardEntries.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (leaderBoardEntries[index].currentUser!) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            // navigateToPosition(index);
                          });
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xFF00C897),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      leaderBoardEntries[index]
                                          .leaderBoardRank
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    leaderBoardEntries[index].studentName!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    leaderBoardEntries[index]
                                        .totalFocusTime
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${leaderBoardEntries[index].leaderBoardRank}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  leaderBoardEntries[index].studentName!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  leaderBoardEntries[index]
                                      .totalMarks!
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: leaderBoardEntries.length,
                      shrinkWrap: true,
                    )
                  : noData ?
                  Text('No Data Found')
                  : Center(
                      child: isloding
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Hold On Your Leaderboard is Loading"),
                                SizedBox(
                                  height: 10,
                                ),
                                CircularProgressIndicator()
                              ],
                            )
                          : Text('No Data Found'),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
