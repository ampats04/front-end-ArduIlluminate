import 'package:ardu_illuminate/Account/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      initialDate: DateTime(2000),
      firstDate: DateTime(1990),
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

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    final String? selectedDateFormatted =
        _selectedDate == null ? null : dateFormat.format(_selectedDate!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enlightening Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Fill-up the following Information Below, such as the Bulb Model, Manufacturer and the Installation date.',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFF0047FF)),
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Bulb Model...',
                prefixIcon: Icon(Icons.lightbulb),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter Bulb Manufacturer...',
                prefixIcon: Icon(Icons.precision_manufacturing),
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
                    hintText: 'Enter Installation Date...',
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
            //add birthdate selector here
            ElevatedButton(
              child: Text(
                'SAVE DETAILS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'BULB DETAILS',
                          style: TextStyle(
                              color: Color(0xFF0047FF),
                              fontFamily: 'Poppins',
                              fontSize: 16),
                        ),
                        content: const Text('Save Bulb Details?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
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
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0047FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
