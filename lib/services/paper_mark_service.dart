import 'package:spt/model/add_mark_response_model.dart';

import '../model/all_mark_data_model.dart';
import 'api_provider.dart';

class PaperMarkService{

  static Future<AllMarkDataModel?> getPaperMarks(String paperID) async{
    try {
      final response = await APIProvider.instance.get('/mark/paper/$paperID');
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AllMarkDataModel allMarkDataModel = AllMarkDataModel.fromJson(response.data);
        return allMarkDataModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<AddMarkResponseModel?> addMarks({
    required String paperID,
    required int studentID,
    required double mcq,
    required double structure,
    required double essay,
    required double totalMark
  }) async {
    try {
      final response = await APIProvider.instance.post('/mark/add',{
        "paperId": paperID,
        "studentId": studentID,
        "essayMarks": essay,
        "mcqMarks": mcq,
        "structuredMarks": structure,
        "totalMark": totalMark
      });
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AddMarkResponseModel addMarkResponseModel = AddMarkResponseModel.fromJson(response.data);
        return addMarkResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}