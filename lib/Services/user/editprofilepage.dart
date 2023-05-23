//import 'package:ardu_illuminate/editPassword.dart';

import 'package:ardu_illuminate/Models/user_model.dart';
import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth/auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _fullnameController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  late Future<dynamic> futureUser;

  String uid = Auth().currentUser!.uid;
  String email = Auth().currentUser!.email!;

  void _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _update() async {
    try {
      Map<String, dynamic> data = {
        'name': _fullnameController.text,
        'birthdate':
            _selectedDate!.toIso8601String().substring(0, 10).toString(),
        'username': _usernameController.text,
      };

      await apiService().put("/users/update/$uid", data);
      // ignore: use_build_context_synchronously
    } catch (err) {
      throw Exception("Failed to update user $err");
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = apiService().get("/users/one/$uid");
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    final String? selectedDateFormatted =
        _selectedDate == null ? null : dateFormat.format(_selectedDate!);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error} occured'),
                );
              } else if (snapshot.hasData) {
                String nameHint = snapshot.data['name'];
                String emailHint = Auth().currentUser!.email!;
                String usernameHint = snapshot.data['username'];
                String birthdateHint = snapshot.data['birthdate'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Profile Details',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 0, 71, 255)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    TextField(
                      enabled: true,
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        hintText: nameHint,
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.00,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _presentDatePicker,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: birthdateHint,
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: 'Birthdate',
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                              text: selectedDateFormatted ?? ''),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.00,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      enabled: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: emailHint,
                        prefixIcon: const Icon(Icons.mark_email_read),
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.00,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: usernameHint,
                        enabled: true,
                        prefixIcon: const Icon(Icons.account_circle),
                        labelText: 'Username',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.00,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        enabled: false,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.00,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Credentials Update?',
                                      style: TextStyle(
                                        color: const Color(0xFF0047FF),
                                        fontFamily: 'Poppins',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                    ),
                                    content: const Text(
                                        'You are about to change details'),
                                    actions: <Widget> [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _update();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage(),
                                            ),
                                          );
                                        },
                                        child: const Text('Proceed'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF0047FF),
                            ),
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
          future: futureUser,
        ),
      ),
    );
  }
}
