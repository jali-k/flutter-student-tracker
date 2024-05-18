import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/created_focus_session_data_model.dart';
import 'package:spt/model/focus_session_in_week_stat_data_model.dart';
import 'package:spt/model/student_details.dart';
import 'package:spt/services/focusService.dart';
import 'package:spt/services/focus_service.dart';
import 'package:spt/util/SubjectColorUtil.dart';
import 'package:spt/util/toast_util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../model/current_focus_session_response.dart';
import '../../model/focus_session_by_student.dart';
import '../../model/subject_response_model.dart';
import '../../widgets/circle_progressbar_painter.dart';

class FocusMode extends StatefulWidget {
  final Lessons lesson;
  final String lessonContent;
  final String subject;
  final bool enableFocus;

  final Function(Map<String, int> countDown) setCountDownTimer;

  const FocusMode(
      {super.key,
      required this.lesson,
      required this.lessonContent,
      required this.subject,
      this.enableFocus = false,
      required this.setCountDownTimer});

  @override
  State<FocusMode> createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> {
  late String lessonId;
  late String lessonContent;
  final TotalDuration dailyStat =
      TotalDuration(hours: 0, minutes: 0, seconds: 0);
  final TotalDuration weeklyStat =
      TotalDuration(hours: 0, minutes: 0, seconds: 0);
  final TotalDuration monthlyStat =
      TotalDuration(hours: 0, minutes: 0, seconds: 0);

  int selectedTime = 25;
  Map<String, int> countDown = {
    'minutes': 25,
    'seconds': 0,
  };
  String ButtonText = 'Start';
  Timer? timer, timer2;
  bool enabledFocus = false;
  bool isPaused = false;
  bool isStarted = false;
  final List<int> _timeDuration = [
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    90,
    120,
    150,
    180,
    210,
    240,
    270,
    300
  ];
  List<SubjectWiseFocusData> focusData = [];
  List<ChartData> dailyChartData = [];
  List<ChartData> weeklyChartData = [];
  List<ChartData> monthlyChartData = [];
  String chartPrefix = "";
  List<ChartData> chartData = [];
  int initialStatIndex = 1;
  Map<String, int> totalDailyStat = {"hour": 0, "minutes": 0};
  Map<String, int> totalWeeklyStat = {"hour": 0, "minutes": 0};
  Map<String, int> totalMonthlyStat = {"hour": 0, "minutes": 0};
  Map<String, int> selectedStat = {"hour": 0, "minutes": 0};
  late Color primaryColor;
  late Color borderColor;
  double percentage = 1;
  List<String> monthsShort = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<Color> _subjectColors = [SubjectColor.BIOLOGY, SubjectColor.CHEMISTRY, SubjectColor.PHYSICS, SubjectColor.AGRICULTURE, SubjectColor.PAPER_WRITING];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    primaryColor = SubjectColor.getPrimaryColor(widget.subject);
    borderColor = SubjectColor.getBorderColor(widget.subject);
    lessonId = widget.lesson.lessonId!;
    lessonContent = widget.lessonContent;
    getYearlyFocusSession();
    getDailyFocusSession();
    getWeeklyFocusSession();
    // checkEnabledFocus();
    getRecentData();
    getSubjectWiseFocusData();
    // getFocusData();
  }

  getSubjectWiseFocusData() async {
    FocusSessionByStudent? tFocus =await FocusSessionService.getFocusSessionByStudent(context);
    setState(() {
      focusData = tFocus!.data!;
    });
  }

