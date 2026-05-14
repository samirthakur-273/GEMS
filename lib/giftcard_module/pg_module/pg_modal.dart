// To parse this JSON data, do
//
//     final giftPgModal = giftPgModalFromJson(jsonString);

import 'dart:convert';

GiftPgModal giftPgModalFromJson(String str) =>
    GiftPgModal.fromJson(json.decode(str));

String giftPgModalToJson(GiftPgModal data) => json.encode(data.toJson());

class GiftPgModal {
  GiftPgModal({
    this.message,
    this.code,
    this.status,
    this.objects,
    this.transactionType,
    this.giftVerificationPin,
    this.productName,
    this.mobileImage,
    this.paymentType,
    this.denominationAmount,
    this.quantity,
    this.totalAmount,
    this.amountPaid,
    this.earnPoints,
    this.pointsRedeemed,
    this.receiverEmail,
    this.receiverMobile,
  });

  String? message;
  String? code;
  bool? status;
  Objects? objects;
  String? transactionType;
  String? giftVerificationPin;
  String? productName;
  String? mobileImage;
  String? paymentType;
  int? denominationAmount;
  int? quantity;
  int? totalAmount;
  int? amountPaid;
  int? earnPoints;
  int? pointsRedeemed;
  String? receiverEmail;
  String? receiverMobile;

  factory GiftPgModal.fromJson(Map<String, dynamic> json) => GiftPgModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null || json["status"] == false
            ? null
            : json["status"],
        objects:
            json["objects"] == null ? null : Objects.fromJson(json["objects"]),
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
        giftVerificationPin:
            json["gift_verification_pin"] == null ? null : json["gift_verification_pin"],
        productName: json["product_name"] == null ? null : json["product_name"],
        mobileImage: json["mobile_image"] == null ? null : json["mobile_image"],
        paymentType: json["payment_type"] == null ? null : json["payment_type"],
        denominationAmount: json["denomination_amount"] == null
            ? null
            : json["denomination_amount"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
        earnPoints: json["earn_points"] == null ? null : json["earn_points"],
        pointsRedeemed:
            json["points_redeemed"] == null ? null : json["points_redeemed"],
        receiverEmail:
            json["receiver_email"] == null ? '' : json["receiver_email"],
        receiverMobile:
            json["receiver_mobile"] == null ? '' : json["receiver_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "objects": objects == null ? null : objects!.toJson(),
        "transaction_type": transactionType == null ? null : transactionType,
        "gift_verification_pin": giftVerificationPin == null ? null : giftVerificationPin,
        "product_name": productName == null ? null : productName,
        "mobile_image": mobileImage == null ? null : mobileImage,
        "payment_type": paymentType == null ? null : paymentType,
        "denomination_amount":
            denominationAmount == null ? null : denominationAmount,
        "quantity": quantity == null ? null : quantity,
        "total_amount": totalAmount == null ? null : totalAmount,
        "amount_paid": amountPaid == null ? null : amountPaid,
        "earn_points": earnPoints == null ? null : earnPoints,
        "points_redeemed": pointsRedeemed == null ? null : pointsRedeemed,
        "receiver_email": receiverEmail == null ? '' : receiverEmail,
        "receiver_mobile": receiverMobile == null ? '' : receiverMobile,
      };
}

class Objects {
  Objects({
    this.transactionId,
    this.transactionType,
    this.pgOrder,
    this.status,
    this.code,
    this.message,
    this.errorMessage,
    this.values,
  });

  String? transactionId;
  String? transactionType;
  PgOrder? pgOrder;
  String? status;
  int? code;
  String? message;
  List<dynamic>? errorMessage;
  List<Value>? values;

  factory Objects.fromJson(Map<String, dynamic> json) => Objects(
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
        pgOrder: json["pg_order"] == null
            ? null
            : PgOrder.fromJson(json["pg_order"]),
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        errorMessage: json["error_message"] == null
            ? null
            : List<dynamic>.from(json["error_message"].map((x) => x)),
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId == null ? null : transactionId,
        "transaction_type": transactionType == null ? null : transactionType,
        "pg_order": pgOrder == null ? null : pgOrder!.toJson(),
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "error_message": errorMessage == null
            ? null
            : List<dynamic>.from(errorMessage!.map((x) => x)),
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PgOrder {
  PgOrder({
    this.status,
    this.url,
  });

  bool? status;
  String? url;

  factory PgOrder.fromJson(Map<String, dynamic> json) => PgOrder(
        status: json["status"] == null ? null : json["status"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "url": url == null ? null : url,
      };
}

class Value {
  Value({
    this.voucherCode,
    this.giftcardUrl,
    this.expirationDate,
  });

  String? voucherCode;
  String? giftcardUrl;
  String? expirationDate;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
      voucherCode: json["voucher_code"] == null ? null : json["voucher_code"],
      giftcardUrl: json["giftcard_url"] == null ? null : json["giftcard_url"],
      expirationDate: json["expiration_date"] == null
          ? null
          : json["expiration_date"]
      );

  Map<String, dynamic> toJson() => {
        "voucher_code": voucherCode == null ? null : voucherCode,
        "giftcard_url": giftcardUrl == null ? null : giftcardUrl,
        "expiration_date": expirationDate == null
            ? null
            : expirationDate //"${expirationDate!.year.toString().padLeft(4, '0')}-${expirationDate!.month.toString().padLeft(2, '0')}-${expirationDate!.day.toString().padLeft(2, '0')}",
      };
}
