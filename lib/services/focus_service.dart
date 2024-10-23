import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/model/current_focus_session_response.dart';
import 'package:spt/model/focus_session_by_student.dart';
import 'package:spt/model/response_model.dart';
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
      "startTime": DateTime.now().toUtc().toIso8601String(),
    });
    if(response.statusCode == 200){
      CreatedFocusSessionDataModel focusSessionData = CreatedFocusSessionDataModel.fromJson(response.data);
      if(focusSessionData.status == 'Successful') {
        ToastUtil.showSuccessToast(context, "Success", "Focus Session Started");
        prefs.setBool('enabledFocus', true);
        prefs.setString('focusData', jsonEncode(response.data));
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
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInWeekFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-week');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInMonthFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-month');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      return null;
    }
  }
  static Future<FocusSessionsInWeekStatsDataModel?> getInYearFocusSessionStat(BuildContext context) async {
    final response = await APIProvider.instance.get('/student/focus-session/stats/in-year');
    if(response.statusCode == 200){
      return FocusSessionsInWeekStatsDataModel.fromJson(response.data);
    }else{
      return null;
    }
  }


  static Future<CurrentFocusSessionResponseModel?> getCurrentFocusSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await APIProvider.instance.get('/student/focus-session/current');
    if(response.statusCode == 200) {
      CurrentFocusSessionResponseModel focusSessionData = CurrentFocusSessionResponseModel.fromJson(
          response.data);
      if (focusSessionData.status == 'Successful') {
        return focusSessionData;
      } else {
        ToastUtil.showErrorToast(context, "Error", "Something Wrong");
      }
    }
      return null;

  }


  static Future<CurrentFocusSessionResponseModel?> isFocusSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isEnabled= prefs.getBool('enabledFocus') ?? false;
    CurrentFocusSessionResponseModel? fs = await getCurrentFocusSession(context);
    if(fs != null){
      // prefs.setBool('enabledFocus', true);
      return fs;
    }
    return null;
  }

  static Future<bool> stopFocusSession(BuildContext context) async{
    DateTime now = DateTime.now();
    Object data = {
      "endTime": DateTime.now().toUtc().toIso8601String(),
    };
    final response = await APIProvider.instance.post('/student/focus-session/stop',data);
    if(response.statusCode == 200) {
        return true;
    }
    return false;
  }

  static Future<bool> cancelFocusSession(BuildContext context) async{
    final response = await APIProvider.instance.post('/student/focus-session/cancel',{});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      prefs.setBool('enabledFocus', false);
      prefs.remove('focusData');
      return true;
    }
    return false;
  }

  static Future<FocusSessionByStudent?> getFocusSessionByStudent(BuildContext context) async {
    try{
      final response = await APIProvider.instance.get('/student/focus-session/subject-summary');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(response.statusCode == 200) {
        return FocusSessionByStudent.fromJson(response.data);
      }
      return null;
    }catch(e){
      print("Error: $e");
      return null;
    }
  }
}