// To parse this JSON data, do
//
//     final commonSearchModel = commonSearchModelFromJson(jsonString);

import 'dart:convert';

CommonSearchModel commonSearchModelFromJson(String str) => CommonSearchModel.fromJson(json.decode(str));

String commonSearchModelToJson(CommonSearchModel data) => json.encode(data.toJson());

class CommonSearchModel {
    bool? status;
    String? code;
    String? message;
    SearchList? searchList;

    CommonSearchModel({
        this.status,
        this.code,
        this.message,
        this.searchList,
    });

    factory CommonSearchModel.fromJson(Map<String, dynamic> json) => CommonSearchModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        searchList: json["search_list"] == null || json["status"] == false
            ? null
            :SearchList.fromJson(json["search_list"]),
        
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "search_list": searchList!.toJson(),
    };
}

class SearchList {
    List<OffersList>? offersList;
    List<GemsPointList>? gemsPointList;
    List<EshopList>? eshopList;

    SearchList({
        this.offersList,
        this.gemsPointList,
        this.eshopList,
    });

    factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
        offersList: List<OffersList>.from(json["OffersList"].map((x) => OffersList.fromJson(x))),
        gemsPointList: List<GemsPointList>.from(json["GemsPointList"].map((x) => GemsPointList.fromJson(x))),
        eshopList: List<EshopList>.from(json["EshopList"].map((x) => EshopList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "OffersList": List<dynamic>.from(offersList!.map((x) => x.toJson())),
        "GemsPointList": List<dynamic>.from(gemsPointList!.map((x) => x.toJson())),
        "EshopList": List<dynamic>.from(eshopList!.map((x) => x.toJson())),
    };
}

class EshopList {
    String? title;
    int? count;

    EshopList({
        this.title,
        this.count,
    });

    factory EshopList.fromJson(Map<String, dynamic> json) => EshopList(
        title: json["title"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "count": count,
    };
}

class GemsPointList {
    String? affiliateId;
    String? affiliateName;

    GemsPointList({
        this.affiliateId,
        this.affiliateName,
    });

    factory GemsPointList.fromJson(Map<String, dynamic> json) => GemsPointList(
        affiliateId: json["affiliate_id"],
        affiliateName: json["affiliate_name"],
    );

    Map<String, dynamic> toJson() => {
        "affiliate_id": affiliateId,
        "affiliate_name": affiliateName,
    };
}

class OffersList {
    String? outletName;
    String? outletCode;
    String? outletDiscount;
    String? offerTitle;
    String? outletArea;
    String? brandCode;
    int? partnerBrndid;
    String? brandLogo;
    String? catName;
    String? catCode;
    double? distance;

    OffersList({
        this.outletName,
        this.outletCode,
        this.outletDiscount,
        this.offerTitle,
        this.outletArea,
        this.brandCode,
        this.partnerBrndid,
        this.brandLogo,
        this.catName,
        this.catCode,
        this.distance,
    });

    factory OffersList.fromJson(Map<String, dynamic> json) => OffersList(
        outletName: json["outlet_name"],
        outletCode: json["outlet_code"],
        outletDiscount: json["outlet_discount"],
        offerTitle: json["offer_title"],
        outletArea: json["outlet_area"],
        brandCode: json["brand_code"],
        partnerBrndid: json["partner_brndid"],
        brandLogo: json["brand_logo"],
        catName: json["cat_name"],
        catCode: json["cat_code"],
        distance: json["distance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "outlet_name": outletName,
        "outlet_code": outletCode,
        "outlet_discount": outletDiscount,
        "offer_title": offerTitle,
        "outlet_area": outletArea,
        "brand_code": brandCode,
        "partner_brndid": partnerBrndid,
        "brand_logo": brandLogo,
        "cat_name": catName,
        "cat_code": catCode,
        "distance": distance,
    };
}
