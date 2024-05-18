class SubjectResponseModel {
  String? status;
  Null? message;
  List<Subject>? data;

  SubjectResponseModel({this.status, this.message, this.data});

  SubjectResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Subject>[];
      json['data'].forEach((v) {
        data!.add(new Subject.fromJson(v));
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

class Subject {
  String? subjectId;
  String? subjectName;
  List<Lessons>? lessons;
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
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(new Lessons.fromJson(v));
      });
    }
    core = json['core'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    if (this.lessons != null) {
      data['lessons'] = this.lessons!.map((v) => v.toJson()).toList();
    }
    data['core'] = this.core;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Lessons {
  String? lessonId;
  String? lessonName;
  String? lessonDescription;
  bool? enabled;

  Lessons(
      {this.lessonId, this.lessonName, this.lessonDescription, this.enabled});

  Lessons.fromJson(Map<String, dynamic> json) {
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
