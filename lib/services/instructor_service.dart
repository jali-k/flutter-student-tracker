import 'package:spt/model/students_of_instructor_model.dart';

import '../model/authenticated_student_model.dart';
import '../model/focus_session_in_week_stat_data_model.dart';
import '../model/instructor_create_response_model.dart';
import '../model/instructor_response_model.dart';
import '../model/response_model.dart';
import 'api_provider.dart';

class InstructorService{

  static Future<StudentOfInstructorModel?> getInstructorStudentDetails() async{
    try {
      final response = await APIProvider.instance.get('/instructor/students');
      if (response.statusCode == 200) {
        //get response data as AuthenticatedStudentModel
        StudentOfInstructorModel authenticatedStudentModel = StudentOfInstructorModel.fromJson(response.data);
        return authenticatedStudentModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<InstructorCreateResponseModel?> createInstructor({
    required String instructorEmail,
    required String firstName,
    required String lastName,
    required String? group
  }) async {
    try {
      final response = await APIProvider.instance.post('/instructor/create', {
        "firstName": firstName,
        "lastName": lastName,
        "username": "$firstName $lastName",
        "email": instructorEmail,
        "instructorGroup": group
      });
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        InstructorCreateResponseModel responseModel = InstructorCreateResponseModel.fromJson(response.data);
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  static Future<InstructorResponseModel?> getAllInstructor() async {
    try {
      final response = await APIProvider.instance.get('/admin/instructor');
      if (response.statusCode == 200) {
        //get response data as ResponseModel
        InstructorResponseModel responseModel = InstructorResponseModel.fromJson(response.data);
        return responseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  static Future<FocusSessionsInWeekStatsDataModel?> getFocusSessionsInWeekStats(String studentID) async {
    try {
      final response = await APIProvider.instance.get('/student/focus-session/$studentID');
      if (response.statusCode == 200) {
        //get response data as FocusSessionsInWeekStatsDataModel
        FocusSessionsInWeekStatsDataModel focusSessionsInWeekStatsDataModel = FocusSessionsInWeekStatsDataModel.fromJson(response.data);
        return focusSessionsInWeekStatsDataModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}