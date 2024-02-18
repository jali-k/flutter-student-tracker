

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService{
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> sendNotification(String title, String body, String uid) async {
    await _firestore.collection('notification').add({
      'title': title,
      'body': body,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

  static Future<QuerySnapshot<Object?>> getNotifications() async{
   //get notifications only date is 7 days ago
    QuerySnapshot q =  await _firestore.collection('notification').
    where('date', isGreaterThan: DateTime.now().subtract(Duration(days: 7))).orderBy('date',descending: true).get();
    //filter notifications for the user by target = user registration number
    return q;
  }
}