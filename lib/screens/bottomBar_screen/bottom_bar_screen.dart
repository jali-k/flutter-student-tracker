
import 'package:flutter/material.dart';
import 'package:spt/services/auth_services.dart';
import 'package:spt/view/student/login_page.dart';

import '../add_folder_screen/folder_list_screen.dart';
import '../manage_student_screen/manage_student.dart';
import '../entry_screen/entry_screen.dart';
import '../home_screen/home_screen.dart';
import '../instructor_screen/instructor_screen.dart';
import '../res/app_colors.dart';

class BottomBarScreen extends StatefulWidget {
  final bool isEntryScreen;
  final bool isInstructorScreen;
  final bool isAddFolderScreen;
  const BottomBarScreen(
      {super.key,
        required this.isEntryScreen,
        required this.isInstructorScreen,
        required this.isAddFolderScreen,
      });

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late int _selectedBottomNavBarItemIndex;
  final List<Widget> bottomNavBarItems = <Widget>[];

  @override
  void initState() {
    // ignore: use_build_context_synchronously

    widget.isEntryScreen
        ? _selectedBottomNavBarItemIndex = 1
        : widget.isInstructorScreen
        ? _selectedBottomNavBarItemIndex = 2
        : widget.isAddFolderScreen
        ? _selectedBottomNavBarItemIndex = 3
        : _selectedBottomNavBarItemIndex = 0;

    //
    // _selectedBottomNavBarItemIndex = 4;
    bottomNavBarItems.addAll([
      const HomeScreen(),
      const EntryScreen(),
      const InstructorScreen(),
      const FolderListScreen(),
      MangeStudent()
    ]);

    super.initState();
  }

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedBottomNavBarItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 35),
        child: Card(
          elevation: 15,
          shadowColor: Colors.black.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Set border radius
          ),
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(color: AppColors.purple, width: 1),
            // ),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 1,
              backgroundColor: AppColors.ligthWhite,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
              currentIndex: _selectedBottomNavBarItemIndex,
              selectedItemColor: AppColors.green,
              onTap: _onBottomNavBarItemTapped,
              unselectedItemColor: AppColors.black,
            ),
          ),
        ),
      ),
      body: Container(
          color: AppColors.ligthWhite,
          child: bottomNavBarItems[_selectedBottomNavBarItemIndex]),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthService.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: const Icon(Icons.logout),
        backgroundColor: AppColors.green,
      )
    );
  }
}
