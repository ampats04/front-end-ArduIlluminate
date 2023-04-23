//import 'package:ardu_illuminate/passwordResetpage.dart';
import 'package:ardu_illuminate/Screens/editprofilepage.dart';
//import 'package:ardu_illuminate/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Account/editPass.dart';

bool isEditProfile = false;

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
            TextField(
              enabled: isEditProfile,
              decoration: const InputDecoration(
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
              enabled: isEditProfile,
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
              decoration: InputDecoration(
                enabled: isEditProfile,
                hintText: 'Jeremy_Andy',
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
                                onPressed: () {
                                  setState(() {
                                    isEditProfile = false;
                                  });
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
