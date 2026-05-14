// To parse this JSON data, do
//
//     final checkoutModel = checkoutModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final checkoutModel = checkoutModelFromJson(jsonString);

import 'dart:convert';

List<CheckoutModel> checkoutModelFromJson(String str) =>
    List<CheckoutModel>.from(
        json.decode(str).map((x) => CheckoutModel.fromJson(x)));

String checkoutModelToJson(List<CheckoutModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckoutModel {
  CheckoutModel({
    this.success,
    this.orderId,
    this.orderIncrementid,
    this.message,
    this.reference,
    this.url,
  });

  String? success;
  String? orderId;
  String? orderIncrementid;
  String? message;
  String? reference;
  String? url;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
        success: json["success"] == null ? null : json["success"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        orderIncrementid: json["order_incrementid"] == null
            ? null
            : json["order_incrementid"],
        message: json["message"] == null ? null : json["message"],
        reference: json["reference"] == null ? null : json["reference"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "order_id": orderId == null ? null : orderId,
        "order_incrementid": orderIncrementid == null ? null : orderIncrementid,
        "message": message == null ? null : message,
        "reference": reference == null ? null : reference,
        "url": url == null ? null : url,
      };
}

List<PaymentMethodModel> paymentMethodModelFromJson(String str) =>
    List<PaymentMethodModel>.from(
        json.decode(str).map((x) => PaymentMethodModel.fromJson(x)));

String paymentMethodModelToJson(List<PaymentMethodModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMethodModel {
  PaymentMethodModel({
    this.success,
    this.message,
    this.shippingmethods,
  });

  String? success;
  String? message;
  List<Paymentmethod> ?shippingmethods;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        shippingmethods: json["shippingmethods"] == null
            ? null
            : List<Paymentmethod>.from(
                json["shippingmethods"].map((x) => Paymentmethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "shippingmethods": shippingmethods == null
            ? null
            : List<dynamic>.from(shippingmethods!.map((x) => x.toJson())),
      };
}

class Paymentmethod {
  Paymentmethod({
    this.code,
    this.title,
  });

  String ?code;
  String ?title;

  factory Paymentmethod.fromJson(Map<String, dynamic> json) => Paymentmethod(
        code: json["code"] == null ? null : json["code"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "title": title == null ? null : title,
      };
}

List<StoreCreditModel> storeCreditModelFromJson(String str) =>
    List<StoreCreditModel>.from(
        json.decode(str).map((x) => StoreCreditModel.fromJson(x)));

String storeCreditModelToJson(List<StoreCreditModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreCreditModel {
  StoreCreditModel({
    this.success,
  });

  String ?success;

  factory StoreCreditModel.fromJson(Map<String, dynamic> json) =>
      StoreCreditModel(
        success: json["success"] == null ? null : json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
      };
}

List<OrderStatusModel> orderStatusModelFromJson(String str) =>
    List<OrderStatusModel>.from(
        json.decode(str).map((x) => OrderStatusModel.fromJson(x)));

String orderStatusModelToJson(List<OrderStatusModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderStatusModel {
  OrderStatusModel({
    this.success,
    this.message,
  });

  String ?success;
  String ?message;

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) =>
      OrderStatusModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
