// To parse this JSON data, do
//
//     final flightSearchCityModel = flightSearchCityModelFromMap(jsonString);

import 'dart:convert';

FlightSearchCityModel flightSearchCityModelFromJson(String str) =>
    FlightSearchCityModel.fromJson(json.decode(str));

String flightSearchCityModelToJson(FlightSearchCityModel data) =>
    json.encode(data.toJson());

class FlightSearchCityModel {
  FlightSearchCityModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory FlightSearchCityModel.fromJson(Map<String, dynamic> json) =>
      FlightSearchCityModel(
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
    this.airportName,
    this.airportCode,
    this.cityName,
    this.cityCode,
    this.countryName,
    this.countryCode,
    this.popularCity,
  });

  String? airportName;
  String? airportCode;
  String? cityName;
  String? cityCode;
  String? countryName;
  String? countryCode;
  int? popularCity;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        airportName: json["AIRPORT_NAME"] == null ? null : json["AIRPORT_NAME"],
        airportCode: json["AIRPORT_CODE"] == null ? null : json["AIRPORT_CODE"],
        cityName: json["CITY_NAME"] == null ? null : json["CITY_NAME"],
        cityCode: json["CITY_CODE"] == null ? null : json["CITY_CODE"],
        countryName: json["COUNTRY_NAME"] == null ? null : json["COUNTRY_NAME"],
        countryCode: json["COUNTRY_CODE"] == null ? null : json["COUNTRY_CODE"],
        popularCity: json["POPULAR_CITY"] == null ? null : json["POPULAR_CITY"],
      );

  Map<String, dynamic> toJson() => {
        "AIRPORT_NAME": airportName == null ? null : airportName,
        "AIRPORT_CODE": airportCode == null ? null : airportCode,
        "CITY_NAME": cityName == null ? null : cityName,
        "CITY_CODE": cityCode == null ? null : cityCode,
        "COUNTRY_NAME": countryName == null ? null : countryName,
        "COUNTRY_CODE": countryCode == null ? null : countryCode,
        "POPULAR_CITY": popularCity == null ? null : popularCity,
      };
}
