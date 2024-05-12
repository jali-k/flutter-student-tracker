


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/focus_session_in_week_stat_data_model.dart';
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
  List<FocusSessions> focusSessions = [];
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



  showStudentDetails(StudentInfo studentDetails) async {
    //show the student's details as a dialog AlertDialog FocusData and AttemptPapers
    focusDataBySubjectAndLesson = {};
    try{
      FocusSessionsInWeekStatsDataModel? data =await InstructorService.getFocusSessionsInWeekStats(studentDetails.registrationNumber!.toString());
      focusSessions = data!.data!.map((e) => e.focusSessions!).expand((element) => element).toList();


      focusSessions.sort((a,b) => a.startTime!.compareTo(b.startTime!));
      //show the student's details as a dialog AlertDialog FocusData
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Student Focus Sessions', style: TextStyle(fontSize: 16)),
            content: Container(
              height: 500,
              width: 300,
              child: focusSessions.isEmpty ? Center(child: Text('No Focus Sessions'),) :
              ListView.builder(
                itemCount: focusSessions.length,
                itemBuilder: (context, index) {
                  FocusSessions focusSession = focusSessions[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(getDateAndTime(DateTime.fromMillisecondsSinceEpoch(focusSession.startTime!)),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject: ${focusSession.remarks!}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                          Text('Duration: ${focusSession.duration!}',style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      trailing: Badge(
                        backgroundColor: focusSession.focusSessionStatus == 'Completed'.toUpperCase() ? Colors.green : Colors.red,
                        label: Text(focusSession.focusSessionStatus!,style: TextStyle(fontSize: 10))
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Close'),
              ),
            ],
          );
        },
      );

    }catch(e){
      print('Error: $e');
    }

  }


  @override
  Widget build(BuildContext context) {
    //show students Name, email, registration number, and a button to view the student's details of FocusData and AttemptPapers
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Detail - ${studentDetails.length}'),
      ),
      body: SafeArea(
        child: isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        )
        :Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 150,
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: studentDetails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(studentDetails[index].displayName!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentDetails[index].registrationNumber!.toString()),
                            Text('${studentDetails[index].firstName!} ${studentDetails[index].lastName!}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            showStudentDetails(studentDetails[index]);
                          },
                        ),
                      ),
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

  String getDateAndTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
