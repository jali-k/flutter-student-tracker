

import 'package:flutter/material.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {

  final isSelected = [true, false, false, false, false];
  int selected = 0;
  final myID = 3524;
  //scroll key
  final ScrollController _scrollController = ScrollController();

  void handleSelected(int i) {
    for (int j = 0; j < isSelected.length; j++) {
      if (j == i) {
        isSelected[j] = true;
      } else {
        isSelected[j] = false;
      }
    }
    setState(() {
      selected = i;
    });
  }

  void navigateToPosition(int position) {
    _scrollController.animateTo(
      position * 70.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *0.9,
      height: MediaQuery.of(context).size.height - 70,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // See Where You Stand
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('See ', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
                Text('where', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C897),
                ),),
                Text(' You Stand', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            // Overall, Biology, Chemistry, Physics, Agriculture Buttons
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(0);
                      });
                    },
                    child: Text('Overall', style: TextStyle(
                      color: isSelected[0] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[0] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(1);
                      });
                    },
                    child: Text('Biology', style: TextStyle(
                      color: isSelected[1] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[1] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(2);
                      });
                    },
                    child: Text('Chemistry', style: TextStyle(
                      color: isSelected[2] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[2] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(3);
                      });
                    },
                    child: Text('Physics', style: TextStyle(
                      color: isSelected[3] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[3] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        handleSelected(4);
                      });
                    },
                    child: Text('Agriculture', style: TextStyle(
                      color: isSelected[4] ? Colors.white : Colors.black,
                    ),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(isSelected[4] ? Color(0xFF00C897) : Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color(0xFF00C897)),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
        ),
          SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 300,
            // Leaderboard
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
              if(index == myID)
                {
                  navigateToPosition(index);
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF00C897),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('${index}', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 3,
                          child: Text('Student ${index+1}', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        Expanded(child: SizedBox(), flex: 1,),
                        Expanded(
                          flex: 2,
                          child: Text('100', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('${index}', style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 3,
                      child: Text('Student ${index+1}', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Expanded(child: SizedBox(), flex: 1,),
                    Expanded(
                      flex: 2,
                      child: Text('100', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.right,),
                    ),
                  ],
                ),
              );
            },
              itemCount: 5000,
              shrinkWrap: true,
            ),
          ),
          SizedBox(height: 20,),


        ],
      ),
    );
  }

}
