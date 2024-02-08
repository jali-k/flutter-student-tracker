import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:spt/services/focusService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class FocusMode extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> lesson;
  final String lessonContent;
  final String subject;

  const FocusMode({super.key, required this.lesson, required this.lessonContent, required this.subject});

  @override
  State<FocusMode> createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> {
  late String lessonId;
  late String lessonContent;
  int selectedTime = 25;
  Map<String, int> countDown = {
    'minutes': 25,
    'seconds': 0,
  };
  String ButtonText = 'Start';
  Timer? timer, timer2;

  showOverlay() async {
    if (!await FlutterOverlayWindow.isPermissionGranted()) {
      await FlutterOverlayWindow.requestPermission();
    } else {
      await FlutterOverlayWindow.showOverlay(
          overlayTitle: "", height: 1100, width: 800, enableDrag: true);
      await FlutterOverlayWindow.shareData(countDown);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lessonId = widget.lesson.id;
    lessonContent = widget.lessonContent;
  }

  @override
  void dispose() {
    super.dispose();
    showOverlay();
  }

  startFocusingSession() {
    // Start the timer
    if (ButtonText == 'Start') {
      setState(() {
        ButtonText = 'Stop';
      });
      timer = Timer(Duration(seconds: 10), () {
        // Show the alert
        FocusService.endFocusOnLesson();
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
      });
      FocusService.focusOnLesson(widget.lesson, lessonContent, selectedTime,widget.subject);
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

    // Show the timer
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
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

    // Show the statistics
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      color: Color(0xFFFAFAFA),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
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
          ),
          Text(
            '${lessonContent}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Time selection
          DropdownButton(
            value: selectedTime,
            items: const [
              DropdownMenuItem(
                child: Text('25 mins'),
                value: 25,
              ),
              DropdownMenuItem(
                child: Text('30 mins'),
                value: 30,
              ),
            ],
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
          SizedBox(
            height: 20,
          ),
          // Show Clock here
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF00C897),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF6C9263),
                  width: 10,
                ),
              ),
              child: Center(
                child: Text(
                  '${countDown['minutes']}:${countDown['seconds']! < 10 ? '0' + countDown['seconds'].toString() : countDown['seconds']}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          // Start button
          ElevatedButton(
            onPressed: () {
              startFocusingSession();
            },
            child: Text(
              ButtonText,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Color(0xFFC3E2C2),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
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
                    onPressed: () {},
                    child: const Text(
                      'Daily',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 50),
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
                    '3h 12mins',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Weekly',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 50),
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
                    '21h 12mins',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(110, 50),
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
                    '90h 12mins',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showStatistics();
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          )

          // Start button
        ],
      ),
    );
  }

  final List<ChartData> chartData = [
    ChartData(1, 35),
    ChartData(2, 23),
    ChartData(3, 34),
    ChartData(4, 25),
    ChartData(5, 40),
    ChartData(6, 30),
    ChartData(7, 35),
  ];

  void showStatistics() {
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
              Row(
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
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Daily',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(110, 50),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '3h 12mins',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Weekly',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(110, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF00C897),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '21h 12mins',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF9E9393)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(110, 50),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        '90h 12mins',
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
                  primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    majorTickLines: MajorTickLines(width: 0),
                    axisLine: AxisLine(width: 1, color: Color(0XFFF2F8F2)),
                  ),
                  primaryYAxis: NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    majorTickLines: MajorTickLines(width: 0),
                    axisLine: AxisLine(width: 1, color: Color(0XFFF2F8F2)),
                  ),
                  plotAreaBorderWidth: 0,
                  title: ChartTitle(text: 'Weekly Statistics'),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, double>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
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
                      '15h 12mins',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Good Job! Keep it up',
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
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final double x;
  final double y;
}
