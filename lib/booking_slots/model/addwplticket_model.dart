// To parse this JSON data, do
//
//     final addWplModel = addWplModelFromJson(jsonString);

import 'dart:convert';

AddWplModel addWplModelFromJson(String str) => AddWplModel.fromJson(json.decode(str));

String addWplModelToJson(AddWplModel data) => json.encode(data.toJson());

class AddWplModel {
  bool status;
  String message;
  String statusCode;
  Values values;

  AddWplModel({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.values,
  });

  factory AddWplModel.fromJson(Map<String, dynamic> json) => AddWplModel(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    values: Values.fromJson(json["values"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "values": values.toJson(),
  };
}

class Values {
  String email;
  String firstName;
  String lastName;
  DateTime wplDate;
  String showWplDate;

  Values({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.wplDate,
    required this.showWplDate,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    wplDate: DateTime.parse(json["wpl_date"]),
    showWplDate: json["show_wpl_date"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "wpl_date": "${wplDate.year.toString().padLeft(4, '0')}-${wplDate.month.toString().padLeft(2, '0')}-${wplDate.day.toString().padLeft(2, '0')}",
    "show_wpl_date": showWplDate,
  };
}
