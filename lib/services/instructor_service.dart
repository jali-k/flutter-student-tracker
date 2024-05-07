import 'package:spt/model/students_of_instructor_model.dart';

import '../model/authenticated_student_model.dart';
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
}