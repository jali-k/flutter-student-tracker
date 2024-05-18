import 'package:spt/model/add_mark_response_model.dart';
import 'package:spt/model/add_paper_response_model.dart';

import '../model/all_mark_data_model.dart';
import '../model/response_model.dart';
import '../model/student_all_mark_response_model.dart';
import 'api_provider.dart';

class PaperMarkService {
  static Future<AllMarkDataModel?> getPaperMarks(String paperID) async {
    try {
      final response = await APIProvider.instance.get('/mark/paper/$paperID');
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AllMarkDataModel allMarkDataModel =
            AllMarkDataModel.fromJson(response.data);
        return allMarkDataModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<AddMarkResponseModel?> addMarks(
      {required String paperID,
      required int studentID,
      required double mcq,
      required double structure,
      required double essay,
      required double totalMark}) async {
    try {
      final response = await APIProvider.instance.post('/mark/add', {
        "paperId": paperID,
        "studentId": studentID,
        "essayMarks": essay,
        "mcqMarks": mcq,
        "structuredMarks": structure,
        "totalMark": totalMark
      });
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AddMarkResponseModel addMarkResponseModel =
            AddMarkResponseModel.fromJson(response.data);
        return addMarkResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<AddMarkResponseModel?> updateMarks(
      {required String markID,
      required String paperID,
      required int studentID,
      required double mcq,
      required double structure,
      required double essay,
      required double totalMark}) async {
    try {
      final response =
          await APIProvider.instance.put('/mark/update/${markID}', {
        "paperId": paperID,
        "studentId": studentID,
        "essayMarks": essay,
        "mcqMarks": mcq,
        "structuredMarks": structure,
        "totalMark": totalMark
      });
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AddMarkResponseModel addMarkResponseModel =
            AddMarkResponseModel.fromJson(response.data);
        return addMarkResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<AddPaperResponseModel?> addPaper(
      {required String paperName,
      required bool isMcq,
      required bool isStructured,
      required bool isEssay}) async {
    try {
      final response = await APIProvider.instance.post('/paper/create', {
        "paperName": paperName,
        "paperDescription": paperName,
        "structured": isStructured,
        "essay": isEssay,
        "mcq": isMcq
      });
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        AddPaperResponseModel addPaperResponseModel =
            AddPaperResponseModel.fromJson(response.data);
        return addPaperResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<ResponseModel?> deletePaper({required String paperID}) async {
    try {
      final response =
          await APIProvider.instance.delete('/paper/delete/$paperID', null);
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        ResponseModel deletePaperResponseModel =
            ResponseModel.fromJson(response.data);
        return deletePaperResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<StudentAllMarkResponseModel?> getStudentAllMarks() async {
    try {
      final response = await APIProvider.instance.get('/mark/student');
      if (response.statusCode == 200) {
        //get response data as StudentAllMarkResponseModel
        StudentAllMarkResponseModel studentAllMarkResponseModel =
            StudentAllMarkResponseModel.fromJson(response.data);
        return studentAllMarkResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<ResponseModel?> deleteMarks({required markID}) async {
    try {
      final response = await APIProvider.instance.delete('/mark/$markID', null);
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        ResponseModel deletePaperResponseModel =
            ResponseModel.fromJson(response.data);
        return deletePaperResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<ResponseModel?> generateLeaderBoard(
      {required String paperID}) async {
    try {
      final response =
          await APIProvider.instance.post('/paper/generate-leaderboard?paperId=$paperID', {});
      if (response.statusCode == 200) {
        //get response data as AllMarkDataModel
        ResponseModel deletePaperResponseModel =
            ResponseModel.fromJson(response.data);
        return deletePaperResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
