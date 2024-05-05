import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/subject_response_model.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/services/leaderboard_service.dart';
import 'package:spt/services/subject_service.dart';
import 'package:spt/util/SubjectColorUtil.dart';
import 'package:spt/view/student/leaderboard_page.dart';

import 'focus_mode_page.dart';

class SubjectSelectionPage extends StatefulWidget {
  final Function(int, Lessons,String,String) selectSubject;
  final bool enableFocus;
  const SubjectSelectionPage({super.key, required this.selectSubject, this.enableFocus = false});

  @override
  State<SubjectSelectionPage> createState() => _SubjectSelectionPageState();
}

class _SubjectSelectionPageState extends State<SubjectSelectionPage> {
  int currentPosition = 0;
  StreamController<int> expandController = StreamController<int>();
  List<Color> _subjectColors = [SubjectColor.BIOLOGY, SubjectColor.CHEMISTRY, SubjectColor.PHYSICS, SubjectColor.AGRICULTURE];

  CollectionReference biologyLessons = FirebaseFirestore.instance
      .collection('subject')
      .doc('biology')
      .collection('lessons');
  CollectionReference chemistryLessons = FirebaseFirestore.instance
      .collection('subject')
      .doc('chemistry')
      .collection('lessons');
  CollectionReference physicsLessons = FirebaseFirestore.instance
      .collection('subject')
      .doc('physics')
      .collection('lessons');
  CollectionReference agricultureLessons = FirebaseFirestore.instance
      .collection('subject')
      .doc('agriculture')
      .collection('lessons');

  int noOfBiologyLessons = -1;
  int noOfChemistryLessons = -1;
  int noOfPhysicsLessons = -1;
  int noOfAgricultureLessons = -1;

  late QuerySnapshot biologyLessonsSnapshot;

  late QuerySnapshot chemistryLessonsSnapshot;

  late QuerySnapshot physicsLessonsSnapshot;

  late QuerySnapshot agricultureLessonsSnapshot;

  bool enableFocus = false;

  String studyContent = '';

  setStudyContent(String content){
    setState(() {
      studyContent = content;
    });
  }

  getSuffixOfPosition(int position){
    // if ends with 1 add st
    if(position == 0){
      return '';
    }
    if(position % 10 == 1){
      return 'st';
    }else if(position % 10 == 2){
      return 'nd';
    }else if(position % 10 == 3){
      return 'rd';
    }
    return 'th';
  }

  getLeaderBoardPosition() async {
    int pos =await FocusService.getOverallLeaderBoardPosition();
    setState(() {
      currentPosition = pos;
    });
  }


  ShowReleaseSoonBanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: //create fancy content with images
          Container(
            width: 300,
            height: 230,
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                    child: Image.asset('assets/images/cs.gif',width: 100,height: 100,)),
                Text('This feature will be ',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200)),
                Text('available soon',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF00C897),
              )
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    // biologyLessons.get().then((value) {
    //   setState(() {
    //     noOfBiologyLessons = value.docs.length;
    //     biologyLessonsSnapshot = value;
    //   });
    // });
    //
    // chemistryLessons.get().then((value) {
    //   setState(() {
    //     noOfChemistryLessons = value.docs.length;
    //     chemistryLessonsSnapshot = value;
    //   });
    // });
    //
    // physicsLessons.get().then((value) {
    //   setState(() {
    //     noOfPhysicsLessons = value.docs.length;
    //     physicsLessonsSnapshot = value;
    //   });
    // });
    //
    // agricultureLessons.get().then((value) {
    //   setState(() {
    //     noOfAgricultureLessons = value.docs.length;
    //     agricultureLessonsSnapshot = value;
    //   });
    // });
    // getLeaderBoardPosition();
  }

  _selectExpand(int index) {
    expandController.sink.add(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * 0.95,
      alignment: Alignment.center,
      color: Color(0xFFFAFAFA),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'What are you going to',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'study',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 26,
                        color: Color(0xFF00C897),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'today?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Four Dashes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 5,
                      color: Color(0xFFC3E2C2),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      height: 5,
                      color: Color(0xFFCFE5FD),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      height: 5,
                      color: Color(0xFFF6F7C4),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 20,
                      height: 5,
                      color: Color(0xFFD1BEDB),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    if(!widget.enableFocus) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainLayout(mainIndex: 1,subIndex: 2,),
                        ),
                      );
                      // ShowReleaseSoonBanner(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/fire_overall.png',
                        width: 54,
                        height: 54,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      //You are 25th
                      // on the leader board
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'You are',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ShaderMask(
                                  // black to F2513B
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF000000),
                                        Color(0xFFF2513B),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    currentPosition == 0?'__':currentPosition.toString(),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Text(
                                getSuffixOfPosition(currentPosition),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'on the leader board',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFFC88200),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: FutureBuilder<SubjectResponseModel>(
                future: SubjectService.getAllSubject(),
                builder: (context,subjectSnapshot) {
                  if(subjectSnapshot.hasData){
                    return StreamBuilder<int>(
                        stream: expandController.stream,
                        initialData: -1,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            int expandedIndex = snapshot.data!;
                            return ListView.builder(
                                itemCount: subjectSnapshot.data!.data!.length,
                                itemBuilder: (context,index){
                              Subject subject = subjectSnapshot.data!.data![index];
                              return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _selectExpand(expandedIndex == index ? -1 : index);
                                          },
                                          child: Container(
                                            height: 90,
                                            margin: const EdgeInsets.symmetric(vertical: 6),
                                            decoration: BoxDecoration(
                                              color: _subjectColors[index % subjectSnapshot.data!.data!.length],
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black45,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/subjectImage.png',
                                                  width: 72,
                                                  height: 72,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      subject.subjectName!,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                    Text(
                                                      '${subject.lessons!.length} lessons',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (expandedIndex == index)
                                          Container(
                                              height: 400,
                                              child: ListView.separated(
                                                  itemBuilder: (context, j) {
                                                    return ExpansionTile(
                                                      title: Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              0.9,
                                                          margin: const EdgeInsets.symmetric(
                                                              vertical: 3),
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 10),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.transparent,
                                                          ),
                                                          child: Text("${j+1}. ${subject.lessons![j].lessonName}")),
                                                      trailing: const Icon(Icons.checklist_sharp),
                                                      backgroundColor: Colors.blue.shade50,
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: Color(0xFF00C897),
                                                          width: 1,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      collapsedBackgroundColor: Colors.white,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              0.9,
                                                          margin: const EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 10,
                                                                      vertical: 5),
                                                                  child: TextField(
                                                                    decoration: const InputDecoration(
                                                                      hintText:
                                                                      'Specify what you are studying',
                                                                      hintStyle: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color:
                                                                        Color(0xFF5A7193),
                                                                      ),
                                                                      border:
                                                                      UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                          color:
                                                                          Color(0xFF5A7193),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onChanged: (value){
                                                                      setStudyContent(value);
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                const EdgeInsets.symmetric(
                                                                    horizontal: 10,
                                                                    vertical: 10),
                                                                child: IconButton(
                                                                  onPressed: () {
                                                                    widget.selectSubject(
                                                                        1,
                                                                        subject.lessons![j],studyContent,subject.subjectName!);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.timer,
                                                                    color: Colors.black,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Done Button
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) {
                                                    return const Divider();
                                                  },
                                                  itemCount: subject.lessons!.length
                                              )
                                          ),
                                      ]
                                  )
                              );
                            });
                          }
                          return Container(
                            child: CircularProgressIndicator(),
                          );
                        }
                    );
                  }else{
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
