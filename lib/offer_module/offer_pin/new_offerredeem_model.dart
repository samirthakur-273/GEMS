import 'dart:convert';

NewOfferRedeemModel newOfferRedeemModelFromJson(String str) => NewOfferRedeemModel.fromJson(json.decode(str));

String newOfferRedeemModelToJson(NewOfferRedeemModel data) => json.encode(data.toJson());

class NewOfferRedeemModel {
    String? message;
    String? code;
    bool? status;
    Values? values;

    NewOfferRedeemModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    factory NewOfferRedeemModel.fromJson(Map<String, dynamic> json) => NewOfferRedeemModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        // values: Values.fromJson(json["values"]),
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values!.toJson(),
    };
}

class Values {
    String? transactionId;
    String? offerTitle;
    String? offerCode;
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
    String? offerExpiry;
    String? offerImage;
    String? voucherCode;

    Values({
        this.transactionId,
        this.offerTitle,
        this.offerCode,
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
        this.offerExpiry,
        this.offerImage,
        this.voucherCode,
    });

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        transactionId: json["transaction_id"],
        offerTitle: json["offer_title"],
        offerCode: json["offer_code"],
        brandName: json["brand_name"],
        brandCode: json["brand_code"],
        brandImage: json["brand_image"],
        outletCode: json["outlet_code"],
        outletName: json["outlet_name"],
        categoryName: json["category_name"],
        totalAmount: json["total_amount"],
        finalAmount: json["final_amount"],
        transactionDate: json["transaction_date"],
        outletAreaName: json["outlet_area_name"],
        merchantName: json["merchant_name"],
        savedAmount: json["saved_amount"],
        offerExpiry: json["offer_expiry"],
        offerImage: json["offer_image"],
        voucherCode: json["voucher_code"] == null ? null : json["voucher_code"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "offer_title": offerTitle,
        "offer_code": offerCode,
        "brand_name": brandName,
        "brand_code": brandCode,
        "brand_image": brandImage,
        "outlet_code": outletCode,
        "outlet_name": outletName,
        "category_name": categoryName,
        "total_amount": totalAmount,
        "final_amount": finalAmount,
        "transaction_date": transactionDate,
        "outlet_area_name": outletAreaName,
        "merchant_name": merchantName,
        "saved_amount": savedAmount,
        "offer_expiry": offerExpiry,
        "offer_image": offerImage,
        "voucher_code": voucherCode == null ? null : voucherCode,
    };
}
