import 'package:ardu_illuminate/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/user/editPass.dart';
import 'package:ardu_illuminate/Screens/light_details.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'view_logs.dart'; //

class DrawHeader extends StatefulWidget {
  const DrawHeader({Key? key}) : super(key: key);

  @override
  State<DrawHeader> createState() => _DrawHeaderState();
}

class _DrawHeaderState extends State<DrawHeader> {
  bool _darkMode = false;

  User? user = Auth().currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text(''),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Card(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                              ),
                              secondary: _darkMode
                                  ? const Icon(Icons.nights_stay)
                                  : const Icon(Icons.wb_sunny),
                              value: _darkMode,
                              onChanged: (bool value) {
                                setState(() {
                                  _darkMode = value;
                                });
                              },
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text(
                                'View Profile',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.list),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const FirstScreen()));
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text(
                                'Enlightening Details',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.lightbulb),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EnlighteningDetails()));
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text(
                                'Edit Password',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_square),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditPassword()));
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text(
                                'View Logs',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.data_exploration),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewLogsPage()),
                                  );
                                },
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text(
                                'Log out',
                                style: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.logout),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Logout Account?',
                                          style: TextStyle(
                                              color: Color(0xFF0047FF),
                                              fontFamily: 'Poppins',
                                              fontSize: 16),
                                        ),
                                        content: const Text(
                                            'Are you sure you want to log out?'),
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
                                              signOut();
                                            },
                                            child: const Text('Continue'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
