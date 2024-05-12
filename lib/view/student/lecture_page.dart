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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      width: MediaQuery.of(context).size.width,
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
                            return ExpansionTile(
                            title: Row(
                              children: [
                                Text(folder.folderName!),
                              ],
                            ),
                            // disable expansion tile if user is not in the folder
                            onExpansionChanged: (value) {
                                // close the expansion tile
                                if(!folder.enabled!) {
                                  // setState(() {
                                  //   folders[index].enabled = false;
                                  // });
                                }
                            },
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: folder.videos!.length,
                                itemBuilder: (context, i) {
                                  Videos video = folder.videos![i];
                                  return ListTile(
                                    title: Text(video.videoName!),
                                    onTap: () {
                                      // Navigate to video page
                                    },
                                    //play video button at the end of the list
                                    trailing: IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () {
                                        // Navigate to video page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoPage(
                                              videoId: video.videoId!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              if(folder.videos!.isEmpty)
                                Text('No videos found'),
                            ],
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
