import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class NetworkSettingsPage extends StatefulWidget {
  const NetworkSettingsPage({Key? key}) : super(key: key);

  @override
  _NetworkSettingsPageState createState() => _NetworkSettingsPageState();
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isConnecting = false;

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  final String ssidPath = '/network/ssid';
  final String passwordPath = '/network/password';
  String? response;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ssid = _ssidController.text;
    final password = _passwordController.text;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(
                labelText: "SSID",
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
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
              child: _isConnecting
                  ? const CircularProgressIndicator()
                  : const Text("Save Settings"),
            ),
            response != null ? Text(response!) : Container(),
          ],
        ),
      ),
    );
  }
}
