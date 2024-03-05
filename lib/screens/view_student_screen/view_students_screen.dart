


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/paper_attempt.dart';
import '../../model/student_details.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<StudentDetails> studentDetails = [];
  Map<String,Map<String,int> > focusDataBySubjectAndLesson = {};
  Map<String,String> lessonIdToLessonName = {};
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLessons();
    fetchStudents();

  }

  getLessons() async {
    //get all the lessons from firestore
    Map<String,String> _lessonIdToLessonName = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('lessons').get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      _lessonIdToLessonName[documentSnapshot.id] = documentSnapshot.get('name');
    }
    setState(() {
      lessonIdToLessonName = _lessonIdToLessonName;
    });

  }

  Future<void> fetchStudents() async {
    List<StudentDetails> _studentDetails = [];
    //get students from firestore of Instructors collection where the instructor id is the current user id
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Instructors')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    List<int> students = data['students'].cast<int>();
    for (int student in students) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('registrationNumber', isEqualTo: student)
          .get();
      List<FocusData> focusData = [];
      List<AttemptPaper> attemptPapers = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        QuerySnapshot focusDataQuerySnapshot = await FirebaseFirestore.instance
            .collection('focusData')
            .where('userID', isEqualTo: documentSnapshot.id)
            .get();
        for (DocumentSnapshot focusDataDocumentSnapshot
            in focusDataQuerySnapshot.docs) {
          focusData.add(FocusData(
            duration: focusDataDocumentSnapshot.get('duration'),
            endAt: focusDataDocumentSnapshot.get('endAt'),
            focusID: focusDataDocumentSnapshot.id,
            isCompleted: focusDataDocumentSnapshot.get('isCompleted'),
            lessonContent: focusDataDocumentSnapshot.get('lessonContent'),
            lessonID: focusDataDocumentSnapshot.get('lessonID'),
            startAt: focusDataDocumentSnapshot.get('startAt'),
            subjectName: focusDataDocumentSnapshot.get('subjectName'),
          ));
        }
        QuerySnapshot attemptPapersQuerySnapshot = await FirebaseFirestore.instance
            .collection('marks')
            .where('studentId', isEqualTo: student)
            .get();
        for (DocumentSnapshot attemptPapersDocumentSnapshot in attemptPapersQuerySnapshot.docs) {
          String paperId = attemptPapersDocumentSnapshot.get('paperId');
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('papers')
              .where('paperId', isEqualTo: paperId)
              .get();
          attemptPapers.add(AttemptPaper(
            essayMarks: attemptPapersDocumentSnapshot.get('essayMarks'),
            mcqMarks: attemptPapersDocumentSnapshot.get('mcqMarks'),
            paperId: attemptPapersDocumentSnapshot.get('paperId'),
            paperName: querySnapshot.docs[0].get('paperName'),
            position: 0,
            structuredMarks: attemptPapersDocumentSnapshot.get('structuredMarks'),
            studentId: attemptPapersDocumentSnapshot.get('studentId'),
            totalMarks: attemptPapersDocumentSnapshot.get('totalMarks'),
          ));
        }
        StudentDetails std = StudentDetails(
          name: documentSnapshot.get('name'),
          email: documentSnapshot.get('email'),
          registrationNumber: documentSnapshot.get('registrationNumber'),
          uid: documentSnapshot.id,
          focusData: focusData,
          attemptPapers: attemptPapers,
        );
        _studentDetails.add(std);
      }
    }
    setState(() {
      studentDetails = _studentDetails;
      isLoading = false;
    });
  }

  showStudentDetails(StudentDetails studentDetails) {
    //show the student's details as a dialog AlertDialog FocusData and AttemptPapers
    focusDataBySubjectAndLesson = {};
    for (FocusData focusData in studentDetails.focusData) {
      if (focusDataBySubjectAndLesson.containsKey(focusData.subjectName)) {
        if (focusDataBySubjectAndLesson[focusData.subjectName]!.containsKey(focusData.lessonContent)) {
          focusDataBySubjectAndLesson[focusData.subjectName]?[focusData.lessonID] =focusDataBySubjectAndLesson[focusData.subjectName]![focusData.lessonContent]! + focusData.duration;
        } else {
          focusDataBySubjectAndLesson[focusData.subjectName]?[focusData.lessonID] = focusData.duration;
        }
      } else {
        focusDataBySubjectAndLesson[focusData.subjectName] = {focusData.lessonID: focusData.duration};
      }
    }
    print(focusDataBySubjectAndLesson);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(studentDetails.name),
          content: Container(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              children: [
                Text('Email: ${studentDetails.email}',textAlign: TextAlign.start,),
                Text('Registration Number: ${studentDetails.registrationNumber}',textAlign: TextAlign.start),
                SizedBox(height: 10),
                Container(
                  height: 35,
                  child: Text(
                    'Focus Data',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: (MediaQuery.of(context).size.height - 400)/2,
                  child: ListView.builder(
                    itemCount: studentDetails.focusData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(studentDetails.focusData[index].subjectName),
                        subtitle: Text(lessonIdToLessonName[studentDetails.focusData[index].lessonID]!),
                        trailing: Text('${focusDataBySubjectAndLesson[studentDetails.focusData[index].subjectName]![studentDetails.focusData[index].lessonID]!} mins'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 35,
                  child: Text(
                    'Attempt Papers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //marks
                Container(
                  height: (MediaQuery.of(context).size.height - 400)/2,
                  child: ListView.builder(
                    itemCount: studentDetails.attemptPapers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(studentDetails.attemptPapers[index].paperName!),
                        subtitle: Text('MCQ: ${studentDetails.attemptPapers[index].mcqMarks} Structured: ${studentDetails.attemptPapers[index].structuredMarks} Essay: ${studentDetails.attemptPapers[index].essayMarks}'),
                        trailing: Text('Total: ${studentDetails.attemptPapers[index].totalMarks}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    //show students Name, email, registration number, and a button to view the student's details of FocusData and AttemptPapers
    return Scaffold(
      body: SafeArea(
        child: isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        )
        :Container(
          child: Column(
            children: [
              Container(
                height: 35,
                child: Text(
                  'Students - ${studentDetails.length}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
              )
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 150,
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: studentDetails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(studentDetails[index].name),
                      subtitle: Text(studentDetails[index].email),
                      trailing: Text(studentDetails[index].registrationNumber.toString()),
                      onTap: () {
                        showStudentDetails(studentDetails[index]);
        
                      },
                      tileColor: Colors.grey[200],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
