// To parse this JSON data, do
//
//     final paymentCardModel = paymentCardModelFromJson(jsonString);

import 'dart:convert';

PaymentCardModel paymentCardModelFromJson(String str) => PaymentCardModel.fromJson(json.decode(str));

String paymentCardModelToJson(PaymentCardModel data) => json.encode(data.toJson());

class PaymentCardModel {
  PaymentCardModel({
    this.success,
    this.orderId,
    this.redirectUrl,
    this.errorMessage,
  });

  bool? success;
  int? orderId;
  String? redirectUrl;
  List<dynamic>? errorMessage;

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) => PaymentCardModel(
    success: json["success"] == null ? null : json["success"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    redirectUrl: json["redirect_url"] == null ? null : json["redirect_url"],
    errorMessage: json["error_message"] == null ? null : List<dynamic>.from(json["error_message"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "order_id": orderId == null ? null : orderId,
    "redirect_url": redirectUrl == null ? null : redirectUrl,
    "error_message": errorMessage == null ? null : List<dynamic>.from(errorMessage!.map((x) => x)),
  };
}
