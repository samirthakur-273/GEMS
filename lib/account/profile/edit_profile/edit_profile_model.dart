import 'dart:convert';

UpdateRegistrationModal updateRegistrationModalFromJson(String str) => UpdateRegistrationModal.fromJson(json.decode(str));

String updateRegistrationModalToJson(UpdateRegistrationModal data) => json.encode(data.toJson());

class UpdateRegistrationModal {
    bool? status;
    String? message;
    String? statusCode;
    Values? values;

    UpdateRegistrationModal({
        this.status,
        this.message,
        this.statusCode,
        this.values,
    });

    factory UpdateRegistrationModal.fromJson(Map<String, dynamic> json) => UpdateRegistrationModal(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "values": values?.toJson(),
    };
}

class Values {
    int? membershipNo;
    String? schoolCode;
    int? customerId;

    Values({
        this.membershipNo,
        this.schoolCode,
        this.customerId,
    });

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        membershipNo: json["membership_no"],
        schoolCode: json["school_code"],
        customerId: json["customer_id"],
    );

    Map<String, dynamic> toJson() => {
        "membership_no": membershipNo,
        "school_code": schoolCode,
        "customer_id": customerId,
    };
}
