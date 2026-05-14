// To parse this JSON data, do
//
//     final offerSearchModel = offerSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';

OfferSearchModel offerSearchModelFromJson(String str) => OfferSearchModel.fromJson(json.decode(str));

String offerSearchModelToJson(OfferSearchModel data) => json.encode(data.toJson());

class OfferSearchModel {
    OfferSearchModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory OfferSearchModel.fromJson(Map<String, dynamic> json) => OfferSearchModel(
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
        this.offercount,
        this.offerslist,
    });

    int? offercount;
    List<Outletlist>? offerslist;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        offercount: json["offercount"] == null ? null : json["offercount"],
        offerslist: json["offerslist"] == null ? null : List<Outletlist>.from(json["offerslist"].map((x) => Outletlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "offercount": offercount == null ? null : offercount,
        "offerslist": offerslist == null ? null : List<dynamic>.from(offerslist!.map((x) => x.toJson())),
    };
}

// class Offerslist {
//     Offerslist({
//         this.outletname,
//         this.outletTitle,
//         this.outletImage,
//         this.outletCode,
//         this.outletlistingimage,
//         this.outletDiscount,
//         this.offertitle,
//         this.outletArea,
//         this.outletAddress,
//         this.brandName,
//         this.brandCode,
//         this.partnerBrndid,
//         this.brandLogo,
//         this.catName,
//         this.catCode,
//         this.subcatName,
//         this.subcatCode,
//         this.distance,
//     });
//     String? outletname;
//     String? outletTitle;
//     String? outletImage;
//     String? outletCode;
//     String? outletlistingimage;
//     String? outletDiscount;
//     String? offertitle;
//     String? outletArea;
//     String? outletAddress;
//     String? brandName;
//     String? brandCode;
//     dynamic partnerBrndid;
//     String? brandLogo;
//     String? catName;
//     String? catCode;
//     String? subcatName;
//     String? subcatCode;
//     double? distance;

//     factory Offerslist.fromJson(Map<String, dynamic> json) => Offerslist(
//         outletTitle: json["outlet_title"] == null ? null : json["outlet_title"],
//         outletname: json["outlet_name"] == null ? null : json["outlet_name"],
//         outletImage: json["outlet_image"] == null ? null : json["outlet_image"],
//         outletCode: json["outlet_code"] == null ? null : json["outlet_code"],
//          outletlistingimage: json["outlet_listing_image"] == null ? null : json["outlet_listing_image"],
//         outletDiscount: json["outlet_discount"] == null ? null : json["outlet_discount"],
//         offertitle: json["offer_title"] == null ? null : json["offer_title"],
//         outletArea: json["outlet_area"] == null ? null : json["outlet_area"],
//         outletAddress: json["outlet_address"] == null ? null : json["outlet_address"],
//         brandName: json["brand_name"] == null ? null : json["brand_name"],
//         brandCode: json["brand_code"] == null ? null : json["brand_code"],
//         partnerBrndid: json["partner_brndid"],
//         brandLogo: json["brand_logo"] == null ? null : json["brand_logo"],
//         catName: json["cat_name"] == null ? null : json["cat_name"],
//         catCode: json["cat_code"] == null ? null : json["cat_code"],
//         subcatName: json["subcat_name"] == null ? null : json["subcat_name"],
//         subcatCode: json["subcat_code"] == null ? null : json["subcat_code"],
//         distance: json["distance"] == null ? null : json["distance"].toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "outlet_title": outletTitle == null ? null : outletTitle,
//         "outlet_name": outletname == null ? null : outletname,
//         "outlet_image": outletImage == null ? null : outletImage,
//         "outlet_code": outletCode == null ? null : outletCode,
//         "outlet_listing_image": outletlistingimage == null ? null : outletlistingimage,
//         "outlet_discount": outletDiscount == null ? null : outletDiscount,
//         "offer_title": offertitle == null ? null : offertitle,
//         "outlet_area": outletArea == null ? null : outletArea,
//         "outlet_address": outletAddress == null ? null : outletAddress,
//         "brand_name": brandName == null ? null : brandName,
//         "brand_code": brandCode == null ? null : brandCode,
//         "partner_brndid": partnerBrndid,
//         "brand_logo": brandLogo == null ? null : brandLogo,
//         "cat_name": catName == null ? null : catName,
//         "cat_code": catCode == null ? null : catCode,
//         "subcat_name": subcatName == null ? null : subcatName,
//         "subcat_code": subcatCode == null ? null : subcatCode,
//         "distance": distance == null ? null : distance,
//     };
// }
