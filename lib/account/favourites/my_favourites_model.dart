// To parse this JSON data, do
//
//     final myFavouriteModel = myFavouriteModelFromJson(jsonString);

import 'dart:convert';

MyFavouriteModel myFavouriteModelFromJson(String str) =>
    MyFavouriteModel.fromJson(json.decode(str));

String myFavouriteModelToJson(MyFavouriteModel data) =>
    json.encode(data.toJson());

class MyFavouriteModel {
  MyFavouriteModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory MyFavouriteModel.fromJson(Map<String, dynamic> json) =>
      MyFavouriteModel(
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
    this.categoryImage,
    this.categoryCode,
    this.categoryName,
    this.favOffers,
  });

  String? categoryImage;
  String? categoryCode;
  String? categoryName;
  List<FavOffer>? favOffers;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
        categoryCode:
            json["category_code"] == null ? null : json["category_code"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        favOffers: json["fav_offers"] == null
            ? null
            : List<FavOffer>.from(
                json["fav_offers"].map((x) => FavOffer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_image": categoryImage == null ? null : categoryImage,
        "category_code": categoryCode == null ? null : categoryCode,
        "category_name": categoryName == null ? null : categoryName,
        "fav_offers": favOffers == null
            ? null
            : List<dynamic>.from(favOffers!.map((x) => x.toJson())),
      };
}

class FavOffer {
  FavOffer({
    this.outletName,
    this.outletCode,
    this.outletImage,
    this.outletDiscount,
    this.outletType,
    this.outletCity,
    this.outletCountry,
    this.areaName,
    this.brandName,
    this.brandCode,
    this.brandLogo,
    this.isfav,
  });

  String? outletName;
  String? outletCode;
  String? outletImage;
  String? outletDiscount;
  String? outletType;
  String? outletCity;
  String? outletCountry;
  String? areaName;
  String? brandName;
  String? brandCode;
  String? brandLogo;
  int? isfav;

  factory FavOffer.fromJson(Map<String, dynamic> json) => FavOffer(
        outletName: json["outlet_name"] == null ? null : json["outlet_name"],
        outletCode: json["outlet_code"] == null ? null : json["outlet_code"],
        outletImage: json["outlet_image"] == null ? null : json["outlet_image"],
        outletDiscount:
            json["outlet_discount"] == null ? null : json["outlet_discount"],
        outletType: json["outlet_type"] == null ? null : json["outlet_type"],
        outletCity: json["outlet_city"] == null ? null : json["outlet_city"],
        outletCountry:
            json["outlet_country"] == null ? null : json["outlet_country"],
        areaName: json["area_name"] == null ? null : json["area_name"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        brandCode: json["brand_code"] == null ? null : json["brand_code"],
          brandLogo: json["brand_logo"] == null ? null : json["brand_logo"],
        isfav: json["isfav"] == null ? null : json["isfav"],
      );

  Map<String, dynamic> toJson() => {
        "outlet_name": outletName == null ? null : outletName,
        "outlet_code": outletCode == null ? null : outletCode,
        "outlet_image": outletImage == null ? null : outletImage,
        "outlet_discount": outletDiscount == null ? null : outletDiscount,
        "outlet_type": outletType == null ? null : outletType,
        "outlet_city": outletCity == null ? null : outletCity,
        "outlet_country": outletCountry == null ? null : outletCountry,
        "area_name": areaName == null ? null : areaName,
        "brand_name": brandName == null ? null : brandName,
        "brand_code": brandCode == null ? null : brandCode,
         "brand_logo": brandLogo == null ? null : brandLogo,
        "isfav": isfav == null ? null : isfav,
      };
}
