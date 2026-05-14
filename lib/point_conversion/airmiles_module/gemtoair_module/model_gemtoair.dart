import 'dart:convert';

GemsToAirmiles gemsToAirmilesFromJson(String str) => GemsToAirmiles.fromJson(json.decode(str));

String gemsToAirmilesToJson(GemsToAirmiles data) => json.encode(data.toJson());

class GemsToAirmiles {
    GemsToAirmiles({
        this.status,
        this.message,
        this.statusCode,
    });

    bool? status;
    String? message;
    String? statusCode;

    factory GemsToAirmiles.fromJson(Map<String, dynamic> json) => GemsToAirmiles(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "status_code": statusCode == null ? null : statusCode,
    };
}
