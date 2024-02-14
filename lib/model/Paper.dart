

import 'package:cloud_firestore/cloud_firestore.dart';

class ExamPaper{
  int id;
  String paperId;
  String paperName;
  bool isEssay;
  bool isMcq;
  bool isStructured;

  ExamPaper({required this.id, required this.paperId, required this.paperName, required this.isEssay, required this.isMcq, required this.isStructured});

  factory ExamPaper.fromJson(Map<String, dynamic> json) {
    return ExamPaper(
      id: json['id'],
      paperId: json['paperId'],
      paperName: json['paperName'],
      isEssay: json['isEssay'],
      isMcq: json['isMcq'],
      isStructured: json['isStructured'],
    );
  }

  factory ExamPaper.fromQuery(QueryDocumentSnapshot snapshot) {
    return ExamPaper(
      id: snapshot['id'],
      paperId: snapshot['paperId'],
      paperName: snapshot['paperName'],
      isEssay: snapshot['isEssay'],
      isMcq: snapshot['isMcq'],
      isStructured: snapshot['isStructured'],
    );
  }
}