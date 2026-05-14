// To parse this JSON data, do
//
//     final shippingAddress = shippingAddressFromJson(jsonString);

import 'dart:convert';

List<ShippingAddresss> shippingAddresssFromJson(String str) =>
    List<ShippingAddresss>.from(
        json.decode(str).map((x) => ShippingAddresss.fromJson(x)));

String shippingAddresssToJson(List<ShippingAddresss> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingAddresss {
  ShippingAddresss({
    this.success,
    this.message,
    this.address,
    this.totalCount,
  });

  String? success;
  String? message;
  List<Address>? address;
  int? totalCount;

  factory ShippingAddresss.fromJson(Map<String, dynamic> json) =>
      ShippingAddresss(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        address: json["address"] == null
            ? null
            : List<Address>.from(
                json["address"].map((x) => Address.fromJson(x))),
        totalCount: json["total_count"] == null ? null : int.tryParse(json["total_count"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "address": address == null
            ? null
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "total_count": totalCount == null ? null : totalCount,
      };
}

class Address {
  Address({
    this.addressId,
    this.firstname,
    this.lastname,
    this.address,
    this.area,
    this.city,
    this.countryId,
    this.countrycode,
    this.carrierCode,
    this.telephone,
    this.isdefault,
  });

  String? addressId;
  String? firstname;
  String? lastname;
  String? address;
  String? area;
  String? city;
  String? countryId;
  String? countrycode;
  String? carrierCode;
  String? telephone;
  int? isdefault;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addressId: json["address_id"] == null ? null : json["address_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        address: json["address"] == null ? null : json["address"],
        area: json["area"] == null ? null : json["area"],
        city: json["city"] == null ? null : json["city"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        countrycode: json["countrycode"] == null ? null : json["countrycode"],
        carrierCode: json["carrier_code"] == null ? null : json["carrier_code"],
        telephone: json["telephone"] == null ? null : json["telephone"],
        isdefault: json["isdefault"] == null ? null : json["isdefault"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId == null ? null : addressId,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "address": address == null ? null : address,
        "area": area == null ? null : area,
        "city": city == null ? null : city,
        "country_id": countryId == null ? null : countryId,
        "countrycode": countrycode == null ? null : countrycode,
        "carrier_code": carrierCode == null ? null : carrierCode,
        "telephone": telephone == null ? null : telephone,
        "isdefault": isdefault == null ? null : isdefault,
      };
}

// List<ShippingMethodModel> shippingMethodModelFromJson(String str) =>
//     List<ShippingMethodModel>.from(
//         json.decode(str).map((x) => ShippingMethodModel.fromJson(x)));

// String shippingMethodModelToJson(List<ShippingMethodModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingMethodModel {
  ShippingMethodModel({
    this.updateResponse,
    this.success,
    this.message,
    this.shipping,
  });
  bool? updateResponse;
  String? success;
  String? message;
  List<Shipping>? shipping;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      ShippingMethodModel(
        updateResponse:
            json['updateResponse'] == null ? null : json['updateResponse'],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        shipping: json["shippingmethods"] == null
            ? null
            : List<Shipping>.from(
                json["shippingmethods"].map((x) => Shipping.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "shippingmethods": shipping == null
            ? null
            : List<dynamic>.from(shipping!.map((x) => x.toJson())),
      };
}

class Shipping {
  Shipping({
    this.code,
    this.title,
    this.ammout,
  });

  String? code;
  String? title;
  String? ammout;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        code: json["code"] == null ? null : json["code"],
        title: json["title"] == null ? null : json["title"],
        ammout: json["ammout"] == null ? null : json["ammout"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "title": title == null ? null : title,
        "ammout": ammout == null ? null : ammout,
      };
}
