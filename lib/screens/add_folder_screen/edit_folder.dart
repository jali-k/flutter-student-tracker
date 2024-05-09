import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spt/model/all_lecture_video_response_model.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../../model/all_folder_response_model.dart';
import '../../model/model.dart';
import '../../popups/confirmation_popup.dart';
import '../../popups/loading_popup.dart';
import '../../popups/progress_popup.dart';
import '../../services/lecture_folder_service.dart';
import '../res/app_colors.dart';
import 'add_video.dart';


class EditFolder extends StatefulWidget {
  final bool isUpdate;
  final FolderInfo? folderDetails;
  final void Function() callBack;
  final List<String> folderNames;
  const EditFolder(
      {super.key,
        required this.isUpdate,
        required this.folderDetails,
        required this.callBack,
        required this.folderNames});

  @override
  State<EditFolder> createState() => _EditFolderState();
}

class _EditFolderState extends State<EditFolder> {
  final double _fieldBorderRadius = 30;
  final double _fieldBorderLineWidth = 1.5;
  final double _fieldFontSizeValue = 12;
  final formKey = GlobalKey<FormState>();
  final folderNameController = TextEditingController();
  final emailListController = TextEditingController();
  Video? videoDetail;
  bool isVideo = false;
  List<LectureVideoInfo> videoList = [];
  bool isLoading = false;
  List<LectureVideoInfo> data = [];
  List<String> emailList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      assignTheData();
      fetchVideo();
      // fetch();
    }
  }

  void assignTheData() {
    setState(() {
      folderNameController.text = widget.folderDetails!.folderName!;
      // emailListController.text = widget.folderDetails!.allowedStudents..join('\n');
    });
  }

  fetchVideo() async{
    data.clear();
    videoList.clear();
    setState(() {
      isLoading = true;
    });
    AllLectureVideoResponseModel? allLectureVideoResponseModel = await LectureFolderService.getAllLectureVideo(context, widget.folderDetails!.folderId!);
    if(allLectureVideoResponseModel == null){
      return;
    }
    List<LectureVideoInfo> lectureVideoInfo = allLectureVideoResponseModel.data!;
    setState(() {
      data.addAll(lectureVideoInfo);
      videoList.addAll(lectureVideoInfo);
      isLoading = false;
      emailList = widget.folderDetails!.allowedStudents!.map((e) => e.user!.username!).toList();
    });
  }

  // Future<void> fetch() async {
  //   data.clear();
  //   videoList.clear();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('folders')
  //       .doc(widget.folderDetails!.docId)
  //       .collection('videoDetails')
  //       .orderBy('videoUploadedDate', descending: false)
  //       .get();
  //   setState(() {
  //     data.addAll(querySnapshot.docs);
  //     for (var video in data) {
  //       videoList.add(
  //         VideoDetail(
  //             docId: widget.folderDetails!.docId,
  //             videoId: video['videoId'],
  //             videoPath: video['videoPath'],
  //             videoDocId: video.id),
  //       );
  //     }
  //     isLoading = false;
  //   });
  // }

  Future<void> addData() async {
    try {
      final emailList = emailListController.text.split('\n');
      String videoId = const Uuid().v1();

      await FirebaseFirestore.instance.collection('folders').add({
        'folderName': folderNameController.text,
        'emailList': emailList,
        'videoUploadedDate': DateTime.now()
      }).then((folderDoc) {
        ProgressPopup(context, videoDetail!.videoFile, videoDetail!.thumbnail,
            videoId, folderDoc.id)
            .show();
        // Add video details to videoDetails subcollection
        FirebaseFirestore.instance
            .collection('folders')
            .doc(folderDoc.id)
            .collection('videoDetails')
            .add({
          'videoId': videoId,
          'docId': folderDoc.id,
          'title': videoDetail!.title,
          'description': videoDetail!.description,
          'lessons': videoDetail!.lesson,
          'date': videoDetail!.date,
          'videoUploadedDate': DateTime.now(),
          'videoPath': videoDetail!.videoFileName,
        });
      });

      setState(() {
        folderNameController.clear();
        emailListController.clear();
        isVideo = false;
      });

      widget.callBack();

      // ignore: use_build_context_synchronously
    } catch (error) {
      // ignore: avoid_print
      print("Failed to add user: $error");
    }
  }

  // Future<void> updateData() async {
  //   try {
  //     final emailList = emailListController.text.split('\n');
  //     String videoId = const Uuid().v1();
  //     ProgressPopup(context, videoDetail!.videoFile, videoDetail!.thumbnail,
  //         videoId, widget.folderDetails!.docId)
  //         .show();
  //     await FirebaseFirestore.instance
  //         .collection('folders')
  //         .doc(widget.folderDetails!.docId) // Reference to the collection
  //         .set({
  //       'folderName': folderNameController.text,
  //       'emailList': emailList,
  //       'videoUploadedDate': widget.folderDetails!.uploadedDate
  //     });
  //     await FirebaseFirestore.instance
  //         .collection('folders')
  //         .doc(widget.folderDetails!.docId)
  //         .collection('videoDetails')
  //         .add({
  //       'videoId': videoId,
  //       'docId': widget.folderDetails!.docId,
  //       'title': videoDetail!.title,
  //       'description': videoDetail!.description,
  //       'lessons': videoDetail!.lesson,
  //       'date': videoDetail!.date,
  //       'videoUploadedDate': DateTime.now(),
  //       'videoPath': videoDetail!.videoFileName,
  //     });
  //
  //     setState(() {
  //       folderNameController.clear();
  //       emailListController.clear();
  //       isVideo = false;
  //     });
  //     widget.callBack();
  //
  //     // ignore: use_build_context_synchronously
  //   } catch (error) {
  //     // ignore: avoid_print
  //     print("Failed to add user: $error");
  //   }
  // }

  Future<void> deleteVideoFile(
      {required String videoDocId,
        required String docId,
        required String videoId}) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage
          .ref()
          .child('videos')
          .child('$videoId.mp4');
      Reference thumbnailRef = storage
          .ref()
          .child('thumbnail')
          .child('$videoId.jpg');
      await storageRef.delete();
      await thumbnailRef.delete();
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(docId)
          .collection('videoDetails')
          .doc(videoDocId)
          .delete();
      loading.dismiss();
      // ignore: use_build_context_synchronously
      Globals.showSnackBar(
          context: context, message: 'Deleted successfully', isSuccess: true);
      print('Video file deleted successfully');
    } catch (e) {
      print('Error deleting video file: $e');
    }
  }

  // Future<void> deleteFolder() async {
  //   try {
  //     final loading = LoadingPopup(context);
  //     loading.show();
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     if(videoList.isNotEmpty){
  //       for (var element in videoList) {
  //         Reference storageRef = storage
  //             .ref()
  //             .child('videos')
  //             .child('${element.videoId}.mp4');
  //         Reference thumbnailRef = storage
  //             .ref()
  //             .child('thumbnail')
  //             .child('${element.videoId}.jpg');
  //         await storageRef.delete();
  //         await thumbnailRef.delete();
  //         await FirebaseFirestore.instance
  //             .collection('folders')
  //             .doc(element.docId)
  //             .collection('videoDetails')
  //             .doc(element.videoDocId)
  //             .delete();
  //               }
  //     }
  //
  //     await FirebaseFirestore.instance
  //         .collection('folders')
  //         .doc(widget.folderDetails!.docId)
  //         .delete();
  //
  //     loading.dismiss();
  //     widget.callBack();
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pop();
  //     // ignore: use_build_context_synchronously
  //     Globals.showSnackBar(
  //         context: context, message: 'Deleted successfully', isSuccess: true);
  //     print('Folder deleted successfully');
  //   } catch (e) {
  //     print('Error deleting video file: $e');
  //     // ignore: use_build_context_synchronously
  //     Globals.showSnackBar(
  //         context: context, message: e.toString(), isSuccess: false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.black,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    final enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.black,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    final valueStyle = TextStyle(
      color: AppColors.black,
      fontSize: _fieldFontSizeValue,
    );

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.red,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );

    const errorStyle = TextStyle(
      color: AppColors.red,
    );

    const cursorColor = AppColors.black;
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: AppColors.backGround,
        title: const Text('Add a new folder'),
        centerTitle: true,
        actions: [
          Visibility(
            visible: widget.isUpdate,
            child: IconButton(
                onPressed: () {
                  ConfirmationPopup(context).show(
                      message: 'Are you sure you want to delete the folder?',
                      callbackOnYesPressed: () {
                        // deleteFolder();
                      });
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.red,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(30),
                const Text(
                  'Folder name',
                  style: TextStyle(color: AppColors.black),
                ),
                const Gap(10),
                TextFormField(
                  style: valueStyle,
                  controller: folderNameController,
                  cursorColor: cursorColor,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5
                    ),
                    fillColor: AppColors.ligthWhite,
                    labelText: 'Enter folder name',
                    labelStyle: const TextStyle(fontSize: 10),
                    focusedBorder: focusedBorder,
                    enabledBorder: enabledBorder,
                    border: focusedBorder,
                    errorBorder: errorBorder,
                    errorStyle: errorStyle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the folder name';
                    }
                    if (!widget.isUpdate) {
                      if (widget.folderNames.contains(value.toLowerCase())) {
                        return 'Folder name is already exists';
                      }
                    }

                    return null;
                  },
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () {
                    if (!isVideo) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddVideo(
                            callBackVideo: (Video video) {
                              setState(() {
                                videoDetail = video;
                                isVideo = videoDetail!.isVideo;
                              });
                            },
                            isUpdate: widget.isUpdate,
                          )));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.ligthWhite,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.black, width: 1.5)),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'Upload videos',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ),
                        Center(
                            child: isVideo
                                ? const Icon(
                              Icons.done_all_sharp,
                              size: 40,
                              color: AppColors.green,
                            )
                                : const Icon(
                              Icons.cloud_upload,
                              size: 40,
                              color: AppColors.blue,
                            )),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: videoList.isNotEmpty,
                    child: isLoading
                        ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                        ))
                        : SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: videoList.length,
                          itemBuilder: (context, index) {
                            LectureVideoInfo video = videoList[index];
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: AppColors.backGround,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.black,
                                      width: 1.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  leading: Image.network(
                                    video.videoThumbnailUrl!,
                                  ),
                                  dense: true,
                                  trailing: IconButton(
                                      onPressed: () {
                                        ConfirmationPopup(context).show(
                                            message:
                                            'Are you sure you want to delete the file?',
                                            callbackOnYesPressed: () {
                                              try{
                                                // deleteVideoFile(
                                                //     videoDocId:
                                                //     video.videoDocId,
                                                //     docId: video.docId,
                                                //     videoId: video.videoId);
                                                // setState(() {
                                                //   videoList.removeAt(index);
                                                // });
                                              }catch(e){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Error Occured!"),
                                                      backgroundColor: AppColors.red,
                                                    ));
                                              }
                                            });


                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  title: Text(
                                    video.videoName!,
                                    style: const TextStyle(
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
                const Gap(20),
                Row(
                  children: [
                    const Text(
                      'Email list',
                      style: TextStyle(color: AppColors.black),
                    ),
                    const Gap(10),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Add email'),
                                    content: TextFormField(
                                      controller: emailListController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter email'),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              emailList.add(emailListController.text);
                                              emailListController.clear();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text('Add')),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text('Cancel'))
                                    ],
                                  );
                                });
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.black,
                        ))
                    ,
                  ],
                ),
                const Gap(10),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: emailList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: AppColors.backGround,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.black, width: 1.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(5),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      emailList.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              title: Text(
                                emailList[index],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      }),
                  ),
                const Gap(10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(29)),
                    child: TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!formKey.currentState!.validate()) return;
                        if (videoDetail == null) {
                          Globals.showSnackBar(
                              context: context,
                              message: 'Please upload the file',
                              isSuccess: false);
                          return;
                        }

                        if (widget.isUpdate) {
                          // updateData();
                        } else {
                          addData();
                        }
                      },
                      child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: AppColors.ligthWhite,
                            ),
                          )),
                    ),
                  ),
                ),
                const Gap(20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
