// ignore: file_names
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();

  //final SnackBar = const SnackBar(content: Text('Email Sent'));
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Text(
                  'Enter the email associated with your account and we’ll send a verification code in order to reset your password.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && EmailValidator.validate(email)
                          ? null
                          : 'Enter a valid Email',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
                  child: ElevatedButton(
                    onPressed: () => verifyEmail(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                          vertical: MediaQuery.of(context).size.height * 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF0047FF),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Email Sent, Please check Email Spam',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.white),
        )),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email Not Found, Please Try Again!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.white,
            )),
      ));
      Navigator.of(context).pop();
    }
  }
}
