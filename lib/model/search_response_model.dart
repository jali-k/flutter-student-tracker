class SearchStudentResponseModel {
  String? status;
  String? message;
  SearchStudentData? data;

  SearchStudentResponseModel({this.status, this.message, this.data});

  SearchStudentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SearchStudentData.fromJson(json['data']) : null;
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

class SearchStudentData {
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;
  String? phoneNumber;
  User? user;

  SearchStudentData(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber,
        this.phoneNumber,
        this.user});

  SearchStudentData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
    registrationNumber = json['registrationNumber'];
    phoneNumber = json['phoneNumber'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    data['registrationNumber'] = this.registrationNumber;
    data['phoneNumber'] = this.phoneNumber;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
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
