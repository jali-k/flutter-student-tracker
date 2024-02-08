

import 'package:cloud_firestore/cloud_firestore.dart';

class Paper{
  int id;
  String paperId;
  String paperName;
  bool isEssay;
  bool isMcq;
  bool isStructured;

  Paper({required this.id, required this.paperId, required this.paperName, required this.isEssay, required this.isMcq, required this.isStructured});

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'],
      paperId: json['paperId'],
      paperName: json['paperName'],
      isEssay: json['isEssay'],
      isMcq: json['isMcq'],
      isStructured: json['isStructured'],
    );
  }

  factory Paper.fromQuery(QueryDocumentSnapshot snapshot) {
    return Paper(
      id: snapshot['id'],
      paperId: snapshot['paperId'],
      paperName: snapshot['paperName'],
      isEssay: snapshot['isEssay'],
      isMcq: snapshot['isMcq'],
      isStructured: snapshot['isStructured'],
    );
  }
}