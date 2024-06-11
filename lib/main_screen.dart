import 'package:flutter/material.dart';
import 'package:story_app/home/ui/home_screen.dart';
import 'package:story_app/profile/ui/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int currIndex;
  const MainScreen({super.key, required this.currIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currIndex = widget.currIndex;
  List pages = [const HomeScreen(), const ProfileScreen()];

  void onTap(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[_currIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => onTap(index),
          currentIndex: _currIndex,
          items: [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: "Home"),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: "Profile")
          ]),
    );
  }
}
