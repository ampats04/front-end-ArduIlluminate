import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:ardu_illuminate/Screens/draw_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final List<PowerData> _powerDataList = [];
  final List<kwhData> _kWhDataList = [];
  final List<PesoData> _pesoDataList = [];

  late SharedPreferences _prefs;
  late String _userUid;
  String? uid = Auth().currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _initFirebase();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userUid = user.uid;
      await _loadGraphData();
    }
  }

  Future<void> _initFirebase() async {
    _powerRef = FirebaseDatabase.instance.ref('energy/power');

    _powerSubscription = _powerRef.onValue.listen(
      (event) {
        setState(
          () {
            _powerValue = (event.snapshot.value as double?) ?? 0.0;
            _kWhValue += _powerValue / 1000.0; // Assuming power is in watts
            _pesoCost = _kWhValue * 10.0; // Assuming cost per kWh is 10 pesos

            final currentTime = DateTime.now();
            final powerData = PowerData(currentTime, _powerValue);
            final kWhData = kwhData(currentTime, _kWhValue);
            final pesoData = PesoData(currentTime, _pesoCost);

            _powerDataList.add(powerData);
            _kWhDataList.add(kWhData);
            _pesoDataList.add(pesoData);

            _saveGraphData();
          },
        );
      },
    );
  }

  Future<void> _saveGraphData() async {
    final powerDataListString =
        json.encode(_powerDataList.map((data) => data.toMap()).toList());
    final kWhDataListString =
        json.encode(_kWhDataList.map((data) => data.toMap()).toList());
    final pesoDataListString =
        json.encode(_pesoDataList.map((data) => data.toMap()).toList());

    await _prefs.setString('$_userUid-powerDataList', powerDataListString);
    await _prefs.setString('$_userUid-kWhDataList', kWhDataListString);
    await _prefs.setString('$_userUid-pesoDataList', pesoDataListString);
  }

  Future<void> _loadGraphData() async {
    final powerDataListString = _prefs.getString('$_userUid-powerDataList');
    final kWhDataListString = _prefs.getString('$_userUid-kWhDataList');
    final pesoDataListString = _prefs.getString('$_userUid-pesoDataList');

    if (powerDataListString != null) {
      final powerDataList = json.decode(powerDataListString) as List<dynamic>;
      _powerDataList.clear();
      for (final data in powerDataList) {
        _powerDataList.add(PowerData.fromMap(data as Map<String, dynamic>));
      }
    }

    if (kWhDataListString != null) {
      final kWhDataList = json.decode(kWhDataListString) as List<dynamic>;
      _kWhDataList.clear();
      for (final data in kWhDataList) {
        _kWhDataList.add(kwhData.fromMap(data as Map<String, dynamic>));
      }
    }

    if (pesoDataListString != null) {
      final pesoDataList = json.decode(pesoDataListString) as List<dynamic>;
      _pesoDataList.clear();
      for (final data in pesoDataList) {
        _pesoDataList.add(PesoData.fromMap(data as Map<String, dynamic>));
      }
    }
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

    // Create the series for the line chart
    final powerSeries = [
      charts.Series<PowerData, DateTime>(
        id: 'Power',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Color(0XFFD30000)), // Change line color to red
        domainFn: (PowerData data, _) => data.date,
        measureFn: (PowerData data, _) => data.power,
        data: _powerDataList,
        strokeWidthPxFn: (_, __) => 3,
      ),
    ];
    final kWhSeries = [
      charts.Series<kwhData, DateTime>(
        id: 'kWh',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0XFFD30000)),
        domainFn: (kwhData data, _) => data.date,
        measureFn: (kwhData data, _) => data.kWh,
        data: _kWhDataList,
        strokeWidthPxFn: (_, __) => 3,
      ),
    ];

    final pesoSeries = [
      charts.Series<PesoData, DateTime>(
        id: 'Peso',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0XFFD30000)),
        domainFn: (PesoData data, _) => data.date,
        measureFn: (PesoData data, _) => data.peso,
        data: _pesoDataList,
        strokeWidthPxFn: (_, __) => 3,
      ),
    ];

    // Create the line chart
    final lineChart = charts.TimeSeriesChart(
      [powerSeries, kWhSeries, pesoSeries]
          .expand((element) => element)
          .toList(),
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
        desiredTickCount: 6,
      )),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Power Meter',
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                  Widget>[
            Container(
              width: 310,
              height: 270,
              decoration: BoxDecoration(
                color: Color(0xFFe7e5e4),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1.0),
                    offset: Offset(5, 5),
                    blurRadius: 4,
                    spreadRadius: 1,
                    // blurRadius: 10,
                  ),
                ],
              ),
              child: lineChart,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 250,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFe7e5e4),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(1.0),
                                offset: Offset(5, 5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _kWhValue.toStringAsFixed(6),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.08,
                                  fontFamily: 'Stencil',
                                  color: Color(0XFFD30000),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            offset: Offset(5, 5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFe7e5e4),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: Text(
                              'KwH',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8.0,
                            right: 8.0,
                            child: Text(
                              _kWhValue.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                                fontFamily: 'Stencil',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1.0),
                            offset: Offset(5, 5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFe7e5e4),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: Text(
                              'Php',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8.0,
                            right: 8.0,
                            child: Text(
                              _kWhValue.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                                fontFamily: 'Stencil',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ])),
    );
  }
}

class PowerData {
  final DateTime date;
  final double power;

  PowerData(this.date, this.power);

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'power': power,
    };
  }

  factory PowerData.fromMap(Map<String, dynamic> map) {
    return PowerData(
      DateTime.parse(map['date']),
      map['power'],
    );
  }
}

class kwhData {
  final DateTime date;
  final double kWh;

  kwhData(this.date, this.kWh);

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'kWh': kWh,
    };
  }

  factory kwhData.fromMap(Map<String, dynamic> map) {
    return kwhData(
      DateTime.parse(map['date']),
      map['kWh'],
    );
  }
}

class PesoData {
  final DateTime date;
  final double peso;

  PesoData(this.date, this.peso);

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'peso': peso,
    };
  }

  factory PesoData.fromMap(Map<String, dynamic> map) {
    return PesoData(
      DateTime.parse(map['date']),
      map['peso'],
    );
  }
}
