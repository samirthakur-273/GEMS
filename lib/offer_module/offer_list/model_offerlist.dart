import 'dart:convert';

OfferList offerListFromJson(String str) => OfferList.fromJson(json.decode(str));

String offerListToJson(OfferList data) => json.encode(data.toJson());

class OfferList {
  OfferList({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory OfferList.fromJson(Map<String, dynamic> json) => OfferList(
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
    this.catList,
    this.subcatList,
    this.emirateList,
    this.isClink,
    this.outletFound,
    this.outletlist,
  });

  List<Cat>? catList;
  List<SubcatList>? subcatList;
  List<EmirateList>? emirateList;
  String? isClink;
  int? outletFound;
  List<Outletlist>? outletlist;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        catList: json["cat_list"] == null
            ? null
            : List<Cat>.from(json["cat_list"].map((x) => Cat.fromJson(x))),
        subcatList: json["subcat_list"] == null
            ? null
            : List<SubcatList>.from(
                json["subcat_list"].map((x) => SubcatList.fromJson(x))),
        emirateList: json["emirate_list"] == null
            ? null
            : List<EmirateList>.from(
                json["emirate_list"].map((x) => EmirateList.fromJson(x))),
        isClink: json["is_clink"],
        outletFound: json["outlet_found"] == null ? null : json["outlet_found"],
        outletlist: json["outletlist"] == null
            ? null
            : List<Outletlist>.from(
                json["outletlist"].map((x) => Outletlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cat_list": catList == null
            ? null
            : List<dynamic>.from(catList!.map((x) => x.toJson())),
        "subcat_list": subcatList == null
            ? null
            : List<dynamic>.from(subcatList!.map((x) => x.toJson())),
        "emirate_list": emirateList == null
            ? null
            : List<dynamic>.from(emirateList!.map((x) => x.toJson())),
        "is_clink": isClink,
        "outlet_found": outletFound == null ? null : outletFound,
        "outletlist": outletlist == null
            ? null
            : List<dynamic>.from(outletlist!.map((x) => x.toJson())),
      };
}

class Cat {
  Cat({
    this.catId,
    this.catName,
    this.catCode,
    this.catImage,
  });

  int? catId;
  String? catName;
  String? catCode;
  String? catImage;

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        catId: json["cat_id"] == null ? null : json["cat_id"],
        catName: json["cat_name"] == null ? null : json["cat_name"],
        catCode: json["cat_code"] == null ? null : json["cat_code"],
        catImage: json["cat_image"] == null ? null : json["cat_image"],
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId == null ? null : catId,
        "cat_name": catName == null ? null : catName,
        "cat_code": catCode == null ? null : catCode,
        "cat_image": catImage == null ? null : catImage,
      };
}

class EmirateList {
  EmirateList({
    this.emirateId,
    this.emirateCode,
    this.emirateName,
    this.catId,
    this.catName,
    this.catCode,
  });

  int? emirateId;
  String? emirateCode;
  String? emirateName;
  int? catId;
  String? catName;
  String? catCode;

  factory EmirateList.fromJson(Map<String, dynamic> json) => EmirateList(
        emirateId: json["emirate_id"] == null ? null : json["emirate_id"],
        emirateCode: json["emirate_code"] == null ? null : json["emirate_code"],
        emirateName: json["emirate_name"] == null ? null : json["emirate_name"],
        catId: json["cat_id"] == null ? null : json["cat_id"],
        catName: json["cat_name"] == null ? null : json["cat_name"],
        catCode: json["cat_code"] == null ? null : json["cat_code"],
      );

  Map<String, dynamic> toJson() => {
        "emirate_id": emirateId == null ? null : emirateId,
        "emirate_code": emirateCode == null ? null : emirateCode,
        "emirate_name": emirateName == null ? null : emirateName,
        "cat_id": catId == null ? null : catId,
        "cat_name": catName == null ? null : catName,
        "cat_code": catCode == null ? null : catCode,
      };
}

class Outletlist {
  Outletlist({
    this.syncCatId,
    this.syncBoutCityId,
    this.outletId,
    this.outletTitle,
    this.outletImage,
    this.outletListingImage,
    this.outletCode,
    this.outletDiscount,
    this.offerTitle,
    this.outletname,
    this.outletLatitude,
    this.outletLongitude,
    this.outletArea,
    this.outletAddress,
    this.brandName,
    this.brandCode,
    this.partnerBrndid,
    this.brandLogo,
    this.merchantName,
    this.merchantCode,
    this.emirateId,
    this.emirateCode,
    this.emirateName,
    this.isFav,
    this.distance,
    this.category,
    this.subcategory,
    this.catName,
    this.catCode,
    this.subcatName,
    this.subcatCode,
  });

