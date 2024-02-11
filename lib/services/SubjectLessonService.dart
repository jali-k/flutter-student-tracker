

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectLessonService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getSubject(String subjectName) async {
    String userID = _auth.currentUser!.uid;
    QuerySnapshot subjects = await _firestore.collection('subjects').where('studentId',isEqualTo: userID).get();
    for (var subject in subjects.docs) {
      if(subject['subjectName'] == subjectName){
        return subject;
      }
    }
  }


  static Future<QueryDocumentSnapshot> getLessonById(String subjectId,String lessonId) async {
    QuerySnapshot snap =  await _firestore
        .collection('subject')
        .doc(subjectId)
        .collection('lessons').get();
    return snap.docs.where((element) => element.id == lessonId).first;

  }
}