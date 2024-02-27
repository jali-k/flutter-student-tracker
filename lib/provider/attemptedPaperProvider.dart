import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Paper.dart';
import '../model/leaderboard_entries.dart';
import '../model/paper_attempt.dart';

class attemptedPaperProvider with ChangeNotifier {
  bool isLoading = true;
  List<ExamPaper> papers=[];
  Map<String, List<LeaderBoardEntries>> leaderBoard = {};

  setPapers(List<ExamPaper> papers, Map<String, List<LeaderBoardEntries>> leaderBoard){
    this.papers=papers;
    this.leaderBoard=leaderBoard;
    notifyListeners();
  }

  setLoader(bool isLoading){
    this.isLoading=isLoading;
    notifyListeners();
  }

}