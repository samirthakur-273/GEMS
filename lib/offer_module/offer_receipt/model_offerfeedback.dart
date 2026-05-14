import 'dart:convert';

OfferFeedBack offerFeedBackFromJson(String str) => OfferFeedBack.fromJson(json.decode(str));

String offerFeedBackToJson(OfferFeedBack data) => json.encode(data.toJson());

class OfferFeedBack {
    OfferFeedBack({
        this.message,
        this.code,
        this.status,
    });

    String? message;
    String? code;
    bool? status;

    factory OfferFeedBack.fromJson(Map<String, dynamic> json) => OfferFeedBack(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
    };
}
