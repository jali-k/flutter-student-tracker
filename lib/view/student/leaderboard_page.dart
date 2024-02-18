

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/Subject.dart';
import 'package:spt/services/focusService.dart';

import '../../model/leaderboard_entries.dart';

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
  List<LeaderBoardEntries> leaderBoardEntries = [];
  List<LeaderBoardEntries> overallEntries = [];
  List<LeaderBoardEntries> biologyEntries = [];
  List<LeaderBoardEntries> chemistryEntries = [];
  List<LeaderBoardEntries> physicsEntries = [];
  List<LeaderBoardEntries> agricultureEntries = [];

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
      if (i == 0) {
        leaderBoardEntries = overallEntries;
      } else if (i == 1) {
        leaderBoardEntries = biologyEntries;
      } else if (i == 2) {
        leaderBoardEntries = chemistryEntries;
      } else if (i == 3) {
        leaderBoardEntries = physicsEntries;
      } else if (i == 4) {
        leaderBoardEntries = agricultureEntries;
      }else{
        leaderBoardEntries = overallEntries;
      }
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
    getStudentLeaderBoard();
    myID = FirebaseAuth.instance.currentUser!.uid;

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
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 300,
            // Leaderboard
            child: leaderBoardEntries.length > 0 ? ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
              if(leaderBoardEntries[index].uid == myID)
                {
                  navigateToPosition(index);
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(leaderBoardEntries[index].position.toString(), style: TextStyle(
                              fontSize: 14,
                            ),),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 3,
                          child: Text(leaderBoardEntries[index].name, style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 2,
                          child: Text(leaderBoardEntries[index].marks.toString(), style: TextStyle(
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
                        child: Text('${leaderBoardEntries[index].position}', style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),),
                      ),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 4,
                      child: Text(
                        leaderBoardEntries[index].name,
                        style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 2,
                      child: Text(leaderBoardEntries[index].marks.toString(), style: TextStyle(
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
              child: isloding ? CircularProgressIndicator() : Text('No Data Found'),
          ),
          ),
          SizedBox(height: 20,),


        ],
      ),
    );
  }

  Future<void> getStudentLeaderBoard() async {
    List<LeaderBoardEntries> overallEntries =await FocusService.getOverallLeaderBoardEntries();
    List<LeaderBoardEntries> biologyEntries =await FocusService.getSubjectLeaderBoardEntries(Subject.BIOLOGY);
    List<LeaderBoardEntries> chemistryEntries =await FocusService.getSubjectLeaderBoardEntries(Subject.CHEMISTRY);
    List<LeaderBoardEntries> physicsEntries =await FocusService.getSubjectLeaderBoardEntries(Subject.PHYSICS);
    List<LeaderBoardEntries> agricultureEntries =await FocusService.getSubjectLeaderBoardEntries(Subject.AGRICULTURE);
    setState(() {
      leaderBoardEntries = overallEntries;
      this.overallEntries = overallEntries;
      this.biologyEntries = biologyEntries;
      this.chemistryEntries = chemistryEntries;
      this.physicsEntries = physicsEntries;
      this.agricultureEntries = agricultureEntries;
      isloding = false;
    });
  }

}
