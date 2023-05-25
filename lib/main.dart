import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ardu_illuminate/controllers/maincontroller.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Screens/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'Ardu-Illuminate',
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDFfBO1Ta6Myec-H5bLsRu3109mBJg1RGI',
          appId: '1:791737884654:android:6bb118fd67d18c4fa4b8ff',
          messagingSenderId: '791737884654',
          projectId: 'ardu-illuminate',
          databaseURL:
              'https://ardu-illuminate-default-rtdb.asia-southeast1.firebasedatabase.app'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return AnimatedSplashScreen(
            splash: Lottie.asset('assets/26390-light-bulb.json'),
            // Center(
            //   child: Transform.scale(
            //     scale: MediaQuery.of(context).size.width * 0.007,
            //     child: Image.asset(
            //       'assets/ardu-ulliminate.png',
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),

            duration: 1000,
            splashTransition: SplashTransition.sizeTransition,
            nextScreen: const WidgetTree(),
          );
        },
      ),
    );
  }
}
