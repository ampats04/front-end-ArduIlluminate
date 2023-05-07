import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:ardu_illuminate/Services/user/passReset.dart';
import 'package:ardu_illuminate/Services/user/passReset.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ardu_illuminate/Services/user/createAcc.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

// ignore: must_be_immutable
class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    try {
      
      await Auth().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/ardu-ulliminate.png',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your Username";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.perm_identity_sharp),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,

                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 8
                    ? 'Enter min. 8 characters'
                    : null,

                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "Please enter your password";
                //   } else {
                //     return null;
                //   }
                // },
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_open_rounded),
                  suffixIcon: Icon(Icons.remove_red_eye),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.09),
                    child: ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color(0xFF0047FF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Forgot Password? ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Click here',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 2, 137, 247),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Column(
                    children: [
                      Text(
                        "Still don't have an account?",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign-up Here!',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 3, 137, 247),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
