import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spt/model/lectures.dart';

class Folder{
  List<dynamic> emailList;
  String folderName;
  Timestamp videoUploadedDate;
  List<Lecture> videoList = [];

  Folder({required this.emailList, required this.folderName, required this.videoUploadedDate});


  bool isUserInFolder(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    String userEmail = _auth.currentUser!.email.toString();
    return emailList.contains(userEmail);
  }

  setVideoList(List<Lecture> videoList){
    this.videoList = videoList;
  }

  factory Folder.fromJson(Map<String, dynamic> json){
    return Folder(
      emailList: json['emailList'],
      folderName: json['folderName'],
      videoUploadedDate: json['videoUploadedDate']
    );
  }

  factory Folder.fromMap(Map<String, dynamic> map){
    return Folder(
      emailList: map['emailList'],
      folderName: map['folderName'],
      videoUploadedDate: map['videoUploadedDate']
    );
  }

  Map<String, dynamic> toJson() => {
    'emailList': emailList,
    'folderName': folderName,
    'videoUploadedDate': videoUploadedDate
  };
}