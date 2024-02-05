import 'dart:async';

import 'package:flutter/material.dart';

class SubjectSelectionPage extends StatefulWidget {
  final Function(int) selectSubject;
  const SubjectSelectionPage({super.key, required this.selectSubject});

  @override
  State<SubjectSelectionPage> createState() => _SubjectSelectionPageState();
}

class _SubjectSelectionPageState extends State<SubjectSelectionPage> {
  StreamController<int> expandController = StreamController<int>();

  _selectExpand(int index) {
    expandController.sink.add(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.95,
      alignment: Alignment.center,
      color: Color(0xFFFAFAFA),
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
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            child: const Text(
                              '25',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Text(
                          'th',
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
          const SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<int>(
                  stream: expandController.stream,
                  initialData: -1,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      int index = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectExpand(index == 0 ? -1 : 0);
                            },
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFC3E2C2),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Biology',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '23 lessons',
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
                          if(snapshot.data == 0)
                            Container(
                              child: Column(
                                children: [
                                  for(int i = 0; i < 23; i++)
                                    ExpansionTile(
                                        title: Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Lesson $i'),
                                        ),
                                        trailing: const Icon(Icons.add),
                                        backgroundColor: Colors.white,
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
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'Specify what you are studying',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF5A7193),
                                                        ),
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Color(0xFF5A7193),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      widget.selectSubject(1);
                                                    },
                                                    icon: Icon(
                                                      Icons.done,
                                                      color: Color(0xFF00C897),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Done Button

                                        ],
                                    )

                                ],
                              )
                            ),

                          GestureDetector(
                            onTap: () {
                              _selectExpand(index == 1 ? -1 : 1);
                            },
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFCFE5FD),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Biology',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '23 lessons',
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
                          if(snapshot.data == 1)
                            Container(
                                child: Column(
                                  children: [
                                    for(int i = 0; i < 23; i++)
                                      ExpansionTile(
                                        title: Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Lesson $i'),
                                        ),
                                        trailing: const Icon(Icons.add),
                                        backgroundColor: Colors.white,
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
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'Specify what you are studying',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF5A7193),
                                                        ),
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Color(0xFF5A7193),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.done,
                                                      color: Color(0xFF00C897),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Done Button

                                        ],
                                      )

                                  ],
                                )
                            ),
                          GestureDetector(
                            onTap: () {
                              _selectExpand(index == 2 ? -1 : 2);
                            },
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFF6F7C4),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Biology',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '23 lessons',
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
                          if(snapshot.data == 2)
                            Container(
                                child: Column(
                                  children: [
                                    for(int i = 0; i < 23; i++)
                                      ExpansionTile(
                                        title: Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Lesson $i'),
                                        ),
                                        trailing: const Icon(Icons.add),
                                        backgroundColor: Colors.white,
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
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'Specify what you are studying',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF5A7193),
                                                        ),
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Color(0xFF5A7193),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.done,
                                                      color: Color(0xFF00C897),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Done Button

                                        ],
                                      )

                                  ],
                                )
                            ),
                          GestureDetector(
                            onTap: () {
                              _selectExpand(index == 3 ? -1 : 3);
                            },
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFD1BEDB),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Biology',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        '23 lessons',
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
                          if(snapshot.data == 3)
                            Container(
                                child: Column(
                                  children: [
                                    for(int i = 0; i < 23; i++)
                                      ExpansionTile(
                                        title: Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          margin: const EdgeInsets.symmetric(vertical: 3),
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text('Lesson $i'),
                                        ),
                                        trailing: const Icon(Icons.add),
                                        backgroundColor: Colors.white,
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
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'Specify what you are studying',
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF5A7193),
                                                        ),
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: Color(0xFF5A7193),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.done,
                                                      color: Color(0xFF00C897),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Done Button

                                        ],
                                      )

                                  ],
                                )
                            ),
                        ],
                      );
                    }
                    else{
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
