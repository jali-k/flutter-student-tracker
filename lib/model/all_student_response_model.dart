class AllStudentResponseModel {
  String? status;
  String? message;
  List<StudentInfo>? data;

  AllStudentResponseModel({this.status, this.message, this.data});

  AllStudentResponseModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  StudentInfo(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber,
        this.user});

  StudentInfo.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    registrationNumber = json['registrationNumber'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['registrationNumber'] = this.registrationNumber;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  Null? id;
  String? firstName;
  String? lastName;
  Null? phoneNumber;
  String? username;
  bool? verified;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.username,
        this.verified,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    username = json['username'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['username'] = this.username;
    data['verified'] = this.verified;
    return data;
  }
}
