// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';

import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/maincontroller.dart';
import 'package:ardu_illuminate/BedroomScreen/bedroom_homePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

DateTime now = DateTime.now();

class _MainPageScreenState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  //Api call
  late Future<dynamic> futureLight;
  late Future<dynamic> futre;
  //widgets
  TextEditingController modelController = TextEditingController();
  Color activeColor = Colors.green;

  bool ledstatus = false;
  late Websocket ws = Websocket();
  String action = "";
  String location = "Bathroom";
  String formatDate = DateFormat('yyyy-MM-dd').format(now);
  String formatTime = DateFormat('HH:mm a').format(now);

  //Authentication
  String? uid = Auth().currentUser!.uid;

  //firebase realtime
  final DatabaseReference uidRef = FirebaseDatabase.instance.ref('post/uid');

  final DatabaseReference ctrRef = FirebaseDatabase.instance.ref('counter');

  late int ctr;
  int offz = 1;
  int onz = 2;

  @override
  void initState() {
    super.initState();
    futureLight = apiService().get("/light/one/$uid");
  }

  void _test() {
    Stream<DatabaseEvent> stream = ctrRef.child('ctr').onValue;

    stream.listen((DatabaseEvent event) {
      ctr = event.snapshot.value as int;
    });
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
    _test();
    if (ledstatus) {
      var off = offz.toString();

      ws.sendcmd("power$off");
      print(off);
      action = "Power Off";
      print("mao ni bathroom");
      ledstatus = false;

      ctrRef.child("ctr").set(++ctr);
      Auth().uidPostData(ctr, action, formatDate, formatTime, uid!, location);
    } else {
      var on = onz.toString();
      ws.sendcmd("power$on");
      action = "Power On";

      ledstatus = true;
      ctrRef.child("ctr").set(++ctr);
      Auth().uidPostData(ctr, action, formatDate, formatTime, uid!, location);
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
                                  action = "Adjusted Brightness: $brightness%";
                                  ws.sendcmd('brightness$brightness');
                                  Auth().uidPostData(ctr, action, formatDate,
                                      formatTime, uid!, location);
                                  setState(() {
                                    mainController.bathroomSliderValue.value =
                                        value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.sunny),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Image.asset(
                'assets/lightbulb.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
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
