import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';

import '../../globals.dart';
import '../../model/model.dart';
import '../../popups/loading_popup.dart';
import '../res/app_colors.dart';

class AddMarks extends StatefulWidget {
  final Paper paper;

  const AddMarks({super.key, required this.paper});

  @override
  State<AddMarks> createState() => _AddMarksState();
}

class _AddMarksState extends State<AddMarks> {
  final studentIdController = TextEditingController();
  final mcqController = TextEditingController();
  final structureController = TextEditingController();
  final essayController = TextEditingController();
  final totalMarksController = TextEditingController();

  //Edit marks dialog controller
  final editMcqController = TextEditingController();
  final editStructureController = TextEditingController();
  final editEssayController = TextEditingController();
  final editTotalMarksController = TextEditingController();
  List<TableRow> rows = [];
  List<DocumentSnapshot> marks = [];
  int addCount = 0;
  bool isLoading = false;
  int totalValidationMarks = 0;
  List<int> studentIds = [];
  List<int> instructorAssignedStudentIds = [];
  int? selectedStudentId;

  @override
  void initState() {
    super.initState();
    rows.add(
      TableRow(
        children: [
          TableCell(
              child: Container(
                  height: 40,
                  color: AppColors.ligthWhite,
                  child: const Center(
                      child: FittedBox(
                    child: Text(
                      'Student id',
                      style: TextStyle(color: AppColors.black, fontSize: 10),
                    ),
                  )))),
          TableCell(
              child: Container(
                  height: 40,
                  color: widget.paper.isMcq
                      ? AppColors.ligthWhite
                      : AppColors.grey,
                  child: const Center(
                      child: FittedBox(
                    child: Text('Mcq',
                        style: TextStyle(color: AppColors.black, fontSize: 10)),
                  )))),
          TableCell(
              child: Container(
                  height: 40,
                  color: widget.paper.isStructure
                      ? AppColors.ligthWhite
                      : AppColors.grey,
                  child: const Center(
                      child: FittedBox(
                    child: Text('Structured',
                        style: TextStyle(color: AppColors.black, fontSize: 10)),
                  )))),
          TableCell(
              child: Container(
                  height: 40,
                  color: widget.paper.isEssay
                      ? AppColors.ligthWhite
                      : AppColors.grey,
                  child: const Center(
                      child: FittedBox(
                    child: Text('Essay',
                        style: TextStyle(color: AppColors.black, fontSize: 10)),
                  )))),
          TableCell(
              child: Container(
                  height: 40,
                  color: AppColors.ligthWhite,
                  child: const Center(
                      child: FittedBox(
                    child: Text(
                      'Total marks',
                      style: TextStyle(color: AppColors.black, fontSize: 10),
                    ),
                  )))),
        ],
      ),
    );
    fetchPaperMarks();
    getInstructorAssignedStudentIds();
  }

