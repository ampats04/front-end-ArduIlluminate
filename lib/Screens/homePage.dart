// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Screens/powerConsumption.dart';
import 'package:ardu_illuminate/Screens/settingsPage.dart';
import 'package:ardu_illuminate/Screens/timer.dart';
import './mainPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedindex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
    const MainPage(),
    const TimerPage(),
    const PowerMeterPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: "Home",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer, color: Colors.white),
            label: "Timer",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, color: Colors.white),
            label: "Power",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: "User",
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedindex,
        selectedItemColor: const Color.fromARGB(255, 0, 255, 204),
        onTap: _onItemTapped,
      ),
    );
  }
}
