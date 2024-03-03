
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spt/model/Instructor.dart';
import 'package:spt/services/auth_services.dart';

import '../../model/StudentCSV.dart';
import '../bottomBar_screen/bottom_bar_screen.dart';
import '../res/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Papers and Instructors"),
        // ),
        backgroundColor: AppColors.backGround,
        body:
            isLoading
                ? Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.ligthWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          CircularProgressIndicator(),
                          Gap(20),
                          Text('This may take a while...')
                        ],
                      )
                    ),
                  )
                :
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(80),
                const Text(
                  "Add new...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.black),
                ),
                const Gap(35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BottomBarScreen(
                                isEntryScreen: true,
                                isInstructorScreen: false,
                            isAddFolderScreen: false,)));
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const Gap(15),
                              Container(
                                height: 170,
                                width: 130,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: AppColors.red, width: 1.0),
                                    bottom: BorderSide(
                                        color: AppColors.blue, width: 1.0),
                                    left: BorderSide(
                                        color: AppColors.green, width: 1.0),
                                    right: BorderSide(
                                        color: AppColors.purple, width: 1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 75,
                            left: 45,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.ligthWhite),
                                child: CircleAvatar(
                                    backgroundColor: AppColors.ligthWhite,
                                    child: Icon(Icons.add)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            child: Container(
                              // height: 35,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                color: AppColors.ligthWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                  child: FittedBox(
                                child: Text(
                                  'Add a new entity',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.black),
                                ),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(40),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BottomBarScreen(
                                isEntryScreen: false,
                                isInstructorScreen: true,
                            isAddFolderScreen: false,)));
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const Gap(15),
                              Container(
                                height: 170,
                                width: 130,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: AppColors.red, width: 2.0),
                                    bottom: BorderSide(
                                        color: AppColors.blue, width: 1.0),
                                    left: BorderSide(
                                        color: AppColors.green, width: 1.0),
                                    right: BorderSide(
                                        color: AppColors.purple, width: 1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 75,
                            left: 45,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.ligthWhite),
                                child: CircleAvatar(
                                    backgroundColor: AppColors.ligthWhite,
                                    child: Icon(Icons.add)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 1,
                            top: 0,
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                color: AppColors.ligthWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                  child: FittedBox(
                                child: Text(
                                  'Add a new instructor',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.black),
                                ),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BottomBarScreen(
                              isEntryScreen: false,
                              isInstructorScreen: false,
                              isAddFolderScreen: true,
                            )));
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const Gap(15),
                              Container(
                                height: 170,
                                width: 130,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: AppColors.red, width: 1.0),
                                    bottom: BorderSide(
                                        color: AppColors.blue, width: 1.0),
                                    left: BorderSide(
                                        color: AppColors.green, width: 1.0),
                                    right: BorderSide(
                                        color: AppColors.purple,
                                        width: 1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 75,
                            left: 45,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.black.withOpacity(0.25),
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      const BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.ligthWhite),
                                child: const CircleAvatar(
                                    backgroundColor: AppColors.ligthWhite,
                                    child: Icon(Icons.add)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 17,
                            top: 0,
                            child: Container(
                              // height: 35,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                color: AppColors.ligthWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Add a folder',
                                      style: TextStyle(
                                          fontSize: 12, color: AppColors.black),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(40),
                    GestureDetector(
                      onTap: () {
                        uploadFile();
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const Gap(15),
                              Container(
                                height: 170,
                                width: 130,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: AppColors.red, width: 2.0),
                                    bottom: BorderSide(
                                        color: AppColors.blue, width: 1.0),
                                    left: BorderSide(
                                        color: AppColors.green, width: 1.0),
                                    right: BorderSide(
                                        color: AppColors.purple, width: 1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 75,
                            left: 45,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(
                                          0.0,
                                          5.0,
                                        ),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.ligthWhite),
                                child: CircleAvatar(
                                    backgroundColor: AppColors.ligthWhite,
                                    child: Icon(Icons.upload)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 1,
                            top: 0,
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                color: AppColors.ligthWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Upload Student CSV',
                                      style: TextStyle(
                                          fontSize: 12, color: AppColors.black),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                // Stack(
                //   children: [
                //     Container(
                //       height: 170,
                //       width: 130,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //         border: Border.all(color: AppColors.red, width: 2.0),
                //       ),
                //     ),
                //     Container(
                //       height: 170,
                //       width: 130,
                //       decoration: BoxDecoration(
                //         border: Border(
                //           bottom: BorderSide(color: AppColors.blue, width: 1.0),
                //           left: BorderSide(color: AppColors.green, width: 1.0),
                //           right:
                //               BorderSide(color: AppColors.purple, width: 1.0),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        )
    );
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    setState(() {
      isLoading = true;
    });
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = File(file.path!).openRead();
      var fields = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();

      List<StudentCSV> students = [];
      List<String> instructors = [];
      fields = fields.sublist(1);
      String error = '';
      bool isValidated = true;
      for (var field in fields) {
        if (field.length != 5) {
          error = 'Invalid CSV format';
          isValidated = false;
          break;
        }
        if(field[0].toString().isEmpty || field[1].toString().isEmpty || field[2].toString().isEmpty){
          error = 'Invalid CSV format';
          isValidated = false;
          break;
        }
      }
      if (!isValidated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 3),
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }



      await AuthService.createStudents(fields, context);
      setState(() {
        isLoading = false;
      });

    }
  }
}
