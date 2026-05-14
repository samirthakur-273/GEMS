import 'dart:convert';

ReviewDetail reviewDetailFromJson(String str) =>
    ReviewDetail.fromJson(json.decode(str));

String reviewDetailToJson(ReviewDetail data) => json.encode(data.toJson());

class ReviewDetail {
  ReviewDetail({
    this.message,
    this.code,
    this.status,
    this.values,
    this.errors,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;
  String? errors;

  factory ReviewDetail.fromJson(Map<String, dynamic> json) => ReviewDetail(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
        errors: json["errors"] == null ? null : json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
        "errors": errors == null ? null : errors,
      };
}

class Values {
  Values({
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
  });

  String? transactionType;
  String? order;
  String? orderToken;
  bool? pgBypass;
  String? successUrl;
  String? pgDesignUrl;
  String? pgKey;
  String? brfNo;
  var partialAmount;
  var totalAmount;
  var redeemPoints;
  String? convRate;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
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
      );

  Map<String, dynamic> toJson() => {
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
      };
}
