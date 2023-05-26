import 'dart:async';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:ardu_illuminate/controllers/maincontroller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Websocket ws = Websocket();

class BedroomTimerPage extends StatefulWidget {
  const BedroomTimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BedroomTimerPageState createState() => _BedroomTimerPageState();
}

DateTime now = DateTime.now();

class _BedroomTimerPageState extends State<BedroomTimerPage>
    with AutomaticKeepAliveClientMixin<BedroomTimerPage> {
  final mainController = Get.find<MainController>();
  String formatDate = DateFormat('yyyy-MM-dd').format(now);
  String formatTimee = DateFormat('HH:mm a').format(now);
  Websocket ws = Websocket();
  String action = "";
  String location = "Bedroom";
  late int ctr;
  String uid = Auth().currentUser!.uid;
  final DatabaseReference ctrRef = FirebaseDatabase.instance.ref('counter');

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   ws.channelConnect();
    // });
    super.initState();
  }

  void _test() {
    Stream<DatabaseEvent> stream = ctrRef.child('ctr').onValue;

    stream.listen((DatabaseEvent event) {
      ctr = event.snapshot.value as int;

      print("value of ctr right in Timer $ctr");
    });
  }

  void startTimer() {
    if (mainController.bedroomSecondsRemaining.value <= 0) {
      resetTimer();
    }

    if (!mainController.bedroomStarted.value) {
      // mainController.bedroomSecondsRemaining.value--;
      // if (mainController.bedroomSecondsRemaining.value <= 0) {
      //   mainController.bedroomTimeSet.value = false;

      //   stopTimer();
      //   ws.sendcmd("poweroff");
      // }
      mainController.bedroomCountDownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mainController.bedroomPaused.value) {
          mainController.bedroomSecondsRemaining.value--;
        }
        if (mainController.bedroomSecondsRemaining.value <= 0) {
          ws.sendcmd("poweroff");
          stopTimer();
        }
      });
      mainController.bedroomStarted.value = true;
      mainController.bedroomPaused.value = false;
    } else if (mainController.bedroomPaused.value) {
      setState(() {
        mainController.bedroomPaused.value = false;
      });
      mainController.bedroomCountDownTimer?.cancel();

      mainController.bedroomCountDownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        mainController.bedroomSecondsRemaining.value--;

        if (mainController.bedroomSecondsRemaining.value <= 0) {
          stopTimer();
        }
      });
    } else {
      setState(() {
        mainController.bedroomPaused.value = true;
      });
      mainController.bedroomCountDownTimer?.cancel();
    }
  }

  void stopTimer() {
    mainController.bedroomCountDownTimer?.cancel();

    mainController.bedroomStarted.value = false;
    mainController.bedroomPaused.value = false;

    mainController.bedroomSecondsRemaining.value = 0;
    action = "Timer Stopped";
    ctrRef.child("ctr").set(++ctr);
    Auth().uidPostData(ctr, action, formatDate, formatTimee, uid, location);
  }

  void resetTimer() {
    stopTimer();
    mainController.bedroomSecondsRemaining.value = 0;

    setState(() {
      mainController.bedroomTimeSet.value = false;
    });
  }

  void setTimer(BuildContext context) async {
    _test();
    final selectedTime = await showDurationPicker(
      context: context,
      initialTime: const Duration(hours: 0, minutes: 15),
    );
    if (selectedTime != null) {
      mainController.bedroomSecondsRemaining.value = selectedTime.inSeconds;

      if (selectedTime.inMinutes == 1) {
        action = "Timer Set : ${selectedTime.inMinutes} minute";
      } else {
        action = "Timer Set : ${selectedTime.inMinutes} minutes";
      }

      ctrRef.child("ctr").set(++ctr);
      Auth().uidPostData(ctr, action, formatDate, formatTimee, uid, location);
      setState(() {
        mainController.bedroomTimeSet.value = true;
      });
    }
  }

  String formatTime(int time) {
    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final mainController = Get.find<MainController>();

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Bedroom Timer',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      drawer: const DrawHeader(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.fitHeight,
            alignment: Alignment(1.5, 1.0),
          ),
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (mainController.isBedroomPowerOn.value) {
                    setTimer(context);
                  } else {
                    null;
                  }
                },
                child: Image.asset(
                  'assets/clock.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Obx(
                () => Text(
                  formatTime(mainController.bedroomSecondsRemaining.value),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: mainController.bedroomTimeSet.value &&
                                mainController.bedroomSecondsRemaining.value > 0
                            ? () {
                                if (mainController.bedroomSecondsRemaining <=
                                    0) {
                                  return;
                                }
                                startTimer();
                                action = "Timer Started";
                                ctrRef.child("ctr").set(++ctr);
                                Auth().uidPostData(ctr, action, formatDate,
                                    formatTimee, uid, location);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          backgroundColor:
                              mainController.bedroomStarted.value &&
                                      !mainController.bedroomPaused.value
                                  ? Colors.orange
                                  : (mainController.bedroomStarted.value
                                      ? Colors.blue
                                      : Colors.green),
                          shape: const CircleBorder(),
                          elevation: 2,
                          minimumSize: const Size(100, 100),
                        ),
                        child: Center(
                          child: mainController.bedroomStarted.value &&
                                  !mainController.bedroomPaused.value
                              ? const Icon(Icons.pause,
                                  size: 50, color: Colors.white)
                              : mainController.bedroomPaused.value
                                  ? const Icon(Icons.play_arrow,
                                      size: 50, color: Colors.white)
                                  : const Text(
                                      'GO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.white),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: mainController.bedroomTimeSet.value
                            ? resetTimer
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          elevation: 2,
                          minimumSize: const Size(100, 100),
                        ),
                        child: const Center(
                          child: Icon(Icons.stop_rounded,
                              size: 50, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
