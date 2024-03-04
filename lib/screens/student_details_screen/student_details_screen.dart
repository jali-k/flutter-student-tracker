
import 'package:flutter/material.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Student Name: John Doe'),
            Text('Student Age: 20'),
            Text('Student Class: 10th'),
          ],
        ),
      ),
    );
  }
}
