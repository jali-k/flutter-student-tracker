class StudentOfInstructorModel {
  String? status;
  String? message;
  List<StudentInfo>? data;

  StudentOfInstructorModel({this.status, this.message, this.data});

  StudentOfInstructorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StudentInfo>[];
      json['data'].forEach((v) {
        data!.add(new StudentInfo.fromJson(v));
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

class StudentInfo {
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;

  StudentInfo(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber});

  StudentInfo.fromJson(Map<String, dynamic> json) {
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
