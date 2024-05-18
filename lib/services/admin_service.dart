import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spt/util/toast_util.dart';

import '../model/all_student_response_model.dart';
import '../model/response_model.dart';
import '../model/search_response_model.dart';
import 'api_provider.dart';

class AdminService{

  static Future<AllStudentResponseModel?> getAllStudent() async {
    try {
      final response = await APIProvider.instance.get('/admin/student/all');
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        AllStudentResponseModel responseModel = AllStudentResponseModel.fromJson(response.data);
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  //search student
  static Future<SearchStudentResponseModel?> searchStudent(String searchValue) async {
    try {
      final response = await APIProvider.instance.get('/student/search?search=$searchValue');
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        SearchStudentResponseModel responseModel = SearchStudentResponseModel.fromJson(response.data);
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static updateStudent(String studentId,String firstName, String lastName, String displayName, String phone, String email, int registrationNumber) async {
    try {
      final response = await APIProvider.instance.put('/student/update/$studentId',{
        "firstName": firstName,
        "lastName": lastName,
        "displayName": displayName,
        "email": email,
        "password": "string",
        "phoneNumber": phone,
        "registrationNumber": registrationNumber,
      });
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        ResponseModel responseModel = ResponseModel.fromJson(response.data);
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static createStudents(File file, BuildContext context) async {
    try {
      Map<String, dynamic> data = {
        "file": MultipartFile.fromFileSync(file.path),
      };
      final response = await APIProvider.instance.postMultipart('/admin/student/csv', data);
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        ResponseModel responseModel = ResponseModel.fromJson(response.data);
        ToastUtil.showSuccessToast(context, "Success", "Students creating By CSV Data in Background");
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}