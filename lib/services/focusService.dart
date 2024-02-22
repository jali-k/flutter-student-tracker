

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/leaderboard_entries.dart';

class FocusService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static generateFocusId(){
    //generate random id
    return DateTime.now().millisecondsSinceEpoch;
  }

  static DocumentReference getFocusReference(String subjectName, String lessonId,String focusID){
    String userID = _auth.currentUser!.uid;
    return _firestore.collection('focusData').doc(focusID);
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
      'duration': duration,
      'startAt': DateTime.now(),
      'endAt': null,
      'lessonContent': lessonContent,
      'isCompleted': false,
    };
    // save on firestore subject -> subjectName -> lessons -> lessonId -> focus -> lessonContent ->userID with fields duration,startAt, endAt
    getFocusReference(subjectName, lessonId,focusID).set(focusData);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    focusData['startAt'] = focusData['startAt'].toIso8601String();
    prefs.setBool('enabledFocus', true);
    prefs.setString('focusData', jsonEncode(focusData));

  }

  static endFocusOnLesson() async {
    String userID = _auth.currentUser!.uid;
    String? lessonId;
    String? subjectName;
    String? focusID;

    SharedPreferences prefs =await SharedPreferences.getInstance();
    Map<String, dynamic> focusData = jsonDecode(prefs.getString('focusData')!);
    focusID = focusData['focusID'];
    lessonId = focusData['lessonID'];
    subjectName = focusData['subjectName'];
    DateTime startAt = DateTime.parse(focusData['startAt']);
    DateTime endAt = DateTime.now();
    //duration in minutes
    prefs.setBool('enabledFocus',false);
    prefs.remove('countDown');
    prefs.remove('focusData');

    // save on firestore subject -> subjectName -> lessons -> lessonId -> focus -> lessonContent ->userID with fields duration,startAt, endAt
    getFocusReference(subjectName!, lessonId!,focusID!).update({
      'endAt': DateTime.now(),
      'isCompleted': true,
    });
    prefs.setBool('enabledFocus', false);
  }

  static stopFocusOnLesson() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.setBool('enabledFocus',false);
    prefs.remove('countDown');
    Map<String, dynamic> focusData = jsonDecode(prefs.getString('focusData')!);
    String? focusID = focusData['focusID'];
    //remove focus data
    prefs.remove('focusData');
    // remove focus data from firestore
    getFocusReference(focusData['subjectName'], focusData['lessonID'],focusID!).delete();

  }

  static getStudentSubjectFocus(String subjectName) async {
    int totalFocus = 0;
    String userID = _auth.currentUser!.uid;
    QuerySnapshot focusData = await _firestore.collection('focusData').where('subjectName',isEqualTo: subjectName).where('userID',isEqualTo: userID).get();
    for (var doc in focusData.docs) {
      bool isCompleted = doc['isCompleted'] as bool;
      if(isCompleted){
        totalFocus += doc['duration'] as int;
      }
    }
    return totalFocus;

  }

  static Future<List<QueryDocumentSnapshot>> getFocusData() async {
    QuerySnapshot focusData = await _firestore.collection('focusData').where('userID',isEqualTo: _auth.currentUser!.uid).get();
    return focusData.docs;
  }

  static Future<List<LeaderBoardEntries>> getOverallLeaderBoardEntries() async {
    List<LeaderBoardEntries> leaderBoardEntries = [];
    QuerySnapshot focusData = await _firestore.collection('focusData').get();
    for (var doc in focusData.docs) {
      QuerySnapshot student =await _firestore.collection('students').where('uid',isEqualTo: doc['userID']).get();
      // if leaderBoardEntries contains student uid
      if (leaderBoardEntries.any((element) => element.uid == doc['userID'])) {
        //update marks
        int index = leaderBoardEntries.indexWhere((element) => element.uid == doc['userID']);
        leaderBoardEntries[index].marks += doc['duration'] as int;
      } else {
        //add new entry
        LeaderBoardEntries leaderBoardEntry = LeaderBoardEntries(
          uid: doc['userID'],
          marks: doc['duration'] as int,
          position: 0,
          name: student.docs[0]['name'],
        );
        leaderBoardEntries.add(leaderBoardEntry);
      }
    }
    print(leaderBoardEntries.length);
    leaderBoardEntries.sort((a, b) => a.marks.compareTo(b.marks));
    //reverse the list
    leaderBoardEntries = leaderBoardEntries.reversed.toList();
    //mark position
    for (int i = 0; i < leaderBoardEntries.length; i++) {
      leaderBoardEntries[i].position = i+1;
    }
    return leaderBoardEntries;
  }

static Future<List<LeaderBoardEntries>> getSubjectLeaderBoardEntries(String subject) async {
    List<LeaderBoardEntries> leaderBoardEntries = [];
    QuerySnapshot focusData = await _firestore.collection('focusData').where('subjectName',isEqualTo: subject).get();
    for (var doc in focusData.docs) {
      QuerySnapshot student =await _firestore.collection('students').where('uid',isEqualTo: doc['userID']).get();
      // if leaderBoardEntries contains student uid
      if (leaderBoardEntries.any((element) => element.uid == doc['userID'])) {
        //update marks
        int index = leaderBoardEntries.indexWhere((element) => element.uid == doc['userID']);
        leaderBoardEntries[index].marks += doc['duration'] as int;
      } else {
        //add new entry
        LeaderBoardEntries leaderBoardEntry = LeaderBoardEntries(
          uid: doc['userID'],
          marks: doc['duration'] as int,
          position: 0,
          name: student.docs[0]['name'],
        );
        leaderBoardEntries.add(leaderBoardEntry);
      }
    }
    print(leaderBoardEntries.length);
    leaderBoardEntries.sort((a, b) => a.marks.compareTo(b.marks));
    //reverse the list
    leaderBoardEntries = leaderBoardEntries.reversed.toList();
    //mark position
    for (int i = 0; i < leaderBoardEntries.length; i++) {
      leaderBoardEntries[i].position = i+1;
    }
    return leaderBoardEntries;
  }

  static Future<int> getOverallLeaderBoardPosition() async{
    List<LeaderBoardEntries> leaderBoardEntries = await getOverallLeaderBoardEntries();
    int position = leaderBoardEntries.indexWhere((element) => element.uid == _auth.currentUser!.uid);
    return (position+1);
  }



}