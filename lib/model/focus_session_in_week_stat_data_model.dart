import 'package:spt/model/current_focus_session_response.dart';

class FocusSessionsInWeekStatsDataModel {
  String? status;
  String? message;
  List<InWeekData>? data;

  FocusSessionsInWeekStatsDataModel({this.status, this.message, this.data});

  FocusSessionsInWeekStatsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InWeekData>[];
      json['data'].forEach((v) {
        data!.add(new InWeekData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InWeekData {
  int? day;
  TotalDuration? totalDuration;
  List<FocusSessions>? focusSessions;

  InWeekData({this.day, this.totalDuration, this.focusSessions});

  InWeekData.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    totalDuration = json['totalDuration'] != null
        ? new TotalDuration.fromJson(json['totalDuration'])
        : null;
    if (json['focusSessions'] != null) {
      focusSessions = <FocusSessions>[];
      json['focusSessions'].forEach((v) {
        focusSessions!.add(new FocusSessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.totalDuration != null) {
      data['totalDuration'] = this.totalDuration!.toJson();
    }
    if (this.focusSessions != null) {
      data['focusSessions'] =
          this.focusSessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalDuration {
  int? hours;
  int? minutes;
  int? seconds;

  TotalDuration({this.hours, this.minutes, this.seconds});

  TotalDuration.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    minutes = json['minutes'];
    seconds = json['seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hours'] = this.hours;
    data['minutes'] = this.minutes;
    data['seconds'] = this.seconds;
    return data;
  }
}

class FocusSessions {
  String? focusSessionId;
  String? focusSessionStatus;
  int? startTime;
  int? endTime;
  int? duration;
  String? remarks;
  Subject? subject;

  FocusSessions(
      {this.focusSessionId,
        this.focusSessionStatus,
        this.startTime,
        this.endTime,
        this.duration,
        this.subject,
        this.remarks});

  FocusSessions.fromJson(Map<String, dynamic> json) {
    focusSessionId = json['focusSessionId'];
    focusSessionStatus = json['focusSessionStatus'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    duration = json['duration'];
    remarks = json['remarks'];
    subject = json['subject'] != null
        ? Subject.fromJson(json['subject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focusSessionId'] = this.focusSessionId;
    data['focusSessionStatus'] = this.focusSessionStatus;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['duration'] = this.duration;
    data['remarks'] = this.remarks;
    return data;
  }
}
