import 'dart:convert';

OfferDetailModel offerDetailModelFromJson(String str) =>
    OfferDetailModel.fromJson(json.decode(str));

String offerDetailModelToJson(OfferDetailModel data) =>
    json.encode(data.toJson());

class OfferDetailModel {
  OfferDetailModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory OfferDetailModel.fromJson(Map<String, dynamic> json) =>
      OfferDetailModel(
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
    this.outletName,
    this.outletImage,
    this.outletCode,
    this.outletDiscount,
    this.outletDescription,
    this.termsCondition,
    this.outletLatitude,
    this.outletLongitude,
    this.outletAddress,
    this.outletArea,
    this.outletEmail,
    this.contactNo,
    this.countryCode,
    this.outletCity,
    this.outletCountry,
    this.openingTime,
    this.closingTime,
    this.type,
    this.howToRedeem,
    this.brandName,
    this.brandCode,
    this.brandLogo,
    this.merchantName,
    this.merchantCode,
    this.merchantPhone,
    this.merchantWhatsappNo,
    this.merchantPin,
    this.isFav,
    this.distance,
    this.offers,
    this.otherBranches,
  });

  String? outletName;
  String? outletImage;
  String? outletCode;
  String? outletDiscount;
  String? outletDescription;
  String? termsCondition;
  String? outletLatitude;
  String? outletLongitude;
  String? outletAddress;
  String? outletArea;
  dynamic outletEmail;
  String? contactNo;
  dynamic countryCode;
  String? outletCity;
  String? outletCountry;
  String? openingTime;
  String? closingTime;
  String? type;
  String? howToRedeem;
  String? brandName;
  String? brandCode;
  String? brandLogo;
  String? merchantName;
  String? merchantCode;
  String? merchantPhone;
  dynamic merchantWhatsappNo;
  String? merchantPin;
  int? isFav;
  double? distance;
  List<Offer>? offers;
  List<Value>? otherBranches;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        outletName: json["outlet_name"] == null ? null : json["outlet_name"],
        outletImage: json["outlet_image"] == null ? null : json["outlet_image"],
        outletCode: json["outlet_code"] == null ? null : json["outlet_code"],
        outletDiscount:
            json["outlet_discount"] == null ? null : json["outlet_discount"],
        outletDescription: json["outlet_description"] == null
            ? null
            : json["outlet_description"],
        termsCondition:
            json["terms_condition"] == null ? null : json["terms_condition"],
        outletLatitude:
            json["outlet_latitude"] == null ? null : json["outlet_latitude"],
        outletLongitude:
            json["outlet_longitude"] == null ? null : json["outlet_longitude"],
        outletAddress:
            json["outlet_address"] == null ? null : json["outlet_address"],
        outletArea: json["outlet_area"] == null ? null : json["outlet_area"],
        outletEmail: json["outlet_email"],
        contactNo: json["contact_no"] == null ? null : json["contact_no"],
        countryCode: json["country_code"],
        outletCity: json["outlet_city"] == null ? null : json["outlet_city"],
        outletCountry:
            json["outlet_country"] == null ? null : json["outlet_country"],
        openingTime: json["opening_time"] == null ? null : json["opening_time"],
        closingTime: json["closing_time"] == null ? null : json["closing_time"],
        type: json["type"] == null ? null : json["type"],
        howToRedeem:
            json["how_to_redeem"] == null ? null : json["how_to_redeem"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        brandCode: json["brand_code"] == null ? null : json["brand_code"],
        brandLogo: json["brand_logo"] == null ? null : json["brand_logo"],
        merchantName:
            json["merchant_name"] == null ? null : json["merchant_name"],
        merchantCode:
            json["merchant_code"] == null ? null : json["merchant_code"],
        merchantPhone:
            json["merchant_phone"] == null ? null : json["merchant_phone"],
        merchantWhatsappNo: json["merchant_whatsapp_no"],
        merchantPin: json["merchant_pin"] == null ? null : json["merchant_pin"],
        isFav: json["is_fav"] == null ? null : json["is_fav"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        offers: json["offers"] == null
            ? null
            : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
        otherBranches: json["other_branches"] == null
            ? null
            : List<Value>.from(
                json["other_branches"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "outlet_name": outletName == null ? null : outletName,
        "outlet_image": outletImage == null ? null : outletImage,
        "outlet_code": outletCode == null ? null : outletCode,
        "outlet_discount": outletDiscount == null ? null : outletDiscount,
        "outlet_description":
            outletDescription == null ? null : outletDescription,
        "terms_condition": termsCondition == null ? null : termsCondition,
        "outlet_latitude": outletLatitude == null ? null : outletLatitude,
        "outlet_longitude": outletLongitude == null ? null : outletLongitude,
        "outlet_address": outletAddress == null ? null : outletAddress,
        "outlet_area": outletArea == null ? null : outletArea,
        "outlet_email": outletEmail,
        "contact_no": contactNo == null ? null : contactNo,
        "country_code": countryCode,
        "outlet_city": outletCity == null ? null : outletCity,
        "outlet_country": outletCountry == null ? null : outletCountry,
        "opening_time": openingTime == null ? null : openingTime,
        "closing_time": closingTime == null ? null : closingTime,
        "type": type == null ? null : type,
        "how_to_redeem": howToRedeem == null ? null : howToRedeem,
        "brand_name": brandName == null ? null : brandName,
        "brand_code": brandCode == null ? null : brandCode,
        "brand_logo": brandLogo == null ? null : brandLogo,
        "merchant_name": merchantName == null ? null : merchantName,
        "merchant_code": merchantCode == null ? null : merchantCode,
        "merchant_phone": merchantPhone == null ? null : merchantPhone,
        "merchant_whatsapp_no": merchantWhatsappNo,
        "merchant_pin": merchantPin == null ? null : merchantPin,
        "is_fav": isFav == null ? null : isFav,
        "distance": distance == null ? null : distance,
        "offers": offers == null
            ? null
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
        "other_branches": otherBranches == null
            ? null
            : List<dynamic>.from(otherBranches!.map((x) => x.toJson())),
      };
}

class Offer {
  Offer(
      {this.ofdId,
      this.offerType,
      this.offerTitle,
      this.offerCode,
      this.offerText,
      this.offerDiscount,
      this.offerDescription,
      this.offerLimit,
      this.type,
      this.routetype,
      this.vouchercode,
      this.partnerOfferid,
      this.voucherCodeType,
      this.availabiltyDate,
      this.offerTermsCon,
      this.affiliateId,
      this.ofrUrl,
      this.ofrSkipCode,
      this.offerexpiry,
      this.ofrPinMandatory,
      this.redemptionLimit,
      this.isBarCode,
      this.isLocation});

  int? ofdId;
  String? offerType;
  String? offerTitle;
  String? offerCode;
  String? offerText;
  String? offerDiscount;
  String? offerDescription;
  String? offerLimit;
  dynamic type;
  dynamic routetype;
  String? vouchercode;
  dynamic partnerOfferid;
  dynamic voucherCodeType;
  DateTime? availabiltyDate;
  String? offerTermsCon;
  dynamic affiliateId;
  dynamic ofrUrl;
  String? ofrSkipCode;
  DateTime? offerexpiry;
  dynamic ofrPinMandatory;
  int? redemptionLimit;
  int? isBarCode;
  int? isLocation;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        ofdId: json["ofd_id"] == null ? null : json["ofd_id"],
        offerType: json["offer_type"] == null ? null : json["offer_type"],
        offerTitle: json["offer_title"] == null ? null : json["offer_title"],
        offerCode: json["offer_code"] == null ? null : json["offer_code"],
        offerText: json["offer_text"] == null ? null : json["offer_text"],
        offerDiscount:
            json["offer_discount"] == null ? null : json["offer_discount"],
        offerDescription: json["offer_description"] == null
            ? null
            : json["offer_description"],
        offerLimit: json["offer_limit"] == null ? null : json["offer_limit"],
        type: json["type"],
        routetype: json["routetype"],
        vouchercode: json["vouchercode"] == null ? null : json["vouchercode"],
        partnerOfferid: json["partner_offerid"],
        voucherCodeType: json["voucher_code_type"],
        availabiltyDate: json["availabilty_date"] == null
            ? null
            : DateTime.parse(json["availabilty_date"]),
        offerTermsCon:
            json["offer_terms_con"] == null ? null : json["offer_terms_con"],
        affiliateId: json["affiliate_id"],
        ofrUrl: json["ofr_url"] == null ? null : json["ofr_url"],
        ofrSkipCode:
            json["ofr_skip_code"] == null ? null : json["ofr_skip_code"],
        offerexpiry: json["offer_expiry"] == null
            ? null
            : DateTime.parse(json["offer_expiry"]),
        ofrPinMandatory: json["ofr_pin_mandatory"],
        redemptionLimit:
            json["redemption_limit"] == null ? null : json["redemption_limit"],
        isBarCode: json["is_barcode"],
        isLocation: json["is_location"],
      );

  Map<String, dynamic> toJson() => {
        "ofd_id": ofdId == null ? null : ofdId,
        "offer_type": offerType == null ? null : offerType,
        "offer_title": offerTitle == null ? null : offerTitle,
        "offer_code": offerCode == null ? null : offerCode,
        "offer_text": offerText == null ? null : offerText,
        "offer_discount": offerDiscount == null ? null : offerDiscount,
        "offer_description": offerDescription == null ? null : offerDescription,
        "offer_limit": offerLimit == null ? null : offerLimit,
        "type": type,
        "routetype": routetype,
        "vouchercode": vouchercode == null ? null : vouchercode,
        "partner_offerid": partnerOfferid,
        "voucher_code_type": voucherCodeType,
        "availabilty_date":
            availabiltyDate == null ? null : availabiltyDate!.toIso8601String(),
        "offer_terms_con": offerTermsCon == null ? null : offerTermsCon,
        "affiliate_id": affiliateId,
        "ofr_url": ofrUrl,
        "ofr_skip_code": ofrSkipCode == null ? null : ofrSkipCode,
        "ofr_pin_mandatory": ofrPinMandatory,
        "offer_expiry":
            offerexpiry == null ? null : offerexpiry!.toIso8601String(),
        "redemption_limit": redemptionLimit == null ? null : redemptionLimit,
        "is_barcode": isBarCode,
        "is_location": isLocation,
      };
}
