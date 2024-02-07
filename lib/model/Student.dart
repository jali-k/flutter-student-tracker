
import 'package:cloud_firestore/cloud_firestore.dart';

class Student{
  String firstName;
  String lastName;
  String email;
  String uid;
  Timestamp createdAt;

  Student({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
    required this.createdAt
  });

  // convert a Student into a List
  List<String> toList() {
    return [firstName, lastName, email, uid, createdAt.toString()];
  }

  // convert a List into a Student
  factory Student.fromList(List<String> list) {
    return Student(
      firstName: list[0],
      lastName: list[1],
      email: list[2],
      uid: list[3],
      createdAt: list[4] as Timestamp
    );
  }

  // convert a Student into a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid,
      'createdAt': createdAt
    };
  }

  // convert a Map into a Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      uid: map['uid'],
      createdAt: map['createdAt']
    );
  }
}