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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: const Text('Profile'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Full Name',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      enabled: true,
                      controller: _fullnameController,
                      decoration: InputDecoration(
                          hintText: nameHint,
                          prefixIcon: const Icon(Icons.person),
                          errorText: "Enter Something"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'Birthdate',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'Email',
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
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'Username',
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
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text('Password',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    const TextField(
                      decoration: InputDecoration(
                        enabled: false,
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
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
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _update();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FirstScreen()));
                                        },
                                        child: const Text('Proceed'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); //add another logic
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02),
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
                                color: Colors.white),
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
