import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spt/services/api_provider.dart';
import 'dart:math' as math;
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../globals.dart';
import '../../model/model.dart';
import '../../popups/confirmation_popup.dart';
import '../../popups/loading_popup.dart';
import '../res/app_colors.dart';


class InstructorScreen extends StatefulWidget {
  const InstructorScreen({super.key});

  @override
  State<InstructorScreen> createState() => _InstructorScreenState();
}

class _InstructorScreenState extends State<InstructorScreen> {
  final double _fieldBorderRadius = 30;
  final double _fieldBorderLineWidth = 1.5;
  final double _fieldFontSizeValue = 12;
  final formKey = GlobalKey<FormState>();
  final entryController = TextEditingController();
  final passwordController = TextEditingController();
  List<Instructor> instructor = [];
  List<DocumentSnapshot> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Instructors')
        .orderBy('email', descending: false)
        .get();
    setState(() {
      data.addAll(querySnapshot.docs);
      for (var email in data) {
        instructor.add(Instructor(
            instructorId: email['uid'],
            email: email['email'],
            docId: email.id
        ));
      }
      isLoading = false;
    });
  }

  // Future<void> addData(
  //     {required String instructorEmail, required String password}) async {
  //   try {
  //     final loading = LoadingPopup(context);
  //     loading.show();
  //     String instructorId = const Uuid().v1();
  //     DocumentReference documentReference = await FirebaseFirestore.instance
  //         .collection('instructor') // Reference to the collection
  //         .add({
  //       'id': instructor.length,
  //       'instructorId': instructorId,
  //       'email': instructorEmail,
  //       'password': password
  //     });
  //     loading.dismiss();
  //     setState(() {
  //       instructor.insert(
  //           0,
  //           Instructor(
  //               instructorId: instructorId,
  //               email: instructorEmail,
  //               docId: documentReference.id));
  //       entryController.clear();
  //       passwordController.clear();
  //     });
  //     final Email email = Email(
  //       body: 'Instructor password is $password',
  //       subject: 'Instructor\'s password',
  //       recipients: [instructorEmail],
  //       // cc: ['cc@example.com'],
  //       // bcc: ['bcc@example.com'],
  //       // attachmentPaths: ['/path/to/attachment.zip'],
  //       isHTML: false,
  //     );
  //
  //     await FlutterEmailSender.send(email);
  //
  //     // ignore: use_build_context_synchronously
  //     Globals.showSnackBar(
  //         context: context, isSuccess: true, message: 'Success');
  //   } catch (error) {
  //     // ignore: avoid_print
  //     print("Failed to add user: $error");
  //   }
  // }
  //
    Future<void> addData(
      {required String instructorEmail}) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      Dio dio = Dio();
      final response = await dio.post(
        '${APIProvider.BASE_URL}/instructor',
        data: {
          'email': instructorEmail,
        },
      );
      instructor.add(Instructor(
          instructorId: response.data['uid'],
          email: instructorEmail,
          docId: response.data['uid']
      ));
      loading.dismiss();
      entryController.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      Globals.showSnackBar(
          context: context, isSuccess: true, message: 'Success');
    } catch (error) {
      // ignore: avoid_print
      print("Failed to add user: $error");
    }
  }



  void deleteInstructor(String instructorId, int index) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      Dio dio = Dio();
      final response = await dio.delete(
        '${APIProvider.BASE_URL}/instructor/$instructorId',
      );
      loading.dismiss();
      setState(() {
        instructor.removeAt(index);
      });


      // ignore: use_build_context_synchronously
      Globals.showSnackBar(
          context: context, message: 'Success', isSuccess: true);
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting instructor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.black,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(_fieldBorderRadius)),
    );

    final enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.black,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(_fieldBorderRadius)),
    );

    final valueStyle = TextStyle(
      color: AppColors.black,
      fontSize: _fieldFontSizeValue,
    );

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.red,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );

    const errorStyle = TextStyle(
      color: AppColors.red,
    );

    const cursorColor = AppColors.black;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(80),
            const Center(
              child: Text(
                "Manage Instructors",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColors.black),
              ),
            ),
            const Gap(50),
            Center(
              child: RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Add a ',
                      style: TextStyle(color: AppColors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'new',
                      style: TextStyle(color: AppColors.green, fontSize: 20),
                    ),
                    TextSpan(
                      text: ' Instructor',
                      style: TextStyle(color: AppColors.black, fontSize: 20),
                    ),
                  ])),
            ),
            const Gap(30),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: SizedBox(
                      width: width / 2,
                      child: TextFormField(
                        style: valueStyle,
                        controller: entryController,
                        cursorColor: cursorColor,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.ligthWhite,
                          labelStyle: const TextStyle(fontSize: 10),
                          labelText: 'Enter instructor\'s email',
                          focusedBorder: focusedBorder,
                          enabledBorder: enabledBorder,
                          border: focusedBorder,
                          errorBorder: errorBorder,
                          errorStyle: errorStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the instructor\'s Email';
                          }
                          String pattern =
                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: EdgeInsets.only(right: (width / 4) - 20),
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(29)),
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (!formKey.currentState!.validate()) return;
                          addData(
                              instructorEmail: entryController.text.trim());
                        },
                        child: const Center(
                            child: Text(
                              'Send',
                              style: TextStyle(
                                color: AppColors.ligthWhite,
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Available ',
                      style: TextStyle(color: AppColors.black),
                    ),
                    TextSpan(
                      text: ' Instructors',
                      style: TextStyle(color: AppColors.green),
                    ),
                  ])),
            ),
            const Gap(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : instructor.isEmpty
                    ? const Center(
                  child: Text(
                    'No instructors',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                  ),
                )
                    : ListView.builder(
                    itemCount: instructor.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.ligthWhite,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        instructor[index].email,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      ConfirmationPopup(context).show(
                                          message:
                                          'Are you sure you want to delete the email?',
                                          callbackOnYesPressed: () {
                                            deleteInstructor(
                                                instructor[index].docId,
                                                index);
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: AppColors.red,
                                    ))
                              ],
                            ),
                          ),
                          const Gap(10),
                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}