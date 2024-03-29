import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  int bottom = 400;
  late String _userEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoId = widget.videoId;
    //check whether _videoId ends with .mp4 or not
    if(!_videoId.endsWith('.mp4')){
      _videoId = '$_videoId.mp4';
    }
    _userEmail = FirebaseAuth.instance.currentUser!.email!;

    getVideoFromFirebaseStorage();


  }

  //dispose the stream controllers and stop the video player
  @override
  void dispose() {
    _streamController.close();
    _progressController.close();
    _controller.dispose();

    super.dispose();
  }

  animateWatermark() {
    int height = MediaQuery.of(context).size.height.toInt();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (bottom > 100+height * 0.5) {
          bottom = 0;
        }
        bottom += 10;
      });
    });
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
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ) :
      Scaffold(
        body: SafeArea(
          child: Stack(

            children: [
              Container(
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
              // add watermark to the video
              if(kIsWeb)
                Positioned(
                bottom: bottom.toDouble(),
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _userEmail,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
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
          animateWatermark();
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

