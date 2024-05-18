class AuthenticatedStudentModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  UserInfo? userInfo;

  AuthenticatedStudentModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.role,
      this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.refreshToken,
      this.userInfo});

  AuthenticatedStudentModel.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;

  UserInfo(
      {this.firstName,
      this.lastName,
      this.displayName,
      this.registrationNumber});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
