//import 'package:ardu_illuminate/editPassword.dart';
import 'dart:convert';

import 'package:ardu_illuminate/Screens/userProfile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:intl/intl.dart';
import '../Authentication/auth.dart';

String uid = Auth().currentUser!.uid;
String email = Auth().currentUser!.email!;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override

  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fullnameController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Future editUser() async {
    try {
      Map<String, dynamic> data = {
        'user_id': uid,
        'name': _fullnameController.text,
        'birthdate': _selectedDate.toString(),
        'username': _usernameController.text,
      };

      final uri =
          Uri.parse('http://192.168.254.115:8000/api/users/update/$uid');
      final headers = {'Content-Type': 'application/json'};

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to update user');
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
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
                enabled: true,
                controller: _fullnameController,
                decoration: const InputDecoration(
                  hintText: 'Jeremy Andy Ampatin',
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
              GestureDetector(
                onTap: _presentDatePicker,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Select your birthdate',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                        text: selectedDateFormatted ?? ''),
                    keyboardType: TextInputType.datetime,
                  ),
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
                enabled: true,
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'jeremyandyampatin@gmail.com',
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
                decoration: const InputDecoration(
                  enabled: true,
                  hintText: 'Jeremy_Andy',
                  prefixIcon: Icon(Icons.account_circle),
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
                                  onPressed: () {
                                    editUser();
                                  },
                                  child: const Text('CONTINUE'),
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
                      padding: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF0047FF),
                    ),
                    child: const Text(
                      'Save Changes',
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
        )),
      ),
    );
  }
}
