// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart';
import '../Model/user_model.dart';

class HttpService {
  final String postsURL = "10.0.2.2:8000/api";

  Future<List<UserModel>> getUsers() async {
    Response res = await get(Uri.parse(postsURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<UserModel> user = body
          .map(
            (dynamic item) => UserModel.fromJson(item),
          )
          .toList();

      return user;
    } else {
      throw "Unable to retrieve users.";
    }
  }
}
