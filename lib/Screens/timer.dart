import 'dart:async';
import 'package:ardu_illuminate/Socket/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
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
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_picked.inHours.remainder(24));
    final minutes = strDigits(_picked.inMinutes.remainder(60));
    final seconds = strDigits(_picked.inSeconds.remainder(60));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    durationPicked(context);
                  },
                  child: const Icon(Icons.timer)),
              Text('$hours:$minutes:$seconds'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (countdownTimer == null || !(countdownTimer!.isActive)) {
                    startTimer();
                  }
                },
                child: const Text(
                  'Start',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (countdownTimer == null || countdownTimer!.isActive) {
                    stopTimer();
                  }
                },
                child: const Text(
                  "Stop",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  resetTimer();
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 30,
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
