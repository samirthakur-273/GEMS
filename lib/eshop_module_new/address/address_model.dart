// To parse this JSON data, do
//
//     final customerAddressModel = customerAddressModelFromJson(jsonString);

import 'dart:convert';

List<CustomerAddressModel> customerAddressModelFromJson(String str) =>
    List<CustomerAddressModel>.from(
        json.decode(str).map((x) => CustomerAddressModel.fromJson(x)));

String customerAddressModelToJson(List<CustomerAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerAddressModel {
  CustomerAddressModel({
    required this.success,
    this.message,
  });

  String success;
  var message;

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) =>
      CustomerAddressModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}

List<DeleteAddressModel> deleteAddressModelFromJson(String str) =>
    List<DeleteAddressModel>.from(
        json.decode(str).map((x) => DeleteAddressModel.fromJson(x)));

String deleteAddressModelToJson(List<DeleteAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeleteAddressModel {
  DeleteAddressModel({
    required this.success,
    required this.message,
  });

  String success;
  String message;

  factory DeleteAddressModel.fromJson(Map<String, dynamic> json) =>
      DeleteAddressModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}

List<AddAddressModel> addAddressModelFromJson(String str) =>
    List<AddAddressModel>.from(
        json.decode(str).map((x) => AddAddressModel.fromJson(x)));

String addAddressModelToJson(List<AddAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddAddressModel {
  AddAddressModel({
    required this.success,
    required this.message,
  });

  String success;
  String message;

  factory AddAddressModel.fromJson(Map<String, dynamic> json) =>
      AddAddressModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
