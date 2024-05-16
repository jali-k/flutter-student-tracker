class FocusSessionByStudent {
  String? status;
  String? message;
  List<SubjectWiseFocusData>? data;

  FocusSessionByStudent({this.status, this.message, this.data});

  FocusSessionByStudent.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubjectWiseFocusData>[];
      json['data'].forEach((v) {
        data!.add(new SubjectWiseFocusData.fromJson(v));
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

class SubjectWiseFocusData {
  Subject? subject;
  SubjectWiseTotalDuration? totalDuration;
  List<SubjectWiseFocusSessions>? focusSessions;

  SubjectWiseFocusData({this.subject, this.totalDuration, this.focusSessions});

  SubjectWiseFocusData.fromJson(Map<String, dynamic> json) {
    subject =
    json['subject'] != null ? new Subject.fromJson(json['subject']) : null;
    totalDuration = json['totalDuration'] != null
        ? new SubjectWiseTotalDuration.fromJson(json['totalDuration'])
        : null;
    if (json['focusSessions'] != null) {
      focusSessions = <SubjectWiseFocusSessions>[];
      json['focusSessions'].forEach((v) {
        focusSessions!.add(new SubjectWiseFocusSessions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
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

class Subject {
  String? subjectId;
  String? subjectName;
  Null? lessons;
  bool? enabled;
  bool? core;

  Subject(
      {this.subjectId,
        this.subjectName,
        this.lessons,
        this.enabled,
        this.core});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    lessons = json['lessons'];
    enabled = json['enabled'];
    core = json['core'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    data['lessons'] = this.lessons;
    data['enabled'] = this.enabled;
    data['core'] = this.core;
    return data;
  }
}

class SubjectWiseTotalDuration {
  int? hours;
  int? minutes;
  int? seconds;

  SubjectWiseTotalDuration({this.hours, this.minutes, this.seconds});

  SubjectWiseTotalDuration.fromJson(Map<String, dynamic> json) {
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

class SubjectWiseFocusSessions {
  String? focusSessionId;
  String? focusSessionStatus;
  int? startTime;
  int? endTime;
  int? duration;
  String? remarks;
  Lesson? lesson;
  Subject? subject;

  SubjectWiseFocusSessions(
      {this.focusSessionId,
        this.focusSessionStatus,
        this.startTime,
        this.endTime,
        this.duration,
        this.remarks,
        this.lesson,
        this.subject});

  SubjectWiseFocusSessions.fromJson(Map<String, dynamic> json) {
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
