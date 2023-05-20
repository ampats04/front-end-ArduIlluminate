import 'dart:async';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/controllers/maincontroller.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:get/get.dart';

Websocket ws = Websocket();

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with AutomaticKeepAliveClientMixin<TimerPage> {
  final mainController = Get.find<MainController>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });
    super.initState();
  }

  void startTimer() {
    if (mainController.bathroomSecondsRemaining.value <= 0) {
      resetTimer();
    }

    if (!mainController.bathroomStarted.value) {
      mainController.bathroomSecondsRemaining.value--;
      if (mainController.bathroomSecondsRemaining.value <= 0) {
        stopTimer();
        ws.sendcmd("poweroff");
      }
      mainController.bathroomCountDownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mainController.bathroomPaused.value) {
          mainController.bathroomSecondsRemaining.value--;
        }
        if (mainController.bathroomSecondsRemaining.value <= 0) {
          stopTimer();
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
  }

  void resetTimer() {
    stopTimer();
    mainController.bathroomSecondsRemaining.value = 0;

    setState(() {
      mainController.bathroomTimeSet.value = false;
    });
  }

  void setTimer(BuildContext context) async {
    final selectedTime = await showDurationPicker(
      context: context,
      initialTime: const Duration(hours: 0, minutes: 15),
    );
    if (selectedTime != null) {
      mainController.bathroomSecondsRemaining.value = selectedTime.inSeconds;
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
                                  return;
                                }
                                startTimer();
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
                                  : const Icon(Icons.play_arrow,
                                      size: 50, color: Colors.white),
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
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          elevation: 2,
                          minimumSize: const Size(100, 100),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.pause, size: 50, color: Colors.white),
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
