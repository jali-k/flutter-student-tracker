import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Paper.dart';
import '../model/paper_attempt.dart';

class paperProvider with ChangeNotifier {
  Map<ExamPaper, AttemptPaper?> paperController={};

  setPapers(Map<ExamPaper, AttemptPaper?> papers){
    paperController=papers;
    notifyListeners();
  }

}