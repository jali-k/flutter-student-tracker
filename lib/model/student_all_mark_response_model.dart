class StudentAllMarkResponseModel {
  String? status;
  String? message;
  List<MarkData>? data;

  StudentAllMarkResponseModel({this.status, this.message, this.data});

  StudentAllMarkResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MarkData>[];
      json['data'].forEach((v) {
        data!.add(new MarkData.fromJson(v));
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

class MarkData {
  String? markId;
  Student? student;
  String? paperId;
  String? instructorId;
  PaperData? paper;
  double? essayMark;
  double? mcqMark;
  double? structuredMark;
  double? totalMark;
  bool? suspended;

  MarkData(
      {this.markId,
        this.student,
        this.paperId,
        this.instructorId,
        this.paper,
        this.essayMark,
        this.mcqMark,
        this.structuredMark,
        this.totalMark,
        this.suspended});

  MarkData.fromJson(Map<String, dynamic> json) {
    markId = json['markId'];
    student =
    json['student'] != null ? new Student.fromJson(json['student']) : null;
    paperId = json['paperId'];
    instructorId = json['instructorId'];
    paper = json['paper'] != null ? new PaperData.fromJson(json['paper']) : null;
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
    if (this.paper != null) {
      data['paper'] = this.paper!.toJson();
    }
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
  Null? phoneNumber;
  int? registrationNumber;
  Null? user;

  Student(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.phoneNumber,
        this.registrationNumber,
        this.user});

  Student.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    phoneNumber = json['phoneNumber'];
    registrationNumber = json['registrationNumber'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['phoneNumber'] = this.phoneNumber;
    data['registrationNumber'] = this.registrationNumber;
    data['user'] = this.user;
    return data;
  }
}

class PaperData {
  String? paperId;
  String? paperName;
  String? paperDescription;
  bool? markReleased;
  bool? enabled;
  bool? essay;
  bool? mcq;
  bool? structured;

  PaperData(
      {this.paperId,
        this.paperName,
        this.paperDescription,
        this.markReleased,
        this.enabled,
        this.essay,
        this.mcq,
        this.structured});

  PaperData.fromJson(Map<String, dynamic> json) {
    paperId = json['paperId'];
    paperName = json['paperName'];
    paperDescription = json['paperDescription'];
    markReleased = json['markReleased'];
    enabled = json['enabled'];
    essay = json['essay'];
    mcq = json['mcq'];
    structured = json['structured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paperId'] = this.paperId;
    data['paperName'] = this.paperName;
    data['paperDescription'] = this.paperDescription;
    data['markReleased'] = this.markReleased;
    data['enabled'] = this.enabled;
    data['essay'] = this.essay;
    data['mcq'] = this.mcq;
    data['structured'] = this.structured;
    return data;
  }
}
