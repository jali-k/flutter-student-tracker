class FolderCreateResponseModel {
  String? status;
  String? message;
  Data? data;

  FolderCreateResponseModel({this.status, this.message, this.data});

  FolderCreateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? folderId;
  String? folderName;
  String? folderDescription;
  Null? folderThumbnailUrl;
  int? dateCreated;
  int? dateModified;
  List<AllowedStudents>? allowedStudents;
  List<Null>? videos;
  bool? enabled;

  Data(
      {this.folderId,
        this.folderName,
        this.folderDescription,
        this.folderThumbnailUrl,
        this.dateCreated,
        this.dateModified,
        this.allowedStudents,
        this.videos,
        this.enabled});

  Data.fromJson(Map<String, dynamic> json) {
    folderId = json['folderId'];
    folderName = json['folderName'];
    folderDescription = json['folderDescription'];
    folderThumbnailUrl = json['folderThumbnailUrl'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    if (json['allowedStudents'] != null) {
      allowedStudents = <AllowedStudents>[];
      json['allowedStudents'].forEach((v) {
        allowedStudents!.add(new AllowedStudents.fromJson(v));
      });
    }
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folderId'] = this.folderId;
    data['folderName'] = this.folderName;
    data['folderDescription'] = this.folderDescription;
    data['folderThumbnailUrl'] = this.folderThumbnailUrl;
    data['dateCreated'] = this.dateCreated;
    data['dateModified'] = this.dateModified;
    if (this.allowedStudents != null) {
      data['allowedStudents'] =
          this.allowedStudents!.map((v) => v.toJson()).toList();
    }
    data['enabled'] = this.enabled;
    return data;
  }
}

class AllowedStudents {
  String? firstName;
  String? lastName;
  String? displayName;
  int? registrationNumber;
  User? user;

  AllowedStudents(
      {this.firstName,
        this.lastName,
        this.displayName,
        this.registrationNumber,
        this.user});

  AllowedStudents.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? firstName;
  String? lastName;
  Null? phoneNumber;
  String? username;
  bool? verified;
  List<Null>? roles;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.username,
        this.verified,
        this.roles});

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
