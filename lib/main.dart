import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Screens/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return AnimatedSplashScreen(
            splash: Center(
              child: Transform.scale(
                scale: MediaQuery.of(context).size.width * 0.007,
                child: Image.asset(
                  'assets/ardu-ulliminate.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            duration: 1000,
            splashTransition: SplashTransition.sizeTransition,
            nextScreen: const WidgetTree(),
          );
        },
      ),
    );
  }
}
