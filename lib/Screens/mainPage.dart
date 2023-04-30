import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Socket/webSocket.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  bool get wantKeepAlive => true;
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Color(0xFFD9D9D9),
      appBar: AppBar(
        title: const Text(
          'Main Light Control',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFD9D9D9),
      ),
      drawer: const DrawHeader(),
      body: Container(
        width: 1500,
        height: 2000,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          //fit: BoxFit.contain,
          fit: BoxFit.fitHeight,
          alignment: Alignment(1.5, 1.0),
        )),
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Power',
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 30),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Intensity',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 23,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(Icons.dark_mode_outlined),
                  SizedBox(
                    width: 170,
                    child: Theme(
                      data: ThemeData(
                        sliderTheme: const SliderThemeData(
                          trackHeight:
                              1.0, // Set the thickness of the slider track
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius:
                                8.0, // Set the size of the slider thumb
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius:
                                16.0, // Set the size of the overlay on the thumb
                          ),
                          activeTrackColor: Colors
                              .black, // Set the color of the active part of the slider
                          inactiveTrackColor: Colors
                              .grey, // Set the color of the inactive part of the slider
                        ),
                      ),
                      child: Slider(
                        value: _currentSliderValue,
                        max: 100,
                        divisions: 100,
                        label: _currentSliderValue.round().toString(),
                        onChanged: _onSliderChanged,
                      ),
                    ),
                  ),
                  const Icon(Icons.sunny),
                ],
              ),
              const SizedBox(height: 40),
              Image.asset('assets/lightbulb.png', width: 80, height: 80),
              const SizedBox(height: 20),
              const Text(
                'Current Bulb',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                height: 20,
                width: 150,
                child: TextField(
                  decoration: InputDecoration(hintText: 'E - 27 Bulb 18W'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
