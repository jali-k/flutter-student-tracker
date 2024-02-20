import 'dart:async';

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

  late VideoPlayerController _controller;
  late String _videoId;
  bool _loading = true;
  final StreamController<int> _streamController = StreamController<int>();
  final StreamController<int> _progressController = StreamController<int>();

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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Column(
            children: [
              //show progress bar
              StreamBuilder(
                stream: Stream.periodic(const Duration(milliseconds: 100)),
                builder: (context, snapshot) {
                  return LinearProgressIndicator(
                    value: _controller.value.position.inSeconds/_controller.value.duration.inSeconds,
                  );
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  //Media controls such as play, pause, seek bar
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: StreamBuilder<Object>(
                          stream: _streamController.stream,
                          initialData: 0,
                          builder: (context, snapshot) {
                            return Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow);
                          }
                        ),
                        onPressed: () {
                          _streamController.add(1);
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.replay_10),
                        onPressed: () {
                          setState(() {
                            _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds - 10));
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.forward_10),
                        onPressed: () {
                          setState(() {
                            _controller.seekTo(Duration(seconds: _controller.value.position.inSeconds + 10));
                          });
                        },
                      ),
                    ],
                  ),
                  //show duration of the video
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(milliseconds: 100)),
                    builder: (context, snapshot) {
                      return Text('${_controller.value.position.inMinutes}:${_controller.value.position.inSeconds.remainder(60)}/${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds.remainder(60)}');
                    }
                  ),
                  //Full screen button
                  IconButton(
                    icon: Icon(Icons.fullscreen),
                    onPressed: () {
                      }
                  ),

                ],
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
          setState(() {
            _loading = false;
          });
        });
    });
  }
}

