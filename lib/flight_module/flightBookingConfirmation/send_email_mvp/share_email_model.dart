// To parse this JSON data, do
//
//     final shareViaEmailModel = shareViaEmailModelFromJson(jsonString);

import 'dart:convert';

ShareViaEmailModel shareViaEmailModelFromJson(String str) => ShareViaEmailModel.fromJson(json.decode(str));

String shareViaEmailModelToJson(ShareViaEmailModel data) => json.encode(data.toJson());

class ShareViaEmailModel {
    ShareViaEmailModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String ?message;
    String ?code;
    bool ?status;
    Values ?values;

    factory ShareViaEmailModel.fromJson(Map<String, dynamic> json) => ShareViaEmailModel(
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
        this.message,
    });

    String? message;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
    };
}
