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
  bool isStarted = false;
  bool isPaused = false;
  Timer? countdownTimer;
  int secondsRemaining = 0;
  bool isTimeSet = false; // Para sa Start and reset button nga di ma fishlit

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });
    super.initState();
  }

  void startTimer() {
    if (secondsRemaining <= 0) {
      resetTimer();
    }

    if (!isStarted) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          secondsRemaining--;
        });
        if (secondsRemaining <= 0) {
          stopTimer();
          ws.sendcmd("poweroff");
        }
      });
      setState(() {
        isStarted = true;
        isPaused = false;
      });
    } else if (isPaused) {
      setState(() {
        isPaused = false;
      });
      countdownTimer?.cancel();
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          secondsRemaining--;
        });
        if (secondsRemaining <= 0) {
          stopTimer();
        }
      });
    } else {
      setState(() {
        isPaused = true;
      });
      countdownTimer?.cancel();
    }
  }

  void stopTimer() {
    countdownTimer?.cancel();
    setState(() {
      isStarted = false;
      isPaused = false;
      secondsRemaining = 0;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      secondsRemaining = 0;
      isTimeSet = false;
    });
  }

  void setTimer(BuildContext context) async {
    final selectedTime = await showDurationPicker(
      context: context,
      initialTime: const Duration(hours: 0, minutes: 15),
    );
    if (selectedTime != null) {
      setState(() {
        secondsRemaining = selectedTime.inSeconds;
        isTimeSet = true;
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
            'Timer Control',
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
                  if (mainController.isPowerOn.value) {
                    setTimer(context);
                  }
                },
                child: Image.asset(
                  'assets/clock.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                formatTime(secondsRemaining),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ElevatedButton.icon(
                onPressed: isTimeSet && secondsRemaining > 0
                    ? () {
                        if (secondsRemaining <= 0) {
                          return;
                        }
                        startTimer();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStarted && !isPaused
                      ? Colors.orange
                      : (isStarted ? Colors.blue : Colors.green),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.028,
                      horizontal: MediaQuery.of(context).size.width * 0.035),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                icon: isStarted && !isPaused
                    ? Icon(Icons.pause,
                        size: MediaQuery.of(context).size.width * 0.1)
                    : isPaused
                        ? Icon(Icons.play_arrow,
                            size: MediaQuery.of(context).size.width * 0.1)
                        : Icon(Icons.play_arrow,
                            size: MediaQuery.of(context).size.width * 0.1),
                label: Text(
                  isStarted && !isPaused
                      ? 'Pause'
                      : (isPaused ? 'Resume' : 'Start'),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ElevatedButton.icon(
                onPressed: isTimeSet ? resetTimer : null,
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
            ],
          ),
        ),
      ),
    );
  }
}