  getDailyFocusSession() async {
    FocusSessionsInWeekStatsDataModel? inWeekStatsDataModel =
        await FocusSessionService.getInWeekFocusSessionStat(context);
    if (inWeekStatsDataModel != null) {
      List<InWeekData> data = inWeekStatsDataModel.data!;
      List<ChartData> chartData = [];
      TotalDuration td = TotalDuration(hours: 0, minutes: 0, seconds: 0);
      for (int i = 0; i < data.length; i++) {
        td = TotalDuration(
            hours: td.hours! + data[i].totalDuration!.hours!,
            minutes: td.minutes! + data[i].totalDuration!.minutes!,
            seconds: td.seconds! + data[i].totalDuration!.seconds!);
        DateTime date = DateTime.fromMillisecondsSinceEpoch(data[i].day!);
        chartData.add(ChartData(
            "${monthsShort[date.month - 1]} ${date.day.toString().padLeft(2, '0')}",
            data[i].totalDuration!.hours!.toDouble() * 60 +
                data[i].totalDuration!.minutes!.toDouble()));
      }
      setState(() {
        dailyChartData = chartData;
        totalDailyStat = {"hour": td.hours!, "minutes": td.minutes!};
      });
    }
  }

  getWeeklyFocusSession() async {
    FocusSessionsInWeekStatsDataModel? inWeekStatsDataModel =
        await FocusSessionService.getInMonthFocusSessionStat(context);
    if (inWeekStatsDataModel != null) {
      List<InWeekData> data = inWeekStatsDataModel.data!;
      List<ChartData> chartData = [];
      TotalDuration td = TotalDuration(hours: 0, minutes: 0, seconds: 0);
      for (int i = 0; i < data.length; i++) {
        td = TotalDuration(
            hours: td.hours! + data[i].totalDuration!.hours!,
            minutes: td.minutes! + data[i].totalDuration!.minutes!,
            seconds: td.seconds! + data[i].totalDuration!.seconds!);
        DateTime date = DateTime.fromMillisecondsSinceEpoch(data[i].day!);
        int weekOfYear =
            date.toUtc().difference(DateTime.utc(date.year, 1, 1)).inDays ~/ 7;
        chartData.add(ChartData(
            "Week ${i + 1}",
            data[i].totalDuration!.hours!.toDouble() * 60 +
                data[i].totalDuration!.minutes!.toDouble()));
      }
      setState(() {
        weeklyChartData = chartData;
        totalWeeklyStat = {"hour": td.hours!, "minutes": td.minutes!};
      });
    }
  }

  getYearlyFocusSession() async {
    FocusSessionsInWeekStatsDataModel? inWeekStatsDataModel =
        await FocusSessionService.getInYearFocusSessionStat(context);
    if (inWeekStatsDataModel != null) {
      List<InWeekData> data = inWeekStatsDataModel.data!;
      List<ChartData> chartData = [];
      int currentMonth = DateTime.now().month;
      for (int i = 0; i < currentMonth; i++) {
        chartData.add(ChartData("${monthsShort[i]}", 0));
      }
      TotalDuration td = TotalDuration(hours: 0, minutes: 0, seconds: 0);
      for (int i = 0; i < data.length; i++) {
        td = TotalDuration(
            hours: td.hours! + data[i].totalDuration!.hours!,
            minutes: td.minutes! + data[i].totalDuration!.minutes!,
            seconds: td.seconds! + data[i].totalDuration!.seconds!);
        DateTime date = DateTime.fromMillisecondsSinceEpoch(data[i].day!);
        String month = monthsShort[date.month - 1];
        // chartData.add(ChartData(
        //     "${month}",
        //     data[i].totalDuration!.hours!.toDouble()));
        int monthIndex = chartData.indexWhere((element) => element.x == month);
        if (monthIndex != -1) {
          chartData[monthIndex].y += data[i].totalDuration!.hours!.toDouble() * 60 +
              data[i].totalDuration!.minutes!.toDouble();
        }
      }
      // remove next months

      setState(() {
        monthlyChartData = chartData;
        totalMonthlyStat = {"hour": td.hours!, "minutes": td.minutes!};
      });
    }
  }

