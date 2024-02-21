import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:spt/services/lecture_service.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoId;
  const VideoPage({super.key, required this.videoId});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  // late VideoPlayerController _controller;
  late CustomVideoPlayerController _customController;
  late VideoPlayerController _controller;
  late String _videoId;
  bool _loading = true;
  final StreamController<int> _streamController = StreamController<int>();
  final StreamController<int> _progressController = StreamController<int>();
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoId = widget.videoId;
    //check whether _videoId ends with .mp4 or not
    if(!_videoId.endsWith('.mp4')){
      _videoId = '$_videoId.mp4';
    }

    getVideoFromFirebaseStorage();


  }

  @override
  Widget build(BuildContext context) {
    return  _loading ?
      Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ) :
      Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            width: MediaQuery.of(context).size.width,
            child: _controller.value.isInitialized
                ? CustomVideoPlayer(
                  customVideoPlayerController: _customController,
                )
                : Container(),
          ),
        ),
    );
  }

  void getVideoFromFirebaseStorage() {
    LectureService.getVideoUrl(_videoId).then((value) {
      print(value);
      setState(() {
        _videoId = value;
      });
      // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      Uri uri = Uri.parse(value);
      _controller = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          setState(() {
            _loading = false;
          });
        });
      _customController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _controller,
        customVideoPlayerSettings: _customVideoPlayerSettings,
      );
    });
  }
}

