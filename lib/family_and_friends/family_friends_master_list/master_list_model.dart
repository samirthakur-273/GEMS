// To parse this JSON data, do
//
//     final masterListModel = masterListModelFromJson(jsonString);

import 'dart:convert';

MasterListModel masterListModelFromJson(String str) =>
    MasterListModel.fromJson(json.decode(str));

String masterListModelToJson(MasterListModel data) =>
    json.encode(data.toJson());

class MasterListModel {
  MasterListModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory MasterListModel.fromJson(Map<String, dynamic> json) =>
      MasterListModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
      };
}

class Values {
  Values(
      {this.school,
      this.emirate,
      this.nationality,
      this.schoolSegment,
      this.fnfRelationship,
      this.countryList,
      this.partnerMasterList});

  List<Emirate>? school;
  List<Emirate>? emirate;
  List<Emirate>? nationality;
  List<Emirate>? schoolSegment;
  List<Emirate>? fnfRelationship;
  List<CountryList>? countryList;
  List<PartnerMasterList>? partnerMasterList;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        school: json["school"] == null
            ? null
            : List<Emirate>.from(
                json["school"].map((x) => Emirate.fromJson(x))),
        emirate: json["emirate"] == null
            ? null
            : List<Emirate>.from(
                json["emirate"].map((x) => Emirate.fromJson(x))),
        nationality: json["nationality"] == null
            ? null
            : List<Emirate>.from(
                json["nationality"].map((x) => Emirate.fromJson(x))),
        schoolSegment: json["school_segment"] == null
            ? null
            : List<Emirate>.from(
                json["school_segment"].map((x) => Emirate.fromJson(x))),
        fnfRelationship: json["fnf_relationship"] == null
            ? null
            : List<Emirate>.from(
                json["fnf_relationship"].map((x) => Emirate.fromJson(x))),
        countryList: json["country_list"] == null
            ? null
            : List<CountryList>.from(
                json["country_list"].map((x) => CountryList.fromJson(x))),
        partnerMasterList: json["partner_master_list"] == null
            ? []
            : List<PartnerMasterList>.from(json["partner_master_list"]!
                .map((x) => PartnerMasterList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school == null
            ? null
            : List<dynamic>.from(school!.map((x) => x.toJson())),
        "emirate": emirate == null
            ? null
            : List<dynamic>.from(emirate!.map((x) => x.toJson())),
        "nationality": nationality == null
            ? null
            : List<dynamic>.from(nationality!.map((x) => x.toJson())),
        "school_segment": schoolSegment == null
            ? null
            : List<dynamic>.from(schoolSegment!.map((x) => x.toJson())),
        "fnf_relationship": fnfRelationship == null
            ? null
            : List<dynamic>.from(fnfRelationship!.map((x) => x.toJson())),
        "country_list": countryList == null
            ? null
            : List<dynamic>.from(countryList!.map((x) => x.toJson())),
        "partner_master_list": partnerMasterList == null
            ? []
            : List<dynamic>.from(partnerMasterList!.map((x) => x.toJson())),
      };
}

class CountryList {
  CountryList({
    this.id,
    this.name,
    this.code,
    this.countryCode,
    this.mobileNumberLength,
    this.image,
  });

  int? id;
  String? name;
  String? code;
  String? countryCode;
  var mobileNumberLength;
  String? image;

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        mobileNumberLength: json["mobile_number_length"] == null
            ? null
            : json["mobile_number_length"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "country_code": countryCode == null ? null : countryCode,
        "mobile_number_length":
            mobileNumberLength == null ? null : mobileNumberLength,
        "image": image == null ? null : image,
      };
}

class Emirate {
  Emirate({
    this.name,
    this.code,
  });

  String? name;
  String? code;

  factory Emirate.fromJson(Map<String, dynamic> json) => Emirate(
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "code": code == null ? null : code,
      };
}

class PartnerMasterList {
    int? id;
    String? partner;
    String? code;
    String? domainName;

    PartnerMasterList({
        this.id,
        this.partner,
        this.code,
        this.domainName,
    });

    factory PartnerMasterList.fromJson(Map<String, dynamic> json) => PartnerMasterList(
        id: json["id"],
        partner: json["partner"],
        code: json["code"],
        domainName: json["domain_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "partner": partner,
        "code": code,
        "domain_name": domainName,
    };
}
