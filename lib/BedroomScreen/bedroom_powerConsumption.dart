import 'dart:async';
import 'dart:convert';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

class BedroomPowerConsumption extends StatefulWidget {
  const BedroomPowerConsumption({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BedroomPowerConsumptionState createState() =>
      _BedroomPowerConsumptionState();
}

class _BedroomPowerConsumptionState extends State<BedroomPowerConsumption>
    with AutomaticKeepAliveClientMixin<BedroomPowerConsumption> {
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

  String uid = Auth().currentUser!.uid;

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

    _powerSubscription = _powerRef.onValue.listen((event) {
      setState(() {
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
      });
    });
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
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PowerData data, _) => data.date,
        measureFn: (PowerData data, _) => data.power,
        data: _powerDataList,
      ),
    ];

    final kWhSeries = [
      charts.Series<kwhData, DateTime>(
        id: 'kWh',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (kwhData data, _) => data.date,
        measureFn: (kwhData data, _) => data.kWh,
        data: _kWhDataList,
      ),
    ];

    final pesoSeries = [
      charts.Series<PesoData, DateTime>(
        id: 'Peso',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (PesoData data, _) => data.date,
        measureFn: (PesoData data, _) => data.peso,
        data: _pesoDataList,
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
      appBar: AppBar(
        title: const Text('Energy Meter'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text(
                  'Power Consumption',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _powerValue.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 60.0),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'W',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _kWhValue.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 60.0),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'kWh',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _pesoCost.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 60.0),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Peso Cost',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: lineChart,
              ),
            ),
            const Expanded(
              child: Text(
                'Real-time Power Consumption',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
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
