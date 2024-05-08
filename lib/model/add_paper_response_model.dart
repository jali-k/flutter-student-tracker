class AddPaperResponseModel {
  String? status;
  String? message;
  Data? data;

  AddPaperResponseModel({this.status, this.message, this.data});

  AddPaperResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? paperId;
  String? paperName;
  String? paperDescription;
  bool? structured;
  bool? essay;
  bool? mcq;

  Data(
      {this.paperId,
        this.paperName,
        this.paperDescription,
        this.structured,
        this.essay,
        this.mcq});

  Data.fromJson(Map<String, dynamic> json) {
    paperId = json['paperId'];
    paperName = json['paperName'];
    paperDescription = json['paperDescription'];
    structured = json['structured'];
    essay = json['essay'];
    mcq = json['mcq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paperId'] = this.paperId;
    data['paperName'] = this.paperName;
    data['paperDescription'] = this.paperDescription;
    data['structured'] = this.structured;
    data['essay'] = this.essay;
    data['mcq'] = this.mcq;
    return data;
  }
}
