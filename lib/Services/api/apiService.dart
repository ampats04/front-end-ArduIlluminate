import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: camel_case_types

const String baseUrl = "http://10.0.2.2:8000/api";

// ignore: camel_case_types
class apiService {
  var client = http.Client();

  Future<dynamic> get(String api) async {
    try {
      var response = await client.get(
        Uri.parse(baseUrl + api),
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
        },
      );

      if (response.statusCode == 200) {
        //resuest sucesss
        return json.decode(response.body);
      } else {
        // The request failed
        throw Exception('Failed to load data from server ${response.body}');
      }
    } catch (err) {
      throw Exception("Failed to Retrieve Creddentials $err");
    }
  }

  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var headers = {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache',
    };
    var payload = jsonEncode(object);

    var response = await client.post(url, headers: headers, body: payload);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to create account: ${response.body}");
    }
  }

  Future<dynamic> put(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache',
    };

    var response = await client.put(url, body: payload, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(
          "Error updating data. Status code: ${response.statusCode}. Body: ${response.body}");
      throw Exception("cannot update ${response.body}");
    }
  }
}
