// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';

import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ardu_illuminate/Screens/addLight.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ardu_illuminate/BedroomScreen/bedroom_mainPage.dart';
import '../controllers/maincontroller.dart';
import 'package:ardu_illuminate/BedroomScreen/bedroom_homePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  //Api call
  late Future<dynamic> futureLight;

  //widgets
  TextEditingController modelController = TextEditingController();
  Color activeColor = Colors.green;

  bool ledstatus = false;
  late Websocket ws = Websocket();
  String action = "";
  int ctr = 0;

  //Authentication
  String? uid = Auth().currentUser!.uid;

  //firebase realtime

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('POST');

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
    DateTime now = DateTime.now();
    String format = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    if (ledstatus) {
      ws.sendcmd("poweroff");
      action = "Power Off";

      databaseReference.child("$ctr").set({
        'action': action,
        'timestamp': format,
      });

      ledstatus = false;
      ctr++;
      print(ctr);
    } else {
      ws.sendcmd("poweron");
      action = "Power On";
      databaseReference.child("$ctr").set({
        'action': action,
        'timestamp': format,
      });
      ledstatus = true;
      ctr++;
      print(ctr);
    }
    Get.find<MainController>().isBathroomPowerOn.value = value;
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
            'Bathroom Light',
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
                    const PopupMenuItem<String>(
                      value: 'bedroom',
                      child: Text('Bedroom'),
                    ),
                  ],
                  elevation: 8.0,
                ).then<void>((String? itemSelected) {
                  if (itemSelected == null) return;

                  switch (itemSelected) {
                    case 'bedroom':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BedroomHomePage(),
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
                      value: Get.find<MainController>().isBathroomPowerOn.value,
                      inactiveThumbColor: const Color(0XFFD30000),
                      activeColor: activeColor,
                      onChanged: _onPressed,
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
                      child: Obx(
                        () => Slider(
                          value: mainController.bathroomSliderValue.value,
                          max: 100,
                          divisions: 100,
                          label: mainController.bathroomSliderValue
                              .round()
                              .toString(),
                          onChanged: mainController.isBathroomPowerOn.value
                              ? (value) {
                                  var brightness = value.round().toString();
                                  ws.sendcmd('brightness$brightness');
                                  setState(() {
                                    mainController.bathroomSliderValue.value =
                                        value;
                                  });
                                }
                              : null,
                          // onChanged: _onSliderChanged,
                        ),
                      ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Remove the underline
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.4,
                  );
                },
              ),
            ].where((child) => child != null).toList()),
      ),
    );
  }
}
