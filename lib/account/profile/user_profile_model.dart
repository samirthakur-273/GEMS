import 'dart:convert';

UserProfileModel userModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    String? message;
    String? code;
    bool? status;
    Values? values;

    UserProfileModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values?.toJson(),
    };
}

class Values {
    String? gemsCustomerId;
    String? firstName;
    String? lastName;
    String? gender;
    String? email;
    String? phone;
    String? dob;
    String? countryCode;
    String? type;
    int? customerId;
    String? membershipNo;
    String? nationality;
    String? nationalityId;
    dynamic isAdvantagePlusMember;
    dynamic advantagePlusCardNo;
    dynamic advantagePlusExpiryDate;
    dynamic advantagePlusPhoto;
    dynamic partnerId;
    dynamic partnerName;
    dynamic domainName;
    dynamic middleName;
    String? school;
    String? segment;
    String? schoolCode;
    String? schoolEmirate;
    String? schoolEmirateCode;
    dynamic relationshipCode;
    int? emirateId;
    dynamic corporateCode;
    dynamic corporateName;
    int? loginExpired;
    String? emirateName;
    int? pointBalance;
    double? pointRate;
    String? encrytedCustomerId;
    String? encrytedMembershipNo;
    String? countryFlag;
    String? gemsToAirmilesRate;
    String? airmilesToGemsRate;
    List<InterestList>? interestList;
    String? partnerImage;

    Values({
        this.gemsCustomerId,
        this.firstName,
        this.lastName,
        this.gender,
        this.email,
        this.phone,
        this.dob,
        this.countryCode,
        this.type,
        this.customerId,
        this.membershipNo,
        this.nationality,
        this.nationalityId,
        this.isAdvantagePlusMember,
        this.advantagePlusCardNo,
        this.advantagePlusExpiryDate,
        this.advantagePlusPhoto,
        this.partnerId,
        this.partnerName,
        this.domainName,
        this.middleName,
        this.school,
        this.segment,
        this.schoolCode,
        this.schoolEmirate,
        this.schoolEmirateCode,
        this.relationshipCode,
        this.emirateId,
        this.corporateCode,
        this.corporateName,
        this.loginExpired,
        this.emirateName,
        this.pointBalance,
        this.pointRate,
        this.encrytedCustomerId,
        this.encrytedMembershipNo,
        this.countryFlag,
        this.gemsToAirmilesRate,
        this.airmilesToGemsRate,
        this.interestList,
        this.partnerImage
    });

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        gemsCustomerId: json["gems_customer_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        email: json["email"],
        phone: json["phone"],
        dob: json["dob"],
        countryCode: json["country_code"],
        type: json["type"],
        customerId: json["customer_id"],
        membershipNo: json["membership_no"],
        nationality: json["nationality"],
        nationalityId: json["nationality_id"],
        isAdvantagePlusMember: json["is_advantage_plus_member"],
        advantagePlusCardNo: json["advantage_plus_card_no"],
        advantagePlusExpiryDate: json["advantage_plus_expiry_date"],
        advantagePlusPhoto: json["advantage_plus_photo"],
        partnerId: json["partner_id"],
        partnerName: json["partner_name"],
        domainName: json["domain_name"],
        middleName: json["middle_name"],
        school: json["school"],
        segment: json["segment"],
        schoolCode: json["school_code"],
        schoolEmirate: json["school_emirate"],
        schoolEmirateCode: json["school_emirate_code"],
        relationshipCode: json["relationship_code"],
        emirateId: json["emirate_id"],
        corporateCode: json["corporate_code"],
        corporateName: json["corporate_name"],
        loginExpired: json["login_expired"],
        emirateName: json["emirate_name"],
        pointBalance: json["point_balance"],
        pointRate: json["point_rate"]?.toDouble(),
        encrytedCustomerId: json["encryted_customer_id"],
        encrytedMembershipNo: json["encryted_membership_no"],
        countryFlag: json["country_flag"],
        gemsToAirmilesRate: json["gems_to_airmiles_rate"],
        airmilesToGemsRate: json["airmiles_to_gems_rate"],
        partnerImage: json['partner_image'],
        interestList: json["interest_list"] == null ? [] : List<InterestList>.from(json["interest_list"]!.map((x) => InterestList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "gems_customer_id": gemsCustomerId,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "email": email,
        "phone": phone,
        "dob": dob,
        "country_code": countryCode,
        "type": type,
        "customer_id": customerId,
        "membership_no": membershipNo,
        "nationality": nationality,
        "nationality_id": nationalityId,
        "is_advantage_plus_member": isAdvantagePlusMember,
        "advantage_plus_card_no": advantagePlusCardNo,
        "advantage_plus_expiry_date": advantagePlusExpiryDate,
        "advantage_plus_photo": advantagePlusPhoto,
        "partner_id": partnerId,
        "partner_name": partnerName,
        "domain_name": domainName,
        "middle_name": middleName,
        "school": school,
        "segment": segment,
        "school_code": schoolCode,
        "school_emirate": schoolEmirate,
        "school_emirate_code": schoolEmirateCode,
        "relationship_code": relationshipCode,
        "emirate_id": emirateId,
        "corporate_code": corporateCode,
        "corporate_name": corporateName,
        "login_expired": loginExpired,
        "emirate_name": emirateName,
        "point_balance": pointBalance,
        "point_rate": pointRate,
        "encryted_customer_id": encrytedCustomerId,
        "encryted_membership_no": encrytedMembershipNo,
        "country_flag": countryFlag,
        "gems_to_airmiles_rate": gemsToAirmilesRate,
        "airmiles_to_gems_rate": airmilesToGemsRate,
        'partner_image':partnerImage,
        "interest_list": interestList == null ? [] : List<dynamic>.from(interestList!.map((x) => x.toJson())),
    };
}

class InterestList {
    int? interestId;
    String? name;
    String? image;
    String? unselectedImage;
    String? customerStatus;

    InterestList({
        this.interestId,
        this.name,
        this.image,
        this.unselectedImage,
        this.customerStatus,
    });

    factory InterestList.fromJson(Map<String, dynamic> json) => InterestList(
        interestId: json["interest_id"],
        name: json["name"],
        image: json["image"],
        unselectedImage: json["unselected_image"],
        customerStatus: json["customer_status"],
    );

    Map<String, dynamic> toJson() => {
        "interest_id": interestId,
        "name": name,
        "image": image,
        "unselected_image": unselectedImage,
        "customer_status": customerStatus,
    };
}
