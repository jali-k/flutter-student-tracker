import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/authenticated_user_model.dart';

import '../model/authenticated_student_model.dart';
import '../model/user_role_model.dart';
import 'api_provider.dart';

class AuthenticationService{

  static Future<bool> login(String accessToken) async {
    try {
      final response = await APIProvider().post('/auth/login', {'accessToken': accessToken});
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response.data['accessToken']);

        //get response data as AuthenticatedStudentModel
        AuthenticatedUserModel authenticatedUserModel = AuthenticatedUserModel.fromJson(response.data);
        if(authenticatedUserModel.role == UserRole.STUDENT){
          //get response data as AuthenticatedStudentModel
          AuthenticatedStudentModel authenticatedStudentModel = AuthenticatedStudentModel.fromJson(response.data);
          prefs.setString('firstName', authenticatedStudentModel.firstName!);
          prefs.setString('lastName', authenticatedStudentModel.lastName!);
          prefs.setString('email', authenticatedStudentModel.email!);
          prefs.setString('role', authenticatedStudentModel.role!);
          prefs.setString('accessToken', authenticatedStudentModel.accessToken!);
          prefs.setString('tokenType', authenticatedStudentModel.tokenType!);
          prefs.setInt('expiresIn', authenticatedStudentModel.expiresIn!);
          prefs.setString('refreshToken', authenticatedStudentModel.refreshToken!);
          prefs.setString('userInfo', authenticatedStudentModel.userInfo!.toJson().toString());
        }


        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }



}