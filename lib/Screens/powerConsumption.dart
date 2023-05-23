// ignore_for_file: library_private_types_in_public_api

import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';

import 'draw_header.dart';

class PowerConsumption extends StatefulWidget {
  const PowerConsumption({super.key});

  @override
  _PowerConsumption createState() => _PowerConsumption();
}

class _PowerConsumption extends State<PowerConsumption>
    with AutomaticKeepAliveClientMixin<PowerConsumption> {
  double wattage = 0.0;
  double kilowattHours = 0.0;
  double pesoCost = 0.0;

  String? uid = Auth().currentUser!.uid;
  late Future<dynamic> futureLight;

  @override
  void initState() {
    super.initState();
    futureLight = apiService().get("/light/one/$uid");
  }

  @override
  bool get wantKeepAlive => true;

  void updateValues(double watt) {
    setState(() {
      wattage = watt;
      kilowattHours = wattage / 1000 * 24;
      pesoCost = kilowattHours * 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Bathroom Power Consumption',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  child: FutureBuilder<dynamic>(
                    future: futureLight,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        double watt = snapshot.data['watt'];

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue: watt.toString(),
                            readOnly: true,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontFamily: 'Poppins',
                                color: const Color(0XFFD30000),
                                fontWeight: FontWeight.bold),
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
