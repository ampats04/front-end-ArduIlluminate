//import 'package:ardu_illuminate/editPassword.dart';

import 'package:ardu_illuminate/Models/user_model.dart';
import 'package:ardu_illuminate/Screens/userProfile.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth/auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override

  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fullnameController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  late Future<UserModel> futureUser;

  String uid = Auth().currentUser!.uid;
  String email = Auth().currentUser!.email!;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1900),
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
  void initState() {
    super.initState();
    futureUser = apiService().get("/users/one/$uid");
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    final String? selectedDateFormatted =
        _selectedDate == null ? null : dateFormat.format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error} occured'),
                );
              } else if (snapshot.hasData) {
                String nameHint = snapshot.data.name;
                String emailHint = Auth().currentUser!.email!;
                String usernameHint = snapshot.data.username;
                String birthdateHint =
                    snapshot.data.birthdate.toString().substring(0, 10);

                return Column(
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
                      enabled: true,
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        hintText: nameHint,
                        prefixIcon: const Icon(Icons.person),
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
                    GestureDetector(
                      onTap: _presentDatePicker,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: birthdateHint,
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                              text: selectedDateFormatted ?? ''),
                          keyboardType: TextInputType.datetime,
                        ),
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
                      enabled: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: emailHint,
                        prefixIcon: const Icon(Icons.mark_email_read),
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
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: usernameHint,
                        enabled: true,
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
                                        'You are about to change details'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            Map<String, dynamic> data = {
                                              'name': _fullnameController.text,
                                              'birthdate': _selectedDate!
                                                  .toIso8601String()
                                                  .substring(0, 10)
                                                  .toString(),
                                              'username':
                                                  _usernameController.text,
                                            };

                                            await apiService()
                                                .put("/users/update/$uid", data);
                                                // ignore: use_build_context_synchronously
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen()));
                                          } catch (err) {
                                            throw Exception(
                                                "Failed to update user $err");
                                          }
                                        },
                                        child: const Text('Proceed'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
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
