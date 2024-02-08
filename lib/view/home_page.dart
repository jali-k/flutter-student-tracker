import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/Subject.dart';
import 'package:spt/services/focusService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _BiologyFocus = 0;


  getBiologyFocus() {
    FocusService.getStudentSubjectFocus(Subject.BIOLOGY);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBiologyFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 60,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: 600,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Title : What’s catching your interest today?
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'What’s catching your',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'interest ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF00C897),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'today?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 500,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFECA11B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Overall")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BEC3E),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("12",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Biology")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BECCD),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Chemistry")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFDEEC1B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("24",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Physics")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFD71BEC),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("00",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Agriculture")
                                                ],
                                              ),
                                            ],
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.only(left: 40),
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Study Now',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.pushNamed(context, '/login');
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFECA11B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Overall")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BEC3E),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("12",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Biology")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BECCD),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Chemistry")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFDEEC1B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("24",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Physics")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFD71BEC),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("00",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Agriculture")
                                                ],
                                              ),
                                            ],
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.only(left: 40),
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'View Marks',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.pushNamed(context, '/login');
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        width: MediaQuery.of(context).size.width * 0.85,
                                        height: 170,
                                        margin: const EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10,right: 5),
                                          width: 150,
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFECA11B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Overall")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BEC3E),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("12",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Biology")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFF1BECCD),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("25",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Chemistry")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFDEEC1B),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("24",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Physics")
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department_rounded,
                                                    color: Color(0xFFD71BEC),
                                                    size: 30,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text("00",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text("Agriculture")
                                                ],
                                              ),
                                            ],
                                          ),
                                        )

                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 20,
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            margin: const EdgeInsets.only(left: 40),
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Lectures',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF00C897),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_forward,color: Colors.white,),
                                                onPressed: () {
                                                  Navigator.pushNamed(context, '/login');
                                                },

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              
                  ]
              )),
        ],
      ),
    );
  }
}
