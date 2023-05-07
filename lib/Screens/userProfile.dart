import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/user/editprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:ardu_illuminate/Models/user_model.dart';
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
  late Future<UserModel> futureUser;
  String uid = Auth().currentUser!.uid;
  String? email = Auth().currentUser!.email;

  @override
  void initState() {
    super.initState();
    futureUser = apiService().get("/users/one/$uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9D9D9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          backgroundColor: Color(0xFFD9D9D9),
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
                    _fullnameController.text = snapshot.data.name;
                    _emailController.text = email!;
                    _birthdateController.text =
                        snapshot.data.birthdate.toString().substring(0, 10);
                    _usernameController.text = snapshot.data.username;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Full Name',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _fullnameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          'Birthdate',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          enabled: isEditProfile,
                          controller: _birthdateController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
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
                          enabled: isEditProfile,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mark_email_read),
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
                            enabled: isEditProfile,
                            prefixIcon: const Icon(Icons.account_circle),
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
              future: futureUser)),
    );
  }
}
