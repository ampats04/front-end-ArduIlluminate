// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:ardu_illuminate/BedroomScreen/bedroom_homePage.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:ardu_illuminate/Screens/lightProfile.dart';
import 'package:ardu_illuminate/Screens/addLight.dart';
import 'package:get/get.dart';
import 'package:ardu_illuminate/Screens/homePage.dart';
import '../controllers/maincontroller.dart';

class BedroomMainPage extends StatefulWidget {
  const BedroomMainPage({Key? key}) : super(key: key);

  @override
  _BedroomMainPageScreenState createState() => _BedroomMainPageScreenState();
}

class _BedroomMainPageScreenState extends State<BedroomMainPage>
    with AutomaticKeepAliveClientMixin<BedroomMainPage> {
  late Future<dynamic> futureLight;
  TextEditingController modelController = TextEditingController();
  Color activeColor = Colors.green;

  bool ledstatus = false;

  late Websocket ws = Websocket();

  String? uid = Auth().currentUser!.uid;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });

    super.initState();
    futureLight = apiService().get("/light/one/$uid");
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
  bool get isPowerOn => ledstatus;
  void _onPressed(bool value) {
    if (ledstatus) {
      ws.sendcmd("poweroff");
      ledstatus = false;
    } else {
      ws.sendcmd("poweron");

      ledstatus = true;
    }
    Get.find<MainController>().isBedroomPowerOn.value = value;
    setState(() {
      activeColor = value ? Colors.green : Colors.red;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainController = Get.find<MainController>();

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Bedroom Light',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFD9D9D9),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_drop_down_circle_sharp),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(25.0, 50.0, 0.0, 0.0),
                  items: [
                    PopupMenuItem<String>(
                      value: 'bathroom',
                      child: Text(
                        'Bathroom',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                  ],
                  elevation: 8.0,
                ).then<void>((String? itemSelected) {
                  if (itemSelected == null) return;

                  switch (itemSelected) {
                    case 'bathroom':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                      break;
                  }
                });
              },
            ),
          ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Power',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Transform.scale(
                  scale: MediaQuery.of(context).size.width * 0.004,
                  child: Obx(() => Switch(
                        thumbIcon: thumbIcon,
                        value:
                            Get.find<MainController>().isBedroomPowerOn.value,
                        inactiveThumbColor: const Color(0XFFD30000),
                        activeColor: activeColor,
                        onChanged: _onPressed,
                        // onChanged: _onPressed,
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Intensity',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    const Icon(Icons.dark_mode_outlined),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
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
                        child: Obx(() => Slider(
                              value: mainController.bedroomSliderValue.value,
                              max: 100,
                              divisions: 100,
                              label: mainController.bedroomSliderValue
                                  .round()
                                  .toString(),
                              onChanged: mainController.isBedroomPowerOn.value
                                  ? (value) {
                                      var brightness = value.round().toString();
                                      ws.sendcmd('brightness$brightness');
                                      setState(() {
                                        mainController
                                            .bedroomSliderValue.value = value;
                                      });
                                    }
                                  : null,
                              // onChanged: _onSliderChanged,
                            )),
                      ),
                    ),
                    const Icon(Icons.sunny),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EnlighteningDetails()),
                    );
                  },
                  child: Image.asset(
                    'assets/lightbulb.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  'Current Bulb',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                FutureBuilder<dynamic>(
                  future: futureLight,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      String model = snapshot.data['model'];
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFormField(
                          initialValue: model,
                          readOnly: true,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // Remove the underline
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.4,
                    );
                  },
                ),
              ].where((child) => child != null).toList()),
        ),
      ),
    );
  }
}
