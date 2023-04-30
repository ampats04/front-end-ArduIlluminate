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
  var _selectedPageIndex;
  late List<Widget> _pages;
  late final PageController _pageController;

  //final PageController _pageController = PageController();

  // final List<Widget> _widgetOptions = [
  //   const TimerPage(),
  //   const MainPage(),
  //   const PowerConsumption(),
  // ];
  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      const TimerPage(),
      const MainPage(),
      const PowerConsumption(),
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xFFcffafe),
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
          index: _selectedPageIndex,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = _selectedPageIndex;
              _pageController.jumpToPage(selectedPageIndex);
            });
          }),
    );
  }
}
