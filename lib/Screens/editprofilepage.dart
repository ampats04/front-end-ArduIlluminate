//import 'package:ardu_illuminate/editPassword.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
//import 'package:ardu_illuminate/passwordResetpage.dart';
//import 'package:ardu_illuminate/editprofile.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
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
              const TextField(
                enabled: true,
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
              const TextField(
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
              const TextField(
                enabled: true,
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
              const TextField(
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FirstScreen(),
                                      ),
                                    );
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
