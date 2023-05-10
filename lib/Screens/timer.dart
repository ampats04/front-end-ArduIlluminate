import 'dart:async';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
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
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBar(
            backgroundColor: const Color(0xFFD9D9D9),
            title: Text(
              'Timer Control',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.009),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        '$hours:$minutes:$seconds',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.01),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: GestureDetector(
                          onTap: () {
                            durationPicked(context);
                          },
                          child: Image.asset('assets/clock.png'),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.08,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03),
                                backgroundColor: const Color(0xFF164e63),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (countdownTimer == null ||
                              countdownTimer!.isActive) {
                            stopTimer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.08,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.03),
                            backgroundColor: const Color(0xFF164e63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: Text(
                          " Stop ",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          resetTimer();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.08,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.03),
                            backgroundColor: const Color(0xFF164e63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
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
