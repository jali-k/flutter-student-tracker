import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/model.dart';
import 'package:spt/services/auth_services.dart';

import '../../model/Admin.dart';
import '../../model/Student.dart';
import '../../screens/bottomBar_screen/bottom_bar_screen.dart';
import '../../screens/instructor_screen/instructor_entry_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if(kDebugMode){
      // emailController.text = "dilushalakmal69@gmail.com";
      // passwordController.text = "pass_dilushalakmal69";
      emailController.text = "upekshalakshani100@gmail.com";
      passwordController.text = "pwd_100179";
    }
  }

  void _checkLogin() async {
    User? user = await AuthService.getCurrentUser();
    if(user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  _login() async {
    // validate email and passwords
    // call the auth service
    setState(() {
      loading = true;
    });
    String? error;
    if(emailController.text == "" && passwordController.text=="") {
      error = 'Please enter email and password';
    }else{
      String email = emailController.text;
      // String email = "test@mail.com";
      String password = passwordController.text;
      // String password = "123456";
      User? user = await AuthService.signInWithEmailAndPassword(email, password);
      bool isUserInstructor = false;
      bool isUserStudent = false;
      bool isUserAdmin = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if(user != null) {
        DocumentSnapshot instructorDoc = await FirebaseFirestore.instance.collection('instructors').doc(user.uid).get();
        if(instructorDoc.exists) {
          isUserInstructor = true;
          Instructor? instructor = instructorDoc.exists ? Instructor(
              instructorId: instructorDoc.get('uid'),
              email: instructorDoc.get('email'),
              docId: instructorDoc.get('uid'),

          ) : null;
          // save on shared preference
          prefs.setString('uid', instructor!.instructorId);
          prefs.setStringList('user', instructor.toList());
          prefs.setString("role", "instructor");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstructorEntryScreen()),
          );
        }else{
          DocumentSnapshot studentDoc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
          if(studentDoc.exists) {
            isUserStudent = true;
            Student? student = await FirebaseFirestore.instance.collection('students').doc(user!.uid).get().then((value) => Student(
                firstName: value.get('name').toString().split(" ").length > 0 ? value.get('name').toString().split(" ")[0] : value.get('name'),
                lastName: value.get('name').toString().split(" ").length > 1 ? value.get('name').toString().split(" ")[1] : "",
                email: value.get('email'),
                uid: value.get('uid'),
                registrationNumber: value.get('registrationNumber').toString() ?? "N/A",
            ));
            // save on shared preference

            prefs.setString('uid', student!.uid);
            prefs.setStringList('user', student.toList());
            prefs.setString("role", "student");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainLayout()),
            );
          }else{
            DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc(user.uid).get();
            if(adminDoc.exists) {
              isUserAdmin = true;
              Admin? admin = adminDoc.exists ? Admin(
                  email: adminDoc.get('email'),
                  password: adminDoc.get('password'),
                  uid: adminDoc.get('uid')
              ) : null;
              // save on shared preference
              prefs.setString('uid', admin!.uid);
              prefs.setStringList('user', admin.toList());
              prefs.setString("role", "admin");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    BottomBarScreen(
                          isEntryScreen: false,
                          isInstructorScreen: false,
                    isAddFolderScreen: false,)
                ),
              );
            }
          }
        }

        setState(() {
          loading = false;
        });
      }else{
        error = 'Could not sign in with those credentials';
      }

    }
    if(error != null) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  _signInWithGoogle() async {
    setState(() {
      loading = true;
    });
    UserCredential? userCredential = await AuthService.signInWithGoogle();
    User? user = userCredential.user;
    print(user!.uid);
    String? error;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserInstructor = false;
    bool isUserStudent = false;
    bool isUserAdmin = false;
    DocumentSnapshot instructorDoc = await FirebaseFirestore.instance.collection('instructors').doc(user.uid).get();
    if(instructorDoc.exists) {
      isUserInstructor = true;
      Instructor? instructor = instructorDoc.exists ? Instructor(
        instructorId: instructorDoc.get('uid'),
        email: instructorDoc.get('email'),
        docId: instructorDoc.get('uid'),
      ) : null;
      // save on shared preference
      prefs.setString('uid', instructor!.instructorId);
      prefs.setStringList('user', instructor.toList());
      prefs.setString("role", "instructor");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InstructorEntryScreen()),
      );
    }else{
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
      if(studentDoc.exists) {
        isUserStudent = true;
        Student? student = await FirebaseFirestore.instance.collection('students').doc(user!.uid).get().then((value) => Student(
          firstName: value.get('name').toString().split(" ").length > 0 ? value.get('name').toString().split(" ")[0] : value.get('name'),
          lastName: value.get('name').toString().split(" ").length > 1 ? value.get('name').toString().split(" ")[1] : "",
          email: value.get('email'),
          uid: value.get('uid'),
          registrationNumber: value.get('registrationNumber').toString() ?? "N/A",
        ));
        // save on shared preference

        prefs.setString('uid', student!.uid);
        prefs.setStringList('user', student.toList());
        prefs.setString("role", "student");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      }else{
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc(user.uid).get();
        if(adminDoc.exists) {
          isUserAdmin = true;
          Admin? admin = adminDoc.exists ? Admin(
              email: adminDoc.get('email'),
              password: adminDoc.get('password'),
              uid: adminDoc.get('uid')
          ) : null;
          // save on shared preference
          prefs.setString('uid', admin!.uid);
          prefs.setStringList('user', admin.toList());
          prefs.setString("role", "admin");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                BottomBarScreen(
                    isEntryScreen: false,
                    isInstructorScreen: false,
                isAddFolderScreen: false,)
            ),
          );
        }
        else{
          //means user is not in any of the roles so make as unknown user and redirect to MainLayout
          prefs.setString("role", "unknown");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
          );

        }
      }
    }

    setState(() {
      loading = false;
    });
        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF00C897),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/login_background.png',
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email),
                            prefixIconColor: Color(0xFF00C897).withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor: Color(0xFF00C897).withOpacity(0.4)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // sign in with google
                      if(!kIsWeb)
                        SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _signInWithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  'http://pngimg.com/uploads/google/google_PNG19635.png',
                                  fit:BoxFit.cover
                              ),
                              const SizedBox(width: 10),
                              const Text('Sign in with Google', style: TextStyle(fontSize: 18,color: Colors.black)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      if(!kIsWeb)
                        const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          child: const Text('LOGIN', style: TextStyle(fontSize: 18,color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text('Don\'t have an account?'),
                      //     const SizedBox(width: 10),
                      //     Text('|'),
                      //     TextButton(
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(builder: (context) => const SignUpPage()
                      //         ));
                      //       },
                      //       child: const Text('Create'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                )
              ),
              if(loading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),

    );
  }
}
