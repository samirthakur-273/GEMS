// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.type,
    this.token,
    this.expiresOn,
    this.expiryMonth,
    this.expiryYear,
    this.scheme,
    this.last4,
    this.bin,
    this.cardType,
    this.cardCategory,
    this.issuer,
    this.issuerCountry,
    this.productId,
    this.productType,
    this.requestId,
    this.errorType,
    this.errorCodes,
  });

  String? type;
  String? token;
  DateTime? expiresOn;
  int? expiryMonth;
  int? expiryYear;
  String? scheme;
  String? last4;
  String? bin;
  String? cardType;
  String? cardCategory;
  String? issuer;
  String? issuerCountry;
  String? productId;
  String? productType;
  String? requestId;
  String? errorType;
  List<String>? errorCodes;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        type: json["type"] == null ? null : json["type"],
        token: json["token"] == null ? null : json["token"],
        expiresOn: json["expires_on"] == null
            ? null
            : DateTime.parse(json["expires_on"]),
        expiryMonth: json["expiry_month"] == null ? null : json["expiry_month"],
        expiryYear: json["expiry_year"] == null ? null : json["expiry_year"],
        scheme: json["scheme"] == null ? null : json["scheme"],
        last4: json["last4"] == null ? null : json["last4"],
        bin: json["bin"] == null ? null : json["bin"],
        cardType: json["card_type"] == null ? null : json["card_type"],
        cardCategory:
            json["card_category"] == null ? null : json["card_category"],
        issuer: json["issuer"] == null ? null : json["issuer"],
        issuerCountry:
            json["issuer_country"] == null ? null : json["issuer_country"],
        productId: json["product_id"] == null ? null : json["product_id"],
        productType: json["product_type"] == null ? null : json["product_type"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        errorType: json["error_type"] == null ? null : json["error_type"],
        errorCodes: json["error_codes"] == null
            ? null
            : List<String>.from(json["error_codes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "token": token == null ? null : token,
        "expires_on": expiresOn == null ? null : expiresOn!.toIso8601String(),
        "expiry_month": expiryMonth == null ? null : expiryMonth,
        "expiry_year": expiryYear == null ? null : expiryYear,
        "scheme": scheme == null ? null : scheme,
        "last4": last4 == null ? null : last4,
        "bin": bin == null ? null : bin,
        "card_type": cardType == null ? null : cardType,
        "card_category": cardCategory == null ? null : cardCategory,
        "issuer": issuer == null ? null : issuer,
        "issuer_country": issuerCountry == null ? null : issuerCountry,
        "product_id": productId == null ? null : productId,
        "product_type": productType == null ? null : productType,
        "request_id": requestId == null ? null : requestId,
        "error_type": errorType == null ? null : errorType,
        "error_codes": errorCodes == null
            ? null
            : List<dynamic>.from(errorCodes!.map((x) => x)),
      };
}
