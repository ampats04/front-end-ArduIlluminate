// ignore_for_file: library_private_types_in_public_api

import 'package:ardu_illuminate/Screens/homePage.dart';
import 'package:ardu_illuminate/Screens/login.dart';
import 'package:ardu_illuminate/Screens/mainPage.dart';
import 'package:ardu_illuminate/Services/api/apiService.dart';
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:ardu_illuminate/Services/user/legalBasis.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  int _activeCurrentStep = 0;
  final bool _isEditable = true;
  bool passwordVisible = false;
  //User Registration
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Wifi setup
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController wifiPassController = TextEditingController();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final String ssidPath = '/network/ssid';
  final String passwordPath = '/network/password';
  bool isConnecting = false;

  DateTime? _selectedDate;
  UserCredential? credential;
  bool isLogin = true;
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1950),
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

  void _wifiUpdate() async {
    final ssid = ssidController.text;
    final password = wifiPassController.text;
    setState(() {
      isConnecting = true;
    });

    await databaseReference.child(ssidPath).set(ssid);
    await databaseReference.child(passwordPath).set(password);
  }

  String? get selectedDateFormatted {
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    return _selectedDate == null ? null : dateFormat.format(_selectedDate!);
  }

  //
  //Light Registration
  TextEditingController bulbController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController wattController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDateLight;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDateLight = pickedDate;
      });
    });
  }

  String? get selectedDateFormattedLight {
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    return _selectedDateLight == null
        ? null
        : dateFormat.format(_selectedDateLight!);
  }

  void _registerUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      final Map<String, dynamic> userData = {
        'user_id': uid,
        'name': fullNameController.text,
        'birthdate':
            _selectedDate!.toIso8601String().substring(0, 10).toString(),
        'username': usernameController.text,
      };

      await apiService().post("/users/add", userData);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));

      // ignore: use_build_context_synchronously
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //logic para sa weak pass
      } else if (e.code == 'email-already-in-use') {
        //logic paras less email
      }
    } catch (e) {
      print("Failed to create account: $e");
    }
  }

  void _registerLight() async {
    try {
      final Map<String, dynamic> lightData = {
        'user_id': Auth().currentUser?.uid,
        'model': bulbController.text,
        'manufacturer': manufacturerController.text,
        'install_date':
            _selectedDateLight!.toIso8601String().substring(0, 10).toString(),
        'watt': wattController.text,
      };

      await apiService().post("/light/add", lightData);
    } catch (e) {
      print("Error message $e");
    }
  }

  bool _agreeToTermsAndPrivacy = false;

  bool _validateFields() {
    if (fullNameController.text.isEmpty) {
      return false;
    }
    if (_selectedDate == null) {
      return false;
    }
    if (emailController.text.isEmpty ||
        !EmailValidator.validate(emailController.text)) {
      return false;
    }
    if (usernameController.text.isEmpty) {
      return false;
    }
    if (passwordController.text.length < 6) {
      return false;
    }
    if (!_agreeToTermsAndPrivacy) {
      return false;
    }

    return true;
  }

  bool _validatorfield() {
    if (bulbController.text.isEmpty) {
      return false;
    }
    if (manufacturerController.text.isEmpty) {
      return false;
    }
    if (wattController.text.isEmpty) {
      return false;
    }
    if (_selectedDateLight == null) {
      return false;
    }

    return true;
  }

  bool _wifivalidator() {
    return (ssidController.text.isEmpty && wifiPassController.text.isEmpty)
        ? false
        : true;
  }

  List<Step> stepList() => [
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Account'),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
            child: Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  TextFormField(
                    controller: fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Full Name is Required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Full Name',
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  GestureDetector(
                    onTap: _presentDatePicker,
                    child: AbsorbPointer(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Birthdate is Required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Birthdate',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                            text: selectedDateFormatted ?? ''),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.00),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    validator: (value) =>
                        value != null && EmailValidator.validate(value)
                            ? null
                            : value == null || value.isEmpty
                                ? '* Email is required'
                                : '* Enter a valid Email',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.00),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  TextFormField(
                    controller: usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is Required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.perm_identity_sharp),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.00),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter a minimum of 6 characters'
                        : null,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _agreeToTermsAndPrivacy,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTermsAndPrivacy = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LegalBasis(),
                            ),
                          );
                        },
                        child: Text(
                          "By signing up, you agree to our \nTerms of use and Data Policy.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontFamily: 'Poppins',
                            color: const Color(0xFF0047FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: const Text('Light Bulb'),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: bulbController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Bulb Model',
                    border: OutlineInputBorder(),
                    labelText: 'Model',
                    prefixIcon: Icon(Icons.lightbulb),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: manufacturerController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Bulb Manufacturer',
                    labelText: 'Manufacturer',
                    prefixIcon: Icon(Icons.precision_manufacturing),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Enter Watt Output';
                    }
                    return null;
                  },
                  controller: wattController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Wattage',
                    hintText: 'Bulb Wattage',
                    prefixIcon: Icon(Icons.electric_bolt_outlined),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: _showDatePicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Installation Date is Required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Installation Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                          text: selectedDateFormattedLight ?? ''),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 2,
          title: const Text('Wifi Setup'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
              TextFormField(
                controller: ssidController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is Required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your SSID',
                  prefixIcon: Icon(Icons.wifi),
                  labelText: 'SSID',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Text(
                '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
              TextFormField(
                controller: wifiPassController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is Required";
                  }
                  return null;
                },
                obscureText: !passwordVisible, // Add this line
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeCurrentStep >= 3,
          title: const Text('Confirm'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'Create Account',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFD9D9D9),
        ),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeCurrentStep,
        steps: stepList(),
        onStepContinue: () {
          if (_activeCurrentStep < (stepList().length - 1)) {
            if (_activeCurrentStep == 0) {
              _registerUser();
            } else if (_activeCurrentStep == 1) {
              _registerLight();
            } else if (_activeCurrentStep == 2) {
              _wifiUpdate();
            }

            if (_validateFields() || _validatorfield() || _wifivalidator()) {
              setState(() {
                _activeCurrentStep += 1;
              });
            }
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        onStepCancel: () {
          if (_activeCurrentStep == 0) {
            return;
          }

          setState(() {
            _activeCurrentStep -= 1;
          });
        },
        onStepTapped: (int index) {
          if (_validateFields() || _validatorfield()) {
            setState(() {
              _activeCurrentStep = index;
            });
          }
        },
      ),
    );
  }
}
