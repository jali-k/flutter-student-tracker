import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture{
  //date , description. docId, lessons, title, videoId, videoPath, videoUploadedDate
  String date;
  String description;
  String docId;
  String lessons;
  String title;
  String videoId;
  String videoPath;
  Timestamp videoUploadedDate;

  Lecture({required this.date, required this.description, required this.docId, required this.lessons, required this.title, required this.videoId, required this.videoPath, required this.videoUploadedDate});

  factory Lecture.fromJson(Map<String, dynamic> json){
    return Lecture(
      date: json['date'],
      description: json['description'],
      docId: json['docId'],
      lessons: json['lessons'],
      title: json['title'],
      videoId: json['videoId'],
      videoPath: json['videoPath'],
      videoUploadedDate: json['videoUploadedDate']
    );
  }

  factory Lecture.fromMap(Map<String, dynamic> map){
    return Lecture(
      date: map['date'],
      description: map['description'],
      docId: map['docId'],
      lessons: map['lessons'],
      title: map['title'],
      videoId: map['videoId'],
      videoPath: map['videoPath'],
      videoUploadedDate: map['videoUploadedDate']
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'description': description,
    'docId': docId,
    'lessons': lessons,
    'title': title,
    'videoId': videoId,
    'videoPath': videoPath,
    'videoUploadedDate': videoUploadedDate
  };
}