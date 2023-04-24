class UserModel {
  // ignore: non_constant_identifier_names
  String user_id;
  String name;
  String birthdate;
  String email;
  String username;
  String password;

  UserModel({
    // ignore: non_constant_identifier_names
    required this.user_id,
    required this.name,
    required this.birthdate,
    required this.email,
    required this.username,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      birthdate: json['birthdate'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }
}
