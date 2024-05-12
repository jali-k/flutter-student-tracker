import 'dart:io';




class UploadResource{


  File videoFile;
  File videoThumbnailFile;
  String videoTitle;
  String videoDescription;
  double videoDuraton;

  UploadResource(
      this.videoFile,
      this.videoThumbnailFile,
      this.videoTitle,
      this.videoDescription,
      this.videoDuraton,
      );
}