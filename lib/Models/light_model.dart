import 'dart:convert';

List<LightModel> userFromJson(String str) =>
    List<LightModel>.from(json.decode(str).map((x) => LightModel.fromJson(x)));

String userToJson(List<LightModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LightModel {
  // ignore: non_constant_identifier_names

  LightModel({
    // ignore: non_constant_identifier_names
    this.user_id,
    this.model,
    this.manufacturer,
    this.installDate,
    this.watts,
  });
  // ignore: non_constant_identifier_names
  String? user_id;
  String? model;
  String? manufacturer;
  DateTime? installDate;
  double? watts;

  factory LightModel.fromJson(Map<String, dynamic> json) => LightModel(
        user_id: json['user_id'],
        model: json['model'],
        manufacturer: json['manufacturer'],
        installDate: DateTime.parse(json['install_date']),
        watts: json['watt'],
      );

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "model": model,
        "manufacturer": manufacturer,
        "instalL_date": installDate.toString(),
        "watt": watts
      };
}
