

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/Subject.dart';
import 'package:spt/model/focus_session_leaderboard_response_model.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/services/student_leaderboard_service.dart';

import '../../model/leaderboard_entries.dart';
import '../../model/subject_focus_session_leaderboard_response.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {

  final isSelected = [true, false, false, false, false];
  int selected = 0;
  late String myID;
  bool isloding = true;
  //scroll key
  final ScrollController _scrollController = ScrollController();
  // List<LeaderBoardEntries> leaderBoardEntries = [];
  // List<LeaderBoardEntries> overallEntries = [];
  // List<LeaderBoardEntries> biologyEntries = [];
  // List<LeaderBoardEntries> chemistryEntries = [];
  // List<LeaderBoardEntries> physicsEntries = [];
  // List<LeaderBoardEntries> agricultureEntries = [];

  List<FSLeaderboardPosition> overallPositions=[];
  List<FSLeaderboardPosition> biologyEntries=[];
  List<FSLeaderboardPosition> chemistryEntries=[];
  List<FSLeaderboardPosition> physicsEntries=[];
  List<FSLeaderboardPosition> agricultureEntries=[];
  List<FSLeaderboardPosition> leaderBoardEntries = [];


  Future<void> handleSelected(int i) async {
    for (int j = 0; j < isSelected.length; j++) {
      if (j == i) {
        isSelected[j] = true;
      } else {
        isSelected[j] = false;
      }
    }
    if(selected == i){
      return;
    }
      setState(() {
        isloding = true;
        leaderBoardEntries = [];
      });
      selected = i;
      if (i == 0) {
        leaderBoardEntries = overallPositions;
      } else if (i == 1) {
        setState(() {
          leaderBoardEntries = biologyEntries;
        });
      } else if (i == 2) {
        setState(() {
          leaderBoardEntries = chemistryEntries;
        });
      } else if (i == 3) {
        setState(() {
          leaderBoardEntries = physicsEntries;
        });
      } else if (i == 4) {
        setState(() {
          leaderBoardEntries = agricultureEntries;
        });
      }else{
        setState(() {
          leaderBoardEntries = overallPositions;
        });
      }
      setState(() {
        isloding = false;
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
  getLeaderboard();
    getSubjectLeaderboard();

  }

  getLeaderboard() async{
    FocusSessionLeaderboardResponseModel? focusSessionLeaderboardResponseModel = await StudentLeaderboardService.getFocusSessionOverallLeaderBoard();
    if(focusSessionLeaderboardResponseModel != null){
      setState(() {
        overallPositions = focusSessionLeaderboardResponseModel.data!;
        leaderBoardEntries = overallPositions;
        isloding = false;
      });
    }
  }
  getSubjectLeaderboard() async{
    SubjectFocusSessionLeaderboardResponse? focusSessionLeaderboardResponseModel = await StudentLeaderboardService.getSubjectFocusSessionOverallLeaderBoard();
    if(focusSessionLeaderboardResponseModel != null){
      setState(() {
        biologyEntries = focusSessionLeaderboardResponseModel.data!.biology!;
        chemistryEntries = focusSessionLeaderboardResponseModel.data!.chemistry!;
        physicsEntries = focusSessionLeaderboardResponseModel.data!.physics!;
        agricultureEntries = focusSessionLeaderboardResponseModel.data!.agriculture!;
        isloding = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *0.9,
      height: MediaQuery.of(context).size.height - 70,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // See Where You Stand
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('See ', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
                Text('where', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C897),
                ),),
                Text(' You Stand', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            // Overall, Biology, Chemistry, Physics, Agriculture Buttons
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(0);
                      });
                    },
                    child: Text('Overall', style: TextStyle(
                      color: isSelected[0] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[0] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(1);
                      });
                    },
                    child: Text('Biology', style: TextStyle(
                      color: isSelected[1] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[1] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(2);
                      });
                    },
                    child: Text('Chemistry', style: TextStyle(
                      color: isSelected[2] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[2] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(3);
                      });
                    },
                    child: Text('Physics', style: TextStyle(
                      color: isSelected[3] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[3] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(4);
                      });
                    },
                    child: Text('Agriculture', style: TextStyle(
                      color: isSelected[4] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[4] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
        ),
          SizedBox(height: 20,),
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
                    child: Text('Position', style: TextStyle(
                      fontSize: 12,
                    ),),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 12,
                  ),),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Minutes', style: TextStyle(
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
            child: leaderBoardEntries.isNotEmpty ?
            ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
              if(leaderBoardEntries[index].currentUser!)
                {
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
                            child: Text(leaderBoardEntries[index].leaderBoardRank.toString(), style: TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 4,
                          child: Text(leaderBoardEntries[index].studentName!, style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 2,
                          child: Text(leaderBoardEntries[index].totalFocusTime.toString(), style: TextStyle(
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
                        child: Text('${leaderBoardEntries[index].leaderBoardRank}', style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),),
                      ),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 4,
                      child: Text(
                        leaderBoardEntries[index].studentName!,
                        style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 2,
                      child: Text(leaderBoardEntries[index].totalFocusTime!.toString(), style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.right,),
                    ),
                  ],
                ),
              );
            },
              itemCount: leaderBoardEntries.length,
              shrinkWrap: true,
            ) : Center(
              child: isloding ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hold On Your Leaderboard is Loading"),
                  SizedBox(height: 10,),
                  CircularProgressIndicator()
                ],
              ) : Text('No Data Found'),
          ),
          ),
          SizedBox(height: 20,),


        ],
      ),
    );
  }


}
