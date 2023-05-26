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

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerPageState createState() => _TimerPageState();
}

DateTime now = DateTime.now();

class _TimerPageState extends State<TimerPage>
    with AutomaticKeepAliveClientMixin<TimerPage> {
  final mainController = Get.find<MainController>();
  String formatDate = DateFormat('yyyy-MM-dd').format(now);
  String formatTimee = DateFormat('HH:mm a').format(now);
  Websocket ws = Websocket();
  String action = "";
  String location = "Bathroom";
  late int ctr;
  String uid = Auth().currentUser!.uid;
  final DatabaseReference ctrRef = FirebaseDatabase.instance.ref('counter');
  int offz = 1;
  int onz = 2;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });
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
    if (mainController.bathroomSecondsRemaining.value <= 0) {
      resetTimer();
      mainController.isBathroomPowerOn.value = false;
      mainController.bathroomTimeSet.value = false;
    }

    if (!mainController.bathroomStarted.value) {
      // mainController.bathroomSecondsRemaining.value--;
      // if (mainController.bathroomSecondsRemaining.value <= 0) {
      //   mainController.bathroomTimeSet.value = false;
      //   mainController.isBathroomPowerOn.value = false;

      //   stopTimer();
      //   ws.sendcmd("poweroff");
      // }
      mainController.bathroomCountDownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mainController.bathroomPaused.value) {
          mainController.bathroomSecondsRemaining.value--;
        }
        if (mainController.bathroomSecondsRemaining.value <= 0) {
          var off = offz.toString();
          stopTimer();
          ws.sendcmd("power$off");
          mainController.bathroomTimeSet.value = false;
          mainController.isBathroomPowerOn.value = false;
        }
      });
      mainController.bathroomStarted.value = true;
      mainController.bathroomPaused.value = false;
    } else if (mainController.bathroomPaused.value) {
      setState(() {
        mainController.bathroomPaused.value = false;
      });
      mainController.bathroomCountDownTimer?.cancel();

      mainController.bathroomCountDownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        mainController.bathroomSecondsRemaining.value--;

        if (mainController.bathroomSecondsRemaining.value <= 0) {
          stopTimer();
        }
      });
    } else {
      setState(() {
        mainController.bathroomPaused.value = true;
      });
      mainController.bathroomCountDownTimer?.cancel();
    }
  }

  void stopTimer() {
    mainController.bathroomCountDownTimer?.cancel();

    mainController.bathroomStarted.value = false;
    mainController.bathroomPaused.value = false;

    mainController.bathroomSecondsRemaining.value = 0;
    action = "Timer Stopped";
    ctrRef.child("ctr").set(++ctr);
    Auth().uidPostData(ctr, action, formatDate, formatTimee, uid, location);
  }

  void resetTimer() {
    stopTimer();
    mainController.bathroomSecondsRemaining.value = 0;

    setState(() {
      mainController.bathroomTimeSet.value = false;
    });
  }

  void setTimer(BuildContext context) async {
    _test();
    final selectedTime = await showDurationPicker(
      context: context,
      initialTime: const Duration(hours: 0, minutes: 15),
    );
    if (selectedTime != null) {
      mainController.bathroomSecondsRemaining.value = selectedTime.inSeconds;

      if (selectedTime.inMinutes == 1) {
        action = "Timer Set : ${selectedTime.inMinutes} minute";
      } else {
        action = "Timer Set : ${selectedTime.inMinutes} minutes";
      }

      ctrRef.child("ctr").set(++ctr);
      Auth().uidPostData(ctr, action, formatDate, formatTimee, uid, location);
      setState(() {
        mainController.bathroomTimeSet.value = true;
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
            'Bathroom Timer',
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
                  if (mainController.isBathroomPowerOn.value) {
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
                  formatTime(mainController.bathroomSecondsRemaining.value),
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
                        onPressed: mainController.bathroomTimeSet.value &&
                                mainController.bathroomSecondsRemaining.value >
                                    0
                            ? () {
                                if (mainController.bathroomSecondsRemaining <=
                                    0) {
                                  mainController.isBathroomPowerOn.value =
                                      false;
                                  mainController.bathroomTimeSet.value = false;
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
                              mainController.bathroomStarted.value &&
                                      !mainController.bathroomPaused.value
                                  ? Colors.orange
                                  : (mainController.bathroomStarted.value
                                      ? Colors.blue
                                      : Colors.green),
                          shape: const CircleBorder(),
                          elevation: 2,
                          minimumSize: const Size(100, 100),
                        ),
                        child: Center(
                          child: mainController.bathroomStarted.value &&
                                  !mainController.bathroomPaused.value
                              ? const Icon(Icons.pause,
                                  size: 50, color: Colors.white)
                              : mainController.bathroomPaused.value
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
                        onPressed: mainController.bathroomTimeSet.value
                            ? resetTimer
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          backgroundColor: Color(0XFFD30000),
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
