class CurrentFocusSessionResponseModel {
  String? status;
  String? message;
  Data? data;

  CurrentFocusSessionResponseModel({this.status, this.message, this.data});

  CurrentFocusSessionResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? focusSessionId;
  String? focusSessionStatus;
  int? startTime;
  int? endTime;
  int? duration;
  String? remarks;
  Lesson? lesson;
  Subject? subject;

  Data(
      {this.focusSessionId,
        this.focusSessionStatus,
        this.startTime,
        this.endTime,
        this.duration,
        this.remarks,
        this.lesson,
        this.subject});

  Data.fromJson(Map<String, dynamic> json) {
    focusSessionId = json['focusSessionId'];
    focusSessionStatus = json['focusSessionStatus'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    duration = json['duration'];
    remarks = json['remarks'];
    lesson =
    json['lesson'] != null ? new Lesson.fromJson(json['lesson']) : null;
    subject =
    json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focusSessionId'] = this.focusSessionId;
    data['focusSessionStatus'] = this.focusSessionStatus;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['duration'] = this.duration;
    data['remarks'] = this.remarks;
    if (this.lesson != null) {
      data['lesson'] = this.lesson!.toJson();
    }
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    return data;
  }
}

class Lesson {
  String? lessonId;
  String? lessonName;
  String? lessonDescription;
  bool? enabled;

  Lesson(
      {this.lessonId, this.lessonName, this.lessonDescription, this.enabled});

  Lesson.fromJson(Map<String, dynamic> json) {
    lessonId = json['lessonId'];
    lessonName = json['lessonName'];
    lessonDescription = json['lessonDescription'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lessonId'] = this.lessonId;
    data['lessonName'] = this.lessonName;
    data['lessonDescription'] = this.lessonDescription;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Subject {
  String? subjectId;
  String? subjectName;
  Null? lessons;
  bool? core;
  bool? enabled;

  Subject(
      {this.subjectId,
        this.subjectName,
        this.lessons,
        this.core,
        this.enabled});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    lessons = json['lessons'];
    core = json['core'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    data['lessons'] = this.lessons;
    data['core'] = this.core;
    data['enabled'] = this.enabled;
    return data;
  }
}
