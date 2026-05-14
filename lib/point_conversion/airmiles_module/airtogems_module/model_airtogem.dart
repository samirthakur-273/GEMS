import 'dart:convert';

AirmilesToGems airmilesToGemsFromJson(String str) => AirmilesToGems.fromJson(json.decode(str));

String airmilesToGemsToJson(AirmilesToGems data) => json.encode(data.toJson());

class AirmilesToGems {
    AirmilesToGems({
        this.status,
        this.message,
        this.code,
    });

    bool? status;
    String? message;
    String? code;

    factory AirmilesToGems.fromJson(Map<String, dynamic> json) => AirmilesToGems(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "code": code == null ? null : code,
    };
}
