import 'dart:convert';

import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/api/apiService.dart';
import 'package:http/http.dart' as http;

TextEditingController bulbController = TextEditingController();
TextEditingController manufacturerController = TextEditingController();
TextEditingController wattController = TextEditingController();

class EnlighteningDetails extends StatefulWidget {
  const EnlighteningDetails({super.key});

  @override
  State<EnlighteningDetails> createState() => _EnlighteningDetailsState();
}

class _EnlighteningDetailsState extends State<EnlighteningDetails> {
  DateTime? _selectedDate;
  TextEditingController dateController = TextEditingController();
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _register() async {
    try {
      final Map<String, dynamic> lightData = {
        'user_id': Auth().currentUser?.uid,
        'model': bulbController.text,
        'manufacturer': manufacturerController.text,
        'install_date':
            _selectedDate!.toIso8601String().substring(0, 10).toString(),
        'watt': wattController.text,
      };

      final response = await apiService().post("/light/add", lightData);
      final lightID = response['light_id'];

      print("Light succesfully created $lightID");

      // ignore: use_build_context_synchronously
    } catch (e) {
      print("Failed to create Light info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    final String? selectedDateFormatted =
        _selectedDate == null ? null : dateFormat.format(_selectedDate!);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: const Text('Enlightening Details'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Fill-up the following Information Below, such as the Bulb Model, Manufacturer and the Installation date.',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: const Color(0xFF0047FF)),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: bulbController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Bulb Model',
                prefixIcon: Icon(Icons.lightbulb),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: manufacturerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Bulb Manufacturer',
                prefixIcon: Icon(Icons.precision_manufacturing),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: wattController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Bulb Wattage',
                prefixIcon: Icon(Icons.energy_savings_leaf),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: _showDatePicker,
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Installation Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  controller:
                      TextEditingController(text: selectedDateFormatted ?? ''),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'BULB DETAILS',
                          style: TextStyle(
                            color: const Color(0xFF0047FF),
                            fontFamily: 'Poppins',
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                        content: const Text('Save Bulb Details?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _register();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ),
                              );
                            },
                            child: const Text('Save'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('REVERT'),
                          ),
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0047FF),
              ),
              child: Text(
                'SAVE DETAILS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: MediaQuery.of(context).size.width * 0.05,
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
