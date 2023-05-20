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

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref();
  final String ssidPath = '/network/ssid';
  final String passwordPath = '/network/password';
  String? response;

  @override
  Widget build(BuildContext context) {
    final ssid = _ssidController.text;
    final password = _passwordController.text;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Settings"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Enter the SSID of your network:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _ssidController,
                decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                  labelText: "SSID",
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isConnecting = true;
                  });

                  await databaseReference.child(ssidPath).set(ssid);
                  await databaseReference.child(passwordPath).set(password);

                  setState(() {
                    _isConnecting = false;
                  });

                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Data Sent"),
                        content: const Text("Settings saved successfully!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: _isConnecting
                    ? const CircularProgressIndicator()
                    : const Text("Save Settings"),
              ),
              response != null ? Text(response!) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
