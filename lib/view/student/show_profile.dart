import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/globals.dart';
import 'package:spt/model/Student.dart';
import 'package:spt/model/model.dart';
import 'package:spt/services/auth_services.dart';

import '../../screens/res/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Student student;
  late bool isLoading;

  // late Instructor instructor;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  getStudentDetails() async {
    // Get Student Details
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? user = prefs.getStringList('user');
    Student _student = Student.fromList(user!);
    setState(() {
      student = _student;
      isLoading = false;
    });
  }

  changePasswordPopUp() {
    // Change Password
    Widget alert = AlertDialog(
      title: const Text('Change Password'),
      content: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            Gap(20),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            Gap(20),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Change Password
            Navigator.pop(context);
            changePassword();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Change'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  changePassword() {
    // Change Password
    if (newPasswordController.text == confirmPasswordController.text) {
      // Change Password
      Navigator.pop(context);
      AuthService.changePassword(
          oldPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
          context: context);
      return true;
    } else {
      // Passwords do not match
      Globals.showSnackBar(
          message: 'Passwords do not match',
          context: context,
          isSuccess: false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getStudentDetails();
  }

  @override
  Widget build(BuildContext context) {
    // Student Name, Email, Registration Number and Change Password Button
    return Container(
      height: MediaQuery.of(context).size.height - 60,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/home_background.png',
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              bottom: 10,
              height: 600,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Gap(20),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            const Gap(20),
                            Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              "${student.firstName} ${student.lastName}",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              student.email,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Gap(20),
                            Text(
                              "Registration Number",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              student.registrationNumber.toString() ?? 'Not Available',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Gap(20),
                            const Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            const Gap(20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Change Password
                                  changePasswordPopUp();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.green,
                                ),
                                child: const Text('Change Password'),
                              ),
                            ),
                            const Gap(20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Change Password
                                  AuthService.signOut();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.red,
                                ),
                                child: Container(
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.logout),
                                      Gap(10),
                                      Text('Logout'),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
              )),
        ],
      ),
    );
  }
}
