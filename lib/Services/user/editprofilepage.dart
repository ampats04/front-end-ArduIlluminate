//import 'package:ardu_illuminate/editPassword.dart';

import 'package:ardu_illuminate/Models/user_model.dart';

import 'package:ardu_illuminate/Services/api/apiService.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../auth/auth.dart';

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
                                    String birthdateString =
                                        _selectedDate!.toIso8601String();
                                    String birthdateOnlyString =
                                        birthdateString.substring(0, 10);
                                    try {
                                      var userId = Auth().currentUser!.uid;
                                      Map<String, dynamic> data = {
                                        'name': _fullnameController.text,
                                        'birthdate': birthdateOnlyString,
                                        'username': _usernameController.text,
                                      };

                                      await apiService()
                                          .put("/users/update/$userId", data)
                                          .catchError((err) {
                                        print(err.toString());
                                      });
                                    } catch (err) {
                                     
                                      throw Exception("Failed to update user $err");
                                    }
                                  },
                                  child: const Text('Continue'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
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
