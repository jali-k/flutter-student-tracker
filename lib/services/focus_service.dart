import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/subject_response_model.dart';
import 'package:spt/util/toast_util.dart';

import '../model/created_focus_session_data_model.dart';
import '../model/focus_session_in_week_stat_data_model.dart';
import '../model/focus_sessions_data_model.dart';
import 'api_provider.dart';

class FocusSessionService{


  static Future<bool> startFocusSession(BuildContext context,Lessons lesson, int duration,String remark) async {
    //generate random id
    final prefs = await SharedPreferences.getInstance();
    final response = await APIProvider.instance.post('/student/focus-session',{
      "lessonId": lesson.lessonId,
      "remark": remark,
      "duration": duration,
      "startTime": DateTime.now().toIso8601String(),
    });
    if(response.statusCode == 200){
      CreatedFocusSessionDataModel focusSessionData = CreatedFocusSessionDataModel.fromJson(response.data);
      if(focusSessionData.status == 'Success') {
        ToastUtil.showSuccessToast(context, "Success", "Focus Session Started");
        prefs.setBool('enabledFocus', true);
        prefs.setString('focusData', response.data.toString());
        return true;
      }else{
        ToastUtil.showErrorToast(context, "Error", focusSessionData.message!);
        //TODO: Handle error and Navigate to Focus Mode
        return false;
      }
    }else{

    }
    return false;
  }

  static Future<FocusSessionsDataModel?> getAllFocusSessionOfYear(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session');
    if(response.statusCode == 200){
      return FocusSessionsDataModel.fromJson(response.data);
    }else{
      ToastUtil.showErrorToast(context, "Error", "Failed to get focus sessions");
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInWeekFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-week');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      ToastUtil.showErrorToast(context, "Error", "Failed to get focus sessions");
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInMonthFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-month');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      ToastUtil.showErrorToast(context, "Error", "Failed to get focus sessions");
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInYearFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-year');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      ToastUtil.showErrorToast(context, "Error", "Failed to get focus sessions");
      return null;
    }
  }


  static Future<CreatedFocusSessionDataModel> getCurrentFocusSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await APIProvider.instance.get('/student/focus-session/current');
    if(response.statusCode == 200) {
      CreatedFocusSessionDataModel focusSessionData = CreatedFocusSessionDataModel.fromJson(
          response.data);
      if (focusSessionData.status == 'Success') {
        return focusSessionData;
      } else {
        ToastUtil.showErrorToast(context, "Error", focusSessionData.message!);
      }
    }
      return CreatedFocusSessionDataModel(status: 'Failed', message: 'Failed to get current focus session');

  }
}