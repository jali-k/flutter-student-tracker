class FocusSessionLeaderboardResponseModel {
  String? status;
  String? message;
  List<FSLeaderboardPosition>? data;

  FocusSessionLeaderboardResponseModel({this.status, this.message, this.data});

  FocusSessionLeaderboardResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FSLeaderboardPosition>[];
      json['data'].forEach((v) {
        data!.add(new FSLeaderboardPosition.fromJson(v));
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

class FSLeaderboardPosition {
  String? studentId;
  String? studentName;
  int? totalFocusTime;
  double? totalMarks;
  int? totalFocusSessions;
  int? leaderBoardRank;
  bool? currentUser;

  FSLeaderboardPosition(
      {this.studentId,
        this.studentName,
        this.totalFocusTime,
        this.totalFocusSessions,
        this.leaderBoardRank,
        this.currentUser});

  FSLeaderboardPosition.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    totalFocusTime = json['totalFocusTime'];
    totalMarks = json['totalMarks'];
    totalFocusSessions = json['totalFocusSessions'];
    leaderBoardRank = json['leaderBoardRank'];
    currentUser = json['currentUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    data['totalFocusTime'] = this.totalFocusTime;
    data['totalMarks'] = this.totalMarks;
    data['totalFocusSessions'] = this.totalFocusSessions;
    data['leaderBoardRank'] = this.leaderBoardRank;
    data['currentUser'] = this.currentUser;
    return data;
  }
}
