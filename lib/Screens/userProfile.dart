import 'package:ardu_illuminate/Services/user/editprofilepage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Services/api/apiService.dart';
import '../Services/auth/auth.dart';

final TextEditingController _fullnameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _birthdateController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();

String uid = Auth().currentUser!.uid;
String email = Auth().currentUser!.email!;

Future fetchDatafromServer(String uid) async {
  try {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/users/one/$uid'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      //resuest sucesss
      return response.body;
    } else {
      // The request failed
      throw Exception('Failed to load data from server ${response.body}');
    }
  } catch (err) {
    throw Exception("Failed to Retrieve Creddentials $err");
  }
}

Future fetchUser(String uid) async {
  final String data = await fetchDatafromServer(uid);
  final decodeData = jsonDecode(data);

  _fullnameController.text = decodeData[0]['name'];
  _emailController.text = email;
  _birthdateController.text = decodeData[0]['birthdate'];
  _usernameController.text = decodeData[0]['username'];
}

bool isEditProfile = false;

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    fetchUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Full Name',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              enabled: isEditProfile,
              controller: _fullnameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Birthdate',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              enabled: isEditProfile,
              controller: _birthdateController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              enabled: isEditProfile,
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mark_email_read),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                enabled: isEditProfile,
                prefixIcon: const Icon(Icons.account_circle),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Password',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold)),
            const TextField(
              decoration: InputDecoration(
                enabled: false,
                hintText: '**********',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Credentials Update?',
                              style: TextStyle(
                                  color: Color(0xFF0047FF),
                                  fontFamily: 'Poppins',
                                  fontSize: 16),
                            ),
                            content: const Text(
                                'Do you want to update credentials?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isEditProfile = false;
                                  });
                                  await fetchUser(uid);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfile(),
                                      ));
                                },
                                child: const Text('Continue'),
                              )
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF0047FF),
                  ),
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
