class CreatedFocusSessionDataModel {
  String? status;
  String? message;
  Data? data;

  CreatedFocusSessionDataModel({this.status, this.message, this.data});

  CreatedFocusSessionDataModel.fromJson(Map<String, dynamic> json) {
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
  String? focusSessionId;
  String? focusSessionStatus;
  int? startTime;
  int? endTime;
  int? duration;
  String? remarks;

  Data(
      {this.focusSessionId,
        this.focusSessionStatus,
        this.startTime,
        this.endTime,
        this.duration,
        this.remarks});

  Data.fromJson(Map<String, dynamic> json) {
    focusSessionId = json['focusSessionId'];
    focusSessionStatus = json['focusSessionStatus'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    duration = json['duration'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['focusSessionId'] = this.focusSessionId;
    data['focusSessionStatus'] = this.focusSessionStatus;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['duration'] = this.duration;
    data['remarks'] = this.remarks;
    return data;
  }
}
