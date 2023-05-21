import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import '../Services/auth/auth.dart';
import 'LightProfileUpdate.dart';

final TextEditingController _modelController = TextEditingController();
final TextEditingController _manufacturerController = TextEditingController();
final TextEditingController _installDateController = TextEditingController();
final TextEditingController _wattController = TextEditingController();

class EnlighteningDetailsView extends StatefulWidget {
  const EnlighteningDetailsView({Key? key}) : super(key: key);

  @override
  _EnlighteningDetailsViewState createState() =>
      _EnlighteningDetailsViewState();
}

class _EnlighteningDetailsViewState extends State<EnlighteningDetailsView> {
  late Future<dynamic> futureLight;
  String? uid = Auth().currentUser!.uid;

  @override
  void initState() {
    super.initState();
    futureLight = apiService().get("/light/one/$uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error} occurred'),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data;

                String lightId = data['light_id'].toString();
                _modelController.text = data['model'];
                _manufacturerController.text = data['manufacturer'];
                _installDateController.text = data['install_date'];
                _wattController.text = data['watt'].toString();
                return Column(
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
                        border: OutlineInputBorder(),
                        labelText: 'Bulb Model',
                        prefixIcon: Icon(Icons.lightbulb),
                      ),
                      readOnly: true,
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
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Installation Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: _installDateController,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
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
                        prefixIcon: Icon(Icons.electrical_services),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatedLightDetails(
                              data: snapshot.data,
                              lightId: lightId,
                            ),
                          ),
                        );
                      },
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
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
          future: futureLight,
        ),
      ),
    );
  }
}