  changeStat(int index, StateSetter changeState) {
    Navigator.pop(context);
    setState(() {
      initialStatIndex = index;
      switch (index) {
        case 0:
          chartPrefix = "";
          chartData = dailyChartData;
          selectedStat = totalDailyStat;
          break;
        case 1:
          chartPrefix = "";
          chartData = weeklyChartData;
          selectedStat = totalWeeklyStat;
          break;
        case 2:
          chartPrefix = "";
          chartData = monthlyChartData;
          selectedStat = totalMonthlyStat;
          break;
        default:
      }
    });
    showStatistics(chartData);
  }

  getRecentData() async {
    CurrentFocusSessionResponseModel? focusData =
        await FocusSessionService.isFocusSession(context);
    if (focusData != null) {
      if (focusData.data! != null) {
        DateTime startAt =
            DateTime.fromMillisecondsSinceEpoch(focusData.data!.startTime!);
        DateTime currentTime = DateTime.now();
        int setDuration = focusData.data!.duration!;
        Duration duration = currentTime.difference(startAt);
        if (duration.inMinutes >= setDuration) {
          FocusSessionService.stopFocusSession(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Time is up!'),
                content: const Text('Time to take a break'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          setState(() {
            ButtonText = 'Start';
          });
          return;
        }
        Map<String, dynamic> _countDown = {
          'minutes': setDuration -
              duration.inMinutes -
              (duration.inSeconds % 60 == 0 ? 0 : 1),
          'seconds': duration.inSeconds % 60,
        };
        timer = Timer(
            Duration(
                minutes: _countDown['minutes']!,
                seconds: _countDown['seconds']!), () {
          // Show the alert
          endFocussingSession();
        });
        timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
          calculateRadialProgress();
          setState(() {
            if (countDown['seconds'] == 0) {
              int? minutes = countDown['minutes'];
              countDown = {
                'minutes': minutes! - 1,
                'seconds': 59,
              };
            } else {
              int? seconds = countDown['seconds'];
              countDown = {
                'minutes': countDown['minutes']!,
                'seconds': seconds! - 1,
              };
            }
            if (countDown['minutes'] == 0 && countDown['seconds'] == 0) {
              timer2?.cancel();
            }
          });
        });
        setState(() {
          enabledFocus = true;
          countDown = _countDown.cast<String, int>();
          ButtonText = 'Stop';
          isStarted = true;
        });
      }
    }
  }

