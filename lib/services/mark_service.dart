
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spt/model/Paper.dart';

import '../model/paper_attempt.dart';

class PaperMarksService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static getPaperMarksReference() async {
    String userID = _auth.currentUser!.uid;
    //get student registration number
    DocumentSnapshot student = await _firestore.collection('students').doc(userID).get();
    if(student.exists){
      int registrationNumber = student['registrationNumber'];
      QuerySnapshot marks =await  _firestore.collection('marks').where('studentId',isEqualTo: registrationNumber).get();
      return marks.docs;
    }
    return null;


  }

  static Future<int> getLeaderboardPosition(String paperId,int studentId) async {
    QuerySnapshot marks = await  _firestore.collection('marks').where('paperId',isEqualTo: paperId).get();
    // sort the marks in descending order
    List sortedMarks =marks.docs;
    sortedMarks.sort((a,b) => b['totalMarks'].compareTo(a['totalMarks']));
    int position = 1;
    print("Marks length: ${marks.docs.length}");
    for (var mark in sortedMarks) {
      if(mark['studentId'] == studentId){
        return position;
      }
      position++;
    }
    return position;
  }

  // static Future<Map<ExamPaper,AttemptPaper>> getStudentPapers() async {
  //   String userID = _auth.currentUser!.uid;
  //   QuerySnapshot student = await _firestore.collection('students').where('uid',isEqualTo: userID).get();
  //   int registrationNumber = student.docs[0]['registrationNumber'];
  //   QuerySnapshot studentMarks = await _firestore.collection('marks').where('studentId',isEqualTo: registrationNumber).get();
  //   Map<ExamPaper,AttemptPaper> papers = {};
  //   for (var mark in studentMarks.docs) {
  //     String paperId = mark['paperId'];
  //     QuerySnapshot paper = await _firestore.collection('papers').where('paperId',isEqualTo: paperId).get();
  //     if(paper.docs.isNotEmpty){
  //       int studentId = mark['studentId'];
  //       ExamPaper p = ExamPaper.fromQuery(paper.docs[0]);
  //       AttemptPaper a = AttemptPaper(
  //         essayMarks: mark['essayMarks'],
  //         mcqMarks: mark['mcqMarks'],
  //         structuredMarks: mark['structuredMarks'],
  //         totalMarks: mark['totalMarks'],
  //         paperId: mark['paperId'],
  //         position:await getLeaderboardPosition(paperId,studentId),
  //         paperName: p.paperName,
  //       );
  //       papers[p] = a;
  //     }
  //   }
  //   print("Papers length: ${papers.entries.map((e) => e.value.position).toList()}");
  //   return papers;
  // }

  static Future<Map<ExamPaper,AttemptPaper?>> getStudentPapers() async {
    String userID = _auth.currentUser!.uid;
    QuerySnapshot student = await _firestore.collection('students').where('uid',isEqualTo: userID).get();
    int registrationNumber = student.docs[0]['registrationNumber'];
    QuerySnapshot studentMarks = await _firestore.collection('marks').where('studentId',isEqualTo: registrationNumber).get();
    Map<ExamPaper,AttemptPaper?> papers = {};
    for (var mark in studentMarks.docs) {
      String paperId = mark['paperId'];
      QuerySnapshot paper = await _firestore.collection('papers').where('paperId',isEqualTo: paperId).get();
      if(paper.docs.isNotEmpty){
        int studentId = mark['studentId'];
        ExamPaper p = ExamPaper.fromQuery(paper.docs[0]);
        AttemptPaper a = AttemptPaper(
          essayMarks: mark['essayMarks'],
          mcqMarks: mark['mcqMarks'],
          structuredMarks: mark['structuredMarks'],
          totalMarks: mark['totalMarks'],
          paperId: mark['paperId'],
          position:await getLeaderboardPosition(paperId,studentId),
          paperName: p.paperName,
        );
        papers[p] = a;
      }
    }
    //get all papers and set it to the papers map and make values to null
    QuerySnapshot allPapers = await _firestore.collection('papers').get();
    List<String> paperIds = papers.keys.map((e) => e.paperId).toList();
    for (var paper in allPapers.docs) {
      ExamPaper p = ExamPaper.fromQuery(paper);
      if(!paperIds.contains(p.paperId)){
        papers[p] = null;
      }
    }
    return papers;
  }

  static Future<QuerySnapshot> getPaperByID(String id) async {
    print("Paper ID: $id");

    return await _firestore.collection('papers').where('paperId',isEqualTo: id).get();
  }
}