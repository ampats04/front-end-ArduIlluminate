// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import '../Services/auth/auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final TextEditingController _modelController = TextEditingController();
final TextEditingController _manufacturerController = TextEditingController();
final TextEditingController _installDateController = TextEditingController();
final TextEditingController _wattController = TextEditingController();

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

    // Set the initial values of the text controllers here
    _modelController.text = widget.data['model'];
    _manufacturerController.text = widget.data['manufacturer'];
    _installDateController.text = widget.data['install_date'];
    _wattController.text = widget.data['watt'].toString();
  }

  void _update() async {
    try {
      Map<String, dynamic> data = {
        'model': _modelController.text,
        'manufacturer': _manufacturerController.text,
        'install_date': _installDateController.text,
        'watt': _wattController.text,
      };

      print(widget.data['light_id'].toString());
      await apiService().put(
          "/lights/update/$uid/${widget.data['light_id'].toString()}", data);
    } catch (err) {
      throw Exception("Failed to update lights $err");
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updated Enlightening Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bulb Details',
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
                labelText: 'Bulb Model',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(
                labelText: 'Manufacturer',
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
                    labelText: 'Installation Date',
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
                labelText: 'Watts',
              ),
            ),
            ElevatedButton(
              onPressed: _update,
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
