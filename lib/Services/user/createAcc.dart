// ignore: file_names
import 'dart:convert';

// import '../../Screens/homePage.dart';
import 'package:ardu_illuminate/Screens/login.dart';
import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../api/apiService.dart';

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

  void _register() async {
    String birthdateString = _selectedDate!.toIso8601String();
    String birthdateOnlyString = birthdateString.substring(0, 10);
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(
          "User registered successfully with uid: ${userCredential.user!.uid}");
      String uid = userCredential.user!.uid;

      final Map<String, dynamic> userData = {
        'user_id': uid,
        'name': fullNameController.text,
        'birthdate': birthdateOnlyString,
        'username': usernameController.text,
      };

      await apiService().post("/users/add", userData);
      print("Account created successfully!");
      // ignore: use_build_context_synchronously
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("Failed to create account: $e");
    }
  }

  bool _agreeToTermsAndPrivacy = false;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
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
            TextFormField(
              controller: fullNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your full name";
                }
                return null;
              },
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
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your Birthdate";
                    }
                    return null;
                  },
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
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Email";
                }
                return null;
              },
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
            TextFormField(
              controller: usernameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Username";
                }
                return null;
              },
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
                _register();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const LoginPage())));
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
