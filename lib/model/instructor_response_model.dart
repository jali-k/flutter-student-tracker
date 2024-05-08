class InstructorResponseModel {
  String? status;
  String? message;
  List<InstructorInfo>? data;

  InstructorResponseModel({this.status, this.message, this.data});

  InstructorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InstructorInfo>[];
      json['data'].forEach((v) {
        data!.add(new InstructorInfo.fromJson(v));
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

class InstructorInfo {
  String? instructorId;
  String? instructorGroup;
  String? firstName;
  String? lastName;
  String? email;
  List<Students>? students;

  InstructorInfo(
      {this.instructorId,
        this.instructorGroup,
        this.firstName,
        this.lastName,
        this.email,
        this.students});

  InstructorInfo.fromJson(Map<String, dynamic> json) {
    instructorId = json['instructorId'];
    instructorGroup = json['instructorGroup'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
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
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
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
