class StudentAllowedFolderResponseModel {
  String? status;
  String? message;
  List<FolderData>? data;

  StudentAllowedFolderResponseModel({this.status, this.message, this.data});

  StudentAllowedFolderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FolderData>[];
      json['data'].forEach((v) {
        data!.add(new FolderData.fromJson(v));
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

class FolderData {
  String? folderId;
  String? folderName;
  String? folderDescription;
  String? folderThumbnailUrl;
  int? dateCreated;
  int? dateModified;
  Null? allowedStudents;
  List<Videos>? videos;
  bool? enabled;

  FolderData(
      {this.folderId,
        this.folderName,
        this.folderDescription,
        this.folderThumbnailUrl,
        this.dateCreated,
        this.dateModified,
        this.allowedStudents,
        this.videos,
        this.enabled});

  FolderData.fromJson(Map<String, dynamic> json) {
    folderId = json['folderId'];
    folderName = json['folderName'];
    folderDescription = json['folderDescription'];
    folderThumbnailUrl = json['folderThumbnailUrl'];
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
    allowedStudents = json['allowedStudents'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
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
    data['allowedStudents'] = this.allowedStudents;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['enabled'] = this.enabled;
    return data;
  }
}

class Videos {
  String? videoId;
  String? videoName;
  String? videoDescription;
  int? videoDuration;
  String? videoThumbnailUrl;
  int? uploadDate;
  String? folderId;
  String? videoResourceKey;
  String? thumbnailResourceKey;
  bool? free;
  bool? enabled;

  Videos(
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

  Videos.fromJson(Map<String, dynamic> json) {
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
