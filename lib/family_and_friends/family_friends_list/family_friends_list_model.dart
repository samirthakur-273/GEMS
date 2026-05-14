// To parse this JSON data, do
//
//     final familyFriendsListModel = familyFriendsListModelFromJson(jsonString);

import 'dart:convert';

FamilyFriendsListModel familyFriendsListModelFromJson(String str) =>
    FamilyFriendsListModel.fromJson(json.decode(str));

String familyFriendsListModelToJson(FamilyFriendsListModel data) =>
    json.encode(data.toJson());

class FamilyFriendsListModel {
  FamilyFriendsListModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory FamilyFriendsListModel.fromJson(Map<String, dynamic> json) =>
      FamilyFriendsListModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.referralDate,
    this.status,
    this.referralId,
    this.totalFnfAvailablePoints,
    this.type,
    this.countryCode,
  });

  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? referralDate;
  String? status;
  int? referralId;
  int? totalFnfAvailablePoints;
  String? type;
  String? countryCode;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        firstName: json["first_name"] == null ? '' : json["first_name"],
        lastName: json["last_name"] == null ? '' : json["last_name"],
        phone: json["phone"] == null ?'' : json["phone"],
        email: json["email"] == null ? '' : json["email"],
        referralDate:
            json["referral_date"] == null ? '' : json["referral_date"],
        status: json["status"] == null ? '' : json["status"],
        referralId: json["referral_id"] == null ? '' : json["referral_id"],
        totalFnfAvailablePoints: json["total_fnf_available_points"] == null
            ? ''
            : json["total_fnf_available_points"],
        type: json["type"] == null ? '' : json["type"],
        countryCode: json["country_code"] == null ? '' : json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName == null ? '' : firstName,
        "last_name": lastName == null ? '' : lastName,
        "phone": phone == null ? '' : phone,
        "email": email == null ? '' : email,
        "referral_date": referralDate == null ? '' : referralDate,
        "status": status == null ? '' : status,
        "referral_id": referralId == null ? '' : referralId,
        "total_fnf_available_points":
            totalFnfAvailablePoints == null ? '' : totalFnfAvailablePoints,
        "type": type == null ? '' : type,
        "country_code": countryCode == null ? '' : countryCode,
      };
}
