import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/user/editprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';

final TextEditingController _fullnameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _birthdateController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();

bool isEditProfile = false;

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<dynamic> futureUser;
  String? uid = Auth().currentUser?.uid;
  String? email = Auth().currentUser?.email;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getUser() {
    return apiService().get("/users/one/$uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          backgroundColor: const Color(0xFFD9D9D9),
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
                    _fullnameController.text = snapshot.data['name'];
                    _emailController.text = email!;
                    _birthdateController.text = snapshot.data['birthdate'];
                    _usernameController.text = snapshot.data['username'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _fullnameController,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.00,
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _birthdateController,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Birthdate',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_month),
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
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _emailController,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
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
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _usernameController,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_2),
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
                                            color: Color(0xFF0047FF),
                                            fontFamily: 'Poppins',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                        ),
                                        content: const Text(
                                            'Do you want to update credentials?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isEditProfile = false;
                                              });
                                              // ignore: use_build_context_synchronously
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
                                            child: const Text('Yes'),
                                          )
                                        ],
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: const Color(0xFF0047FF),
                              ),
                              child: Text(
                                'EDIT PROFILE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
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
              future: getUser())),
    );
  }
}
