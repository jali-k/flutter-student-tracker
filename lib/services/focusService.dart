

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static generateFocusId(){
    //generate random id
    return DateTime.now().millisecondsSinceEpoch;
  }

  static CollectionReference getFocusReference(String subjectName, String lessonId,String focusID){
    String userID = _auth.currentUser!.uid;
    return _firestore.collection('focusData').doc(subjectName).collection("lessons").doc(lessonId).collection(focusID);
  }

  static focusOnLesson(QueryDocumentSnapshot lesson, String lessonContent, int duration,String subjectName) async {
    String userID = _auth.currentUser!.uid;
    String focusID = generateFocusId().toString();
    String lessonId = lesson.id;

    Map<String, dynamic> focusData = {
      'focusID': focusID, //generate random id
      'lessonID': lessonId, //lesson id
      'subjectName': subjectName, //subject name
      'userID': userID,
      'duration': 0,
      'startAt': DateTime.now(),
      'endAt': null,
      'lessonContent': lessonContent,
      'isCompleted': false,
    };
    // save on firestore subject -> subjectName -> lessons -> lessonId -> focus -> lessonContent ->userID with fields duration,startAt, endAt
    getFocusReference(subjectName, lessonId,focusID).doc(userID).set(focusData);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    focusData['startAt'] = focusData['startAt'].toIso8601String();
    prefs.setString('enabledFocus', true.toString());
    prefs.setString('focusData', jsonEncode(focusData));

  }

  static endFocusOnLesson() async {
    String userID = _auth.currentUser!.uid;
    String? lessonId;
    String? subjectName;
    String? focusID;
    int duration = 0;
    SharedPreferences prefs =await SharedPreferences.getInstance();
    Map<String, dynamic> focusData = jsonDecode(prefs.getString('focusData')!);
    print(focusData);
    focusID = focusData['focusID'];
    lessonId = focusData['lessonID'];
    subjectName = focusData['subjectName'];
    DateTime startAt = DateTime.parse(focusData['startAt']);
    DateTime endAt = DateTime.now();
    //duration in minutes
    duration = endAt.difference(startAt).inSeconds;

    // save on firestore subject -> subjectName -> lessons -> lessonId -> focus -> lessonContent ->userID with fields duration,startAt, endAt
    getFocusReference(subjectName!, lessonId!,focusID!).doc(userID).update({
      'duration': duration,
      'endAt': DateTime.now(),
      'isCompleted': true,
    });
    prefs.setString('enabledFocus', false.toString());
  }

  static getStudentSubjectFocus(String subjectName) async {
    String userID = _auth.currentUser!.uid;
    QuerySnapshot focusData = await _firestore.collection('focusData').doc(subjectName).collection("lessons").get();
    print(focusData.docs);

  }

}