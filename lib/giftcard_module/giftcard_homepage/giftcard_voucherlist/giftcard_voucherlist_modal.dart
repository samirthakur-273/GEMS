// To parse this JSON data, do
//
//     final giftVoucherModal = giftVoucherModalFromJson(jsonString);

import 'dart:convert';

GiftVoucherModal giftVoucherModalFromJson(String str) => GiftVoucherModal.fromJson(json.decode(str));

String giftVoucherModalToJson(GiftVoucherModal data) => json.encode(data.toJson());

class GiftVoucherModal {
    GiftVoucherModal({
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

    String ?message;
    String? code;
    bool ?status;
    List<Object>? objects;
    PriceRange? priceRange;
    double? redemptionRate;
    int ?total;
    int? limit;
    List<Country>? countries;

    factory GiftVoucherModal.fromJson(Map<String, dynamic> json) => GiftVoucherModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        objects: json["objects"] == null ? null : List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
        priceRange: json["price_range"] == null ? null : PriceRange.fromJson(json["price_range"]),
        redemptionRate: json["redemption_rate"] == null ? null : json["redemption_rate"].toDouble(),
        total: json["total"] == null ? null : json["total"],
        limit: json["limit"] == null ? null : json["limit"],
        countries: json["countries"] == null ? null : List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "objects": objects == null ? null : List<dynamic>.from(objects!.map((x) => x.toJson())),
        "price_range": priceRange == null ? null : priceRange!.toJson(),
        "redemption_rate": redemptionRate == null ? null : redemptionRate,
        "total": total == null ? null : total,
        "limit": limit == null ? null : limit,
        "countries": countries == null ? null : List<dynamic>.from(countries!.map((x) => x.toJson())),
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

    int ?countryId;
    String ?countryName;
    String ?countryCode;
    String ?currency;
    PriceRange ?priceRange;

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: json["country_id"] == null ? null : json["country_id"],
        countryName: json["country_name"] == null ? null : json["country_name"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        currency: json["currency"] == null ? null : json["currency"],
        priceRange: json["price_range"] == null ? null : PriceRange.fromJson(json["price_range"]),
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

    int ?min;
    int ?max;

    factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
    );

    Map<String, dynamic> toJson() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
    };
}

class Object {
    Object({
        this.giftcardId,
        this.name,
        this.sequence,
        this.supplierCode,
        this.supplierName,
        this.mobileImage,
        this.homepageMobileImage,
        this.description,
        this.categoryName,
        this.categoryCode,
        this.brand,
        this.homepageDenomination,
        this.productType,
        this.denominationType,
        this.fixedDenominationAmount,
        this.country,
        this.currency,
        this.currConvRate,
        this.discount,
        this.earnPoints,
        this.payWithPoints,
        this.seo,
    });

    int ?giftcardId;
    String ?name;
    int ?sequence;
    String? supplierCode;
    String? supplierName;
    String ?mobileImage;
    dynamic homepageMobileImage;
    String ?description;
    String ?categoryName;
    String ?categoryCode;
    String ?brand;
    int? homepageDenomination;
    String? productType;
    String ?denominationType;
    String ?fixedDenominationAmount;
    String? country;
    String ?currency;
    double? currConvRate;
    int ?discount;
    int ?earnPoints;
    int ?payWithPoints;
    Seo ?seo;

    factory Object.fromJson(Map<String, dynamic> json) => Object(
        giftcardId: json["giftcard_id"] == null ? null : json["giftcard_id"],
        name: json["name"] == null ? null : json["name"],
        sequence: json["sequence"] == null ? null : json["sequence"],
        supplierCode: json["supplier_code"] == null ? null : json["supplier_code"],
        supplierName: json["supplier_name"] == null ? null : json["supplier_name"],
        mobileImage: json["mobile_image"] == null ? null : json["mobile_image"],
        homepageMobileImage: json["homepage_mobile_image"],
        description: json["description"] == null ? null : json["description"],
        categoryName: json["category_name"] == null ? null : json["category_name"],
        categoryCode: json["category_code"] == null ? null : json["category_code"],
        brand: json["brand"] == null ? null : json["brand"],
        homepageDenomination: json["homepage_denomination"] == null ? null : json["homepage_denomination"],
        productType: json["product_type"] == null ? null : json["product_type"],
        denominationType: json["denomination_type"] == null ? null : json["denomination_type"],
        fixedDenominationAmount: json["fixed_denomination_amount"] == null ? null : json["fixed_denomination_amount"],
        country: json["country"] == null ? null : json["country"],
        currency: json["currency"] == null ? null : json["currency"],
        currConvRate: json["currConvRate"] == null ? null : json["currConvRate"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"],
        earnPoints: json["earn_points"] == null ? null : json["earn_points"],
        payWithPoints: json["pay_with_points"] == null ? null : json["pay_with_points"],
        seo: json["seo"] == null ? null : Seo.fromJson(json["seo"]),
    );

    Map<String, dynamic> toJson() => {
        "giftcard_id": giftcardId == null ? null : giftcardId,
        "name": name == null ? null : name,
        "sequence": sequence == null ? null : sequence,
        "supplier_code": supplierCode == null ? null : supplierCode,
        "supplier_name": supplierName == null ? null : supplierName,
        "mobile_image": mobileImage == null ? null : mobileImage,
        "homepage_mobile_image": homepageMobileImage,
        "description": description == null ? null : description,
        "category_name": categoryName == null ? null : categoryName,
        "category_code": categoryCode == null ? null : categoryCode,
        "brand": brand == null ? null : brand,
        "homepage_denomination": homepageDenomination == null ? null : homepageDenomination,
        "product_type": productType == null ? null : productType,
        "denomination_type": denominationType == null ? null : denominationType,
        "fixed_denomination_amount": fixedDenominationAmount == null ? null : fixedDenominationAmount,
        "country": country == null ? null : country,
        "currency": currency == null ? null : currency,
        "currConvRate": currConvRate == null ? null : currConvRate,
        "discount": discount == null ? null : discount,
        "earn_points": earnPoints == null ? null : earnPoints,
        "pay_with_points": payWithPoints == null ? null : payWithPoints,
        "seo": seo == null ? null : seo!.toJson(),
    };
}

class Seo {
    Seo({
        this.metaTitle,
        this.metaDescription,
        this.urlKey,
        this.keywords,
    });

    String ?metaTitle;
    String? metaDescription;
    String ?urlKey;
    String ?keywords;

    factory Seo.fromJson(Map<String, dynamic> json) => Seo(
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaDescription: json["meta_description"] == null ? null : json["meta_description"],
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
