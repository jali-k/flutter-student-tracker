import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/response_model.dart';
import 'package:spt/screens/res/app_colors.dart';
import 'package:spt/util/toast_util.dart';

import '../../model/search_response_model.dart';
import '../../services/admin_service.dart';

class MangeStudent extends StatefulWidget {
  const MangeStudent({super.key});

  @override
  State<MangeStudent> createState() => _MangeStudentState();
}

class _MangeStudentState extends State<MangeStudent> {
  String searchProperty = 'Registration Number';
  SearchStudentData? searchStudentData;

  TextEditingController searchController = TextEditingController();

  //Name , Phone, Email, Registration Number TextEditingControllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();

  bool isUpdate = false;

  searchStudent() async {
    //search student with registration number
    String searchValue = searchController.text;
    if (searchValue.isNotEmpty) {
      //search student with registration number
      try {
        //search student with registration number
        SearchStudentResponseModel? searchStudentResponseModel =
            await AdminService.searchStudent(searchValue);
        if (searchStudentResponseModel != null) {
          //show student details
          setState(() {
            searchStudentData = searchStudentResponseModel.data;
          });
        } else {
          //show error message
          print('Error: No student found');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      //show error message
      print('Error: Please enter search value');
    }
  }

  updateStudent() async {
    //update student details
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String displayName = displayNameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    int registrationNumber = 0;
    try {
      registrationNumber = int.parse(registrationNumberController.text);
    } catch (e) {
      ToastUtil.showErrorToast(context,'Error', 'Please enter valid registration number');
      return;
    }


    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty) {
      try {
        //update student details
        ResponseModel? searchStudentResponseModel =
            await AdminService.updateStudent(
              searchStudentData!.user!.id!,
                firstName, lastName,displayName, phone, email, registrationNumber);
        if (searchStudentResponseModel != null) {
          //show student details
          ToastUtil.showSuccessToast(context,'Success', 'Student details updated successfully');
        } else {
          //show error message
          ToastUtil.showErrorToast(context,'Error', 'Failed to update student details');
        }
      } catch (e) {
        ToastUtil.showErrorToast(context,'Error', 'Failed to update student details');
      }
    } else {
      //show error message
      ToastUtil.showErrorToast(context,'Error', 'Please enter all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Student'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                //text box to search student and drop down to find with registration number and email
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                                hintText: 'Search',
                                hintStyle: TextStyle(fontSize: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //Search button
                      Container(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            searchStudent();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.onPrimary),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //search result
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Builder(builder: (context) {
                    if (searchStudentData != null) {
                      firstNameController.text =
                          searchStudentData!.user!.firstName!;
                      lastNameController.text =
                          searchStudentData!.user!.lastName!;
                      phoneController.text =
                          searchStudentData!.phoneNumber ?? '';
                      registrationNumberController.text =
                          searchStudentData!.registrationNumber!.toString();
                      emailController.text = searchStudentData!.user!.username!;
                      displayNameController.text = searchStudentData!.displayName!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(
                            color: AppColors.grey,
                            thickness: 1,
                          ),
                          //Search Result for student Text
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Text(
                            'Search Result',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Profile Image
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: AppColors.greyUnSelected,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'First Name: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: isUpdate,
                                              style: TextStyle(fontSize: 12),
                                              controller: firstNameController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'Last Name: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: isUpdate,
                                              style: TextStyle(fontSize: 12),
                                              controller: lastNameController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'Display Name: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: isUpdate,
                                              style: TextStyle(fontSize: 12),
                                              controller: displayNameController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'Phone: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: isUpdate,
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(fontSize: 12),
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'Email: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: false,
                                              style: TextStyle(fontSize: 12),
                                              keyboardType: TextInputType.emailAddress,
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              'Reg Number: ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              enabled: isUpdate,
                                              style: TextStyle(fontSize: 12),
                                              controller:
                                                  registrationNumberController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (isUpdate)
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                //update student details
                                                if (isUpdate) {
                                                  updateStudent();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                'Update',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.onPrimary),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isUpdate = !isUpdate;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: CircleBorder(),
                                        ),
                                        icon: Icon(
                                            isUpdate
                                                ? Icons.cancel
                                                : Icons.edit,
                                            color: AppColors.onPrimary)),
                                  )
                                ],
                              )),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
