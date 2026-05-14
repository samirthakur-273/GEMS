// To parse this JSON data, do
//
//     final giftcardDetailsModal = giftcardDetailsModalFromJson(jsonString);

import 'dart:convert';

GiftcardDetailsModal giftcardDetailsModalFromJson(String str) =>
    GiftcardDetailsModal.fromJson(json.decode(str));

String giftcardDetailsModalToJson(GiftcardDetailsModal data) =>
    json.encode(data.toJson());

class GiftcardDetailsModal {
  GiftcardDetailsModal({
    this.message,
    this.code,
    this.status,
    this.objects,
    this.priceRange,
    this.redemptionRate,
    this.total,
    this.limit,
    this.countries,
  });

  String? message;
  String? code;
  bool? status;
  Objects? objects;
  PriceRange? priceRange;
  double? redemptionRate;
  int? total;
  int? limit;
  List<Country>? countries;

  factory GiftcardDetailsModal.fromJson(Map<String, dynamic> json) =>
      GiftcardDetailsModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        objects:
            json["objects"] == null ? null : Objects.fromJson(json["objects"]),
        priceRange: json["price_range"] == null
            ? null
            : PriceRange.fromJson(json["price_range"]),
        redemptionRate: json["redemption_rate"] == null
            ? null
            : json["redemption_rate"].toDouble(),
        total: json["total"] == null ? null : json["total"],
        limit: json["limit"] == null ? null : json["limit"],
        countries: json["countries"] == null
            ? null
            : List<Country>.from(
                json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "objects": objects == null ? null : objects!.toJson(),
        "price_range": priceRange == null ? null : priceRange!.toJson(),
        "redemption_rate": redemptionRate == null ? null : redemptionRate,
        "total": total == null ? null : total,
        "limit": limit == null ? null : limit,
        "countries": countries == null
            ? null
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    this.countryId,
    this.countryName,
    this.countryCode,
    this.currency,
    this.priceRange,
  });

  int? countryId;
  String? countryName;
  String? countryCode;
  String? currency;
  PriceRange? priceRange;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: json["country_id"] == null ? null : json["country_id"],
        countryName: json["country_name"] == null ? null : json["country_name"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        currency: json["currency"] == null ? null : json["currency"],
        priceRange: json["price_range"] == null
            ? null
            : PriceRange.fromJson(json["price_range"]),
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId == null ? null : countryId,
        "country_name": countryName == null ? null : countryName,
        "country_code": countryCode == null ? null : countryCode,
        "currency": currency == null ? null : currency,
        "price_range": priceRange == null ? null : priceRange!.toJson(),
      };
}

class PriceRange {
  PriceRange({
    this.min,
    this.max,
  });

  int? min;
  int? max;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
      };
}

class Objects {
  Objects(
      {this.giftcardId,
      this.name,
      this.mobileImage,
      this.homepageMobileImage,
      this.description,
      this.campaignId,
      this.vendorId,
      this.category,
      this.subCategory,
      this.brand,
      this.supplierId,
      this.supplierName,
      this.supplierCode,
      this.supplierCommission,
      this.denominationType,
      this.fixedDenominationAmount,
      this.fixedDenominationCodes,
      this.country,
      this.currency,
      this.currConvRate,
      this.discount,
      this.termsCondition,
      this.howToRedeem,
      this.productType,
      this.homepageDenomination,
      this.sku,
      this.earnPoints,
      this.redeemPoints,
      this.seo,
      this.payWithPoints,
      this.brandName,
      this.redemptionRate,
      this.offerPloughbackFactor,
      this.rpm});

  int? giftcardId;
  String? name;
  String? mobileImage;
  dynamic homepageMobileImage;
  String? description;
  String? campaignId;
  String? vendorId;
  String? category;
  String? subCategory;
  String? brand;
  int? supplierId;
  String? supplierName;
  String? supplierCode;
  String? supplierCommission;
  String? denominationType;
  String? fixedDenominationAmount;
  String? fixedDenominationCodes;
  String? country;
  String? currency;
  double? currConvRate;
  int? discount;
  String? termsCondition;
  String? howToRedeem;
  String? productType;
  int? homepageDenomination;
  String? sku;
  String? earnPoints;
  dynamic redeemPoints;
  Seo? seo;
  String? payWithPoints;
  String? brandName;
  double? redemptionRate;
  var offerPloughbackFactor;
  var rpm;

