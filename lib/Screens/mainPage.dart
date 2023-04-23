// This is the main light control screen
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Socket/webSocket.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPage> {
  bool light1 = false;
  Color activeColor = Colors.green;
  double _currentSliderValue = 20;
  bool ledstatus = false;

  late Websocket ws = Websocket();

  void initstate() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });

    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void _onPressed(bool value) {
    if (ledstatus) {
      ws.sendcmd("poweroff");
      ledstatus = false;
    } else {
      ws.sendcmd("poweron");
      ledstatus = true;
    }
    setState(() {
      light1 = value;
      activeColor = value ? Colors.green : Colors.red;
    });
  }

  void _onSliderChanged(double value) {
    var brightness = value.round().toString();
    ws.sendcmd("brightness$brightness");
    setState(() {
      if (ledstatus == false) {
        brightness = value.round().toString();
      }
      _currentSliderValue = value;
      print(brightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Main Light Control',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 150),
              const Center(
                child: Text(
                  'Power',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              Transform.scale(
                scale: 1.5,
                child: Switch(
                  thumbIcon: thumbIcon,
                  value: light1,
                  inactiveThumbColor: Colors.red,
                  activeColor: activeColor,
                  onChanged: _onPressed,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  'Light Intensity',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.dark_mode_outlined),
                  Expanded(
                    child: Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 100,
                      label: _currentSliderValue.round().toString(),
                      onChanged: _onSliderChanged,
                    ),
                  ),
                  const Icon(Icons.sunny),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
