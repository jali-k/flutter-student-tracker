
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spt/model/Paper.dart';

import '../model/paper_attempt.dart';

class PaperMarksService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static getPaperMarksReference() async {
    String userID = _auth.currentUser!.uid;
    QuerySnapshot marks =await  _firestore.collection('marks').where('studentId',isEqualTo: userID).get();
    print(marks.docs.length);
  }

  static Future<int> getLeaderboardPosition(String paperId,String studentId) async {
    QuerySnapshot marks = await  _firestore.collection('marks').where('paperId',isEqualTo: paperId).get();
    // sort the marks in descending order
    marks.docs.sort((a,b) => b['totalMarks'].compareTo(a['totalMarks']));
    int position = 1;
    for (var mark in marks.docs) {
      if(mark['studentId'] == studentId){
        return position;
      }
      position++;
    }
    return position;
  }

  static Future<Map<Paper,AttemptPaper>> getStudentPapers() async {
    String userID = _auth.currentUser!.uid;
    QuerySnapshot studentMarks = await _firestore.collection('marks').where('studentId',isEqualTo: userID).get();
    Map<Paper,AttemptPaper> papers = {};
    for (var mark in studentMarks.docs) {
      String paperId = mark['paperId'];
      QuerySnapshot paper = await _firestore.collection('papers').where('paperId',isEqualTo: paperId).get();
      if(paper.docs.isNotEmpty){
        Paper p = Paper.fromQuery(paper.docs[0]);
        AttemptPaper a = AttemptPaper(
          essayMarks: mark['essayMarks'],
          mcqMarks: mark['mcqMarks'],
          structuredMarks: mark['structuredMarks'],
          totalMarks: mark['totalMarks'],
          paperId: mark['paperId'],
          position:await getLeaderboardPosition(paperId,userID)
        );
        papers[p] = a;
      }
    }
    return papers;
  }
}