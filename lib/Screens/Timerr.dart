import 'dart:async';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/controllers/maincontroller.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

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
              Obx(
                () => ElevatedButton.icon(
                  onPressed: mainController.bathroomTimeSet.value &&
                          mainController.bathroomSecondsRemaining.value > 0
                      ? () {
                          if (mainController.bathroomSecondsRemaining <= 0) {
                            return;
                          }
                          startTimer();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainController.bathroomStarted.value &&
                            !mainController.bathroomPaused.value
                        ? Colors.orange
                        : (mainController.bathroomStarted.value
                            ? Colors.blue
                            : Colors.green),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.028,
                        horizontal: MediaQuery.of(context).size.width * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  icon: mainController.bathroomStarted.value &&
                          !mainController.bathroomPaused.value
                      ? Icon(Icons.pause,
                          size: MediaQuery.of(context).size.width * 0.1)
                      : mainController.bathroomPaused.value
                          ? Icon(Icons.play_arrow,
                              size: MediaQuery.of(context).size.width * 0.1)
                          : Icon(Icons.play_arrow,
                              size: MediaQuery.of(context).size.width * 0.1),
                  label: Text(
                    // mainController.bathroomStarted.value &&
                    //         !mainController.bathroomPaused.value
                    //     ? 'Pause'
                    //     : (mainController.bathroomPaused.value
                    //         ? 'Resume'
                    //         : 'Start'),
                    !mainController.bathroomStarted.value
                        ? 'Start'
                        : mainController.bathroomPaused.value
                            ? 'Resume'
                            : 'Pause',

                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Obx(
                () => ElevatedButton.icon(
                  onPressed:
                      mainController.bathroomTimeSet.value ? resetTimer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.028,
                        horizontal: MediaQuery.of(context).size.width * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.refresh, size: 32),
                  label: Text(
                    'Reset',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
