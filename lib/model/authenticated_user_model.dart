class AuthenticatedUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;

  AuthenticatedUserModel(
      {this.firstName,
        this.lastName,
        this.email,
        this.role,
        this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.refreshToken});

  AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'];
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    refreshToken = json['refreshToken'];
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
    return data;
  }
}
