
import 'dart:convert';

AirmilesGemsPointModel airmilesGemsPointModelFromJson(String str) => AirmilesGemsPointModel.fromJson(json.decode(str));

String airmilesGemsPointModelToJson(AirmilesGemsPointModel data) => json.encode(data.toJson());

class AirmilesGemsPointModel {
    bool status;
    String message;
    String statusCode;
    Values values;

    AirmilesGemsPointModel({
        required this.status,
        required this.message,
        required this.statusCode,
        required this.values,
    });

    factory AirmilesGemsPointModel.fromJson(Map<String, dynamic> json) => AirmilesGemsPointModel(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        values: Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "values": values.toJson(),
    };
}

class Values {
    List<AirmilesToGem> airmilesToGems;
    List<AirmilesToGem> gemsToAirmiles;

    Values({
        required this.airmilesToGems,
        required this.gemsToAirmiles,
    });

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        airmilesToGems: List<AirmilesToGem>.from(json["airmiles_to_gems"].map((x) => AirmilesToGem.fromJson(x))),
        gemsToAirmiles: List<AirmilesToGem>.from(json["gems_to_airmiles"].map((x) => AirmilesToGem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "airmiles_to_gems": List<dynamic>.from(airmilesToGems.map((x) => x.toJson())),
        "gems_to_airmiles": List<dynamic>.from(gemsToAirmiles.map((x) => x.toJson())),
    };
}

class AirmilesToGem {
    int gemsPoints;
    int airmiles;

    AirmilesToGem({
        required this.gemsPoints,
        required this.airmiles,
    });

    factory AirmilesToGem.fromJson(Map<String, dynamic> json) => AirmilesToGem(
        gemsPoints: json["gems_points"],
        airmiles: json["airmiles"],
    );

    Map<String, dynamic> toJson() => {
        "gems_points": gemsPoints,
        "airmiles": airmiles,
    };
}
