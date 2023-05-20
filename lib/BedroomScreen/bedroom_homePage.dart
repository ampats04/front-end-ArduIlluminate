// ignore_for_file: library_private_types_in_public_api
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
//import 'package:ardu_illuminate/Screens/powerConsumption.dart';
import 'package:ardu_illuminate/main.dart';
//import 'Timerr.dart';
import 'package:ardu_illuminate/BedroomScreen/bedroom_mainPage.dart';
import 'bedroom_powerConsumption.dart';
import 'bedroom_timerPage.dart';

List<Color> _iconColors = [
  Colors.white,
  Colors.white,
  Colors.white,
];

class BedroomHomePage extends StatefulWidget {
  const BedroomHomePage({Key? key}) : super(key: key);
  @override
  _BedroomHomePageState createState() => _BedroomHomePageState();
}

class _BedroomHomePageState extends State<BedroomHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var _selectedPageIndex;
  late List<Widget> _pages;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      const BedroomTimerPage(),
      const BedroomMainPage(),
      const BedroomPowerConsumption(),
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
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
          backgroundColor: const Color(0xFF24AFC1),
          color: const Color(0xFF1795A8),
          height: MediaQuery.of(context).size.height * 0.09,
          animationDuration: const Duration(milliseconds: 400),
          items: [
            Icon(
              Icons.timer,
              color: _iconColors[0],
            ),
            Icon(
              Icons.home,
              color: _iconColors[1],
            ),
            Icon(
              Icons.lightbulb,
              color: _iconColors[2],
            ),
          ],
          index: _selectedPageIndex,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;

              for (int i = 0; i < _iconColors.length; i++) {
                if (i == selectedPageIndex) {
                  _iconColors[i] = const Color(0xFFFCCF47);
                } else {
                  _iconColors[i] = const Color.fromARGB(255, 255, 255, 255);
                }
              }

              _pageController.jumpToPage(selectedPageIndex);
            });
          },
        ));
  }
}
