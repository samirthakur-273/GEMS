import 'dart:convert';

OfferFavouriteModel offerFavouriteModelFromJson(String str) => OfferFavouriteModel.fromJson(json.decode(str));

String offerFavouriteModelToJson(OfferFavouriteModel data) => json.encode(data.toJson());

class OfferFavouriteModel {
    OfferFavouriteModel({
        this.message,
        this.code,
        this.status,
    });

    String? message;
    String? code;
    bool? status;

    factory OfferFavouriteModel.fromJson(Map<String, dynamic> json) => OfferFavouriteModel(
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
