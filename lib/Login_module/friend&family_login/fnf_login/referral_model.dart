import 'dart:convert';

ReferralModel referralModelFromJson(String str) => ReferralModel.fromJson(json.decode(str));

String referralModelToJson(ReferralModel data) => json.encode(data.toJson());

class ReferralModel {
    ReferralModel({
        this.status,
        this.message,
        this.statusCode,
        this.values,
    });

    bool? status;
    String? message;
    String? statusCode;
    Values? values;

    factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
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
        this.membershipNo,
        this.isConverted,
    });

    String? email;
    String? mobileNumber;
    String? countryCode;
    int? otp;
    String? token;
    String? membershipNo;
    bool? isConverted;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        email: json["email"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        otp: json["otp"],
        token: json["token"],
        membershipNo: json["membership_no"],
        isConverted: json["is_converted"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "otp": otp,
        "token": token,
        "membership_no": membershipNo,
        "is_converted": isConverted,
    };
}