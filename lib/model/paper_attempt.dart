

import 'package:cloud_firestore/cloud_firestore.dart';

class AttemptPaper{
  int? essayMarks;
  int? mcqMarks;
  int? structuredMarks;
  int? totalMarks;
  String? paperId;
  int? studentId;
  int? position;

  AttemptPaper({this.essayMarks, this.mcqMarks, this.structuredMarks, this.totalMarks, this.paperId,this.studentId,this.position});

  static fromMap(DocumentSnapshot data) {
    return AttemptPaper(
      essayMarks: data['essayMarks'],
      mcqMarks: data['mcqMarks'],
      structuredMarks: data['structuredMarks'],
      totalMarks: data['totalMarks'],
      paperId: data['paperId'],
      studentId: data['studentId'],
      position: 0
    );
  }
}