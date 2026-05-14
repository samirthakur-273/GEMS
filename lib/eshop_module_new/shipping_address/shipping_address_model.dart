// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

List<CityModel> cityModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  CityModel({
    this.success,
    this.city,
    this.countryCode,
    this.carrierCode,
    this.customAddressType,
  });

  String? success;
  List<City>? city;
  List<CarrierCode>? countryCode;
  List<CarrierCode>? carrierCode;
  List<CarrierCode>? customAddressType;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        success: json["success"] == null ? null : json["success"],
        city: json["city"] == null
            ? null
            : List<City>.from(json["city"].map((x) => City.fromJson(x))),
        countryCode: json["country_code"] == null
            ? null
            : List<CarrierCode>.from(
                json["country_code"].map((x) => CarrierCode.fromJson(x))),
        carrierCode: json["carrier_code"] == null
            ? null
            : List<CarrierCode>.from(
                json["carrier_code"].map((x) => CarrierCode.fromJson(x))),
        customAddressType: json["custom_address_type"] == null
            ? null
            : List<CarrierCode>.from(json["custom_address_type"]
                .map((x) => CarrierCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "city": city == null
            ? null
            : List<dynamic>.from(city!.map((x) => x.toJson())),
        "country_code": countryCode == null
            ? null
            : List<dynamic>.from(countryCode!.map((x) => x.toJson())),
        "carrier_code": carrierCode == null
            ? null
            : List<dynamic>.from(carrierCode!.map((x) => x.toJson())),
        "custom_address_type": customAddressType == null
            ? null
            : List<dynamic>.from(customAddressType!.map((x) => x.toJson())),
      };
}

class CarrierCode {
  CarrierCode({
    this.id,
    this.code,
  });

  String? id;
  String? code;

  factory CarrierCode.fromJson(Map<String, dynamic> json) => CarrierCode(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
      };
}

class City {
  City({
    this.name,
  });

  String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}

List<AreaModel> areaModelFromJson(String str) =>
    List<AreaModel>.from(json.decode(str).map((x) => AreaModel.fromJson(x)));

String areaModelToJson(List<AreaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AreaModel {
  AreaModel({
    this.success,
    this.area,
  });

  String? success;
  List<Area>? area;

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        success: json["success"] == null ? null : json["success"],
        area: json["area"] == null
            ? null
            : List<Area>.from(json["area"].map((x) => Area.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "area": area == null
            ? null
            : List<dynamic>.from(area!.map((x) => x.toJson())),
      };
}

class Area {
  Area({
    this.name,
  });

  String? name;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}
