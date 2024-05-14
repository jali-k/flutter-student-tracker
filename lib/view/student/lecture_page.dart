import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spt/model/folder.dart';
import 'package:spt/services/lecture_folder_service.dart';
import 'package:spt/services/lecture_service.dart';
import 'package:spt/util/toast_util.dart';
import 'package:spt/view/student/video_page.dart';

import '../../model/student_allowed_folder_response_model.dart';

class LecturesPage extends StatefulWidget {
  const LecturesPage({super.key});

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  bool isLoaded = false;
  List<FolderData> folders = [];

  getLectures() async {
    StudentAllowedFolderResponseModel? folderResponseModel =await LectureFolderService.getLectures();
    if(folderResponseModel == null) {
      ToastUtil.showErrorToast(context, "Error", "Failed to get lectures");
      return;
    }
    List<FolderData> _folders = folderResponseModel!.data!;
    setState(() {
      folders = _folders;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLectures();
  }

  showVideoInfoDialog(Videos video)async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(video.videoName!),
          content: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    children: [
                      Image.network("https://dopamine-storage.s3.ap-southeast-1.amazonaws.com/${video.videoThumbnailUrl!}",
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 80,
                        left: (MediaQuery.of(context).size.width/2 - 50),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.play_arrow,color: Colors.white,size: 30,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text("Title : \n${video.videoName}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Description: \n${video.videoDescription}",style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Watch Video'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoPage(videoId: video.videoId!)),
                );
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: 0,
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Title : What’s catching your interest today?
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Lectures',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF00C897),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width - 10,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: !isLoaded
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          :
                      ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          FolderData folder = folders[index];
                          // ExpansionTile
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(folder.folderName!, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 400,
                                    height: 160,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: folder.videos!.isNotEmpty ?
                                    ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: folder.videos!.length,
                                      itemBuilder: (context, i) {
                                        Videos video = folder.videos![i];
                                        return GestureDetector(
                                          onTap: () {
                                            showVideoInfoDialog(video);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            width: 120,
                                            height: 140,
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                      child: Image.network("https://dopamine-storage.s3.ap-southeast-1.amazonaws.com/${video.videoThumbnailUrl!}",
                                                      width: 100,
                                                      height: 100,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Text(video.videoName!, style: TextStyle(fontSize: 12),),
                                                  ],
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      borderRadius: BorderRadius.circular(50),
                                                    ),
                                                    child: Icon(Icons.play_arrow,color: Colors.white,)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ) :
                                    const Center(
                                      child: Text("No videos Uploaded yet!"),
                                    ),
                                  ),
                                ],
                              ),
                            );

                        },
                      ),
                    ),
                  ])),

        ],
      ),
    );
  }
}
