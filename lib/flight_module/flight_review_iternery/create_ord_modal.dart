// To parse this JSON data, do
//
//     final flightCreateOrderModal = flightCreateOrderModalFromJson(jsonString);

import 'dart:convert';

FlightCreateOrderModal flightCreateOrderModalFromJson(String str) =>
    FlightCreateOrderModal.fromJson(json.decode(str));

String flightCreateOrderModalToJson(FlightCreateOrderModal data) =>
    json.encode(data.toJson());

class FlightCreateOrderModal {
  FlightCreateOrderModal({
    this.message,
    this.code,
    this.status,
    this.values,
    this.error,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;
  Error? error;

  factory FlightCreateOrderModal.fromJson(Map<String, dynamic> json) =>
      FlightCreateOrderModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
        "error": error == null ? null : error!.toJson(),
      };
}
class Error {
  Error({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}

class Values {
  Values({
    this.status,
    this.transactionType,
    this.order,
    this.orderToken,
    this.pgBypass,
    this.successUrl,
    this.pgDesignUrl,
    this.pgKey,
    this.brfNo,
    this.partialAmount,
    this.totalAmount,
    this.redeemPoints,
    this.convRate,
    this.convFees,
    this.priceChanged,
    this.newamount,
    this.oldamount,
  });

  bool? status;
  String? transactionType;
  String? order;
  String? orderToken;
  bool? pgBypass;
  String? successUrl;
  String? pgDesignUrl;
  String? pgKey;
  String? brfNo;
  int? partialAmount;
  int? totalAmount;
  int? redeemPoints;
  String? convRate;
  int? convFees;
  String? priceChanged;
  int? newamount;
  int? oldamount;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        status: json["status"] == null ? null : json["status"],
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
        order: json["order"] == null ? null : json["order"],
        orderToken: json["order_token"] == null ? null : json["order_token"],
        pgBypass: json["pg_bypass"] == null ? null : json["pg_bypass"],
        successUrl: json["success_url"] == null ? null : json["success_url"],
        pgDesignUrl:
            json["pg_design_url"] == null ? null : json["pg_design_url"],
        pgKey: json["pg_key"] == null ? null : json["pg_key"],
        brfNo: json["brf_no"] == null ? null : json["brf_no"],
        partialAmount:
            json["partialAmount"] == null ? null : json["partialAmount"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        redeemPoints:
            json["redeemPoints"] == null ? null : json["redeemPoints"],
        convRate: json["convRate"] == null ? null : json["convRate"].toString(),
        convFees: json["convFees"] == null ? null : json["convFees"],
        priceChanged:
            json["price_changed"] == null ? null : json["price_changed"],
        newamount: json["newamount"] == null ? null : json["newamount"],
        oldamount: json["oldamount"] == null ? null : json["oldamount"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "transaction_type": transactionType == null ? null : transactionType,
        "order": order == null ? null : order,
        "order_token": orderToken == null ? null : orderToken,
        "pg_bypass": pgBypass == null ? null : pgBypass,
        "success_url": successUrl == null ? null : successUrl,
        "pg_design_url": pgDesignUrl == null ? null : pgDesignUrl,
        "pg_key": pgKey == null ? null : pgKey,
        "brf_no": brfNo == null ? null : brfNo,
        "partialAmount": partialAmount == null ? null : partialAmount,
        "totalAmount": totalAmount == null ? null : totalAmount,
        "redeemPoints": redeemPoints == null ? null : redeemPoints,
        "convRate": convRate == null ? null : convRate.toString(),
        "convFees": convFees == null ? null : convFees,
        "price_changed": priceChanged == null ? null : priceChanged,
        "newamount": newamount == null ? null : newamount,
        "oldamount": oldamount == null ? null : oldamount,
      };
}
