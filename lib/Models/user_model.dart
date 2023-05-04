import 'dart:convert';

List<UserModel> userFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  // ignore: non_constant_identifier_names

  UserModel({
    // ignore: non_constant_identifier_names
    this.user_id,
    this.name,
    this.birthdate,
    this.username,
  });
  // ignore: non_constant_identifier_names
  String? user_id;
  String? name;
  DateTime? birthdate;
  String? username;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user_id: json['user_id'],
        name: json['name'],
        birthdate: DateTime.parse(json['birthdate']),
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "name": name,
        "birthdate": birthdate.toString(),
        "username": username,
      };
}
