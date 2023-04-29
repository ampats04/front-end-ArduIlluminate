//import 'package:ardu_illuminate/editPassword.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
//import 'package:ardu_illuminate/passwordResetpage.dart';
//import 'package:ardu_illuminate/editprofile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Authentication/auth.dart';

TextEditingController _fullnameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _birthdateController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _usernameController = TextEditingController();
String uid = Auth().currentUser!.uid;
String email = Auth().currentUser!.email!;

Future userProfile() async {
  try {
    //String password = await Auth().currentUser!.password!;
    //String birthdate = await Auth().currentUser!.birthdate!;
    //String username = await Auth().currentUser!.username!;

    Response response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/users/retrieve?name=$uid'),
      headers: {'Content-Type': 'application/json'},
    );

    var data = json.decode(response.body);
    print("hi");
    print(uid);
    print(data);

    _fullnameController.text = data[0]['name'];
    _emailController.text = email;
    _birthdateController.text = data[0]['birthdate'];
    _usernameController.text = data[0]['username'];
    print(_usernameController.text);
  } catch (error) {
    print(error);
    throw Exception('Failed to Get User Credentials');
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    userProfile();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                decoration: InputDecoration(
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
              TextField(
                controller: _birthdateController,
                enabled: true,
                decoration: InputDecoration(
                  hintText: 'January 69, 6969',
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
                enabled: true,
                controller: _emailController,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
              TextField(
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
                                    // Get all the updated inputs
                                    // ex. _usernameController.text prints j
                                    Response response1 = await http.put(
                                        Uri.parse(
                                            'http://10.0.2.2:8000/api/users/update'),
                                        headers: {
                                          'Content-Type': 'application/json'
                                        },
                                        body: {
                                          'user_id': uid,
                                          'email': email,
                                          'name': _fullnameController.text,
                                          'birthdate':
                                              _birthdateController.toString(),
                                          'username': _usernameController.text,
                                        });
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const FirstScreen(),
                                    //   ),
                                    // );
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
