// ignore: file_names

import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/apiService.dart';

class CreateAccountPage extends StatefulWidget {
  //final formKey = GlobalKey<FormState>();
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

      String uid = userCredential.user!.uid;
      final Map<String, dynamic> userData = {
        'user_id': uid,
        'name': fullNameController.text,
        'birthdate': birthdateOnlyString,
        'username': usernameController.text,
      };

      await apiService().post("/users/add", userData);

      // ignore: use_build_context_synchronously
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //logic para sa weak pass
      } else if (e.code == 'email-already-in-use') {
        //logic paras less email
      }
    } catch (e) {
      print("Failed to create account: $e");
    }
  }

  bool _agreeToTermsAndPrivacy = false;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1950),
      lastDate: DateTime(2015),
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
      backgroundColor: Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Create Account',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFD9D9D9),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Full Name',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            TextFormField(
              controller: fullNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  const InputDecoration(
                      errorText: "Please Enter your full name");
                  return "Please enter your full name";
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Birthdate',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Email',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Username',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Password',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 8
                  ? 'Enter a min. of 8 characters'
                  : null,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                Expanded(
                  child: Text(
                    'By signing up, you agree to our Terms and Data Policy.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ElevatedButton(
              onPressed: () {
                _register();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MainPage())));
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
