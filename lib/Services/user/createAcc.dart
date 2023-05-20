// ignore: file_names

import 'package:ardu_illuminate/Screens/login.dart';
import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:ardu_illuminate/Services/user/legalBasis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/apiService.dart';
import 'package:email_validator/email_validator.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formGlobalKey = GlobalKey<FormState>();
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
      initialDate: DateTime(2010),
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
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    final String? selectedDateFormatted =
        _selectedDate == null ? null : dateFormat.format(_selectedDate!);

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
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
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              TextFormField(
                controller: fullNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Full Name is Required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Full Name',
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                '',
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
                        return "* Birthdate is Required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Birthdate',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                        text: selectedDateFormatted ?? ''),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                validator: (value) =>
                    value != null && EmailValidator.validate(value)
                        ? null
                        : value == null || value.isEmpty
                            ? '* Email is required'
                            : '* Enter a valid Email',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              TextFormField(
                controller: usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Username is Required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.perm_identity_sharp),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter a min. of 6 characters'
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalBasis(),
                        ),
                      );
                    },
                    child: Text(
                      "By signing up, you agree to our \nTerms of use and Data Policy.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF0047FF),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ElevatedButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    _register();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPage())),
                    );
                  }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}