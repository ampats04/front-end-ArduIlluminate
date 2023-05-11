import 'dart:async';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';

Websocket ws = Websocket();

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with AutomaticKeepAliveClientMixin<TimerPage> {
  @override
  bool get wantKeepAlive => true;
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.06),
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
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setTimer(context);
                },
                child: Image.asset(
                  'assets/clock.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                formatTime(secondsRemaining),
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    icon: SizedBox(
                      height: 50,
                      width: 50,
                      child: isStarted && !isPaused
                          ? const Icon(Icons.pause, size: 40)
                          : isPaused
                              ? const Icon(Icons.play_arrow, size: 40)
                              : const Icon(Icons.play_arrow, size: 40),
                    ),
                    label: const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 25),
                  ElevatedButton.icon(
                    onPressed: isTimeSet ? resetTimer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    icon: const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.refresh, size: 40),
                    ),
                    label: const SizedBox.shrink(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
