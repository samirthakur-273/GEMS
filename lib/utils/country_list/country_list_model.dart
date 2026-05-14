// To parse this JSON data, do
//
//     final countryListModel = countryListModelFromJson(jsonString);

import 'dart:convert';

CountryListModel countryListModelFromJson(String str) =>
    CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) =>
    json.encode(data.toJson());

class CountryListModel {
  CountryListModel({
    this.status,
    this.code,
    this.message,
    this.data,
    this.totalRecords,
  });

  bool? status;
  String? code;
  String? message;
  List<Datum>? data;
  int? totalRecords;

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalRecords:
            json["total_records"] == null ? null : json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_records": totalRecords == null ? null : totalRecords,
      };
}

class Datum {
  Datum({
    this.id,
    this.code,
    this.name,
    this.countryCode,
    this.mobileNoLength,
  });

  int? id;
  String? code;
  String? name;
  String? countryCode;
  var mobileNoLength;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        mobileNoLength:
            json["mobile_no_length"] == null ? null : json["mobile_no_length"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "country_code": countryCode == null ? null : countryCode,
        "mobile_no_length": mobileNoLength == null ? null : mobileNoLength,
      };
}
