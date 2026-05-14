// To parse this JSON data, do
//
//     final mySavingsModel = mySavingsModelFromJson(jsonString);

import 'dart:convert';

MySavingsModel mySavingsModelFromJson(String str) =>
    MySavingsModel.fromJson(json.decode(str));

String mySavingsModelToJson(MySavingsModel data) => json.encode(data.toJson());

class MySavingsModel {
  MySavingsModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory MySavingsModel.fromJson(Map<String, dynamic> json) => MySavingsModel(
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
    this.transactionId,
    this.brandName,
    this.outletName,
    this.offerTitle,
    this.offerImage,
    this.brandLogo,
    this.totalAmount,
    this.savedAmount,
    this.transactionDate,
    this.transactionStatus,
  });

  String? transactionId;
  String? brandName;
  String? outletName;
  String? offerTitle;
  dynamic offerImage;
  String? brandLogo;
  String? totalAmount;
  String? savedAmount;
  String? transactionDate;
  String? transactionStatus;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        outletName: json["outlet_name"] == null ? null : json["outlet_name"],
        offerTitle: json["offer_title"] == null ? null : json["offer_title"],
        offerImage: json["offer_image"],
        brandLogo: json["brand_logo"] == null ? null : json["brand_logo"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        savedAmount: json["saved_amount"] == null ? null : json["saved_amount"],
        transactionDate:
            json["transaction_date"] == null ? null : json["transaction_date"],
        transactionStatus: json["transaction_status"] == null
            ? null
            : json["transaction_status"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId == null ? null : transactionId,
        "brand_name": brandName == null ? null : brandName,
        "outlet_name": outletName == null ? null : outletName,
        "offer_title": offerTitle == null ? null : offerTitle,
        "offer_image": offerImage,
        "brand_logo": brandLogo == null ? null : brandLogo,
        "total_amount": totalAmount == null ? null : totalAmount,
        "saved_amount": savedAmount == null ? null : savedAmount,
        "transaction_date": transactionDate == null ? null : transactionDate,
        "transaction_status":
            transactionStatus == null ? null : transactionStatus,
      };
}
