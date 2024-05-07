


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/students_of_instructor_model.dart';
import 'package:spt/services/instructor_service.dart';

import '../../model/authenticated_student_model.dart';
import '../../model/paper_attempt.dart';
import '../../model/student_details.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<StudentInfo> studentDetails = [];
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

  fetchStudents () async{
    isLoading = true;
    //get all the students from firestore
    StudentOfInstructorModel? studentOfInstructorModel = await InstructorService.getInstructorStudentDetails();
    if(studentOfInstructorModel != null){
      setState(() {
        studentDetails = [];
        isLoading = false;
      });
    }
    setState(() {
      studentDetails = studentOfInstructorModel!.data!;
      isLoading = false;
    });
  }


  showStudentDetails(StudentInfo studentDetails) {
    //show the student's details as a dialog AlertDialog FocusData and AttemptPapers
    focusDataBySubjectAndLesson = {};
    // for (FocusData focusData in studentDetails.focusData) {
    //   if (focusDataBySubjectAndLesson.containsKey(focusData.subjectName)) {
    //     if (focusDataBySubjectAndLesson[focusData.subjectName]!.containsKey(focusData.lessonContent)) {
    //       focusDataBySubjectAndLesson[focusData.subjectName]?[focusData.lessonID] =focusDataBySubjectAndLesson[focusData.subjectName]![focusData.lessonContent]! + focusData.duration;
    //     } else {
    //       focusDataBySubjectAndLesson[focusData.subjectName]?[focusData.lessonID] = focusData.duration;
    //     }
    //   } else {
    //     focusDataBySubjectAndLesson[focusData.subjectName] = {focusData.lessonID: focusData.duration};
    //   }
    // }
    // print(focusDataBySubjectAndLesson);
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text(studentDetails.name),
    //       content: Container(
    //         height: MediaQuery.of(context).size.height - 100,
    //         width: MediaQuery.of(context).size.width - 50,
    //         child: Column(
    //           children: [
    //             Text('Email: ${studentDetails.email}',textAlign: TextAlign.start,),
    //             Text('Registration Number: ${studentDetails.registrationNumber}',textAlign: TextAlign.start),
    //             SizedBox(height: 10),
    //             Container(
    //               height: 35,
    //               child: Text(
    //                 'Focus Data',
    //                 style: TextStyle(
    //                   fontSize: 24,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 10),
    //             Container(
    //               height: (MediaQuery.of(context).size.height - 400)/2,
    //               child: ListView.builder(
    //                 itemCount: studentDetails.focusData.length,
    //                 itemBuilder: (context, index) {
    //                   return ListTile(
    //                     title: Text(studentDetails.focusData[index].subjectName[0].toUpperCase() + studentDetails.focusData[index].subjectName.substring(1)),
    //                     subtitle: Text(lessonIdToLessonName[studentDetails.focusData[index].lessonID]!),
    //                     trailing: Text('${focusDataBySubjectAndLesson[studentDetails.focusData[index].subjectName]![studentDetails.focusData[index].lessonID]!} mins'),
    //                   );
    //                 },
    //               ),
    //             ),
    //             SizedBox(height: 10),
    //             Container(
    //               height: 35,
    //               child: Text(
    //                 'Attempt Papers',
    //                 style: TextStyle(
    //                   fontSize: 24,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //             //marks
    //             Container(
    //               height: (MediaQuery.of(context).size.height - 400)/2,
    //               child: ListView.builder(
    //                 itemCount: studentDetails.attemptPapers.length,
    //                 itemBuilder: (context, index) {
    //                   return ListTile(
    //                     title: Text(studentDetails.attemptPapers[index].paperName!),
    //                     subtitle: Text('MCQ: ${studentDetails.attemptPapers[index].mcqMarks} Structured: ${studentDetails.attemptPapers[index].structuredMarks} Essay: ${studentDetails.attemptPapers[index].essayMarks}'),
    //                     trailing: Text('Total: ${studentDetails.attemptPapers[index].totalMarks}'),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: Text('Close'),
    //         ),
    //       ],
    //     );
    //   },
    // );
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
                      title: Text(studentDetails[index].displayName!),
                      subtitle: Text(studentDetails[index].firstName!.toString()),
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
