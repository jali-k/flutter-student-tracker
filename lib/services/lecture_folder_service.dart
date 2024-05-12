import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:spt/model/all_lecture_video_response_model.dart';
import 'package:spt/model/folder_create_response_model.dart';
import 'package:spt/model/lecture_video_upload_response_model.dart';
import 'package:spt/model/upload_resource.dart';

import '../model/all_folder_response_model.dart';
import '../model/student_allowed_folder_response_model.dart';
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

  static Future<FolderCreateResponseModel?> addFolder(
      BuildContext context,
      String folderName,
      String folderDescription,
      String allowType,
      List<String> allowStudents) async{
    try {
      Map<String, dynamic> data = {
        "folderName": folderName,
        "folderDescription": folderDescription,
        "allowType": allowType.toUpperCase(),
        "allowedStudentsEmails": allowStudents,
      };
      final response = await APIProvider.instance.postMultipart('/lecture/folder/create',data);
      if (response.statusCode == 200) {
        //get response data as AllFolderResponseModel
        FolderCreateResponseModel folderCreateResponseModel = FolderCreateResponseModel.fromJson(response.data);
        return folderCreateResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
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

  static Future<LectureVideoUploadResponseModel?> uploadLectureVideo(BuildContext context, String folderId, UploadResource element)async {
    try {
      Map<String, dynamic> data = {
        "videoName": element.videoTitle,
        "videoDescription": element.videoDescription,
        "videoDuration": element.videoDuraton,
        "video": MultipartFile.fromFileSync(element.videoFile.path),
        "thumbnail": MultipartFile.fromFileSync(element.videoThumbnailFile.path),
      };
      final response = await APIProvider.instance.postMultipart('/lecture/video/upload/$folderId',data);
      if (response.statusCode == 200) {
        return LectureVideoUploadResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<StudentAllowedFolderResponseModel?> getLectures() async {
    try {
      final response = await APIProvider.instance.get('/student/folder/get');
      if (response.statusCode == 200) {
        return StudentAllowedFolderResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


}