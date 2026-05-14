// To parse this JSON data, do
//
//     final resendParentOtpModel = resendParentOtpModelFromJson(jsonString);

import 'dart:convert';

ResendParentOtpModel resendParentOtpModelFromJson(String str) => ResendParentOtpModel.fromJson(json.decode(str));

String resendParentOtpModelToJson(ResendParentOtpModel data) => json.encode(data.toJson());

class ResendParentOtpModel {
    ResendParentOtpModel({
        this.status,
        this.message,
        this.statusCode,
        this.values,
    });

    bool? status;
    String? message;
    String? statusCode;
    Values? values;

    factory ResendParentOtpModel.fromJson(Map<String, dynamic> json) => ResendParentOtpModel(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        // values: Values.fromJson(json["values"]),
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "values": values!.toJson(),
    };
}

class Values {
    Values({
        this.email,
        this.mobileNumber,
        this.countryCode,
        this.otp,
        this.token,
    });

    String? email;
    String? mobileNumber;
    String? countryCode;
    String? otp;
    String? token;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        email: json["email"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        otp: json["otp"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "otp": otp,
        "token": token,
    };
}