  dynamic syncCatId;
  dynamic syncBoutCityId;
  dynamic outletId;
  String? outletTitle;
  String? outletImage;
  dynamic outletListingImage;
  String? outletCode;
  String? outletDiscount;
  String? offerTitle;
  String? outletname;
  String? outletLatitude;
  String? outletLongitude;
  String? outletArea;
  String? outletAddress;
  String? brandName;
  String? brandCode;
  int? partnerBrndid;
  String? brandLogo;
  String? merchantName;
  String? merchantCode;
  int? emirateId;
  String? emirateCode;
  String? emirateName;
  int? isFav;
  double? distance;
  List<Cat>? category;
  List<Subcategory>? subcategory;
  String? catName;
  String? catCode;
  String? subcatName;
  String? subcatCode;

  factory Outletlist.fromJson(Map<String, dynamic> json) => Outletlist(
        syncCatId: json["sync_cat_id"],
        syncBoutCityId: json["sync_bout_city_id"],
        outletId: json["outlet_id"],
        outletTitle: json["outlet_title"] == null ? null : json["outlet_title"],
        outletImage: json["outlet_image"] == null ? null : json["outlet_image"],
        outletListingImage: json["outlet_listing_image"] == null
            ? null
            : json["outlet_listing_image"],
        outletCode: json["outlet_code"] == null ? null : json["outlet_code"],
        outletDiscount:
            json["outlet_discount"] == null ? null : json["outlet_discount"],
        offerTitle: json["offer_title"] == null ? null : json["offer_title"],
        outletname: json["outlet_name"] == null ? null : json["outlet_name"],
        outletLatitude:
            json["outlet_latitude"] == null ? null : json["outlet_latitude"],
        outletLongitude:
            json["outlet_longitude"] == null ? null : json["outlet_longitude"],
        outletArea: json["outlet_area"] == null ? null : json["outlet_area"],
        outletAddress:
            json["outlet_address"] == null ? null : json["outlet_address"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        brandCode: json["brand_code"] == null ? null : json["brand_code"],
        partnerBrndid:
            json["partner_brndid"] == null ? null : json["partner_brndid"],
        brandLogo: json["brand_logo"] == null ? null : json["brand_logo"],
        merchantName:
            json["merchant_name"] == null ? null : json["merchant_name"],
        merchantCode:
            json["merchant_code"] == null ? null : json["merchant_code"],
        emirateId: json["emirate_id"] == null ? null : json["emirate_id"],
        emirateCode: json["emirate_code"] == null ? null : json["emirate_code"],
        emirateName: json["emirate_name"] == null ? null : json["emirate_name"],
        isFav: json["is_fav"] == null ? null : json["is_fav"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        category: json["category"] == null
            ? null
            : List<Cat>.from(json["category"].map((x) => Cat.fromJson(x))),
        subcategory: json["subcategory"] == null
            ? null
            : List<Subcategory>.from(
                json["subcategory"].map((x) => Subcategory.fromJson(x))),
        catName: json["cat_name"] == null ? null : json["cat_name"],
        catCode: json["cat_code"] == null ? null : json["cat_code"],
        subcatName: json["subcat_name"] == null ? null : json["subcat_name"],
        subcatCode: json["subcat_code"] == null ? null : json["subcat_code"],
      );

  Map<String, dynamic> toJson() => {
        "sync_cat_id": syncCatId,
        "sync_bout_city_id": syncBoutCityId,
        "outlet_id": outletId,
        "outlet_title": outletTitle == null ? null : outletTitle,
        "outlet_image": outletImage == null ? null : outletImage,
        "outlet_listing_image":
            outletListingImage == null ? null : outletListingImage,
        "outlet_code": outletCode == null ? null : outletCode,
        "outlet_discount": outletDiscount == null ? null : outletDiscount,
        "offer_title": offerTitle == null ? null : offerTitle,
        "outlet_name": outletname == null ? null : outletname,
        "outlet_latitude": outletLatitude == null ? null : outletLatitude,
        "outlet_longitude": outletLongitude == null ? null : outletLongitude,
        "outlet_area": outletArea == null ? null : outletArea,
        "outlet_address": outletAddress == null ? null : outletAddress,
        "brand_name": brandName == null ? null : brandName,
        "brand_code": brandCode == null ? null : brandCode,
        "partner_brndid": partnerBrndid == null ? null : partnerBrndid,
        "brand_logo": brandLogo == null ? null : brandLogo,
        "merchant_name": merchantName == null ? null : merchantName,
        "merchant_code": merchantCode == null ? null : merchantCode,
        "emirate_id": emirateId == null ? null : emirateId,
        "emirate_code": emirateCode == null ? null : emirateCode,
        "emirate_name": emirateName == null ? null : emirateName,
        "is_fav": isFav == null ? null : isFav,
        "distance": distance == null ? null : distance,
        "category": category == null
            ? null
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        "subcategory": subcategory == null
            ? null
            : List<dynamic>.from(subcategory!.map((x) => x.toJson())),
        "cat_name": catName == null ? null : catName,
        "cat_code": catCode == null ? null : catCode,
        "subcat_name": subcatName == null ? null : subcatName,
        "subcat_code": subcatCode == null ? null : subcatCode,
      };
}

class Subcategory {
  Subcategory({
    this.subcatId,
    this.subcatName,
    this.subcatCode,
    this.subcatImage,
  });

  int? subcatId;
  String? subcatName;
  String? subcatCode;
  String? subcatImage;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subcatId: json["subcat_id"] == null ? null : json["subcat_id"],
        subcatName: json["subcat_name"] == null ? null : json["subcat_name"],
        subcatCode: json["subcat_code"] == null ? null : json["subcat_code"],
        subcatImage: json["subcat_image"] == null ? null : json["subcat_image"],
      );

  Map<String, dynamic> toJson() => {
        "subcat_id": subcatId == null ? null : subcatId,
        "subcat_name": subcatName == null ? null : subcatName,
        "subcat_code": subcatCode == null ? null : subcatCode,
        "subcat_image": subcatImage == null ? null : subcatImage,
      };
}

class SubcatList {
  SubcatList(
      {this.catId,
      this.subcatId,
      this.catImage,
      this.subcatImage,
      this.catName,
      this.subcatName,
      this.catCode,
      this.subcatCode,
      this.altcatname,
      this.outletLength});

