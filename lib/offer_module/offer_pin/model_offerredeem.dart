import 'dart:convert';

OfferRedeemModel offerRedeemModelFromJson(String str) => OfferRedeemModel.fromJson(json.decode(str));

String offerRedeemModelToJson(OfferRedeemModel data) => json.encode(data.toJson());

class OfferRedeemModel {
    OfferRedeemModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory OfferRedeemModel.fromJson(Map<String, dynamic> json) => OfferRedeemModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
    };
}

class Values {
    Values({
        this.transactionId,
        this.offerTitle,
        this.offerCode,
        this.offerImage,
        this.offerExpiry,
        this.brandName,
        this.brandCode,
        this.brandImage,
        this.outletCode,
        this.outletName,
        this.categoryName,
        this.totalAmount,
        this.finalAmount,
        this.transactionDate,
        this.outletAreaName,
        this.merchantName,
        this.savedAmount,
        this.voucherCode,
    });

    String? transactionId;
    String? offerTitle;
    String? offerCode;
    String? offerImage;
    String? offerExpiry;
    String? brandName;
    String? brandCode;
    String? brandImage;
    String? outletCode;
    String? outletName;
    String? categoryName;
    String? totalAmount;
    dynamic finalAmount;
    String? transactionDate;
    String? outletAreaName;
    String? merchantName;
    int? savedAmount;
    String? voucherCode;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
        offerTitle: json["offer_title"] == null ? null : json["offer_title"],
        offerCode: json["offer_code"] == null ? null : json["offer_code"],
        offerImage: json["offer_image"] == null ? null : json["offer_image"],
        offerExpiry: json["offer_expiry"] == null ? null : json["offer_expiry"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        brandCode: json["brand_code"] == null ? null : json["brand_code"],
        brandImage: json["brand_image"] == null ? null : json["brand_image"],
        outletCode: json["outlet_code"] == null ? null : json["outlet_code"],
        outletName: json["outlet_name"] == null ? null : json["outlet_name"],
        categoryName: json["category_name"] == null ? null : json["category_name"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        finalAmount: json["final_amount"],
        transactionDate: json["transaction_date"] == null ? null : json["transaction_date"],
        outletAreaName: json["outlet_area_name"] == null ? null : json["outlet_area_name"],
        merchantName: json["merchant_name"] == null ? null : json["merchant_name"],
        savedAmount: json["saved_amount"] == null ? null : json["saved_amount"],
        voucherCode: json["voucher_code"] == null ? null : json["voucher_code"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_id": transactionId == null ? null : transactionId,
        "offer_title": offerTitle == null ? null : offerTitle,
        "offer_code": offerCode == null ? null : offerCode,
        "offer_image": offerImage == null ? null : offerImage,
        "offer_expiry": offerExpiry == null ? null : offerExpiry,
        "brand_name": brandName == null ? null : brandName,
        "brand_code": brandCode == null ? null : brandCode,
        "brand_image": brandImage == null ? null : brandImage,
        "outlet_code": outletCode == null ? null : outletCode,
        "outlet_name": outletName == null ? null : outletName,
        "category_name": categoryName == null ? null : categoryName,
        "total_amount": totalAmount == null ? null : totalAmount,
        "final_amount": finalAmount,
        "transaction_date": transactionDate == null ? null : transactionDate,
        "outlet_area_name": outletAreaName == null ? null : outletAreaName,
        "merchant_name": merchantName == null ? null : merchantName,
        "saved_amount": savedAmount == null ? null : savedAmount,
        "voucher_code": voucherCode == null ? null : voucherCode,
    };
}
