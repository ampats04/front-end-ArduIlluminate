import 'package:ardu_illuminate/Services/api/webSocket.dart';
import 'package:flutter/material.dart';

class NetworkSettingsPage extends StatefulWidget {
  const NetworkSettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NetworkSettingsPageState createState() => _NetworkSettingsPageState();
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isConnecting = false;

  late Websocket ws = Websocket();
  String? response;

  void initstate() {
    Future.delayed(Duration.zero, () async {
      ws.channelconnect();
    });

    super.initState();
  }

  @override
  void dispose() {
    ws.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _isConnecting ? null : _setNetworkSettings,
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

  void _onDataReceived(dynamic data) {
    setState(() {
      response = data;
    });
  }

  void _setNetworkSettings() {
    final ssid = _ssidController.text;
    final password = _passwordController.text;

    ws.sendcmd("ssid$ssid");
    ws.sendcmd("password$password");

    setState(() {
      _isConnecting = true;
    });
  }
}
