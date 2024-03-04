

import 'package:spt/model/paper_attempt.dart';

class StudentDetails{
  String name;
  String email;
  int registrationNumber;
  String uid;
  List<FocusData> focusData;
  List<AttemptPaper> attemptPapers;

  StudentDetails({
    required this.name,
    required this.email,
    required this.registrationNumber,
    required this.uid,
    required this.focusData,
    required this.attemptPapers
  });
}

class FocusData{
  int duration;
  DateTime endAt;
  String focusID;
  bool isCompleted;
  String lessonContent;
  String lessonID;
  DateTime startAt;
  String subjectName;

  FocusData({
    required this.duration,
    required this.endAt,
    required this.focusID,
    required this.isCompleted,
    required this.lessonContent,
    required this.lessonID,
    required this.startAt,
    required this.subjectName
  });
}