class LectureVideoUploadResponseModel {
  String? status;
  String? message;
  Data? data;

  LectureVideoUploadResponseModel({this.status, this.message, this.data});

  LectureVideoUploadResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? videoId;
  String? videoName;
  String? videoDescription;
  double? videoDuration;
  String? videoThumbnailUrl;
  String? uploadDate;
  String? folderId;
  String? videoResourceKey;
  String? thumbnailResourceKey;
  bool? free;
  bool? enabled;

  Data(
      {this.videoId,
        this.videoName,
        this.videoDescription,
        this.videoDuration,
        this.videoThumbnailUrl,
        this.uploadDate,
        this.folderId,
        this.videoResourceKey,
        this.thumbnailResourceKey,
        this.free,
        this.enabled});

  Data.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    videoName = json['videoName'];
    videoDescription = json['videoDescription'];
    videoDuration = json['videoDuration'];
    videoThumbnailUrl = json['videoThumbnailUrl'];
    uploadDate = json['uploadDate'];
    folderId = json['folderId'];
    videoResourceKey = json['videoResourceKey'];
    thumbnailResourceKey = json['thumbnailResourceKey'];
    free = json['free'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['videoName'] = this.videoName;
    data['videoDescription'] = this.videoDescription;
    data['videoDuration'] = this.videoDuration;
    data['videoThumbnailUrl'] = this.videoThumbnailUrl;
    data['uploadDate'] = this.uploadDate;
    data['folderId'] = this.folderId;
    data['videoResourceKey'] = this.videoResourceKey;
    data['thumbnailResourceKey'] = this.thumbnailResourceKey;
    data['free'] = this.free;
    data['enabled'] = this.enabled;
    return data;
  }
}
