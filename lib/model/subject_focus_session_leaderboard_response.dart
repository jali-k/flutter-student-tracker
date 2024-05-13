import 'focus_session_leaderboard_response_model.dart';

class SubjectFocusSessionLeaderboardResponse {
  String? status;
  String? message;
  Data? data;

  SubjectFocusSessionLeaderboardResponse(
      {this.status, this.message, this.data});

  SubjectFocusSessionLeaderboardResponse.fromJson(Map<String, dynamic> json) {
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
  List<FSLeaderboardPosition>? biology;
  List<FSLeaderboardPosition>? chemistry;
  List<FSLeaderboardPosition>? physics;
  List<FSLeaderboardPosition>? agriculture;

  Data({this.biology, this.chemistry, this.physics, this.agriculture});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['biology'] != null) {
      biology = <FSLeaderboardPosition>[];
      json['biology'].forEach((v) {
        biology!.add(new FSLeaderboardPosition.fromJson(v));
      });
    }
    if (json['chemistry'] != null) {
      chemistry = <FSLeaderboardPosition>[];
      json['chemistry'].forEach((v) {
        chemistry!.add(new FSLeaderboardPosition.fromJson(v));
      });
    }
    if (json['physics'] != null) {
      physics = <FSLeaderboardPosition>[];
      json['physics'].forEach((v) {
        physics!.add(new FSLeaderboardPosition.fromJson(v));
      });
    }
    if (json['agriculture'] != null) {
      agriculture = <FSLeaderboardPosition>[];
      json['agriculture'].forEach((v) {
        agriculture!.add(new FSLeaderboardPosition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.biology != null) {
      data['biology'] = this.biology!.map((v) => v.toJson()).toList();
    }
    if (this.chemistry != null) {
      data['chemistry'] = this.chemistry!.map((v) => v.toJson()).toList();
    }
    if (this.physics != null) {
      data['physics'] = this.physics!.map((v) => v.toJson()).toList();
    }
    if (this.agriculture != null) {
      data['agriculture'] = this.agriculture!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}