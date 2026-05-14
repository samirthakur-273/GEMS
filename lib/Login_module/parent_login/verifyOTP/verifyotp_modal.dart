import 'dart:convert';

VerifyOtpModal verifyOtpModalFromJson(String str) => VerifyOtpModal.fromJson(json.decode(str));

String verifyOtpModalToJson(VerifyOtpModal data) => json.encode(data.toJson());

class VerifyOtpModal {
    VerifyOtpModal({
        this.status,
        this.message,
        this.statusCode,
        this.membershipNo,
        this.values,
    });

    bool? status;
    String? message;
    String? statusCode;
    String? membershipNo;
    Values? values;

    factory VerifyOtpModal.fromJson(Map<String, dynamic> json) => VerifyOtpModal(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        membershipNo: json["membership_no"],
        // values: Values.fromJson(json["values"]),
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "membership_no": membershipNo,
        "values": values!.toJson(),
      };
}

class Values {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  String? type;
  dynamic customerId;
  dynamic gemsCustomerId;
  dynamic membershipNo;
  dynamic schoolCode;
  String? otp;
  int? profileUpdate;
  String ? relationType;

  Values({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.type,
    this.customerId,
    this.gemsCustomerId,
    this.membershipNo,
    this.schoolCode,
    this.otp,
    this.profileUpdate,
    this.relationType
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        countryCode: json["country_code"],
        type: json["type"],
        customerId: json["customer_id"],
        gemsCustomerId: json["gems_customer_id"],
        membershipNo: json["membership_no"],
        schoolCode: json["school_code"],
        relationType: json["relation_type"],
        otp: json["otp"],
        profileUpdate: json["profile_update"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "type": type,
        "customer_id": customerId,
        "gems_customer_id": gemsCustomerId,
        "membership_no": membershipNo,
        "school_code": schoolCode,
        "relation_type":relationType,
        "otp": otp,
        "profile_update": profileUpdate,
      };
}
