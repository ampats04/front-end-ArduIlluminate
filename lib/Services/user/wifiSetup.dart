// ignore: file_names
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NetworkSettingsPage extends StatefulWidget {
  const NetworkSettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NetworkSettingsPageState createState() => _NetworkSettingsPageState();
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isConnecting = false;
  final formGlobalKey = GlobalKey<FormState>();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final String ssidPath = '/network/ssid';
  final String passwordPath = '/network/password';
  String? response;

  @override
  Widget build(BuildContext context) {
    final ssid = _ssidController.text;
    final password = _passwordController.text;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Network Settings',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Icon(
                    Icons.wifi,
                    size: 80,
                    color: Color(0xFF0047FF),
                  ),
                  const SizedBox(height: 35.0),
                  const Text(
                    "Enter the SSID of your network:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 10.0),
                    child: TextFormField(
                      controller: _ssidController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '* SSID is required';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "SSID",
                        labelStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 5.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '* Password is required';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        labelStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        setState(() {
                          _isConnecting = true;
                        });

                        String ssid = _ssidController.text;
                        String password = _passwordController.text;

                        // Perform the necessary operations with the data
                        // await databaseReference.child(ssidPath).set(ssid);
                        // await databaseReference.child(passwordPath).set(password);

                        setState(() {
                          _isConnecting = false;
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Data Sent",
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              content: const Text(
                                "Settings saved successfully!",
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF0047FF),
                    ),
                    child: _isConnecting
                        ? const CircularProgressIndicator()
                        : Text(
                            "Save Settings",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                  ),
                  response != null ? Text(response!) : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
