import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                          onPressed: () {},
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
