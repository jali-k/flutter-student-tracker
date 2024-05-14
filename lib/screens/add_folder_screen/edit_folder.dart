import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spt/model/lecture_video_upload_response_model.dart';
import 'package:spt/services/admin_service.dart';
import 'package:spt/services/lecture_folder_service.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../../model/all_folder_response_model.dart';
import '../../model/all_lecture_video_response_model.dart';
import '../../model/all_student_response_model.dart';
import '../../model/folder_create_response_model.dart';
import '../../model/model.dart';
import '../../model/upload_resource.dart';
import '../../popups/confirmation_popup.dart';
import '../../popups/loading_popup.dart';
import '../../popups/progress_popup.dart';
import '../../util/toast_util.dart';
import '../res/app_colors.dart';
import 'add_video.dart';

class EditFolder extends StatefulWidget {
  final FolderInfo folderInfo;
  EditFolder({super.key, required this.folderInfo});

  @override
  State<EditFolder> createState() => _AddFolderState();
}

class _AddFolderState extends State<EditFolder> {
  final formKey = GlobalKey<FormState>();
  bool isUploading = false;
  bool isLoading = true;

  //Folder Name, Folder Description, Folder Video, Allow Type (either all or specific), if specific then email list
  Video? videoDetail;
  List<LectureVideoInfo> videoList = [];
  List<String> emailList = [];
  List<String> allEmailList = [];
  List<UploadResource> uploadLectureVideos = [
    UploadResource(
      File(''),
      File(''),
      '',
      '',
      0.0,
    )
  ];
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _folderDescriptionController =
  TextEditingController();
  final TextEditingController _folderVideoController = TextEditingController();
  final TextEditingController _emailListController = TextEditingController();
  String _allowType = 'Specific';
  List<LectureVideoInfo> prevVideoDetail = [];
  @override
  void initState() {
    super.initState();
    fetchEmail();
    setData();
  }

  setData() async{
    AllLectureVideoResponseModel? data = await LectureFolderService.getAllLectureVideo(context, widget.folderInfo.folderId!);
    List<LectureVideoInfo> videoDetail = data!.data!;
    setState(() {
      emailList = widget.folderInfo.allowedStudents !=null ? widget.folderInfo.allowedStudents!.map((e) => e.user!.username!).toList() : [];
      videoList.addAll(videoDetail);
      prevVideoDetail.addAll(videoDetail);
      uploadLectureVideos.addAll(videoDetail.map((e) => UploadResource(
        File(''),
        File(e.videoThumbnailUrl!),
        e.videoName!,
        e.videoDescription!,
        e.videoDuration!,
      )).toList());
      _folderNameController.text = widget.folderInfo.folderName!;
      _folderDescriptionController.text = widget.folderInfo.folderDescription!;
      isLoading = false;
    });
  }

  fetchEmail() async {
    AllStudentResponseModel? allStudentResponseModel =
    await AdminService.getAllStudent();
    List<StudentInfo> studentInfo = allStudentResponseModel!.data!;
    setState(() {
      allEmailList.addAll(studentInfo.map((e) => e.user!.username!).toList());
    });
  }



  //_videoTitleController, _videoDescriptionController, _videoDurationController
  final TextEditingController _videoTitleController = TextEditingController();
  final TextEditingController _videoDescriptionController =
  TextEditingController();
  final TextEditingController _videoDurationController =
  TextEditingController();
  final StreamController<double> uploadProgressController =
  StreamController<double>.broadcast();

