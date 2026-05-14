import 'dart:convert';

SmilesLoginModel smilesLoginModelFromJson(String str) => SmilesLoginModel.fromJson(json.decode(str));

String smilesLoginModelToJson(SmilesLoginModel data) => json.encode(data.toJson());

class SmilesLoginModel {
    SmilesLoginModel({
        this.status,
        this.statusCode,
        this.message,
    });

    bool? status;
    int? statusCode;
    String? message;

    factory SmilesLoginModel.fromJson(Map<String, dynamic> json) => SmilesLoginModel(
        status: json["status"] == null ? null : json["status"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
    };
}
