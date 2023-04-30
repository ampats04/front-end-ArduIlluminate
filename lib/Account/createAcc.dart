// ignore: file_names
import 'dart:convert';

import 'package:ardu_illuminate/Account/login.dart';
import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ardu_illuminate/Authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController fullNameController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage = 'Account creation failed';
  UserCredential? credential;
  bool isLogin = true;

  Future createUser() async {
    try {
      String uid = await Auth().register(
        email: emailController.text,
        password: passwordController.text,
      );

      print("yawa maoni si $uid");

      Map<String, dynamic> data = {
        'user_id': uid,
        'name': fullNameController.text,
        'birthdate': _selectedDate.toString(),
        'username': usernameController.text,
      };

      final uri = Uri.parse('http://192.168.254.102:8000/api/users/add');
      final headers = {'Content-Type': 'application/json'};

      print('Data to be sent: $data');

      Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(data),
        // encoding: encoding,
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Request failed with status code ${response.statusCode}');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to create user');
    } catch (error) {
      print(error);
      throw Exception('Failed to create user');
    }
  }

  //check gpt
  Future<void> _createAccount() async {
    if (!_agreeToTermsAndPrivacy) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please agree to the terms and privacy policy'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    try {
      await createUser();

      // If the account is created successfully, automatically logs the user in
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }

    if (errorMessage != null) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
//check gpt

  bool _agreeToTermsAndPrivacy = false;

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
        title: const Padding(
          padding: EdgeInsets.only(top: 40), // Add top padding here
          child: Center(
            child: Text(
              'Create Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Birthdate',
              style: TextStyle(fontSize: 16.0),
            ),
            GestureDetector(
              onTap: _presentDatePicker,
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Select your birthdate',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller:
                      TextEditingController(text: selectedDateFormatted ?? ''),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Email',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Username',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _agreeToTermsAndPrivacy,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTermsAndPrivacy = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'By signing up, you agree to our Terms and Data Policy.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _createAccount();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const MainPage(),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF0047FF),
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
