// To parse this JSON data, do
//
//     final giftCardPurchaseListModel = giftCardPurchaseListModelFromJson(jsonString);

import 'dart:convert';

GiftCardPurchaseListModel giftCardPurchaseListModelFromJson(String str) =>
    GiftCardPurchaseListModel.fromJson(json.decode(str));

String giftCardPurchaseListModelToJson(GiftCardPurchaseListModel data) =>
    json.encode(data.toJson());

class GiftCardPurchaseListModel {
  GiftCardPurchaseListModel({
    this.message,
    this.code,
    this.status,
    this.objects,
    this.total,
    this.limit,
  });

  String? message;
  String? code;
  bool? status;
  List<Object>? objects;
  int? total;
  String? limit;

  factory GiftCardPurchaseListModel.fromJson(Map<String, dynamic> json) =>
      GiftCardPurchaseListModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        objects: json["objects"] == null
            ? null
            : List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        limit: json["limit"] == null ? null : json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "objects": objects == null
            ? null
            : List<dynamic>.from(objects!.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "limit": limit == null ? null : limit,
      };
}

class Object {
  Object({
    this.transactionId,
    this.productName,
    this.mobileImage,
    this.paymentType,
    this.denominationAmount,
    this.totalAmount,
    this.amountPaid,
    this.earnPoints,
    this.pointsRedeemed,
    this.giftcardUrl,
    this.receiverEmail,
    this.receiverMobile,
    this.purchasedDate,
    this.transactionType,
    this.transactionStatus,
    this.giftVerificatonPin,
    this.values,
    this.quantity,
  });

  String? transactionId;
  String? productName;
  String? mobileImage;
  String? paymentType;
  int? denominationAmount;
  int? totalAmount;
  int? amountPaid;
  int? earnPoints;
  int? pointsRedeemed;
  String? giftcardUrl;
  String? receiverEmail;
  String? receiverMobile;
  String? purchasedDate;
  String? transactionType;
  String? transactionStatus;
  String? giftVerificatonPin;
  List<Value>? values;
  int? quantity;

  factory Object.fromJson(Map<String, dynamic> json) => Object(
        transactionId:
            json["transaction_id"] == null ? "" : json["transaction_id"],
        productName: json["product_name"] == null ? '' : json["product_name"],
        mobileImage: json["mobile_image"] == null ? '' : json["mobile_image"],
        paymentType: json["payment_type"] == null ? '' : json["payment_type"],
        denominationAmount: json["denomination_amount"] == null
            ? null
            : json["denomination_amount"],
        totalAmount: json["total_amount"] == null ? '' : json["total_amount"],
        amountPaid: json["amount_paid"] == null ? '' : json["amount_paid"],
        earnPoints: json["earn_points"] == null ? '' : json["earn_points"],
        pointsRedeemed:
            json["points_redeemed"] == null ? '' : json["points_redeemed"],
        giftcardUrl: json["giftcard_url"] == null ? '' : json["giftcard_url"],
        receiverEmail:
            json["receiver_email"] == null ? '' : json["receiver_email"],
        receiverMobile:
            json["receiver_mobile"] == null ? '' : json["receiver_mobile"],
        purchasedDate:
            json["purchased_date"] == null ? '' : json["purchased_date"],
        transactionType:
            json["transaction_type"] == null ? '' : json["transaction_type"],
        transactionStatus: json["transaction_status"] == null
            ? ''
            : json["transaction_status"],
        giftVerificatonPin: json["gift_verification_pin"] == null
            ? ''
            : json["gift_verification_pin"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
        quantity: json["quantity"] == null ? '' : json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId == null ? '' : transactionId,
        "product_name": productName == null ? '' : productName,
        "mobile_image": mobileImage == null ? '' : mobileImage,
        "payment_type": paymentType == null ? '' : paymentType,
        "denomination_amount":
            denominationAmount == null ? '' : denominationAmount,
        "total_amount": totalAmount == null ? '' : totalAmount,
        "amount_paid": amountPaid == null ? '' : amountPaid,
        "earn_points": earnPoints == null ? '' : earnPoints,
        "points_redeemed": pointsRedeemed == null ? '' : pointsRedeemed,
        "giftcard_url": giftcardUrl == null ? '' : giftcardUrl,
        "receiver_email": receiverEmail == null ? '' : receiverEmail,
        "receiver_mobile": receiverMobile == null ? '' : receiverMobile,
        "purchased_date": purchasedDate == null ? '' : purchasedDate,
        "transaction_type": transactionType == null ? '' : transactionType,
        "transaction_status":
            transactionStatus == null ? '' : transactionStatus,
        "gift_verification_pin":
            giftVerificatonPin == null ? '' : giftVerificatonPin,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "quantity": quantity == null ? '' : quantity,
      };
}

class Value {
  Value({
    this.voucherCode,
    this.giftcardUrl,
  });

  String? voucherCode;
  String? giftcardUrl;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        voucherCode: json["voucher_code"] == null ? '' : json["voucher_code"],
        giftcardUrl: json["giftcard_url"] == null ? '' : json["giftcard_url"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_code": voucherCode == null ? '' : voucherCode,
        "giftcard_url": giftcardUrl == null ? '' : giftcardUrl,
      };
}
