class AllPapersDataModel {
  String? status;
  Null? message;
  List<PaperInfo>? data;

  AllPapersDataModel({this.status, this.message, this.data});

  AllPapersDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PaperInfo>[];
      json['data'].forEach((v) {
        data!.add(new PaperInfo.fromJson(v));
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

class PaperInfo {
  String? paperId;
  String? paperName;
  String? paperDescription;
  bool? structured;
  bool? essay;
  bool? mcq;

  PaperInfo(
      {this.paperId,
        this.paperName,
        this.paperDescription,
        this.structured,
        this.essay,
        this.mcq});

  PaperInfo.fromJson(Map<String, dynamic> json) {
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