  //add Video popup to enter Video Name Description
  addVideo(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final StreamController<File> pickedVideoThumbnailFileController =
          StreamController<File>();
          final StreamController<File> pickedVideoFileController =
          StreamController<File>();
          String? pickedVideoFile = null;
          String? pickedVideoThumbnailFile = null;
          double? pickedVideoDuration = null;
          String? pickedVideoTitle = null;
          String? pickedVideoDescription = null;

          return AlertDialog(
            title: Text('Add Video'),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _videoTitleController,
                      decoration: InputDecoration(
                        labelText: 'Video Title',
                        labelStyle: TextStyle(color: AppColors.black),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _videoDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Video Description',
                        labelStyle: TextStyle(color: AppColors.black),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // TextField(
                    //   controller: _videoDurationController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     labelText: 'Video Duration',
                    //     labelStyle: TextStyle(color: AppColors.black),
                    //     contentPadding:
                    //     EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: AppColors.primary),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: StreamBuilder<File>(
                          stream: pickedVideoThumbnailFileController.stream,
                          builder: (context, snapshot) {
                            return pickedVideoThumbnailFile == null
                                ? Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  //upload video
                                  final picker = ImagePicker();
                                  XFile? pickedFile =
                                  await picker.pickImage(
                                      source: ImageSource.gallery,
                                      maxHeight: 300,
                                      maxWidth: 300);
                                  if (pickedFile != null) {
                                    pickedVideoThumbnailFile =
                                        pickedFile.path;
                                    pickedVideoThumbnailFileController
                                        .add(File(pickedFile.path));
                                  }
                                },
                                child: Text('Upload Video Thumbnail'),
                              ),
                            )
                                : Stack(
                              children: [
                                Image.file(
                                  snapshot.data!,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: IconButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Colors.white),
                                    ),
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      XFile? pickedFile =
                                      await picker.pickImage(
                                          source: ImageSource.gallery,
                                          maxHeight: 300,
                                          maxWidth: 300);
                                      if (pickedFile != null) {
                                        pickedVideoFile = pickedFile.path;
                                        pickedVideoThumbnailFileController
                                            .add(File(pickedFile.path));
                                      }
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: StreamBuilder<File>(
                          stream: pickedVideoFileController.stream,
                          builder: (context, snapshot) {
                            return pickedVideoFile == null
                                ? Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                      AppColors.primary),
                                ),
                                onPressed: () async {
                                  //upload video
                                  final picker = ImagePicker();
                                  XFile? pickedFile =
                                  await picker.pickVideo(
                                      source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    pickedVideoFile = pickedFile.path;
                                    pickedVideoFileController
                                        .add(File(pickedFile.path));
                                  }
                                },
                                child: Text(
                                  'Upload Video',
                                  style: TextStyle(
                                      color: AppColors.onPrimary),
                                ),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff55a576),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  //Badge with Video Uploaded
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        Gap(5),
                                        Text(
                                          'Video Ready To Upload',
                                          style: TextStyle(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: IconButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Colors.white),
                                      ),
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        XFile? pickedFile =
                                        await picker.pickVideo(
                                            source:
                                            ImageSource.gallery);
                                        if (pickedFile != null) {
                                          pickedVideoFile =
                                              pickedFile.path;
                                          pickedVideoFileController
                                              .add(File(pickedFile.path));
                                        }
                                      },
                                      iconSize: 14,
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  //Add Video to List
                  UploadResource uploadResource = UploadResource(
                    File(pickedVideoFile!),
                    File(pickedVideoThumbnailFile!),
                    _videoTitleController.text,
                    _videoDescriptionController.text,
                    null
                  );
                  setState(() {
                    uploadLectureVideos.add(uploadResource);
                    _videoTitleController.clear();
                    _videoDescriptionController.clear();
                    _videoDurationController.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Add Video'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   isUploading = false;
    // });
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Folder'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: isUploading || isLoading
              ? Container(
            color: Colors.black.withOpacity(0.5),
            child: isUploading ?
                  Center(
              child: StreamBuilder<double>(
                  stream: uploadProgressController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data == 100.0){
                        ToastUtil.showSuccessToast(context,'Success', 'Folder Updated Successfully');
                        Timer(Duration(seconds: 2), (){
                          Navigator.of(context).pop();
                        });
                        return Center(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: AppColors.green, size: 50,),
                                Gap(10),
                                Text('Uploading Completed', style: TextStyle(color: Colors.white,fontSize: 18),),
                              ],
                            )

                        );
                      }
                      return Center(
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Gap(10),
                              Text('Uploading ${snapshot.data} %', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                            ],
                          )

                      );
                    }
                    return Center(child: CircularProgressIndicator(color: AppColors.primary,));
                  }
              ),
            ) :isLoading ? Center(child: Column(
              children: [
                CircularProgressIndicator(color: AppColors.primary,),
                Gap(10),
                Text('Loading...', style: TextStyle(color: Colors.white),),
              ],
            ),) : Container(),
          )
              : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _folderNameController,
                    decoration: InputDecoration(
                      labelText: 'Folder Name',
                      labelStyle: TextStyle(color: AppColors.black),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Gap(20),
                  TextField(
                    controller: _folderDescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Folder Description',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //Uploaded Video List
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 220,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: uploadLectureVideos.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return DottedBorder(
                            strokeWidth: 1,
                            dashPattern: [5, 5],
                            child: GestureDetector(
                              onTap: () {
                                addVideo(context);
                              },
                              child: Container(
                                  width: 150,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    // Upload Video Card Button
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.ondemand_video_sharp,
                                            size: 50,
                                            color: AppColors.primary),
                                        Gap(10),
                                        Text('Add Video'),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        }
                        return Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  uploadLectureVideos[index]
                                      .videoThumbnailFile.path!.startsWith('http') ?
                                  Image.network(
                                    uploadLectureVideos[index]
                                        .videoThumbnailFile.path!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ):
                                      Image.file(
                                        uploadLectureVideos[index]
                                            .videoThumbnailFile,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                  Gap(5),
                                  Text(
                                    uploadLectureVideos[index].videoTitle,
                                    style:
                                    TextStyle(color: AppColors.black),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        uploadLectureVideos
                                            .removeAt(index);
                                      });
                                    },
                                    style: ButtonStyle(
                                      visualDensity:
                                      VisualDensity.compact,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(2)),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Colors.white),
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                    ),
                                    iconSize: 16,
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // DropdownButtonFormField<String>(
                  //   value: _allowType,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       _allowType = newValue!;
                  //     });
                  //   },
                  //   items: <String>['All', 'Specific']
                  //       .map<DropdownMenuItem<String>>(
                  //         (String value) => DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     ),
                  //   )
                  //       .toList(),
                  //   decoration: InputDecoration(
                  //       labelText: 'Allow Type',
                  //       contentPadding: EdgeInsets.symmetric(
                  //           vertical: 2, horizontal: 5),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide:
                  //         BorderSide(color: AppColors.primary),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       labelStyle: TextStyle(color: AppColors.black),
                  //       hintStyle: TextStyle(color: AppColors.grey)),
                  // ),
                  if (_allowType == 'Specific') ...[
                    SizedBox(height: 5),
                    // email list and add new email button
                    Text('Email List - ${emailList.length}'),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: emailList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(emailList[index]),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  emailList.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailListController,
                            maxLines: 3,
                            decoration:
                            InputDecoration(labelText: 'Email List'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_emailListController.text.isNotEmpty) {
                              try {
                                String text = _emailListController.text;
                                //split by '\n'
                                List<String> emails = text.split('\n');
                                setState(() {
                                  emailList.addAll(emails);
                                });
                                _emailListController.clear();
                              } catch (e) {
                                ToastUtil.showErrorToast(
                                    context,
                                    "Parsing Error",
                                    "Enter Email List in New Line");
                              }
                            }
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Send your request here
                      // Create Folder
                      try {
                        setState(() {
                          isUploading = true;
                        });
                        uploadProgressController.add(0.0);
                        FolderCreateResponseModel?
                        folderCreateResponseModel =
                        await LectureFolderService.editFolder(
                            context,
                            widget.folderInfo.folderId!,
                            _folderNameController.text,
                            _folderDescriptionController.text,
                            _allowType,
                            emailList);
                        if(folderCreateResponseModel == null){
                          setState(() {
                            isUploading = false;
                          });
                          return;
                        }
                        String folderId =
                        folderCreateResponseModel.data!.folderId!;
                        int count =0;
                        uploadProgressController.add(0.0);
                        // Upload Videos compare with prevVideoDetail and upload only new videos
                        uploadLectureVideos.sublist(1).removeWhere((element) => element.videoFile.path == '');

                        uploadLectureVideos
                            .sublist(1)
                            .forEach((element) async {
                          LectureVideoUploadResponseModel?
                          lectureVideoUploadResponseModel =
                          await LectureFolderService.uploadLectureVideo(
                              context, folderId, element);
                          if(lectureVideoUploadResponseModel != null){
                            count++;
                          }
                          if(count == uploadLectureVideos.sublist(1).length - 1){
                            uploadProgressController.add(100.0);
                            Future.delayed(Duration(seconds: 5), (){
                              setState(() {
                                isUploading = false;
                              });
                              // Navigator.of(context).pop();
                            });
                          }
                          double value = (count)/uploadLectureVideos.sublist(1).length*100;
                          uploadProgressController.add(value);
                        });

                      } on Exception catch (e) {
                        print('Error: $e');
                        setState(() {
                          isUploading = false;
                        });
                      }
                    },
                    child: Text('Edit Folder'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    _folderDescriptionController.dispose();
    _folderVideoController.dispose();
    _emailListController.dispose();
    super.dispose();
  }
}
