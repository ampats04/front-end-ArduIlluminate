// ignore_for_file: library_private_types_in_public_api

import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:ardu_illuminate/Screens/lightProfile.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import '../Services/auth/auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final TextEditingController _modelController = TextEditingController();
final TextEditingController _manufacturerController = TextEditingController();
final TextEditingController _installDateController = TextEditingController();
final TextEditingController _wattController = TextEditingController();
// ignore: non_constant_identifier_names
late final String light_id;

class UpdatedLightDetails extends StatefulWidget {
  const UpdatedLightDetails({Key? key, this.data, required this.lightId})
      : super(key: key);
  final dynamic data;
  final String lightId;

  @override
  _UpdatedLightDetailsState createState() => _UpdatedLightDetailsState();
}

class _UpdatedLightDetailsState extends State<UpdatedLightDetails> {
  late Future<dynamic> futureLight;
  String? uid = Auth().currentUser!.uid;

  @override
  void initState() {
    super.initState();
    futureLight = apiService().get("/light/one/$uid");

    _modelController.text = widget.data['model'];
    _manufacturerController.text = widget.data['manufacturer'];
    _installDateController.text = widget.data['install_date'];
    _wattController.text = widget.data['watt'].toString();
  }

  void _update() async {
    light_id = widget.data['light_id'].toString();
    try {
      Map<String, dynamic> data = {
        'model': _modelController.text,
        'manufacturer': _manufacturerController.text,
        'install_date': _installDateController.text,
        'watt': _wattController.text,
      };

      await apiService().put("/light/update/$uid/$light_id", data);
    } catch (err) {
      throw Exception("Failed to update lights $err");
    }
  }

  void updateDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to update the details?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('UPDATE'),
              onPressed: () {
                _update();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: ((context) => const HomePage())),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void openCalendarPicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          _installDateController.text = date.toString();
        });
      },
      currentTime: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Light Details',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Update Bulb Details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                color: Color(0xFF0047FF),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bulb Model',
                prefixIcon: Icon(Icons.lightbulb),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Manufacturer',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                openCalendarPicker();
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Installation Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: _installDateController,
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _wattController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Watts',
                prefixIcon: Icon(Icons.electric_bolt_outlined),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateDetails,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0047FF),
              ),
              child: const Text(
                'UPDATE DETAILS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
