

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  QuerySnapshot? notifications;
  bool _loading = true;
  int? registrationNumber;

  getNotifications() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int _registrationNumber = (await FirebaseFirestore.instance.collection('students').doc(uid).get())['registrationNumber'];

    QuerySnapshot _notifications = await NotificationService.getNotifications();
    setState(() {
      notifications = _notifications;
      _loading = false;
      registrationNumber = _registrationNumber;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: 0,
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Title : What’s catching your interest today?
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Notifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: (notifications == null || _loading)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : !_loading && (notifications== null || !notifications!.docs.map((e) => e['target']).toList().contains(registrationNumber))
                              ? Center(
                                  child: Text('No Notifications'),
                                )
                              : ListView.builder(
                        itemCount: notifications!.docs.map((e) => e['target']).toList().contains(registrationNumber) ? notifications!.docs.length : 0,
                        itemBuilder: (context, index) {
                          DateTime d = notifications!.docs[index]['date'].toDate();
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  notifications!.docs[index]['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  notifications!.docs[index]['description'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${d.day}/${d.month}/${d.year}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ])),
        ],
      ),
    );
  }
}
