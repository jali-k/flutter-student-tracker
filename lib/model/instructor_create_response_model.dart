class InstructorCreateResponseModel {
  String? status;
  String? message;
  Data? data;

  InstructorCreateResponseModel({this.status, this.message, this.data});

  InstructorCreateResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? instructorId;
  String? instructorGroup;

  Data({this.instructorId, this.instructorGroup});

  Data.fromJson(Map<String, dynamic> json) {
    instructorId = json['instructorId'];
    instructorGroup = json['instructorGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instructorId'] = this.instructorId;
    data['instructorGroup'] = this.instructorGroup;
    return data;
  }
}
