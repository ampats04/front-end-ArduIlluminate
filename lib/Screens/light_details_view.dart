import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnlighteningDetailsView extends StatelessWidget {
  final DateTime? selectedDate;

  const EnlighteningDetailsView({Key? key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMEd();
    final String? selectedDateFormatted =
        selectedDate == null ? null : dateFormat.format(selectedDate!);

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
            const TextField(
              decoration: InputDecoration(
                hintText: 'Light Bulb 1',
                prefixIcon: Icon(Icons.lightbulb),
              ),
              readOnly: true,
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Phillips INC.',
                prefixIcon: Icon(Icons.precision_manufacturing),
              ),
              readOnly: true,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {},
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'January 1, 2022',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  controller: TextEditingController(text: selectedDateFormatted ?? ''),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0047FF),
              ),
              child: const Text(
                'SAVE DETAILS',
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
