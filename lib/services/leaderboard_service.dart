import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spt/model/Paper.dart';
import 'package:spt/model/leaderboard_entries.dart';

class LeaderBoardService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, List<LeaderBoardEntries>>> getLeaderBoard() async {
    QuerySnapshot marks = await _firestore.collection('marks').get();

    QuerySnapshot papers = await _firestore.collection('papers').get();
    QuerySnapshot students = await _firestore.collection('students').get();
    List<ExamPaper> paperList = [];

    Map<String, List<LeaderBoardEntries>> groupedMarks = {};
    marks.docs.forEach((mark) {
      String paperId = mark['paperId'];
      bool isExist =
          papers.docs.any((element) => element['paperId'] == paperId);
      if (isExist) {
        QueryDocumentSnapshot? paper =
            papers.docs.firstWhere((element) => element['paperId'] == paperId);
        ExamPaper p = ExamPaper.fromQuery(paper);
        // get Student by Student ID If not found then return null
        bool isStudentExist = students.docs.any(
            (element) => element['registrationNumber'] == mark['studentId']);
        String name = 'Unknown';
        if (isStudentExist) {
          QueryDocumentSnapshot student = students.docs.firstWhere(
              (element) => element['registrationNumber'] == mark['studentId']);
          name = student['name'];
        }
        // String name = student.exists ? student['firstName'] : 'Unknown';

        paperList.add(p);
        if (groupedMarks[paperId] == null) {
          groupedMarks[paperId] = [];
        }
        List<dynamic> studentIDs = students.docs
            .map((e) => e['registrationNumber'])
            .toList();
        print('Student ID : ${mark['studentId']}');
        print(studentIDs);
        bool isExist = studentIDs.contains(mark['studentId']);

        if(isExist){
          groupedMarks[paperId]!.add(
            LeaderBoardEntries(
              name: name,
              marks: mark['totalMarks'],
              position: 0,
              uid: students.docs
                  .firstWhere((element) =>
              element['registrationNumber'] == mark['studentId'])
                  .id,
            ),
          );
        }
      }
    });

    // add position based on marks
    groupedMarks.forEach((key, value) {
      value.sort((a, b) => b.marks!.compareTo(a.marks!));
      for (int i = 0; i < value.length; i++) {
        value[i].position = i + 1;
      }
    });

    return groupedMarks;
  }

  static Future<List<ExamPaper>> getAttemptedPapers() async {
    QuerySnapshot marks = await _firestore.collection('marks').get();

    QuerySnapshot papers = await _firestore.collection('papers').get();
    List<ExamPaper> paperList = [];

    Map<String, List<LeaderBoardEntries>> groupedMarks = {};
    marks.docs.forEach((mark) {
      String paperId = mark['paperId'];
      bool isExist =
          papers.docs.any((element) => element['paperId'] == paperId);
      if(isExist){
        QueryDocumentSnapshot? paper =
        papers.docs.firstWhere((element) => element['paperId'] == paperId);
        ExamPaper p = ExamPaper.fromQuery(paper);
        paperList.add(p);
      }
    });
    return paperList;
  }
}
