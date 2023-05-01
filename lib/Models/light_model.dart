import 'dart:convert';

List<LightModel> userFromJson(String str) =>
    List<LightModel>.from(json.decode(str).map((x) => LightModel.fromJson(x)));

String userToJson(List<LightModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LightModel {
  // ignore: non_constant_identifier_names

  LightModel({
    // ignore: non_constant_identifier_names
    this.light_id,
    this.model,
    this.manufacturer,
    this.installDate,
    this.powerCons,
  });
  // ignore: non_constant_identifier_names
  String? light_id;
  String? model;
  String? manufacturer;
  DateTime? installDate;
  String? powerCons;

  factory LightModel.fromJson(Map<String, dynamic> json) => LightModel(
        light_id: json['light_id'],
        model: json['model'],
        manufacturer: json['manufacturer'],
        installDate: DateTime.parse(json['install_date']),
        powerCons: json['power_cons'],
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "manufacturer": manufacturer,
        "instalL_date": installDate.toString(),
        "power_cons": powerCons
      };
}
