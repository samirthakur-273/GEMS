// To parse this JSON data, do
//
//     final filterCount = filterCountFromMap(jsonString);

import 'dart:convert';

FilterCount filterCountFromMap(String str) => FilterCount.fromMap(json.decode(str));

String filterCountToMap(FilterCount data) => json.encode(data.toMap());

class FilterCount {
    FilterCount({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory FilterCount.fromMap(Map<String, dynamic> json) => FilterCount(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        values: Values.fromMap(json["values"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values!.toMap(),
    };
}

class Values {
    Values({
        this.totalCnt,
        this.filterMenu,
    });

    int? totalCnt;
    FilterMenu? filterMenu;

    factory Values.fromMap(Map<String, dynamic> json) => Values(
        totalCnt: json["total_cnt"],
        filterMenu: FilterMenu.fromMap(json["filterMenu"]),
    );

    Map<String, dynamic> toMap() => {
        "total_cnt": totalCnt,
        "filterMenu": filterMenu!.toMap(),
    };
}

class FilterMenu {
    FilterMenu({
        this.starRating,
        this.priceData,
        this.custRating,
        this.amenities,
        this.themesData,
        this.chainData,
        this.priceSlot,
        this.prprtyData,
        this.refundable,
    });

    List<CustRating>? starRating;
    List<CustRating>? priceData;
    List<CustRating>? custRating;
    List<Amenity>? amenities;
    List<Amenity>? themesData;
    List<Amenity>? chainData;
    List<PriceSlot>? priceSlot;
    List<Amenity>? prprtyData;
    List<PriceSlot>? refundable;

    factory FilterMenu.fromMap(Map<String, dynamic> json) => FilterMenu(
        starRating: List<CustRating>.from(json["star_rating"].map((x) => CustRating.fromMap(x))),
        priceData: List<CustRating>.from(json["price_data"].map((x) => CustRating.fromMap(x))),
        custRating: List<CustRating>.from(json["cust_rating"].map((x) => CustRating.fromMap(x))),
        amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromMap(x))),
        themesData: List<Amenity>.from(json["themes_data"].map((x) => Amenity.fromMap(x))),
        chainData: List<Amenity>.from(json["chain_data"].map((x) => Amenity.fromMap(x))),
        priceSlot: List<PriceSlot>.from(json["priceSlot"].map((x) => PriceSlot.fromMap(x))),
        prprtyData: List<Amenity>.from(json["prprty_data"].map((x) => Amenity.fromMap(x))),
        refundable: List<PriceSlot>.from(json["refundable"].map((x) => PriceSlot.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "star_rating": List<dynamic>.from(starRating!.map((x) => x.toMap())),
        "price_data": List<dynamic>.from(priceData!.map((x) => x.toMap())),
        "cust_rating": List<dynamic>.from(custRating!.map((x) => x.toMap())),
        "amenities": List<dynamic>.from(amenities!.map((x) => x.toMap())),
        "themes_data": List<dynamic>.from(themesData!.map((x) => x.toMap())),
        "chain_data": List<dynamic>.from(chainData!.map((x) => x.toMap())),
        "priceSlot": List<dynamic>.from(priceSlot!.map((x) => x.toMap())),
        "prprty_data": List<dynamic>.from(prprtyData!.map((x) => x.toMap())),
        "refundable": List<dynamic>.from(refundable!.map((x) => x.toMap())),
    };
}

class Amenity {
    Amenity({
        this.id,
        this.value,
        this.count,
    });

    int? id;
    String? value;
    int? count;

    factory Amenity.fromMap(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        value: json["value"],
        count: json["count"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "value": value,
        "count": count,
    };
}

class CustRating {
    CustRating({
        this.value,
        this.count,
    });

    int? value;
    int? count;

    factory CustRating.fromMap(Map<String, dynamic> json) => CustRating(
        value: json["value"],
        count: json["count"],
    );

    Map<String, dynamic> toMap() => {
        "value": value,
        "count": count,
    };
}

class PriceSlot {
    PriceSlot({
        this.value,
        this.count,
    });

    String? value;
    int? count;

    factory PriceSlot.fromMap(Map<String, dynamic> json) => PriceSlot(
        value: json["value"],
        count: json["count"],
    );

    Map<String, dynamic> toMap() => {
        "value": value,
        "count": count,
    };
}
