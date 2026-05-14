import 'dart:convert';

VisitorUpdateRequestModal visitorUpdateRequestModalFromJson(String str) => VisitorUpdateRequestModal.fromJson(json.decode(str));

String visitorUpdateRequestModalToJson(VisitorUpdateRequestModal data) => json.encode(data.toJson());

class VisitorUpdateRequestModal {
    String? email;
    String? timestamp;
    String? firstName;
    String? lastName;
    String? countryCode;
    String? phone;
    String? country;
    String? status;
    String? membershipNo;

    VisitorUpdateRequestModal({
        this.email,
        this.timestamp,
        this.firstName,
        this.lastName,
        this.countryCode,
        this.phone,
        this.country,
        this.status,
        this.membershipNo,
    });

    factory VisitorUpdateRequestModal.fromJson(Map<String, dynamic> json) => VisitorUpdateRequestModal(
        email: json["email"] == null ? null : json["email"],
        timestamp: json["timestamp"]  == null ? null : json["timestamp"],
        firstName: json["first_name"]  == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        phone: json["phone"] == null ? null : json["phone"],
        country: json["country"] == null ? null : json["country"],
        status: json["status"] == null ? null : json["status"],
        membershipNo: json["membership_no"] == null ? null : json["membership_no"],
    );

    Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "timestamp": timestamp == null ? null : timestamp,
        "first_name": firstName == null ? null :  firstName,
        "last_name": lastName == null ? null : lastName,
        "country_code": countryCode == null ? null : countryCode,
        "phone": phone == null ? null : phone,
        "country": country == null ? null : country,
        "status": status == null ? null : status,
        "membership_no": membershipNo == null ? null : membershipNo,
    };
}
