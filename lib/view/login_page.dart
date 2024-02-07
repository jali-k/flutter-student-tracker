import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spt/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final StreamController<bool> _loadingStream = StreamController<bool>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    _loadingStream.close();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    // _checkLogin();
    _loadingStream.add(true);
    Future.delayed(Duration(seconds: 2), () {
      _loadingStream.add(false);
    });
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
    _loadingStream.add(true);
    String? error;
    if(emailController.text == "" && passwordController.text=="") {
      error = 'Please enter email and password';
    }else{
      String email = emailController.text;
      // String email = "test@mail.com";
      String password = passwordController.text;
      // String password = "123456";
      User? user = await AuthService.signInWithEmailAndPassword(email, password);
      if(user != null) {
        Navigator.pushReplacementNamed(context, '/home');
        _loadingStream.add(false);
      }else{
        error = 'Could not sign in with those credentials';
      }

    }
    if(error != null) {
      _loadingStream.add(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
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
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF00C897),
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
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
                      topRight: Radius.circular(50),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          child: const Text('LOGIN', style: TextStyle(fontSize: 18,color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          const SizedBox(width: 10),
                          Text('|'),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ),
              StreamBuilder<bool>(
                stream: _loadingStream.stream,
                builder: (context, snapshot) {
                  if(snapshot.hasData && snapshot.data == true) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
