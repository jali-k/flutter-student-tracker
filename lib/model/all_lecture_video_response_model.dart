class AllLectureVideoResponseModel {
  String? status;
  String? message;
  List<LectureVideoInfo>? data;

  AllLectureVideoResponseModel({this.status, this.message, this.data});

  AllLectureVideoResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LectureVideoInfo>[];
      json['data'].forEach((v) {
        data!.add(new LectureVideoInfo.fromJson(v));
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

class LectureVideoInfo {
  String? videoId;
  String? videoName;
  String? videoDescription;
  String? videoUrl;
  double? videoDuration;
  String? videoThumbnailUrl;
  int? uploadDate;
  bool? free;
  bool? enabled;

  LectureVideoInfo(
      {this.videoId,
        this.videoName,
        this.videoDescription,
        this.videoUrl,
        this.videoDuration,
        this.videoThumbnailUrl,
        this.uploadDate,
        this.free,
        this.enabled});

  LectureVideoInfo.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    videoName = json['videoName'];
    videoDescription = json['videoDescription'];
    videoUrl = json['videoUrl'];
    videoDuration = json['videoDuration'];
    videoThumbnailUrl = json['videoThumbnailUrl'];
    uploadDate = json['uploadDate'];
    free = json['free'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['videoName'] = this.videoName;
    data['videoDescription'] = this.videoDescription;
    data['videoUrl'] = this.videoUrl;
    data['videoDuration'] = this.videoDuration;
    data['videoThumbnailUrl'] = this.videoThumbnailUrl;
    data['uploadDate'] = this.uploadDate;
    data['free'] = this.free;
    data['enabled'] = this.enabled;
    return data;
  }
}
