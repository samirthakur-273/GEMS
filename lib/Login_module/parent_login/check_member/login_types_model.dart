import 'dart:convert';

CheckMemberModel checkMemberModelFromJson(String str) =>
    CheckMemberModel.fromJson(json.decode(str));

String checkMemberModelToJson(CheckMemberModel data) =>
    json.encode(data.toJson());

class CheckMemberModel {
  String? message;
  String? code;
  int? isCisco;
  int? isCorporate;
  bool? status;
  Values? values;

  CheckMemberModel({
    this.message,
    this.code,
    this.isCisco,
    this.isCorporate,
    this.status,
    this.values,
  });

  factory CheckMemberModel.fromJson(Map<String, dynamic> json) =>
      CheckMemberModel(
        message: json["message"],
        code: json["code"],
        isCisco: json["is_cisco"] == null ? null : json["is_cisco"],
        isCorporate: json["is_corporate"] == null ? null : json["is_corporate"],
        status: json["status"],
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "is_cisco": isCisco,
        "is_corporate": isCorporate,
        "status": status,
        "values": values!.toJson(),
      };
}

class Values {
  String? type;
  String? membershipNo;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  String? gemsCustomerId;

  Values({
    this.type,
    this.membershipNo,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.gemsCustomerId,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        type: json["type"],
        membershipNo: json["membership_no"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        countryCode: json["country_code"],
        gemsCustomerId: json["gems_customer_id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "membership_no": membershipNo,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "gems_customer_id": gemsCustomerId,
      };
}