  Future<void> checkEnabledFocus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('enabledFocus') &&
        prefs.getBool('enabledFocus')! &&
        prefs.containsKey('countDown')) {
      CreatedFocusSessionDataModel focusData =
          CreatedFocusSessionDataModel.fromJson(
              jsonDecode(prefs.getString('focusData')!));
      DateTime startAt =
          DateTime.fromMillisecondsSinceEpoch(focusData.data!.startTime!);
      DateTime currentTime = DateTime.now();
      int setDuration = focusData.data!.duration!;
      Duration duration = currentTime.difference(startAt);
      if (duration.inMinutes >= setDuration) {
        FocusSessionService.stopFocusSession(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Time is up!'),
              content: const Text('Time to take a break'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          ButtonText = 'Start';
        });
        return;
      }

      Map<String, dynamic> _countDown = {
        'minutes': setDuration -
            duration.inMinutes -
            (duration.inSeconds % 60 == 0 ? 0 : 1),
        'seconds': duration.inSeconds % 60,
      };
      timer = Timer(
          Duration(
              minutes: _countDown['minutes']!,
              seconds: _countDown['seconds']!), () {
        // Show the alert
        endFocussingSession();
      });
      timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
        calculateRadialProgress();
        setState(() {
          if (countDown['seconds'] == 0) {
            int? minutes = countDown['minutes'];
            countDown = {
              'minutes': minutes! - 1,
              'seconds': 59,
            };
          } else {
            int? seconds = countDown['seconds'];
            countDown = {
              'minutes': countDown['minutes']!,
              'seconds': seconds! - 1,
            };
          }
          prefs.setString('countDown', jsonEncode(countDown));
          if (countDown['minutes'] == 0 && countDown['seconds'] == 0) {
            timer2?.cancel();
          }
        });
      });

      setState(() {
        enabledFocus = prefs.getBool('enabledFocus')!;
        countDown = _countDown.cast<String, int>();
        ButtonText = enabledFocus ? 'Stop' : 'Start';
        isStarted = enabledFocus;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.setCountDownTimer(countDown);
    timer?.cancel();
    timer2?.cancel();
  }

  startFocusingSession() async {
    // Start the timer
    if (ButtonText == 'Start') {
      setState(() {
        ButtonText = 'Stop';
        isStarted = true;
      });
      timer = Timer(Duration(minutes: selectedTime), () {
        FocusSessionService.stopFocusSession(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Time is up!'),
              content: const Text('Time to take a break'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          ButtonText = 'Start';
        });
      });
      // FocusService.focusOnLesson(
      //     widget.lesson, lessonContent, selectedTime, widget.subject);
    } else {
      setState(() {
        ButtonText = 'Start';
      });
      timer!.cancel();
    }

    countDown = {
      'minutes': selectedTime,
      'seconds': 0,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('countDown', jsonEncode(countDown));

    // Show the timer
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      calculateRadialProgress();
      setState(() {
        if (countDown['seconds'] == 0) {
          int? minutes = countDown['minutes'];
          countDown = {
            'minutes': minutes! - 1,
            'seconds': 59,
          };
        } else {
          int? seconds = countDown['seconds'];
          countDown = {
            'minutes': countDown['minutes']!,
            'seconds': seconds! - 1,
          };
        }
        prefs.setString('countDown', jsonEncode(countDown));
        if (countDown['minutes'] == 0 && countDown['seconds'] == 0) {
          timer2?.cancel();
        }
      });
    });

    // Show the statistics
  }

  startFocusSession() async {
    bool started = await FocusSessionService.startFocusSession(
        context, widget.lesson, selectedTime, widget.lessonContent);
    if (started) {
      setState(() {
        ButtonText = 'Stop';
        isStarted = true;
      });
      timer = Timer(Duration(minutes: selectedTime), () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Time is up!'),
              content: const Text('Time to take a break'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          ButtonText = 'Start';
        });
      });
    } else {
      //Navigate to Subject Selection Page
      return;
    }

    countDown = {
      'minutes': selectedTime,
      'seconds': 0,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('countDown', jsonEncode(countDown));

    // Show the timer
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      calculateRadialProgress();
      setState(() {
        if (countDown['seconds'] == 0) {
          int? minutes = countDown['minutes'];
          countDown = {
            'minutes': minutes! - 1,
            'seconds': 59,
          };
        } else {
          int? seconds = countDown['seconds'];
          countDown = {
            'minutes': countDown['minutes']!,
            'seconds': seconds! - 1,
          };
        }
        prefs.setString('countDown', jsonEncode(countDown));
        if (countDown['minutes'] == 0 && countDown['seconds'] == 0) {
          timer2?.cancel();
        }
      });
    });
  }

  stopFocusSession() async {
    //TODO : Complete the Focus Session
    bool stopped = await FocusSessionService.cancelFocusSession(context);
    if (stopped == false) {
      ToastUtil.showErrorToast(
          context, "Error", "Failed to stop focus session");
      return;
    }
    timer?.cancel();
    timer2?.cancel();
    ToastUtil.showSuccessToast(context, "Success", "Focus Session Stopped");
    Navigator.of(context).pop();
  }

  endFocussingSession() async {
    bool stopped = await FocusSessionService.stopFocusSession(context);
    if (stopped == false) {
      ToastUtil.showErrorToast(
          context, "Error", "Failed to stop focus session");
      return;
    }
    timer?.cancel();
    timer2?.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('enabledFocus', false);
    prefs.remove('countDown');
    prefs.remove('focusData');
    ToastUtil.showSuccessToast(context, "Success", "Focus Session Ended");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time is up!'),
          content: const Text('Time to take a break'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainLayout()));
    setState(() {
      ButtonText = 'Start';
    });
  }

  calculateRadialProgress() {
    double percentage = (countDown['minutes']! * 60 + countDown['seconds']!) /
        (selectedTime * 60);
    print(percentage);
    setState(() {
      this.percentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          color: Color(0xFFFAFAFA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stay ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Focused',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C897),
                    ),
                  ),
                ],
              ),
              // Text(
              //   '${lessonContent}',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              // Time selection
              if (!isStarted)
                DropdownButton(
                  value: selectedTime,
                  disabledHint: const Text('Timer Started'),
                  items: _timeDuration
                      .map((e) => DropdownMenuItem(
                            enabled: isStarted ? e == selectedTime : true,
                            value: e,
                            alignment: Alignment.center,
                            child:
                                // if e is greater than 60 then show hours and minutes
                                Text(
                              e > 60
                                  ? '${e ~/ 60} h ${e % 60 != 0 ? '${e % 60} min' : ''}'
                                  : '$e mins',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value as int;
                      countDown = {
                        'minutes': selectedTime,
                        'seconds': 0,
                      };
                    });
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              // Show Clock here
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CustomPaint(
                  foregroundPainter: CircleProgressBarPainter(
                    lineColor: Colors.grey,
                    completeColor: primaryColor,
                    completePercent: !isStarted ? 100 : (percentage) * 100,
                    width: 15.0,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: 10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        generateTimeString(countDown),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (ButtonText == "Start")
                ElevatedButton(
                  onPressed: ButtonText == "Start"
                      ? () {
                          startFocusSession();
                        }
                      : null,
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Color(0xFFC3E2C2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              // Start button
              if (ButtonText != "Start")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        stopFocusSession();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 40,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Color(0xFFC3E2C2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Gap(30),
                    IconButton(
                      onPressed: () {
                        endFocussingSession();
                      },
                      icon: Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Color(0xFFC3E2C2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "STATISTICS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Statistics Button as a Row Daily, Weekly, Monthly
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            initialStatIndex = 0;
                            selectedStat = totalDailyStat;
                          });
                          showStatistics(dailyChartData);
                        },
                        child: const Text(
                          'Daily',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // fixedSize: const Size(110, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF424242),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '${totalDailyStat["hour"]}h ${totalDailyStat["minutes"]}mins',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            initialStatIndex = 1;
                            selectedStat = totalWeeklyStat;
                          });
                          showStatistics(weeklyChartData);
                        },
                        child: const Text(
                          'Weekly',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // fixedSize: const Size(110, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF424242),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '${totalWeeklyStat["hour"]}h ${totalWeeklyStat["minutes"]}mins',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            initialStatIndex = 2;
                            selectedStat = totalMonthlyStat;
                          });
                          showStatistics(monthlyChartData);
                        },
                        child: const Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // fixedSize: const Size(110, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF424242),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '${totalMonthlyStat["hour"]}h ${totalMonthlyStat["minutes"]}mins',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // See more button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //report button
                  TextButton(
                    onPressed: () {
                      showReport();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Report',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.ac_unit,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showStatistics(weeklyChartData);
                      selectedStat = totalWeeklyStat;
                    },
                    child: Row(
                      children: const [
                        Text(
                          'See more',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              )

              // Start button
            ],
          ),
        ),
      ),
    );
  }

  void showStatistics(List<ChartData> cData) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Color(0xFF424242),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter changeState) {
          return Container(
            height: 650,
            decoration: const BoxDecoration(
              color: Color(0xFF424242),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "STATISTICS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            changeStat(0, changeState);
                          },
                          style: ElevatedButton.styleFrom(
                            // fixedSize: const Size(110, 50),
                            foregroundColor: initialStatIndex == 0
                                ? Colors.white
                                : Colors.black,
                            backgroundColor: initialStatIndex == 0
                                ? Color(0xFF00C897)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Daily',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '${totalDailyStat["hour"]}h ${totalDailyStat["minutes"]}mins',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            changeStat(1, changeState);
                          },
                          child: const Text(
                            'Weekly',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            // fixedSize: const Size(110, 50),
                            foregroundColor: initialStatIndex == 1
                                ? Colors.white
                                : Colors.black,
                            backgroundColor: initialStatIndex == 1
                                ? Color(0xFF00C897)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          '${totalWeeklyStat["hour"]}h ${totalWeeklyStat["minutes"]}mins',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            changeStat(2, changeState);
                          },
                          child: const Text(
                            'Monthly',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            // fixedSize: const Size(110, 50),
                            foregroundColor: initialStatIndex == 2
                                ? Colors.white
                                : Colors.black,
                            backgroundColor: initialStatIndex == 2
                                ? Color(0xFF00C897)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          '${totalMonthlyStat["hour"]}h ${totalMonthlyStat["minutes"]}mins',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(width: 0),
                      axisLine: AxisLine(width: 1, color: Color(0XFFF2F8F2)),
                      labelRotation: -90,
                    ),
                    primaryYAxis: const NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(width: 0),
                      axisLine: AxisLine(width: 1, color: Color(0XFFF2F8F2)),
                    ),
                    plotAreaBorderWidth: 0,
                    title: const ChartTitle(text: 'Weekly Statistics'),
                    legend: const Legend(isVisible: false),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                          dataSource: cData,
                          xValueMapper: (ChartData data, _) => "${data.x}",
                          yValueMapper: (ChartData data, _) => data.y,
                          color: Color(0xFFACE194),
                          borderRadius: BorderRadius.all(Radius.circular(3)))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${selectedStat["hour"]}h ${selectedStat["minutes"]}mins',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (selectedStat["hour"]! >= 2)
                        Text(
                          'Good Job! Keep it up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFC3E2C2),
                          ),
                        ),
                      if (selectedStat["hour"]! < 2)
                        Text(
                          'Focus more!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFC3E2C2),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  void showReport() {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Color(0xFF424242),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFF424242),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                //Title and List of Reports focusData by subject expansion and lessons
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "REPORT",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //List of Reports
                Container(
                  height: 600,
                  child: focusData.length == 0
                      ? Center(
                          child: Text(
                            "No data available",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: focusData.length,
                          itemBuilder: (context, index) {
                            SubjectWiseFocusData subjectWiseFocusSession = focusData[index];
                            return ExpansionTile(
                              visualDensity: VisualDensity.compact,
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              title: Text(subjectWiseFocusSession.subject!.subjectName!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Color(0xFF565656),
                              children: [
                                Container(
                                  height: 200,
                                  constraints: BoxConstraints(
                                    minHeight: 50,
                                    maxHeight: 200,
                                  ),
                                  child: ListView.builder(
                                    itemCount: subjectWiseFocusSession.focusSessions!.length,
                                    itemBuilder: (context, j) {
                                      SubjectWiseFocusSessions focusSession = subjectWiseFocusSession.focusSessions![j];
                                      return ListTile(
                                        selectedColor: Colors.transparent,
                                        tileColor: Colors.transparent,
                                        visualDensity: VisualDensity.compact,
                                        title: Text(getTimeAndDate(DateTime.fromMillisecondsSinceEpoch(focusSession.startTime!)),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(focusSession.remarks!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        trailing: Text(
                                          '${focusSession.duration!} mins',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ]));
        });
  }

  String generateTimeString(Map<String, int> countDown) {
    //if minutes > 60 theb show hh:mm if not show mm:ss
    if (countDown['minutes']! >= 60) {
      return '${countDown['minutes']! ~/ 60}h ${countDown['minutes']! % 60}m';
    } else {
      return '${countDown['minutes']!}m ${countDown['seconds']}s';
    }
  }

  String getTimeAndDate(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

class ChartData {
  ChartData(this.x, this.y);

  String x;
  double y;
}
