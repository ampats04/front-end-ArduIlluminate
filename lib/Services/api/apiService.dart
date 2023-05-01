import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart';

// ignore: camel_case_types

const String baseUrl = "http://192.168.254.115:8000/api";

// ignore: camel_case_types
class apiService {
  var client = http.Client();

  Future<dynamic> post(
      String api, String password, String email, dynamic object) async {
    try {
      String uid = await Auth().register(
        email: email,
        password: password,
      );

      var url = Uri.parse(baseUrl + api);
      var payload = json.encode(object);
      var headers = {'Content-Type': 'application/json'};

      var response = await client.post(url, body: payload, headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Request failed with status code ${response.statusCode}');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to create user');
    } catch (error) {
      print(error);
      throw Exception('Failed to create user');
    }
  }

  Future<dynamic> put(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.put(url, body: payload, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("cannot update");
    }
  }
}
