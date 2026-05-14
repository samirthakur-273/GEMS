import 'dart:convert';

GenerateOtpModal generateOtpModalFromJson(String str) =>
    GenerateOtpModal.fromJson(json.decode(str));

String generateOtpModalToJson(GenerateOtpModal data) =>
    json.encode(data.toJson());

class GenerateOtpModal {
  bool? status;
  String? message;
  String? statusCode;
  Values? values;

  GenerateOtpModal({
    this.status,
    this.message,
    this.statusCode,
    this.values,
  });

  factory GenerateOtpModal.fromJson(Map<String, dynamic> json) =>
      GenerateOtpModal(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
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
  String? email;
  String? mobileNumber;
  String? countryCode;
  int? otp;
  String? membershipNo;
  String? token;
  int? isCisco;
  int? corporateId;
  String? corporateName;
  String? corporateCode;
  int? isDomainWhitelist;

  Values({
    this.email,
    this.mobileNumber,
    this.countryCode,
    this.otp,
    this.membershipNo,
    this.token,
    this.isCisco,
    this.corporateId,
    this.corporateName,
    this.corporateCode,
    this.isDomainWhitelist,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        email: json["email"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        otp: json["otp"],
        membershipNo: json["membership_no"],
        token: json["token"],
        isCisco: json["is_cisco"],
        corporateId: json["corporate_id"],
        corporateName: json["corporate_name"],
        corporateCode: json["corporate_code"],
        isDomainWhitelist: json["isDomainWhitelist"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "otp": otp,
        "membership_no": membershipNo,
        "token": token,
        "is_cisco": isCisco,
        "corporate_id": corporateId,
        "corporate_name": corporateName,
        "corporate_code": corporateCode,
        "isDomainWhitelist": isDomainWhitelist,
      };
}