  factory Objects.fromJson(Map<String, dynamic> json) => Objects(
        giftcardId: json["giftcard_id"] == null ? null : json["giftcard_id"],
        name: json["name"] == null ? null : json["name"],
        mobileImage: json["mobile_image"] == null ? null : json["mobile_image"],
        homepageMobileImage: json["homepage_mobile_image"],
        description: json["description"] == null ? null : json["description"],
        campaignId: json["campaign_id"] == null ? null : json["campaign_id"],
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        category: json["category"] == null ? null : json["category"],
        subCategory: json["sub_category"] == null ? null : json["sub_category"],
        brand: json["brand"] == null ? null : json["brand"],
        supplierId: json["supplier_id"] == null ? null : json["supplier_id"],
        supplierName:
            json["supplier_name"] == null ? null : json["supplier_name"],
        supplierCode:
            json["supplier_code"] == null ? null : json["supplier_code"],
        supplierCommission: json["supplier_commission"] == null
            ? null
            : json["supplier_commission"],
        denominationType: json["denomination_type"] == null
            ? null
            : json["denomination_type"],
        fixedDenominationAmount: json["fixed_denomination_amount"] == null
            ? null
            : json["fixed_denomination_amount"],
        fixedDenominationCodes: json["fixed_denomination_codes"] == null
            ? null
            : json["fixed_denomination_codes"],
        country: json["country"] == null ? null : json["country"],
        currency: json["currency"] == null ? null : json["currency"],
        currConvRate: json["currConvRate"] == null
            ? null
            : json["currConvRate"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"],
        termsCondition:
            json["terms_condition"] == null ? null : json["terms_condition"],
        howToRedeem:
            json["how_to_redeem"] == null ? null : json["how_to_redeem"],
        productType: json["product_type"] == null ? null : json["product_type"],
        homepageDenomination: json["homepage_denomination"] == null
            ? null
            : json["homepage_denomination"],
        sku: json["sku"] == null ? null : json["sku"],
        earnPoints: json["earn_points"] == null ? null : json["earn_points"],
        redeemPoints: json["redeem_points"],
        seo: json["seo"] == null ? null : Seo.fromJson(json["seo"]),
        payWithPoints:
            json["pay_with_points"] == null ? null : json["pay_with_points"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        redemptionRate: json["redemption_rate"] == null
            ? null
            : json["redemption_rate"].toDouble(),
        offerPloughbackFactor: json["offer_ploughback_factor"] == null
            ? 0
            : json["offer_ploughback_factor"],
        rpm: json["rpm"] == null ? 0 : json["rpm"],
      );

  Map<String, dynamic> toJson() => {
        "giftcard_id": giftcardId == null ? null : giftcardId,
        "name": name == null ? null : name,
        "mobile_image": mobileImage == null ? null : mobileImage,
        "homepage_mobile_image": homepageMobileImage,
        "description": description == null ? null : description,
        "campaign_id": campaignId == null ? null : campaignId,
        "vendor_id": vendorId == null ? null : vendorId,
        "category": category == null ? null : category,
        "sub_category": subCategory == null ? null : subCategory,
        "brand": brand == null ? null : brand,
        "supplier_id": supplierId == null ? null : supplierId,
        "supplier_name": supplierName == null ? null : supplierName,
        "supplier_code": supplierCode == null ? null : supplierCode,
        "supplier_commission":
            supplierCommission == null ? null : supplierCommission,
        "denomination_type": denominationType == null ? null : denominationType,
        "fixed_denomination_amount":
            fixedDenominationAmount == null ? null : fixedDenominationAmount,
        "fixed_denomination_codes":
            fixedDenominationCodes == null ? null : fixedDenominationCodes,
        "country": country == null ? null : country,
        "currency": currency == null ? null : currency,
        "currConvRate": currConvRate == null ? null : currConvRate,
        "discount": discount == null ? null : discount,
        "terms_condition": termsCondition == null ? null : termsCondition,
        "how_to_redeem": howToRedeem == null ? null : howToRedeem,
        "product_type": productType == null ? null : productType,
        "homepage_denomination":
            homepageDenomination == null ? null : homepageDenomination,
        "sku": sku == null ? null : sku,
        "earn_points": earnPoints == null ? null : earnPoints,
        "redeem_points": redeemPoints,
        "seo": seo == null ? null : seo!.toJson(),
        "pay_with_points": payWithPoints == null ? null : payWithPoints,
        "brand_name": brandName == null ? null : brandName,
        "redemption_rate": redemptionRate == null ? null : redemptionRate,
        "offer_ploughback_factor":
            offerPloughbackFactor == null ? 0 : offerPloughbackFactor,
        "rpm": rpm == null ? 0 : rpm,
      };
}

class Seo {
  Seo({
    this.metaTitle,
    this.metaDescription,
    this.urlKey,
    this.keywords,
  });

  String? metaTitle;
  String? metaDescription;
  String? urlKey;
  String? keywords;

  factory Seo.fromJson(Map<String, dynamic> json) => Seo(
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaDescription:
            json["meta_description"] == null ? null : json["meta_description"],
        urlKey: json["url_key"] == null ? null : json["url_key"],
        keywords: json["keywords"] == null ? null : json["keywords"],
      );

  Map<String, dynamic> toJson() => {
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_description": metaDescription == null ? null : metaDescription,
        "url_key": urlKey == null ? null : urlKey,
        "keywords": keywords == null ? null : keywords,
      };
}
