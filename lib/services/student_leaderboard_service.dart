
import 'package:dio/dio.dart';
import 'package:spt/model/focus_session_leaderboard_response_model.dart';
import 'package:spt/model/response_model.dart';
import 'package:spt/util/toast_util.dart';

import '../model/subject_focus_session_leaderboard_response.dart';
import 'api_provider.dart';

class StudentLeaderboardService{
  static Future<FocusSessionLeaderboardResponseModel?> getFocusSessionOverallLeaderBoard() async{
    try{
      final response = await APIProvider.instance.get('/student/focus-session/leaderboard');
      if(response.statusCode == 200){
        //get response data as StudentAllMarkResponseModel
        FocusSessionLeaderboardResponseModel studentAllMarkResponseModel = FocusSessionLeaderboardResponseModel.fromJson(response.data);
        return studentAllMarkResponseModel;
      }else{
        return null;
      }

    }catch(e){
      print('Error: $e');
      return null;
    }
  }

  static Future<SubjectFocusSessionLeaderboardResponse?> getSubjectFocusSessionOverallLeaderBoard() async{
    try{
      final response = await APIProvider.instance.get('/student/focus-session/leaderboard/subject');
      if(response.statusCode == 200){
        //get response data as StudentAllMarkResponseModel
        SubjectFocusSessionLeaderboardResponse studentAllMarkResponseModel = SubjectFocusSessionLeaderboardResponse.fromJson(response.data);
        return studentAllMarkResponseModel;
      }else{
        return null;
      }

    }catch(e){
      print('Error: $e');
      return null;
    }
  }

  static Future<FocusSessionLeaderboardResponseModel?> getPaperLeaderboard(String paperID) async{
    try{
      final response = await APIProvider.instance.get('/paper/leaderboard/$paperID');
      if(response.statusCode == 200){
        //get response data as StudentAllMarkResponseModel
        FocusSessionLeaderboardResponseModel studentAllMarkResponseModel = FocusSessionLeaderboardResponseModel.fromJson(response.data);
        return studentAllMarkResponseModel;
      }else if(response.statusCode == 400) {
        ResponseModel responseModel = ResponseModel.fromJson(response.data);
        return null;
      }
      else{
        return null;
      }

    }catch(e){
      print('Error: $e');
      return null;
    }
  }


}

