import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import '../Services/auth/auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final TextEditingController _modelController = TextEditingController();
final TextEditingController _manufacturerController = TextEditingController();
final TextEditingController _installDateController = TextEditingController();

class UpdatedLightDetails extends StatefulWidget {
  const UpdatedLightDetails({Key? key, this.data}) : super(key: key);
  final dynamic data;

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
  }

  void updateDetails() {
    // Implement the logic to update the details here
    // You can access the updated values using _modelController.text,
    // _manufacturerController.text, and _installDateController.text
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
