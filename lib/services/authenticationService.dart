import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/authenticated_instructor_model.dart';
import 'package:spt/model/authenticated_user_model.dart';

import '../model/authenticated_admin_model.dart';
import '../model/authenticated_student_model.dart';
import '../model/user_role_model.dart';
import 'api_provider.dart';

class AuthenticationService{

  static Future<bool> login(String accessToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      final response = await Dio(BaseOptions(
        baseUrl: APIProvider.BASE_URL,
      )).post('/auth/login', data: {'accessToken': accessToken});
      if (response.statusCode == 200) {
        //get response data as AuthenticatedStudentModel
        AuthenticatedUserModel authenticatedUserModel = AuthenticatedUserModel.fromJson(response.data);
        if(authenticatedUserModel.role == UserRole.STUDENT){
          //get response data as AuthenticatedStudentModel
          AuthenticatedStudentModel authenticatedStudentModel = AuthenticatedStudentModel.fromJson(response.data);
          prefs.setString('firstName', authenticatedStudentModel.userInfo!.firstName!);
          prefs.setString('lastName', authenticatedStudentModel.userInfo!.lastName!);
          prefs.setString('email', authenticatedStudentModel.email!);
          prefs.setString('role', authenticatedStudentModel.role!);
          prefs.setString('accessToken', authenticatedStudentModel.accessToken!);
          prefs.setString('tokenType', authenticatedStudentModel.tokenType!);
          prefs.setInt('registrationNumber', authenticatedStudentModel.userInfo!.registrationNumber!);
          prefs.setInt('expiresIn', authenticatedStudentModel.expiresIn!);
          prefs.setString('refreshToken', authenticatedStudentModel.refreshToken!);
          prefs.setString('userInfo', jsonEncode(authenticatedStudentModel.userInfo!));
        }
        else if(authenticatedUserModel.role == UserRole.INSTRUCTOR){
          //get response data as AuthenticatedInstructorModel
          AuthenticatedInstructorModel authenticatedInstructorModel = AuthenticatedInstructorModel.fromJson(response.data);
          prefs.setString('firstName', authenticatedInstructorModel.firstName!);
          prefs.setString('lastName', authenticatedInstructorModel.lastName!);
          prefs.setString('email', authenticatedInstructorModel.email!);
          prefs.setString('role', authenticatedInstructorModel.role!);
          prefs.setString('accessToken', authenticatedInstructorModel.accessToken!);
          prefs.setString('tokenType', authenticatedInstructorModel.tokenType!);
          prefs.setInt('expiresIn', authenticatedInstructorModel.expiresIn!);
          prefs.setString('refreshToken', authenticatedInstructorModel.refreshToken!);
          prefs.setString('userInfo', jsonEncode(authenticatedInstructorModel.userInfo!));
        }
        else if(authenticatedUserModel.role == UserRole.ADMIN){
          //get response data as AuthenticatedAdminModel
          AuthenticatedAdminModel authenticatedAdminModel = AuthenticatedAdminModel.fromJson(response.data);
          prefs.setString('firstName', authenticatedAdminModel.firstName!);
          prefs.setString('lastName', authenticatedAdminModel.lastName!);
          prefs.setString('email', authenticatedAdminModel.email!);
          prefs.setString('role', authenticatedAdminModel.role!);
          prefs.setString('accessToken', authenticatedAdminModel.accessToken!);
          prefs.setString('tokenType', authenticatedAdminModel.tokenType!);
          prefs.setInt('expiresIn', authenticatedAdminModel.expiresIn!);
          prefs.setString('refreshToken', authenticatedAdminModel.refreshToken!);
          prefs.setString('userInfo', authenticatedAdminModel.userInfo!.toJson().toString());

        }
        else{
          prefs.setString('firstName', authenticatedUserModel.firstName!);
          prefs.setString('lastName', authenticatedUserModel.lastName!);
          prefs.setString('email', authenticatedUserModel.email!);
          prefs.setString('role', authenticatedUserModel.role!);
          prefs.setString('accessToken', authenticatedUserModel.accessToken!);
          prefs.setString('tokenType', authenticatedUserModel.tokenType!);
          prefs.setInt('expiresIn', authenticatedUserModel.expiresIn!);
        }
        APIProvider.instance.reInitializeAPIProvider();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    APIProvider.instance.reInitializeAPIProvider();
  }



}