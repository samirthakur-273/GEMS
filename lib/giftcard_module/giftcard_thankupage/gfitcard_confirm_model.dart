// To parse this JSON data, do
//
//     final giftConfrmModal = giftConfrmModalFromJson(jsonString);

import 'dart:convert';

GiftConfrmModal giftConfrmModalFromJson(String str) =>
    GiftConfrmModal.fromJson(json.decode(str));

String giftConfrmModalToJson(GiftConfrmModal data) =>
    json.encode(data.toJson());

class GiftConfrmModal {
  GiftConfrmModal({
    this.message,
    this.code,
    this.objects,
    this.transactionType,
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
  Objects? objects;
  String? transactionType;
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

  factory GiftConfrmModal.fromJson(Map<String, dynamic> json) =>
      GiftConfrmModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        objects:
            json["objects"] == null ? null : Objects.fromJson(json["objects"]),
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
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
            json["receiver_email"] == null ? null : json["receiver_email"],
        receiverMobile:
            json["receiver_mobile"] == null ? null : json["receiver_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "objects": objects == null ? null : objects!.toJson(),
        "transaction_type": transactionType == null ? null : transactionType,
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
        "receiver_email": receiverEmail == null ? null : receiverEmail,
        "receiver_mobile": receiverMobile == null ? null : receiverMobile,
      };
}

class Objects {
  Objects(
      {this.status,
      this.code,
      this.message,
      this.errorMessage,
      this.values,
      this.egiftCard});

  String? status;
  int? code;
  String? message;
  List<dynamic>? errorMessage;
  List<Value>? values;
  EgiftCard? egiftCard;

  factory Objects.fromJson(Map<String, dynamic> json) => Objects(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        errorMessage: json["error_message"] == null
            ? null
            : List<dynamic>.from(json["error_message"].map((x) => x)),
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
        egiftCard: EgiftCard.fromJson(json["egift_card"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "error_message": errorMessage == null
            ? null
            : List<dynamic>.from(errorMessage!.map((x) => x)),
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "egift_card": egiftCard!.toJson(),
      };
}

class EgiftCard {
  String? url;
  String? giftVerificationPin;

  EgiftCard({
     this.url,
     this.giftVerificationPin,
  });

  factory EgiftCard.fromJson(Map<String, dynamic> json) => EgiftCard(
        url: json["url"],
        giftVerificationPin: json["gift_verification_pin"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "gift_verification_pin": giftVerificationPin,
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
        expirationDate:
            json["expiration_date"] == null ? null : json["expiration_date"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_code": voucherCode == null ? '' : voucherCode,
        "giftcard_url": giftcardUrl == null ? '' : giftcardUrl,
        "expiration_date": expirationDate == null ? '' : expirationDate
      };
}
