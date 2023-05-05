//import 'package:ardu_illuminate/editPassword.dart';

import 'package:ardu_illuminate/Models/user_model.dart';

import 'package:ardu_illuminate/Services/api/apiService.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
  void initState(){

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
      body: const SingleChildScrollView(
         child: Center(
            child: Padding(
          padding: const EdgeInsets.all(30),
      
        child: FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot){


        },
        future: futureUser,
        ),

        ),
         ),
    ),);
  }
}
