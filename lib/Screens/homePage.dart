// ignore_for_file: library_private_types_in_public_api
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Screens/powerConsumption.dart';
import 'package:ardu_illuminate/Screens/timer.dart';
import './mainPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedindex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = [
    const TimerPage(),
    const MainPage(),
    const PowerConsumption(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFcffafe),
        // Color(0xFF219ebc),
        color: const Color(0xFF219ebc),
        height: 57.0,
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(
            Icons.timer,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.lightbulb,
            color: Colors.white,
          ),
        ],
        index: _selectedindex,
        onTap: _onItemTapped,
      ),
    );
  }
}
