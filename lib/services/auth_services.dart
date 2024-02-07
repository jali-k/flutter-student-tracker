import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/Student.dart';

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
      Student? student = await _firestore.collection('students').doc(user!.uid).get().then((value) => Student(
        firstName: value.get('firstName'),
        lastName: value.get('lastName'),
        email: value.get('email'),
        uid: value.get('uid'),
        createdAt: value.get('createdAt')
      ));
      // save on shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', student!.uid);
      prefs.setStringList('user', student.toList());
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
}
