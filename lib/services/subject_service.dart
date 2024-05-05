

import 'package:spt/model/subject_response_model.dart';
import 'package:spt/services/api_provider.dart';

class SubjectService{
  static Future<SubjectResponseModel> getAllSubject() async {
    APIProvider instance = APIProvider.instance;
    final response = await instance.get('/subject/all');
    if (response.statusCode == 200) {
      return SubjectResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}