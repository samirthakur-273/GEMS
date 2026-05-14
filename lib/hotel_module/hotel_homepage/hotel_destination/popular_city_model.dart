// To parse this JSON data, do
//
//     final popularCityHotelModel = popularCityHotelModelFromJson(jsonString);

import 'dart:convert';

PopularCityHotelModel popularCityHotelModelFromJson(String str) => PopularCityHotelModel.fromJson(json.decode(str));

String popularCityHotelModelToJson(PopularCityHotelModel data) => json.encode(data.toJson());

class PopularCityHotelModel {
    PopularCityHotelModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory PopularCityHotelModel.fromJson(Map<String, dynamic> json) => PopularCityHotelModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        values: Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values!.toJson(),
    };
}

class Values {
    Values({
        this.data,
    });

    List<Datum>? data;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.destinationId,
        this.searchType,
        this.searchText,
        this.destType,
        this.count,
    });

    String? destinationId;
    int? searchType;
    String? searchText;
    String? destType;
    int? count;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        destinationId: json["destination_id"],
        searchType: json["search_type"],
        searchText: json["search_text"]??'',
        destType: json["dest_type"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "destination_id": destinationId,
        "search_type": searchType,
        "search_text": searchText,
        "dest_type": destType,
        "count": count,
    };
}
