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
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Reset Password',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontFamily: 'Poppins'),
          ),
        ),
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
                          : email == null || email.isEmpty
                              ? '* Email is required'
                              : '* Enter a valid Email',
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
                        fontWeight: FontWeight.bold,
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
    BuildContext context = this.context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Email Sent',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Color(0xFF0047FF),
              ),
            ),
            content: Text(
              'Password reset link has been sucessfully delivered. Please check your email.',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: MediaQuery.of(context).size.width * 0.043),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.035,
                vertical: MediaQuery.of(context).size.height * 0.025),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.065,
                child: TextButton(
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF0047FF),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      print(e);
      Future.microtask(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Problem Occured',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color(0XFFD30000),
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            content: Text(
              'The email you entered isn’t connected to an account.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.035,
                vertical: MediaQuery.of(context).size.height * 0.025),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.065,
                child: TextButton(
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF0047FF),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      });
    }
  }
}
