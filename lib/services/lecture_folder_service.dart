import 'package:flutter/cupertino.dart';
import 'package:spt/model/all_lecture_video_response_model.dart';

import '../model/all_folder_response_model.dart';
import 'api_provider.dart';

class LectureFolderService{

  static Future<AllFolderResponseModel> getAllFolder(BuildContext context) async{
    try {
      final response = await APIProvider.instance.get('/lecture/all');
      if (response.statusCode == 200) {
        //get response data as AllFolderResponseModel
        AllFolderResponseModel allFolderResponseModel = AllFolderResponseModel.fromJson(response.data);
        return allFolderResponseModel;
      } else {
        return AllFolderResponseModel();
      }
    } catch (e) {
      print('Error: $e');
      return AllFolderResponseModel();
    }
  }

  static Future<AllLectureVideoResponseModel?> getAllLectureVideo(BuildContext context, String lectureId) async {
    try {
      final response = await APIProvider.instance.get('/lecture/folder/$lectureId');
      if (response.statusCode == 200) {
        //get response data as AllFolderResponseModel
        AllLectureVideoResponseModel allFolderResponseModel = AllLectureVideoResponseModel.fromJson(response.data);
        return allFolderResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


}