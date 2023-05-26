import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
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

  Websocket ws = Websocket();
  // ws.channelconnect;
  Future.delayed(Duration.zero, () async {
    ws.channelconnect();
  });
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
          double screenWidth = MediaQuery.of(context).size.width;
          double screenheight = MediaQuery.of(context).size.width;
          return AnimatedSplashScreen(
            backgroundColor: Color(0XFF2f3334),
            splash: Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 5.0, // Adjust the height factor as needed
                child: Transform.scale(
                  scale: screenheight *
                      0.0025, // Adjust the scale factor as needed
                  child: Lottie.asset(
                    'assets/lf20_fboneztl.json',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            nextScreen: const WidgetTree(),
          );
        },
      ),
    );
  }
}
