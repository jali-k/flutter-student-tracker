import '../model/all_student_response_model.dart';
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

}