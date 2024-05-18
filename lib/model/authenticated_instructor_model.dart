class AuthenticatedInstructorModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  UserInfo? userInfo;

  AuthenticatedInstructorModel(
      {this.firstName,
        this.lastName,
        this.email,
        this.role,
        this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.refreshToken,
        this.userInfo});

  AuthenticatedInstructorModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    refreshToken = json['refreshToken'];
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['role'] = this.role;
    data['accessToken'] = this.accessToken;
    data['tokenType'] = this.tokenType;
    data['expiresIn'] = this.expiresIn;
    data['refreshToken'] = this.refreshToken;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  String? instructorId;
  String? instructorGroup;
  List<Students>? students;

  UserInfo({this.instructorId, this.instructorGroup, this.students});

  UserInfo.fromJson(Map<String, dynamic> json) {
    instructorId = json['instructorId'];
    instructorGroup = json['instructorGroup'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instructorId'] = this.instructorId;
    data['instructorGroup'] = this.instructorGroup;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;

  Students(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber});

  Students.fromJson(Map<String, dynamic> json) {
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
