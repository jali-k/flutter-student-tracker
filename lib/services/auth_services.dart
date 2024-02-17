import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/globals.dart';
import 'dart:math' as math;
import 'package:spt/model/StudentCSV.dart';
import 'package:spt/services/api_provider.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      _firestore.collection('students').doc(user!.uid).set({
        'uid': user.uid,
        'email': user.email,
      });
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  static Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('email: $email, password: $password');
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<User?> getCurrentUser() {
    User? user = _auth.currentUser;
    return Future.value(user);
  }

  static void signOut() async{
    _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void changePassword({required String oldPassword, required String newPassword, required BuildContext context}) {
    User? user = _auth.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: oldPassword);
    user.reauthenticateWithCredential(credential).then((value) {
      user.updatePassword(newPassword).then((_) {
        Globals.showSnackBar(context: context, message: "Password changed successfully",isSuccess: true);
      }).catchError((error) {
        Globals.showSnackBar(context: context, message: "Password can't be changed" + error.toString(),isSuccess: false);
      });
    }).catchError((error) {
      Globals.showSnackBar(context: context, message: "Password can't be changed" + error.toString(),isSuccess: false);
    });
  }

  static Future<void> createStudents(List<List> fields,BuildContext context) async {
    final Dio dio = Dio();
    Response res = await dio.post('${APIProvider.BASE_URL}/csv', data: {
      'fields': jsonEncode(fields),
    });
    if(res.data == []) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Students created successfully'),
        backgroundColor: Colors.green,
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error creating students'),
        backgroundColor: Colors.red,
      ));
    }
  }


}
