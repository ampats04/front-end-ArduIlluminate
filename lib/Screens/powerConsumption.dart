import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';

import 'package:ardu_illuminate/Screens/draw_header.dart';

class PowerConsumption extends StatefulWidget {
  const PowerConsumption({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PowerConsumptionState createState() => _PowerConsumptionState();
}

class _PowerConsumptionState extends State<PowerConsumption>
    with AutomaticKeepAliveClientMixin<PowerConsumption> {
  late DatabaseReference _powerRef;
  StreamSubscription<DatabaseEvent>? _powerSubscription;
  double _powerValue = 0.0;
  double _kWhValue = 0.0;
  double _pesoCost = 0.0;

  String? uid = Auth().currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _powerRef = FirebaseDatabase.instance.ref().child('energy/power');
    _powerSubscription = _powerRef.onValue.listen((event) {
      setState(() {
        _powerValue = (event.snapshot.value as double?) ?? 0.0;
        _kWhValue += _powerValue / 1000.0; // Assuming power is in watts
        _pesoCost = _kWhValue * 10.0; // Assuming cost per kWh is 10 pesos
      });
    });
  }

  @override
  void dispose() {
    _powerSubscription?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Bedroom Power',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFD9D9D9),
        ),
      ),
      drawer: const DrawHeader(),
      backgroundColor: const Color(0xFFD9D9D9),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.fitHeight,
            alignment: Alignment(1.5, 1.0),
          ),
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: (MediaQuery.of(context).size.height * 0.03)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Text(
                  _powerValue.toStringAsFixed(5),
                  style: const TextStyle(fontSize: 60.0, color: Colors.red),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.03)),
                Text(
                  'Watts',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.08)),
                Text(
                  '${_kWhValue.toStringAsFixed(4)} kWh',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontFamily: 'Poppins',
                      color: const Color(0XFFD30000),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.009)),
                Text(
                  'KwH',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.08)),
                Text(
                  'P ${_pesoCost.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontFamily: 'Poppins',
                      color: Color(0XFFD30000),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.009)),
                Text(
                  'Pesos', // - Per Day (at P10/kWh):
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height * 0.035)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
