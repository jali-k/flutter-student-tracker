import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spt/model/add_paper_response_model.dart';
import 'package:spt/model/response_model.dart';
import 'package:spt/services/paper_mark_service.dart';
import 'package:spt/util/toast_util.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../../model/all_papers_data_model.dart';
import '../../model/model.dart';
import '../../popups/confirmation_popup.dart';
import '../../popups/loading_popup.dart';
import '../../services/auth_services.dart';
import '../../services/paper_service.dart';
import '../../view/student/login_page.dart';
import '../res/app_colors.dart';


class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final double _fieldBorderRadius = 5;
  final double _fieldBorderLineWidth = 1.5;
  final double _fieldFontSizeValue = 12;
  final formKey = GlobalKey<FormState>();
  final entryController = TextEditingController();
  bool isMCQ = false;
  bool isStructured = false;
  bool isEssay = false;
  List<PaperInfo> papers = [];
  List<PaperInfo> paperList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPapers();
  }

  Future<void> addData(
      {required String paperName,
        required bool isMcqSelected,
        required bool isStructuredSelected,
        required bool isEssaySelected}) async {
    try {
      if (!isMcqSelected && !isStructuredSelected && !isEssaySelected) {
        Globals.showSnackBar(
            context: context,
            message: 'Please select the paper category',
            isSuccess: false);
        return;
      }
      final loading = LoadingPopup(context);
      loading.show();
      String paperId = const Uuid().v1();
      AddPaperResponseModel? addPaperResponseModel = await PaperMarkService.addPaper(
          paperName: paperName,
          isMcq: isMcqSelected,
          isStructured: isStructuredSelected,
          isEssay: isEssaySelected);

      if(addPaperResponseModel == null) {
        loading.dismiss();
        Globals.showSnackBar(
            context: context,
            message: 'Failed to add paper',
            isSuccess: false);
        return;
      }
      PaperInfo paperInfo = PaperInfo(
          paperId: paperId,
          paperName: paperName,
          mcq: isMcqSelected,
          structured: isStructuredSelected,
          essay: isEssaySelected);
      setState(() {
        paperList.add(paperInfo);
      });
      loading.dismiss();
      //clear the text field
      entryController.clear();


      // ignore: use_build_context_synchronously
      ToastUtil.showSuccessToast(context, "Success", "Paper Added Successfully");
    } catch (error) {
      // ignore: avoid_print
      print("Failed to add user: $error");
    }
  }


  Future<void> fetchPapers() async {
    setState(() {
      isLoading = true;
    });
    AllPapersDataModel allPapersDataModel = await PaperService.getAllPaperList(context);
    List<PaperInfo>? p = allPapersDataModel.data;
    setState(() {
      paperList.addAll(p!);
      isLoading = false;
    });
  }



  void deletePaper(String paperID, int index) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      ResponseModel? deletePaperResponseModel = await PaperMarkService.deletePaper(paperID: paperID);
      if(deletePaperResponseModel == null) {
        loading.dismiss();
        ToastUtil.showSuccessToast(context, "Error", "Paper Deletion Unsuccessful");
        return;
      }
      loading.dismiss();
      setState(() {
        paperList.removeAt(index);
      });

      // ignore: use_build_context_synchronously
      ToastUtil.showSuccessToast(context, "Success", "Paper Deleted Successfully");
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting instructor: $e');
    }
  }
  void generateLeaderBoard(String paperID, int index) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      ResponseModel? deletePaperResponseModel = await PaperMarkService.generateLeaderBoard(paperID: paperID);
      if(deletePaperResponseModel == null) {
        loading.dismiss();
        ToastUtil.showErrorToast(context, "Error", "Leader Board Generation Unsuccessful");
        return;
      }
      loading.dismiss();

      // ignore: use_build_context_synchronously
      ToastUtil.showSuccessToast(context, "Success", "Leader Board Generated Successfully");
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting instructor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.black,
        width: _fieldBorderLineWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(_fieldBorderRadius)),
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(80),
            const Center(
              child: Text(
                "Manage Papers",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColors.black),
              ),
            ),
            const Gap(50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Add a ',
                      style: TextStyle(color: AppColors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'new',
                      style: TextStyle(color: AppColors.green, fontSize: 20),
                    ),
                    TextSpan(
                      text: ' Entry',
                      style: TextStyle(color: AppColors.black, fontSize: 20),
                    ),
                  ])),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formKey,
                child: SizedBox(
                  width: width / 2,
                  height: 30,
                  child: TextFormField(
                    style: valueStyle,
                    controller: entryController,
                    cursorColor: cursorColor,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      filled: true,
                      fillColor: AppColors.ligthWhite,
                      labelText: 'Enter paper name',
                      labelStyle: const TextStyle(fontSize: 10),
                      focusedBorder: focusedBorder,
                      enabledBorder: enabledBorder,
                      border: focusedBorder,
                      errorBorder: errorBorder,
                      errorStyle: errorStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the paper name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 2,
                  shadowColor: AppColors.purple,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: isMCQ ? AppColors.purple : AppColors.ligthWhite,
                        border: Border.all(
                          color: AppColors.purple, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isMCQ = !isMCQ;
                        });
                      },
                      child: Row(
                        children: [
                          Visibility(
                            visible: isMCQ,
                            child: const Icon(
                              Icons.check,
                              color: AppColors.ligthWhite,
                            ),
                          ),
                          const Gap(5),
                          Center(
                              child: Text(
                                'MCQ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isMCQ
                                      ? AppColors.ligthWhite
                                      : AppColors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  shadowColor: AppColors.green,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: isStructured
                            ? AppColors.green
                            : AppColors.ligthWhite,
                        border: Border.all(
                          color: AppColors.green,
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isStructured = !isStructured;
                        });
                      },
                      child: Row(
                        children: [
                          Visibility(
                            visible: isStructured,
                            child: const Icon(
                              Icons.check,
                              color: AppColors.ligthWhite,
                            ),
                          ),
                          const Gap(5),
                          Center(
                              child: Text(
                                'STRUCTURED',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isStructured
                                      ? AppColors.ligthWhite
                                      : AppColors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  shadowColor: AppColors.red,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: isEssay ? AppColors.red : AppColors.ligthWhite,
                        border: Border.all(
                          color: AppColors.red,
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isEssay = !isEssay;
                        });
                      },
                      child: Row(
                        children: [
                          Visibility(
                            visible: isEssay,
                            child: const Icon(
                              Icons.check,
                              color: AppColors.ligthWhite,
                            ),
                          ),
                          const Gap(5),
                          Center(
                              child: Text(
                                'ESSAY',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isEssay
                                      ? AppColors.ligthWhite
                                      : AppColors.black,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(29)),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!formKey.currentState!.validate()) return;
                      addData(
                          paperName: entryController.text.trim(),
                          isMcqSelected: isMCQ,
                          isStructuredSelected: isStructured,
                          isEssaySelected: isEssay);
                    },
                    child: const Center(
                        child: Text(
                          'Add Paper',
                          style: TextStyle(
                            color: AppColors.ligthWhite,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Divider(
              color: AppColors.black,
              thickness: 1,
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Papers ',
                      style: TextStyle(color: AppColors.green),
                    ),
                    TextSpan(
                      text: ' Available',
                      style: TextStyle(color: AppColors.black),
                    ),
                  ])),
            ),
            const Gap(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : paperList.isEmpty
                    ? const Center(
                  child: Text(
                    'No papers',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                  ),
                )
                    : ListView.builder(
                    itemCount: paperList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PaperInfo paper = paperList[index];
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.ligthWhite,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      paper.paperName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black),
                                    ),
                                    const Gap(5),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible:
                                          paper.mcq!,
                                          child: const SizedBox(
                                            height: 10,
                                            width: 20,
                                            child: CircleAvatar(
                                              backgroundColor:
                                              AppColors.purple,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: paper.structured!,
                                          child: const SizedBox(
                                            height: 10,
                                            width: 20,
                                            child: CircleAvatar(
                                              backgroundColor:
                                              AppColors.green,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                          paper.essay!,
                                          child: const SizedBox(
                                            height: 10,
                                            width: 20,
                                            child: CircleAvatar(
                                              backgroundColor:
                                              AppColors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                ConfirmationPopup(context)
                                                    .show(
                                                    message:
                                                    'Are you sure you want to generate Leader Board for this paper?',
                                                    callbackOnYesPressed:
                                                        () {
                                                      generateLeaderBoard(paper.paperId!,
                                                          index);
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.settings,
                                                color: AppColors.blue,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                ConfirmationPopup(context)
                                                    .show(
                                                    message:
                                                    'Are you sure you want to delete the ${paperList[index].paperName} paper?',
                                                    callbackOnYesPressed:
                                                        () {
                                                      deletePaper(paper.paperId!,
                                                          index);
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: AppColors.red,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(10)
                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AuthService.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Icon(Icons.logout),
          backgroundColor: AppColors.green,
        )
    );
  }
}