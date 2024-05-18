class AllMarkDataModel {
  String? status;
  String? message;
  List<MarkInfo>? data;

  AllMarkDataModel({this.status, this.message, this.data});

  AllMarkDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MarkInfo>[];
      json['data'].forEach((v) {
        data!.add(new MarkInfo.fromJson(v));
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

class MarkInfo {
  String? markId;
  Student? student;
  String? paperId;
  String? instructorId;
  double? essayMark;
  double? mcqMark;
  double? structuredMark;
  double? totalMark;
  bool? suspended;

  MarkInfo(
      {this.markId,
        this.student,
        this.paperId,
        this.instructorId,
        this.essayMark,
        this.mcqMark,
        this.structuredMark,
        this.totalMark,
        this.suspended});

  MarkInfo.fromJson(Map<String, dynamic> json) {
    markId = json['markId'];
    student =
    json['student'] != null ? new Student.fromJson(json['student']) : null;
    paperId = json['paperId'];
    instructorId = json['instructorId'];
    essayMark = json['essayMark'];
    mcqMark = json['mcqMark'];
    structuredMark = json['structuredMark'];
    totalMark = json['totalMark'];
    suspended = json['suspended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['markId'] = this.markId;
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    data['paperId'] = this.paperId;
    data['instructorId'] = this.instructorId;
    data['essayMark'] = this.essayMark;
    data['mcqMark'] = this.mcqMark;
    data['structuredMark'] = this.structuredMark;
    data['totalMark'] = this.totalMark;
    data['suspended'] = this.suspended;
    return data;
  }
}

class Student {
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;

  Student(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber});

  Student.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    registrationNumber = json['registrationNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['registrationNumber'] = this.registrationNumber;
    return data;
  }
}