  int? catId;
  int? subcatId;
  String? catImage;
  String? subcatImage;
  String? catName;
  String? subcatName;
  String? catCode;
  String? subcatCode;
  String? altcatname;
  String? outletLength;

  factory SubcatList.fromJson(Map<String, dynamic> json) => SubcatList(
        catId: json["cat_id"] == null ? null : json["cat_id"],
        subcatId: json["subcat_id"] == null ? null : json["subcat_id"],
        catImage: json["cat_image"] == null ? null : json["cat_image"],
        subcatImage: json["subcat_image"] == null ? null : json["subcat_image"],
        catName: json["cat_name"] == null ? null : json["cat_name"],
        subcatName: json["subcat_name"] == null ? null : json["subcat_name"],
        catCode: json["cat_code"] == null ? null : json["cat_code"],
        subcatCode: json["subcat_code"] == null ? null : json["subcat_code"],
        altcatname: json["alt_cat_name"] == null ? null : json["alt_cat_name"],
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId == null ? null : catId,
        "subcat_id": subcatId == null ? null : subcatId,
        "cat_image": catImage == null ? null : catImage,
        "subcat_image": subcatImage == null ? null : subcatImage,
        "cat_name": catName == null ? null : catName,
        "subcat_name": subcatName == null ? null : subcatName,
        "cat_code": catCode == null ? null : catCode,
        "subcat_code": subcatCode == null ? null : subcatCode,
        "alt_cat_name": altcatname == null ? null : altcatname,
      };
}
