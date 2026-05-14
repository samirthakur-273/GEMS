// To parse this JSON data, do
//
//     final autoSuggestHotelModel = autoSuggestHotelModelFromJson(jsonString);

import 'dart:convert';

AutoSuggestHotelModel autoSuggestHotelModelFromJson(String str) => AutoSuggestHotelModel.fromJson(json.decode(str));

String autoSuggestHotelModelToJson(AutoSuggestHotelModel data) => json.encode(data.toJson());

class AutoSuggestHotelModel {
    AutoSuggestHotelModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory AutoSuggestHotelModel.fromJson(Map<String, dynamic> json) => AutoSuggestHotelModel(
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
        this.suggestion,
    });

    List<Suggestion>? suggestion;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        suggestion: List<Suggestion>.from(json["suggestion"].map((x) => Suggestion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "suggestion": List<dynamic>.from(suggestion!.map((x) => x.toJson())),
    };
}

class Suggestion {
    Suggestion({
        this.destinationId,
        this.searchType,
        this.searchText,
        this.destType,
        this.count,
        this.latitude,
        this.longitude,
    });

    int? destinationId;
    int? searchType;
    String? searchText;
    String? destType;
    int? count;
    double? latitude;
    double? longitude;

    factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        destinationId: json["destination_id"],
        searchType: json["search_type"],
        searchText: json["search_text"],
        destType: json["dest_type"],
        count: json["count"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "destination_id": destinationId,
        "search_type": searchType,
        "search_text": searchText,
        "dest_type": destType,
        "count": count,
        "latitude": latitude,
        "longitude": longitude,
    };
}
