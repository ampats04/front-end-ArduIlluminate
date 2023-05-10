import 'package:ardu_illuminate/Screens/login.dart';
import 'package:ardu_illuminate/Services/user/editprofilepage.dart';
import 'package:ardu_illuminate/Services/user/legalBasis.dart';
import 'package:ardu_illuminate/Services/user/passReset.dart';
import 'package:ardu_illuminate/Services/user/wifiSetup.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/user/legalBasis.dart';
import 'package:ardu_illuminate/Screens/addLight.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'view_logs.dart';
import 'package:ardu_illuminate/Screens/lightProfile.dart';

class DrawHeader extends StatefulWidget {
  const DrawHeader({Key? key}) : super(key: key);

  @override
  State<DrawHeader> createState() => _DrawHeaderState();
}

class _DrawHeaderState extends State<DrawHeader> {
  User? user = Auth().currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MaterialApp(
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
            child: AppBar(
              title: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'View Profile',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
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
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'WI-FI setup',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(Icons.wifi_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NetworkSettingsPage()));
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'Enlightening Details',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(Icons.lightbulb),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EnlighteningDetailsView()));
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'Edit Password',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_square),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ResetPassword()));
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'View Logs',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.data_exploration),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ViewLogsPage()));
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListTile(
                              title: Text(
                                'Legal Basis',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.privacy_tip_rounded),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LegalBasis())); //this should be the legal basis section
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    ListTile(
                      title: Text(
                        'Log out',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Logout Account?',
                                  style: TextStyle(
                                      color: const Color(0xFF0047FF),
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
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
          ),
        ),
      ),
    );
  }
}
