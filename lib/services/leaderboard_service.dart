


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spt/model/Paper.dart';
import 'package:spt/model/leaderboard_entries.dart';

class LeaderBoardService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<Paper,List<LeaderBoardEntries>>> getLeaderBoard() async {
    QuerySnapshot marks = await _firestore.collection('marks').get();
    // Group the marks by paperId
    Map<Paper,List<LeaderBoardEntries>> groupedMarks = {};
    for (var mark in marks.docs) {
      QuerySnapshot paper = await _firestore.collection('papers').where('paperId',isEqualTo: mark['paperId']).get();
      if(paper.docs.isEmpty){
        continue;
      }
      Paper p = Paper.fromQuery(paper.docs[0]);
      String paperName = paper.docs[0]['paperName'];
      String paperId = mark['paperId'];
      if(groupedMarks.containsKey(p)){
        groupedMarks[p]!.add(LeaderBoardEntries(
          marks: mark['totalMarks'],
          name: mark['studentId'],
          position: 0,
        ));
      }else{
        groupedMarks[p] = [LeaderBoardEntries(
          marks: mark['totalMarks'],
          name: mark['studentId'].toString(),
          position: 0,
        )];
      }
    }
    // sort the marks in descending order inside the group
    for (var key in groupedMarks.keys) {
      groupedMarks[key]!.sort((a,b) => b.marks.compareTo(a.marks));
    }
    // assign positions
    for (var key in groupedMarks.keys) {
      int position = 1;
      for (var entry in groupedMarks[key]!) {
        entry.position = position;
        position++;
      }
    }
    print(groupedMarks);
    return groupedMarks;
  }


}