  getInstructorAssignedStudentIds() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Instructors')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    List<QueryDocumentSnapshot> m = querySnapshot.docs;
    //get student ids array
    for (var element in m) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      setState(() {
        instructorAssignedStudentIds = data['students'].cast<int>();
      });
    }
  }

  showMarksEditDialog(
      {required int studentId,
      required int? mcq,
      required int? structure,
      required int? essay,
      required int totalMarks}) {
    print('studentId: $studentId mcq: $mcq structure: $structure essay: $essay totalMarks: $totalMarks');
    editMcqController.text = mcq != null ? mcq.toString() : '';
    editStructureController.text = structure != null ? structure.toString() : '';
    editEssayController.text = essay != null ? essay.toString() : '';
    editTotalMarksController.text = totalMarks.toString();
    showDialog(
      anchorPoint: const Offset(0.0, 0.0),
      useRootNavigator: true,
      context: context,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text('Edit Marks'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        initialValue: studentId.toString(),
                        decoration: const InputDecoration(
                          hintText: 'Student id',
                        ),
                        enabled: false,
                      ),
                      if(widget.paper.isMcq)
                        TextFormField(
                          controller: editMcqController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: TextStyle(
                              color: AppColors.black,
                            ),
                            label: Text(
                              'MCQ Marks',
                              style: TextStyle(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          enabled: widget.paper.isMcq,
                        ),
                      if(widget.paper.isStructure)
                        TextFormField(
                          controller: editStructureController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: TextStyle(
                              color: AppColors.black,
                            ),
                            label: Text(
                              'Structured Marks',
                              style: TextStyle(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          enabled: widget.paper.isStructure,
                        ),
                      if(widget.paper.isEssay)
                        TextFormField(
                          controller: editEssayController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: TextStyle(
                              color: AppColors.black,
                            ),
                            label: Text(
                              'Essay Marks',
                              style: TextStyle(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          enabled: widget.paper.isEssay,
                        ),
                      TextFormField(
                        controller: editTotalMarksController,
                        decoration: const InputDecoration(
                          hintText: 'Total marks',
                          alignLabelWithHint: true,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: TextStyle(
                            color: AppColors.black,
                          ),
                          label: Text(
                            'Total marks',
                            style: TextStyle(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.green,
                ),
                onPressed: () async{
                  if (editMcqController.text.trim().isNotEmpty) {
                    if (int.tryParse(editMcqController.text.trim()) == null) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter valid mcq marks',
                          isSuccess: false);
                      return;
                    }
                    if (0 > int.parse(editMcqController.text.trim()) ||
                        int.parse(editMcqController.text.trim()) > 2000) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'mcq marks'
                              ' should be between 0 and 100',
                          isSuccess: false);
                      return;
                    }
                  }
                  if (editStructureController.text.trim().isNotEmpty) {
                    if (int.tryParse(editStructureController.text.trim()) == null) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter valid structure marks',
                          isSuccess: false);
                      return;
                    }
                    if (0 > int.parse(editStructureController.text.trim()) ||
                        int.parse(editStructureController.text.trim()) > 2000) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'structure marks'
                              ' should be between 0 and 100',
                          isSuccess: false);
                      return;
                    }
                  }
                  if (editEssayController.text.trim().isNotEmpty) {
                    if (int.tryParse(editEssayController.text.trim()) == null) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter valid essay marks',
                          isSuccess: false);
                      return;
                    }
                    if (0 > int.parse(editEssayController.text.trim()) ||
                        int.parse(editEssayController.text.trim()) > 2000) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'essay marks'
                              ' should be between 0 and 100',
                          isSuccess: false);
                      return;
                    }
                  }
                  if (editTotalMarksController.text.trim().isEmpty) {
                    Globals.showSnackBar(
                        context: context,
                        message: 'Please enter the total marks',
                        isSuccess: false);
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('marks')
                      .where('paperId', isEqualTo: widget.paper.paperId)
                      .where('studentId', isEqualTo: studentId)
                      .get()
                      .then((value) {
                    value.docs.forEach((element) {
                      element.reference.update({
                        'mcqMarks': editMcqController.text.trim().isNotEmpty
                            ? int.parse(editMcqController.text.trim())
                            : null,
                        'structuredMarks': editStructureController.text.trim().isNotEmpty
                            ? int.parse(editStructureController.text.trim())
                            : null,
                        'essayMarks': editEssayController.text.trim().isNotEmpty
                            ? int.parse(editEssayController.text.trim())
                            : null,
                        'totalMarks': int.parse(editTotalMarksController.text.trim())
                      });
                    });
                  });

                  //edit row in table
                  int index = studentIds.indexOf(studentId);
                  index = index + 1;
                  setState(() {
                    rows.removeAt(index);
                    rows.insert(
                      index,
                      TableRow(
                        decoration: BoxDecoration(
                          color: AppColors.ligthWhite,
                        ),
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                showMarksEditDialog(
                                    studentId: studentId,
                                    mcq: mcq,
                                    structure: structure,
                                    essay: essay,
                                    totalMarks: totalMarks);
                              });
                            },
                            child: TableCell(
                                child: Container(
                                    height: 40,
                                    color: AppColors.ligthWhite,
                                    child: Center(
                                        child: Text(
                                      studentId.toString(),
                                      style: const TextStyle(color: AppColors.black),
                                    )))),
                          ),
                          TableCell(
                              child: Container(
                                  height: 40,
                                  color: widget.paper.isMcq
                                      ? AppColors.ligthWhite
                                      : AppColors.grey,
                                  child: Center(
                                      child: Text(
                                    editMcqController.text.trim().isNotEmpty
                                        ? editMcqController.text.trim()
                                        : '',
                                    style: const TextStyle(color: AppColors.black),
                                  )))),
                          TableCell(
                              child: Container(
                                  height: 40,
                                  color: widget.paper.isStructure
                                      ? AppColors.ligthWhite
                                      : AppColors.grey,
                                  child: Center(
                                      child: Text(
                                    editStructureController.text.trim().isNotEmpty
                                        ? editStructureController.text.trim()
                                        : '',
                                    style: const TextStyle(color: AppColors.black),
                                  )))),
                          TableCell(
                              child: Container(
                                  height: 40,
                                  color: widget.paper.isEssay
                                      ? AppColors.ligthWhite
                                      : AppColors.grey,
                                  child: Center(
                                      child: Text(
                                    editEssayController.text.trim().isNotEmpty
                                        ? editEssayController.text.trim()
                                        : '',
                                    style: const TextStyle(color: AppColors.black),
                                  )))),
                          TableCell(
                              child: Container(
                                  height: 40,
                                  color: AppColors.ligthWhite,
                                  child: Center(
                                      child: Text(
                                    editTotalMarksController.text.trim(),
                                    style: const TextStyle(color: AppColors.black),
                                  )))),
                        ],
                      ),
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marks updated'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.of(context).pop();


                },
                child: Text('Edit')),
            //DELETE BUTTON
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.red,
              ),
              onPressed: () async {
               //confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Marks'),
                      content: const Text('Are you sure you want to delete the marks?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('marks')
                                .where('paperId', isEqualTo: widget.paper.paperId)
                                .where('studentId', isEqualTo: studentId)
                                .get()
                                .then((value) {
                              value.docs.forEach((element) {
                                element.reference.delete();
                              });
                            });
                            //delete row in table
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Marks deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddMarks(
                                      paper: widget.paper,
                                    )));
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void fetchPaperMarks() async {
    setState(() {
      isLoading = true;
    });
    //check if the paper has marks
    bool hasMarks = false;
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection('marks')
        .where('paperId', isEqualTo: widget.paper.paperId)
        .get();
    if (q.docs.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('marks')
          .where('paperId', isEqualTo: widget.paper.paperId)
          .orderBy('studentId', descending: false)
          .get();
      List<QueryDocumentSnapshot> m = querySnapshot.docs;
      //sort by student id
      m.sort((a, b) => a['studentId'].compareTo(b['studentId']));
      setState(() {
        isLoading = false;
      });
      setState(() {
        marks.addAll(m);
        if (marks.isNotEmpty) {
          marks.forEach((element) {
            Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
            int? mcq = data['mcqMarks'];
            int? structure = data['structuredMarks'];
            int? essay = data['essayMarks'];
            int studentId = data['studentId'];
            int totalMarks = data['totalMarks'];
            studentIds.add(studentId);
            rows.add(
              TableRow(
                children: [
                  TableCell(
                      child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        showMarksEditDialog(
                            studentId: studentId,
                            mcq: mcq,
                            structure: structure,
                            essay: essay,
                            totalMarks: totalMarks);
                      });
                    },
                        onDoubleTap: () {
                          setState(() {
                            showMarksEditDialog(
                                studentId: studentId,
                                mcq: mcq,
                                structure: structure,
                                essay: essay,
                                totalMarks: totalMarks);
                          });
                        },
                    child: Container(
                        height: 40,
                        color: AppColors.ligthWhite,
                        child: Center(
                            child: Text(
                          studentId.toString(),
                          style: const TextStyle(color: AppColors.black),
                        ))),
                  )),
                  TableCell(
                      child: Container(
                          height: 40,
                          color: widget.paper.isMcq
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          child: Center(
                              child: Text(mcq != null ? mcq.toString() : '',
                                  style: const TextStyle(
                                      color: AppColors.black))))),
                  TableCell(
                      child: Container(
                          height: 40,
                          color: widget.paper.isStructure
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          child: Center(
                              child: Text(
                                  structure != null ? structure.toString() : '',
                                  style: const TextStyle(
                                      color: AppColors.black))))),
                  TableCell(
                      child: Container(
                          height: 40,
                          color: widget.paper.isEssay
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          child: Center(
                              child: Text(essay != null ? essay.toString() : '',
                                  style: const TextStyle(
                                      color: AppColors.black))))),
                  TableCell(
                      child: Container(
                          height: 40,
                          color: AppColors.ligthWhite,
                          child: Center(
                              child: Text(
                            totalMarks.toString(),
                            style: const TextStyle(color: AppColors.black),
                          )))),
                ],
              ),
            );
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMarks({
    required String paperId,
    required int studentId,
    required int? mcq,
    required int? structured,
    required int? essay,
    required int total,
  }) async {
    try {
      final loading = LoadingPopup(context);
      loading.show();
      await FirebaseFirestore.instance
          .collection('marks') // Reference to the collection
          .add({
        'paperId': paperId,
        'studentId': studentId,
        'mcqMarks': mcq,
        'structuredMarks': structured,
        'essayMarks': essay,
        'totalMarks': total
      });
      loading.dismiss();

      // ignore: use_build_context_synchronously
      Globals.showSnackBar(
          context: context, isSuccess: true, message: 'Success');
      setState(() {
        addCount = 0;

        rows.removeLast();
        rows.add(
          TableRow(
            children: [
              TableCell(
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        showMarksEditDialog(
                            studentId: studentId,
                            mcq: mcq,
                            structure: structured,
                            essay: essay,
                            totalMarks: total);
                      });
                    },

                    child: Container(
                        height: 40,
                        color: AppColors.ligthWhite,
                        child: Center(
                            child: Text(
                          studentIdController.text,
                          style: const TextStyle(color: AppColors.black),
                        ))),
                  )),
              TableCell(
                  child: Container(
                      height: 40,
                      color: widget.paper.isMcq
                          ? AppColors.ligthWhite
                          : AppColors.grey,
                      child: Center(
                          child: Text(mcqController.text,
                              style:
                                  const TextStyle(color: AppColors.black))))),
              TableCell(
                  child: Container(
                      height: 40,
                      color: widget.paper.isStructure
                          ? AppColors.ligthWhite
                          : AppColors.grey,
                      child: Center(
                          child: Text(structureController.text,
                              style:
                                  const TextStyle(color: AppColors.black))))),
              TableCell(
                  child: Container(
                      height: 40,
                      color: widget.paper.isEssay
                          ? AppColors.ligthWhite
                          : AppColors.grey,
                      child: Center(
                          child: Text(essayController.text,
                              style:
                                  const TextStyle(color: AppColors.black))))),
              TableCell(
                  child: Container(
                      height: 40,
                      color: AppColors.ligthWhite,
                      child: Center(
                          child: Text(
                        totalMarksController.text,
                        style: const TextStyle(color: AppColors.black),
                      )))),
            ],
          ),
        );
        studentIds.add(int.parse(studentIdController.text));
        studentIdController.clear();
        mcqController.clear();
        structureController.clear();
        essayController.clear();
        totalMarksController.clear();
      });
    } catch (error) {
      // ignore: avoid_print
      print("Failed to add user: $error");
    }
  }

  void _addRow() {
    setState(() {
      if (addCount == 0) {
        rows.add(
          TableRow(
            children: [
              // TableCell(
              //     child: SizedBox(
              //         height: 40,
              //         child: Center(
              //             child: TextFormField(
              //           style: const TextStyle(
              //               color: AppColors.black, fontSize: 12),
              //           textAlign: TextAlign.center,
              //           controller: studentIdController,
              //           decoration: const InputDecoration(
              //             filled: true,
              //             fillColor: AppColors.ligthWhite,
              //             hintStyle:
              //                 TextStyle(color: AppColors.black, fontSize: 12),
              //             hintText: 'Enter',
              //             border: OutlineInputBorder(
              //               borderSide: BorderSide(
              //                 color: AppColors.black,
              //                 // width: 1.5,
              //               ),
              //             ),
              //             // Remove the default border
              //             enabledBorder: UnderlineInputBorder(
              //               // Add bottom line as enabled border
              //               borderSide: BorderSide(color: AppColors.black),
              //             ),
              //           ),
              //         )))),
              TableCell(
                  child: SizedBox(
                      height: 40,
                      child: Center(
                          child: TypeAheadField(
                            controller: studentIdController,
                            builder: (context, controller, focusNode) => TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: true,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(
                                fontSize: 12,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter student id',
                              ),
                            ),
                            decorationBuilder: (context, child) => Material(
                              type: MaterialType.card,
                              elevation: 4,
                              borderRadius: BorderRadius.circular(4),
                              child: child,
                            ),
                            itemBuilder: (context, product) => ListTile(
                              title: Text(product.toString()),
                            ),
                            onSelected: (product) {
                              setState(() {
                                selectedStudentId = int.parse(product.toString());
                                studentIdController.text = product.toString();
                              });
                            },
                            suggestionsCallback: (pattern) async {
                              return instructorAssignedStudentIds
                                  .where((element) =>
                                  element.toString().contains(pattern))
                                  .toList();
                            },
                          )))),
              TableCell(
                  child: SizedBox(
                      height: 40,
                      child: Center(
                          child: TextFormField(
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 12),
                        textAlign: TextAlign.center,
                        enabled: widget.paper.isMcq,
                        controller: mcqController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: widget.paper.isMcq
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          hintStyle: const TextStyle(
                              color: AppColors.black, fontSize: 12),
                          hintText: widget.paper.isMcq ? 'Enter' : '',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              // width: 1.5,
                            ),
                          ),
                          // Remove the default border
                          enabledBorder: const UnderlineInputBorder(
                            // Add bottom line as enabled border
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                        ),
                      )))),
              TableCell(
                  child: SizedBox(
                      height: 40,
                      child: Center(
                          child: TextFormField(
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 12),
                        textAlign: TextAlign.center,
                        enabled: widget.paper.isStructure,
                        controller: structureController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: widget.paper.isStructure
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          hintStyle: const TextStyle(
                              color: AppColors.black, fontSize: 12),
                          hintText: widget.paper.isStructure ? 'Enter' : '',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              // width: 1.5,
                            ),
                          ),
                          // Remove the default border
                          enabledBorder: const UnderlineInputBorder(
                            // Add bottom line as enabled border
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                        ),
                      )))),
              TableCell(
                  child: SizedBox(
                      height: 40,
                      child: Center(
                          child: TextFormField(
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 12),
                        textAlign: TextAlign.center,
                        enabled: widget.paper.isEssay,
                        controller: essayController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: widget.paper.isEssay
                              ? AppColors.ligthWhite
                              : AppColors.grey,
                          hintStyle: const TextStyle(
                              color: AppColors.black, fontSize: 12),
                          hintText: widget.paper.isEssay ? 'Enter' : '',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              // width: 1.5,
                            ),
                          ),
                          // Remove the default border
                          enabledBorder: const UnderlineInputBorder(
                            // Add bottom line as enabled border
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                        ),
                      )))),
              TableCell(
                  child: SizedBox(
                      height: 40,
                      child: Center(
                          child: TextFormField(
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 12),
                        textAlign: TextAlign.center,
                        controller: totalMarksController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.ligthWhite,
                          hintStyle:
                              TextStyle(color: AppColors.black, fontSize: 12),
                          hintText: 'Enter',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              // width: 1.5,
                            ),
                          ),
                          // Remove the default border
                          enabledBorder: UnderlineInputBorder(
                            // Add bottom line as enabled border
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                        ),
                      )))),
            ],
          ),
        );
        addCount++;
      } else {
        Globals.showSnackBar(
            context: context,
            message: 'You have to add marks',
            isSuccess: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        shape: const CircleBorder(),
        onPressed: _addRow,
        child: const Icon(
          Icons.add,
          color: AppColors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(80),
              const Center(
                child: Text(
                  "Add Marks",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.black),
                ),
              ),
              const Gap(50),
              Text(
                widget.paper.paperName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              Row(
                children: [
                  Visibility(
                    visible: widget.paper.isMcq,
                    child: const SizedBox(
                      height: 10,
                      width: 20,
                      child: CircleAvatar(
                        backgroundColor: AppColors.purple,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.paper.isStructure,
                    child: const SizedBox(
                      height: 10,
                      width: 20,
                      child: CircleAvatar(
                        backgroundColor: AppColors.green,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.paper.isEssay,
                    child: const SizedBox(
                      height: 10,
                      width: 20,
                      child: CircleAvatar(
                        backgroundColor: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              const Text(
                'Add Marks',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const Gap(10),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Table(
                      border: TableBorder.all(),
                      children: rows,
                    ),
              const Gap(40),
              Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    // if (!formKey.currentState!.validate()) return;
                    if (studentIdController.text.trim().isEmpty) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter the student id',
                          isSuccess: false);
                      return;
                    }
                    if (int.tryParse(studentIdController.text.trim()) == null) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter valid student id',
                          isSuccess: false);
                      return;
                    }

                    if (studentIds
                        .contains(int.parse(studentIdController.text.trim()))) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Student id is already taken',
                          isSuccess: false);
                      return;
                    }
                    if (widget.paper.isMcq &&
                        mcqController.text.trim().isEmpty) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter the mcq marks',
                          isSuccess: false);
                      return;
                    }
                    if (mcqController.text.isNotEmpty) {
                      if (int.tryParse(mcqController.text.trim()) == null) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'Please enter valid mcq marks',
                            isSuccess: false);
                        return;
                      }
                      if (0 > int.parse(mcqController.text.trim()) ||
                          int.parse(mcqController.text.trim()) > 2000) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'mcq marks should be between 0 and 100',
                            isSuccess: false);
                        return;
                      }
                    }
                    if ((widget.paper.isStructure &&
                        structureController.text.trim().isEmpty)) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter the structure marks',
                          isSuccess: false);
                      return;
                    }
                    if (structureController.text.isNotEmpty) {
                      if (int.tryParse(structureController.text.trim()) ==
                          null) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'Please enter valid structure marks',
                            isSuccess: false);
                        return;
                      }
                      if (0 > int.parse(structureController.text.trim()) ||
                          int.parse(structureController.text.trim()) > 2000) {
                        Globals.showSnackBar(
                            context: context,
                            message:
                                'structure marks should be between 0 and 100',
                            isSuccess: false);
                        return;
                      }
                    }
                    if ((widget.paper.isEssay &&
                        essayController.text.trim().isEmpty)) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter the essay marks',
                          isSuccess: false);
                      return;
                    }
                    if (essayController.text.isNotEmpty) {
                      if (int.tryParse(essayController.text.trim()) == null) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'Please enter valid esaay marks',
                            isSuccess: false);
                        return;
                      }
                      if (0 > int.parse(essayController.text.trim()) ||
                          int.parse(essayController.text.trim()) > 2000) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'essay marks should be between 0 and 100',
                            isSuccess: false);
                        return;
                      }
                    }
                    if (totalMarksController.text.trim().isEmpty) {
                      Globals.showSnackBar(
                          context: context,
                          message: 'Please enter the total marks',
                          isSuccess: false);
                      return;
                    }
                    if (totalMarksController.text.isNotEmpty) {
                      if (int.tryParse(totalMarksController.text.trim()) ==
                          null) {
                        Globals.showSnackBar(
                            context: context,
                            message: 'Please enter valid total marks',
                            isSuccess: false);
                        return;
                      }
                      if (widget.paper.isMcq &&
                          widget.paper.isStructure &&
                          widget.paper.isEssay) {
                        if (0 > int.parse(totalMarksController.text.trim()) ||
                            int.parse(totalMarksController.text.trim()) > 2000) {
                          Globals.showSnackBar(
                              context: context,
                              message:
                                  'total marks should be between 0 and 300',
                              isSuccess: false);
                          return;
                        }
                      }
                      if (widget.paper.isMcq &&
                          widget.paper.isStructure &&
                          !widget.paper.isEssay) {
                        if (0 > int.parse(totalMarksController.text.trim()) ||
                            int.parse(totalMarksController.text.trim()) > 2000) {
                          Globals.showSnackBar(
                              context: context,
                              message:
                                  'total marks should be between 0 and 200',
                              isSuccess: false);
                          return;
                        }
                      }
                      if (widget.paper.isMcq &&
                          widget.paper.isEssay &&
                          !widget.paper.isStructure) {
                        if (0 > int.parse(totalMarksController.text.trim()) ||
                            int.parse(totalMarksController.text.trim()) > 2000) {
                          Globals.showSnackBar(
                              context: context,
                              message:
                                  'total marks should be between 0 and 200',
                              isSuccess: false);
                          return;
                        }
                      }
                      if (widget.paper.isStructure &&
                          widget.paper.isEssay &&
                          !widget.paper.isMcq) {
                        if (0 > int.parse(totalMarksController.text.trim()) ||
                            int.parse(totalMarksController.text.trim()) > 2000) {
                          Globals.showSnackBar(
                              context: context,
                              message:
                                  'total marks should be between 0 and 200',
                              isSuccess: false);
                          return;
                        }
                      }

                      if (widget.paper.isMcq &&
                          !widget.paper.isStructure &&
                          !widget.paper.isEssay) {
                        if (0 > int.parse(totalMarksController.text.trim()) ||
                            int.parse(totalMarksController.text.trim()) > 2000) {
                          Globals.showSnackBar(
                              context: context,
                              message:
                                  'total marks should be between 0 and 100',
                              isSuccess: false);
                          return;
                        }
                      }
                    }
                    addMarks(
                      paperId: widget.paper.paperId,
                      studentId: int.parse(studentIdController.text.trim()),
                      mcq: mcqController.text.trim().isNotEmpty
                          ? int.parse(mcqController.text.trim())
                          : null,
                      structured: structureController.text.trim().isNotEmpty
                          ? int.parse(structureController.text.trim())
                          : null,
                      essay: essayController.text.trim().isNotEmpty
                          ? int.parse(essayController.text.trim())
                          : null,
                      total: int.parse(totalMarksController.text.trim()),
                    );
                  },
                  child: const Center(
                      child: Text(
                    'Done',
                    style: TextStyle(
                      color: AppColors.ligthWhite,
                    ),
                  )),
                ),
              ),
              const Gap(15)
            ],
          ),
        ),
      ),
    );
  }
}
