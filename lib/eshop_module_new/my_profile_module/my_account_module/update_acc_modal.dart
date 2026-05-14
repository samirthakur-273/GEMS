// To parse this JSON data, do
//
//     final updateDataModal = updateDataModalFromMap(jsonString);

import 'dart:convert';

List<UpdateDataModal> updateDataModalFromMap(String str) =>
    List<UpdateDataModal>.from(
        json.decode(str).map((x) => UpdateDataModal.fromMap(x)));

String updateDataModalToMap(List<UpdateDataModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class UpdateDataModal {
  UpdateDataModal({
    this.success,
    this.message,
    this.customer,
  });

  String ?success;
  String ?message;
  Customers? customer;

  factory UpdateDataModal.fromMap(Map<String, dynamic> json) => UpdateDataModal(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        customer: json["customer"] == null
            ? null
            : Customers.fromMap(json["customer"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "customer": customer == null ? null : customer!.toMap(),
      };
}

class Customers {
  Customers({
    this.email,
    this.lastName,
    this.firstName,
    this.fullName,
  });

  String ?email;
  String ?lastName;
  String ?firstName;
  String ?fullName;

  factory Customers.fromMap(Map<String, dynamic> json) => Customers(
        email: json["email"] == null ? null : json["email"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        fullName: json["fullName"] == null ? null : json["fullName"],
      );

  Map<String, dynamic> toMap() => {
        "email": email == null ? null : email,
        "lastName": lastName == null ? null : lastName,
        "firstName": firstName == null ? null : firstName,
        "fullName": fullName == null ? null : fullName,
      };
}
