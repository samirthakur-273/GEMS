// To parse this JSON data, do
//
//     final hotelListModel = hotelListModelFromJson(jsonString);

import 'dart:convert';

HotelListModel hotelListModelFromJson(String str) =>
    HotelListModel.fromJson(json.decode(str));

String hotelListModelToJson(HotelListModel data) => json.encode(data.toJson());

class HotelListModel {
  HotelListModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory HotelListModel.fromJson(Map<String, dynamic> json) => HotelListModel(
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
    this.totalCnt,
    this.hotels,
  });

  int? totalCnt;
  List<Hotel>? hotels;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        totalCnt: json["total_cnt"] == null ? null : json["total_cnt"],
        hotels: json["hotels"] == null
            ? null
            : List<Hotel>.from(json["hotels"].map((x) => Hotel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_cnt": totalCnt == null ? null : totalCnt,
        "hotels": hotels == null
            ? null
            : List<dynamic>.from(hotels!.map((x) => x.toJson())),
      };
}

class Hotel {
  Hotel({
    this.id,
    this.sid,
    this.rqid,
    this.propertyId,
    this.destId,
    this.cityName,
    this.htlName,
    this.long,
    this.lat,
    this.amenities,
    this.starRating,
    this.customerRating,
    this.distance,
    this.thumbnail,
    this.noOfNights,
    this.supplierPrice,
    this.price,
    this.htlId,
    this.uniqueId,
    this.bnzAccrPnts,
    this.bnzReddemPnts,
    this.totalAmount,
    this.currency,
    this.isRef,
    this.isBrkfst,
    this.themes,
    this.htlChainId,
    this.propId,
    this.version,
  });

  String? id;
  String? sid;
  String? rqid;
  List<int>? propertyId;
  int? destId;
  String? cityName;
  String? htlName;
  int? long;
  int? lat;
  List<String>? amenities;
  int? starRating;
  int? customerRating;
  String? distance;
  String? thumbnail;
  int? noOfNights;
  String? supplierPrice;
  String? price;
  int? htlId;
  String? uniqueId;
  int? bnzAccrPnts;
  int? bnzReddemPnts;
  int? totalAmount;
  String? currency;
  String? isRef;
  String? isBrkfst;
  List<String>? themes;
  String? htlChainId;
  String? propId;
  double? version;

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        id: json["id"] == null ? null : json["id"],
        sid: json["sid"] == null ? null : json["sid"],
        rqid: json["rqid"] == null ? null : json["rqid"],
        propertyId: json["property_id"] == null
            ? null
            : List<int>.from(json["property_id"].map((x) => x)),
        destId: json["dest_id"] == null ? null : json["dest_id"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        htlName: json["htl_name"] == null ? null : json["htl_name"],
        long: json["long"] == null ? null : json["long"],
        lat: json["lat"] == null ? null : json["lat"],
        amenities: json["amenities"] == null
            ? null
            : List<String>.from(json["amenities"].map((x) => x)),
        starRating: json["star_rating"] == null ? null : json["star_rating"],
        customerRating:
            json["customer_rating"] == null ? null : json["customer_rating"],
        distance: json["distance"] == null ? null : json["distance"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        noOfNights: json["no_of_nights"] == null ? null : json["no_of_nights"],
        supplierPrice:
            json["supplier_price"] == null ? null : json["supplier_price"],
        price: json["price"] == null ? null : json["price"],
        htlId: json["htl_id"] == null ? null : json["htl_id"],
        uniqueId: json["unique_id"] == null ? null : json["unique_id"],
        bnzAccrPnts:
            json["bnz_accr_pnts"] == null ? null : json["bnz_accr_pnts"],
        bnzReddemPnts:
            json["bnz_reddem_pnts"] == null ? null : json["bnz_reddem_pnts"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        currency: json["currency"] == null ? null : json["currency"],
        isRef: json["is_ref"] == null ? null : json["is_ref"],
        isBrkfst: json["is_brkfst"] == null ? null : json["is_brkfst"],
        themes: json["themes"] == null
            ? null
            : List<String>.from(json["themes"].map((x) => x)),
        htlChainId: json["htl_chain_id"] == null ? null : json["htl_chain_id"],
        propId: json["prop_id"] == null ? null : json["prop_id"],
        version:
            json["_version_"] == null ? null : json["_version_"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sid": sid == null ? null : sid,
        "rqid": rqid == null ? null : rqid,
        "property_id": propertyId == null
            ? null
            : List<dynamic>.from(propertyId!.map((x) => x)),
        "dest_id": destId == null ? null : destId,
        "city_name": cityName == null ? null : cityName,
        "htl_name": htlName == null ? null : htlName,
        "long": long == null ? null : long,
        "lat": lat == null ? null : lat,
        "amenities": amenities == null
            ? null
            : List<dynamic>.from(amenities!.map((x) => x)),
        "star_rating": starRating == null ? null : starRating,
        "customer_rating": customerRating == null ? null : customerRating,
        "distance": distance == null ? null : distance,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "no_of_nights": noOfNights == null ? null : noOfNights,
        "supplier_price": supplierPrice == null ? null : supplierPrice,
        "price": price == null ? null : price,
        "htl_id": htlId == null ? null : htlId,
        "unique_id": uniqueId == null ? null : uniqueId,
        "bnz_accr_pnts": bnzAccrPnts == null ? null : bnzAccrPnts,
        "bnz_reddem_pnts": bnzReddemPnts == null ? null : bnzReddemPnts,
        "totalAmount": totalAmount == null ? null : totalAmount,
        "currency": currency == null ? null : currency,
        "is_ref": isRef == null ? null : isRef,
        "is_brkfst": isBrkfst == null ? null : isBrkfst,
        "themes":
            themes == null ? null : List<dynamic>.from(themes!.map((x) => x)),
        "htl_chain_id": htlChainId == null ? null : htlChainId,
        "prop_id": propId == null ? null : propId,
        "_version_": version == null ? null : version,
      };
}
