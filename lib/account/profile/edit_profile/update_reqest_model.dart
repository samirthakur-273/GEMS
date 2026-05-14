import 'dart:convert';

UpdateRequestModal updateRequestModalFromJson(String str) =>
    UpdateRequestModal.fromJson(json.decode(str));

String updateRequestModalToJson(UpdateRequestModal data) =>
    json.encode(data.toJson());

class UpdateRequestModal {
  String? type;
  String? customerId;
  String? transactionId;
  String? customerType;
  String? email;
  String? firstName;
  String? lastName;
  String? midName;
  String? schoolCode;
  int? countryCode;
  String? productCode;
  String? isStaff;
  String? mobileNo;
  String? gender;
  String? staffId;
  int? nationalityId;
  int? emirateId;
  String? emirateName;
  String? dateOfBirth;
  String? corporateCode;

  UpdateRequestModal({
    this.type,
    this.customerId,
    this.transactionId,
    this.customerType,
    this.email,
    this.firstName,
    this.lastName,
    this.midName,
    this.schoolCode,
    this.countryCode,
    this.productCode,
    this.isStaff,
    this.mobileNo,
    this.gender,
    this.staffId,
    this.nationalityId,
    this.emirateId,
    this.emirateName,
    this.dateOfBirth,
    this.corporateCode,
  });

  factory UpdateRequestModal.fromJson(Map<String, dynamic> json) =>
      UpdateRequestModal(
        type: json["type"],
        customerId: json["customer_id"],
        transactionId: json["transaction_id"],
        customerType: json["customer_type"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        midName: json["mid_name"],
        schoolCode: json["school_code"],
        countryCode: json["country_code"],
        productCode: json["product_code"],
        isStaff: json["is_staff"],
        mobileNo: json["mobile_no"],
        gender: json["gender"],
        staffId: json["staff_id"],
        nationalityId: json["nationality_id"],
        emirateId: json["emirate_id"],
        emirateName: json["emirate_name"],
        dateOfBirth: json["date_of_birth"],
        corporateCode: json["corporate_code"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "customer_id": customerId,
        "transaction_id": transactionId,
        "customer_type": customerType,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "mid_name": midName,
        "school_code": schoolCode,
        "country_code": countryCode,
        "product_code": productCode,
        "is_staff": isStaff,
        "mobile_no": mobileNo,
        "gender": gender,
        "staff_id": staffId,
        "nationality_id": nationalityId,
        "emirate_id": emirateId,
        "emirate_name": emirateName,
        "date_of_birth": dateOfBirth,
        "corporate_code": corporateCode,
      };
}
