import 'package:flutter/material.dart';
import 'package:spt/model/folder.dart';
import 'package:spt/services/lecture_service.dart';
import 'package:spt/view/student/video_page.dart';

class LecturesPage extends StatefulWidget {
  const LecturesPage({super.key});

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {

  List<Folder> folders = [];

  getLectures() async {
    List<Folder> _folders =await LectureService.getLectures();
    setState(() {
      folders = _folders;
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
                      child: ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          // ExpansionTile
                          return ExpansionTile(
                            title: Row(
                              children: [
                                Text(folders[index].folderName),
                                SizedBox(width: 10),
                                if(!folders[index].isUserInFolder())
                                  Icon(Icons.lock, color: Colors.red,),
                              ],
                            ),
                            // disable expansion tile if user is not in the folder
                            onExpansionChanged: (value) {
                              if(!folders[index].isUserInFolder()){
                                // close the expansion tile
                                if(value){
                                  setState(() {
                                    folders[index].isUserInFolder();
                                  });
                                }
                                //remove other snackbar
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                // show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('You are not allowed to access this folder'),
                                  ),
                                );
                              }
                            },
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: folders[index].videoList.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: Text(folders[index].videoList[i].title),
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
                                              videoId: folders[index].videoList[i].videoId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
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
