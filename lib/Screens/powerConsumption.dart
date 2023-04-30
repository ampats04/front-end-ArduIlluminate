// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'draw_header.dart';

class PowerConsumption extends StatefulWidget {
  const PowerConsumption({super.key});

  @override
  _PowerConsumption createState() => _PowerConsumption();
}

class _PowerConsumption extends State<PowerConsumption>
    with AutomaticKeepAliveClientMixin<PowerConsumption> {
  @override
  bool get wantKeepAlive => true;
  double wattage = 0.0;
  double kilowattHours = 0.0;
  double pesoCost = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Energy Meter',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFD9D9D9),
      ),
      drawer: const DrawHeader(),
      backgroundColor: Color(0xFFD9D9D9),
      body: Container(
        width: 1500,
        height: 2000,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.fitHeight,
            alignment: Alignment(1.5, 1.0),
          ),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Wattage of Light Bulb:',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    wattage = double.parse(value);
                    kilowattHours = wattage / 1000 * 24;
                    pesoCost = kilowattHours * 10;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Watts',
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Kilowatt-hours per day:',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            Text(
              '${kilowattHours.toStringAsFixed(2)} kWh',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            const Text(
              'Cost per day (at P10/kWh):',
              style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            Text(
              'P ${pesoCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
