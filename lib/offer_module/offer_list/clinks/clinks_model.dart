// To parse this JSON data, do
//
//     final clinksDetailModel = clinksDetailModelFromJson(jsonString);

import 'dart:convert';

ClinksDetailModel clinksDetailModelFromJson(String str) => ClinksDetailModel.fromJson(json.decode(str));

String clinksDetailModelToJson(ClinksDetailModel data) => json.encode(data.toJson());

class ClinksDetailModel {
    ClinksDetailModel({
        this.message,
        this.code,
        this.status,
    });

    String? message;
    String? code;
    bool? status;

    factory ClinksDetailModel.fromJson(Map<String, dynamic> json) => ClinksDetailModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
    };
}
