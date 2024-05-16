import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spt/services/api_provider.dart';
import 'dart:math' as math;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:spt/services/instructor_service.dart';
import 'package:spt/util/toast_util.dart';

import '../../globals.dart';
import '../../model/instructor_create_response_model.dart';
import '../../model/instructor_response_model.dart';
import '../../model/model.dart';
import '../../model/response_model.dart';
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
  final double _fieldBorderLineWidth = 0.5;
  final double _fieldFontSizeValue = 12;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String? instructorGroup;
  List<InstructorInfo> instructor = [];
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
    InstructorResponseModel? response = await InstructorService.getAllInstructor();
    if(response == null) {
      ToastUtil.showErrorToast(context, "Network Error", "Failed to fetch data");
      return;
    }
    List<InstructorInfo> instructors = response!.data!;
    setState(() {
      instructor.addAll(instructors);
      isLoading = false;
    });
  }

    Future<void> addData(
      {
        required String instructorEmail,
        required String firstName,
        required String lastName,
        required String? group
      }) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      Dio dio = Dio();
      InstructorCreateResponseModel? response = await InstructorService.createInstructor(
          instructorEmail: instructorEmail,
          firstName: firstName,
          lastName: lastName,
          group: group
      );
      instructor.add(InstructorInfo(
          instructorId: response?.data!.instructorId,
          instructorGroup: response?.data!.instructorGroup,
          firstName: firstName,
          lastName: lastName,
          email: instructorEmail
      ));
      loading.dismiss();
      emailController.clear();
      firstNameController.clear();
      lastNameController.clear();
      instructorGroup = null;

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
        color: Colors.black26,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    final enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black26,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );

    final valueStyle = TextStyle(
      color: Colors.black26,
      fontSize: _fieldFontSizeValue,
    );

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.red,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width / 2) - 40,
                        child: TextFormField(
                          style: valueStyle,
                          controller: firstNameController,
                          cursorColor: cursorColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            filled: true,
                            fillColor: AppColors.ligthWhite,
                            labelStyle: const TextStyle(fontSize: 10),
                            labelText: 'Enter First Name',
                            focusedBorder: focusedBorder,
                            enabledBorder: enabledBorder,
                            border: focusedBorder,
                            errorBorder: errorBorder,
                            errorStyle: errorStyle,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the First Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: (width / 2) -40,
                        child: TextFormField(
                          style: valueStyle,
                          controller: lastNameController,
                          cursorColor: cursorColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            filled: true,
                            fillColor: AppColors.ligthWhite,
                            labelStyle: const TextStyle(fontSize: 10),
                            labelText: 'Enter Last Name',
                            focusedBorder: focusedBorder,
                            enabledBorder: enabledBorder,
                            border: focusedBorder,
                            errorBorder: errorBorder,
                            errorStyle: errorStyle,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Last Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width) - 40,
                        child: TextFormField(
                          style: valueStyle,
                          controller: emailController,
                          cursorColor: cursorColor,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
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
                      // SizedBox(width: 10,),
                      // Container(
                      //   width: (width / 2) - 40,
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   decoration: BoxDecoration(
                      //       color: AppColors.ligthWhite,
                      //       border: Border.all(color: AppColors.black),
                      //       borderRadius: BorderRadius.circular(5)
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: instructorGroup,
                      //     hint: const Text('Select Group'),
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     iconSize: 24,
                      //     elevation: 16,
                      //     isExpanded: true,
                      //     style: const TextStyle(color: Colors.black),
                      //     underline: SizedBox(),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         instructorGroup = newValue!;
                      //       });
                      //     },
                      //     items: <String>['A', 'B', 'C', 'D']
                      //         .map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                    ],
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
                              instructorEmail: emailController.text.trim(),
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              group: instructorGroup
                          );
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
                                        instructor[index].email!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    // onPressed: () {
                                    //   ConfirmationPopup(context).show(
                                    //       message:
                                    //       'Are you sure you want to delete the email?',
                                    //       callbackOnYesPressed: () {
                                    //         deleteInstructor(
                                    //             instructor[index].instructorId!,
                                    //             index);
                                    //       });
                                    // },
                                   onPressed: null,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: AppColors.red,
                                    )
                                )
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