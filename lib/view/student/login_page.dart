import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spt/layout/main_layout.dart';
import 'package:spt/model/model.dart';
import 'package:spt/services/auth_services.dart';
import 'package:spt/services/authenticationService.dart';
import 'package:spt/util/toast_util.dart';
import 'package:toastification/toastification.dart';

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
    if (kDebugMode) {
      // emailController.text = "nilakshahirushan45@gmail.com";
      // passwordController.text = "pwd_nilakshahirushan45";
      // emailController.text = "athmajabhagya123@gmail.com";
      // passwordController.text = "pwd_athmajabhagya123";
      // emailController.text = "dilushalakmal69@gmail.com";
      // passwordController.text = "pass_dilushalakmal69";
      // emailController.text = "asithumi2004@gmail.com";
      // passwordController.text = "pwd_101098";
      emailController.text = "chamudidewanga@gmail.com";
      passwordController.text = "pwd_101725";

      // emailController.text = "ehasikaherath@gmail.com";
      // passwordController.text = "pwd_100748";
    }
  }

  void _checkLogin() async {
    User? user = await AuthService.getCurrentUser();
    if (user != null) {
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
    if (emailController.text == "" && passwordController.text == "") {
      error = 'Please enter email and password';
    } else {
      String email = emailController.text;
      // String email = "test@mail.com";
      String password = passwordController.text;
      // String password = "123456";
      User? user =
          await AuthService.signInWithEmailAndPassword(email, password);
      if(user == null){
        error = 'Could not sign in with those credentials';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          loading = false;
        });
        return;

      }
      bool isUserInstructor = false;
      bool isUserStudent = false;
      bool isUserAdmin = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (user != null) {
        DocumentSnapshot instructorDoc = await FirebaseFirestore.instance
            .collection('Instructors')
            .doc(user.uid)
            .get();
        if (instructorDoc.exists) {
          isUserInstructor = true;
          Instructor? instructor = instructorDoc.exists
              ? Instructor(
                  instructorId: instructorDoc.get('uid'),
                  email: instructorDoc.get('email'),
                  docId: instructorDoc.get('uid'),
                )
              : null;
          // save on shared preference
          prefs.setString('uid', instructor!.instructorId);
          prefs.setStringList('user', instructor.toList());
          prefs.setString("role", "instructor");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstructorEntryScreen()),
          );
        } else {
          DocumentSnapshot studentDoc = await FirebaseFirestore.instance
              .collection('students')
              .doc(user.uid)
              .get();
          if (studentDoc.exists) {
            isUserStudent = true;
            Student? student = await FirebaseFirestore.instance
                .collection('students')
                .doc(user.uid)
                .get()
                .then((value) => Student(
                      firstName:
                          value.get('name').toString().split(" ").length > 0
                              ? value.get('name').toString().split(" ")[0]
                              : value.get('name'),
                      lastName:
                          value.get('name').toString().split(" ").length > 1
                              ? value.get('name').toString().split(" ")[1]
                              : "",
                      email: value.get('email'),
                      uid: value.get('uid'),
                      registrationNumber:
                          value.get('registrationNumber'),
                    ));
            // save on shared preference

            prefs.setString('uid', student!.uid);
            prefs.setStringList('user', student.toList());
            prefs.setString("role", "student");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainLayout()),
            );
          } else {
            DocumentSnapshot adminDoc = await FirebaseFirestore.instance
                .collection('admin')
                .doc(user.uid)
                .get();
            if (adminDoc.exists) {
              isUserAdmin = true;
              Admin? admin = adminDoc.exists
                  ? Admin(
                      email: adminDoc.get('email'),
                      password: adminDoc.get('password'),
                      uid: adminDoc.get('uid'))
                  : null;
              // save on shared preference
              prefs.setString('uid', admin!.uid);
              prefs.setStringList('user', admin.toList());
              prefs.setString("role", "admin");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBarScreen(
                          isEntryScreen: false,
                          isInstructorScreen: false,
                          isAddFolderScreen: false,
                        )),
              );
            }
          }
        }

        setState(() {
          loading = false;
        });
      } else {
        error = 'Could not sign in with those credentials';
      }
    }
    if (error != null) {
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
    try {
      AuthCredential? authCredential = await AuthService.signInWithGoogle();
      String? accessToken = "";
      if(authCredential==null){
        ToastUtil.showErrorToast(context, "Error", "Something Went Wrong !");
        setState(() {
          loading = false;
        });
        return;
      }
      accessToken = authCredential.accessToken;
      bool isLoggedIn = await AuthenticationService.login(accessToken!);
      if(isLoggedIn){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('role')) {
          String role = prefs.getString('role')!;
          if (role == 'role_student') {
            ToastUtil.showSuccessToast(context, "Success", "Logged in Successfully !");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainLayout()));
            return;
          }
          else if (role == 'role_instructor') {
            ToastUtil.showSuccessToast(context, "Success", "Logged in Successfully !");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InstructorEntryScreen()));
            return;
          }
          else if (role == 'role_admin') {
            ToastUtil.showSuccessToast(context, "Success", "Logged in Successfully !");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBarScreen(
              isEntryScreen: false,
              isInstructorScreen: false,
              isAddFolderScreen: false,
            ),));
            return;
          }
          return MainLayout();
        }
      }else{
        ToastUtil.showErrorToast(context, "Error", "Something Went Wrong !");
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ));
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not sign in with those credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  'assets/images/login_background.gif',
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
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
                          if(kDebugMode && !kIsWeb)
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
                          if(kDebugMode && !kIsWeb)
                          const SizedBox(height: 20),
                          if(kDebugMode && !kIsWeb)
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
                          if(kDebugMode && !kIsWeb)
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'Dopamine is an online learning platform for advanced level students. '
                                  'It is to improve and enhance your studies and evaluate your progress.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              ),
                            ),
                          ),
                          // sign in with google
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
                                        fit: BoxFit.cover),
                                    const SizedBox(width: 10),
                                    const Text('Sign in with Google',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black)),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          if (!kIsWeb) const SizedBox(height: 20),
                          if(kDebugMode)
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
                          const SizedBox(height: 20),
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
                    ),
                  )),
              if (loading)
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
