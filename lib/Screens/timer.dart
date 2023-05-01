import 'dart:async';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:ardu_illuminate/Socket/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

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
  Duration _picked = const Duration(hours: 0, minutes: 0);
  Timer? countdownTimer;
  bool isStarted = false;
  Websocket ws = Websocket();
  bool? ledstatus;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });
    super.initState();
  }

  void startTimer() {
    if (!isStarted) {
      countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    }

    setState(() {
      isStarted = true;
    });
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());

    setState(() {
      isStarted = false;
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() => _picked = const Duration(hours: 0, minutes: 0));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = _picked.inSeconds - reduceSecondsBy;

      if (seconds < 0) {
        countdownTimer!.cancel();
        ws.sendcmd("poweroff");
        ledstatus = false;
        // print(ledstatus);
      } else {
        _picked = Duration(seconds: seconds);
        //(_picked);
      }
    });
  }

  void durationPicked(BuildContext context) async {
    _picked = (await showDurationPicker(
      context: context,
      initialTime: const Duration(minutes: 15),
    ))!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_picked.inHours.remainder(24));
    final minutes = strDigits(_picked.inMinutes.remainder(60));
    final seconds = strDigits(_picked.inSeconds.remainder(60));

    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9D9D9),
        title: const Text(
          'Timer Control',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const DrawHeader(),
      body: Container(
        width: 1500,
        height: 1600,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            //fit: BoxFit.contain,
            fit: BoxFit.fitHeight,
            alignment: Alignment(1.5, 1.0),
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Text(
                        '$hours:$minutes:$seconds',
                        style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: GestureDetector(
                          onTap: () {
                            durationPicked(context);
                          },
                          child: Image.asset('assets/clock.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (countdownTimer == null ||
                                  !(countdownTimer!.isActive)) {
                                startTimer();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 15),
                                backgroundColor: Color(0xFF164e63),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (countdownTimer == null ||
                              countdownTimer!.isActive) {
                            stopTimer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 31, vertical: 15),
                            primary: Color(0xFF164e63),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          " Stop ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                      ElevatedButton(
                        onPressed: () {
                          resetTimer();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            backgroundColor: const Color(0xFF164e63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
