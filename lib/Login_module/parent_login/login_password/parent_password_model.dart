// To parse this JSON data, do
//
//     final parentPasswordModel = parentPasswordModelFromJson(jsonString);

import 'dart:convert';

ParentPasswordModel parentPasswordModelFromJson(String str) => ParentPasswordModel.fromJson(json.decode(str));

String parentPasswordModelToJson(ParentPasswordModel data) => json.encode(data.toJson());

class ParentPasswordModel {
    ParentPasswordModel({
        this.status,
        this.message,
        this.code,
        this.membershipNo,
        this.values,
    });

    bool? status;
    String? message;
    String? code;
    String? membershipNo;
    Values? values;

    factory ParentPasswordModel.fromJson(Map<String, dynamic> json) => ParentPasswordModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        membershipNo: json["membership_no"],
        // values: Values.fromJson(json["values"]),
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "membership_no": membershipNo,
        "values": values!.toJson(),
    };
}

class Values {
    Values({
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.countryCode,
        this.customerId,
        this.type,
        this.gemsCustomerId,
        this.membershipNo,
        this.schoolCode,
    });

    String? firstName;
    String? lastName;
    String? email;
    String? phone;
    String? countryCode;
    int? customerId;
    String? type;
    String? gemsCustomerId;
    String? membershipNo;
    String? schoolCode;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        countryCode: json["country_code"],
        customerId: json["customer_id"],
        type: json["type"],
        gemsCustomerId: json["gems_customer_id"],
        membershipNo: json["membership_no"],
        schoolCode: json["school_code"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "customer_id": customerId,
        "type": type,
        "gems_customer_id": gemsCustomerId,
        "membership_no": membershipNo,
        "school_code": schoolCode,
    };
}
