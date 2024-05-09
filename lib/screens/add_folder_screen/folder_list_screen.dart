import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../model/all_folder_response_model.dart';
import '../../model/model.dart';
import '../../services/lecture_folder_service.dart';
import '../res/app_colors.dart';
import 'add_folder.dart';
import 'edit_folder.dart';


class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  List<FolderInfo> data = [];
  List<FolderInfo> folderList = [];
  List<String> folderName = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    data.clear();
    folderList.clear();
    setState(() {
      isLoading = true;
    });
    AllFolderResponseModel allFolderResponseModel = await LectureFolderService.getAllFolder(context);
    List<FolderInfo> folderInfo = allFolderResponseModel.data!;

    setState(() {
      data.addAll(folderInfo);
      folderList.addAll(folderInfo);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        onPressed: () {
          // Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddFolder(
                isUpdate: false,
                callBack: () {
                  fetch();
                },
                folderDetails: null,
                folderNames: folderName,
              )));
        },
        child: const Icon(
          Icons.add,
          color: AppColors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.backGround,
        title: const Text('Folders'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.blue,
          ))
          : folderList.isEmpty
          ? const Center(
        child: Text(
          'No folders',
          style: TextStyle(color: AppColors.black),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 10.0,
            // mainAxisSpacing: 10.0,
          ),
          itemCount: folderList.length, // Number of items in the grid
          itemBuilder: (BuildContext context, int index) {
            FolderInfo folder = folderList[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    color: Colors.yellow,
                    splashColor: AppColors.grey,
                    focusColor: AppColors.grey,
                    hoverColor: AppColors.grey,
                    iconSize: 120,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditFolder(
                            isUpdate: true,
                            callBack: () {
                              fetch();
                            },
                            folderDetails: folder,
                            folderNames: folderName,
                          )));
                    },
                    icon: const Icon(Icons.folder)),
                // const Gap(8),
                Text(
                  folder.folderName!,
                  style: const TextStyle(color: AppColors.black),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

