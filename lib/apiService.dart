import 'dart:convert';
import 'package:http/http.dart' as http;
import './Authentication/auth.dart';

// ignore: camel_case_types

const String baseUrl = "http://192.168.254.115:8000/api/users";

// ignore: camel_case_types
class apiService {
  var client = http.Client();

  // Future<dynamic> get(String api) async {
  //   var url = Uri.parse(baseUrl + api);

  //   var headers = {'Content-Type': 'application/json'};

  //   var response = await client.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception("Cannot retrieve user credentials");
  //   }
  // }

  // Future<dynamic> post(String api, dynamic object) async {
  //   var url = Uri.parse(baseUrl + api);
  //   var payload = json.encode(object);
  //   var headers = {
  //     'Content-Type': 'application/json',
  //   };

  //   var response = await client.post(url, body: payload, headers: headers);
  //   if (response.statusCode == 201) {
  //     return response.body;
  //   } else {
  //     throw Exception("Cannot add user");
  //   }
  // }

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
      throw Exception("cannot update user");
    }
  }
}
