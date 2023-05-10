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
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Energy Meter',
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
                      hintText: '',
                    ),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontFamily: 'Poppins',
                        color: Color(0XFFD30000),
                        fontWeight: FontWeight.bold),
                  ),
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
                  '${kilowattHours.toStringAsFixed(2)} kWh',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontFamily: 'Poppins',
                      color: Color(0XFFD30000),
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
                  'P ${pesoCost.toStringAsFixed(2)}',
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
