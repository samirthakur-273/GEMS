import 'dart:convert';

PartnerDetailsModel partnerDetailsModelFromJson(String str) =>
    PartnerDetailsModel.fromJson(json.decode(str));

String partnerDetailsModelToJson(PartnerDetailsModel data) =>
    json.encode(data.toJson());

class PartnerDetailsModel {
  bool? status;
  int? statusCode;
  String? statusMessage;
  List<Value>? values;
  int? partnerCount;
  String? message;
  String? code;
  DateTime? requestTime;
  DateTime? responseTime;
  String? apiExecutionTime;
  String? trackId;

  PartnerDetailsModel({
    this.status,
    this.statusCode,
    this.statusMessage,
    this.values,
    this.partnerCount,
    this.message,
    this.code,
    this.requestTime,
    this.responseTime,
    this.apiExecutionTime,
    this.trackId,
  });

  factory PartnerDetailsModel.fromJson(Map<String, dynamic> json) =>
      PartnerDetailsModel(
        status: json["status"],
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
        partnerCount: json["partnerCount"],
        message: json["message"],
        code: json["code"],
        requestTime: json["requestTime"] == null
            ? null
            : DateTime.parse(json["requestTime"]),
        responseTime: json["responseTime"] == null
            ? null
            : DateTime.parse(json["responseTime"]),
        apiExecutionTime: json["apiExecutionTime"],
        trackId: json["trackId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "statusMessage": statusMessage,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "partnerCount": partnerCount,
        "message": message,
        "code": code,
        "requestTime": requestTime?.toIso8601String(),
        "responseTime": responseTime?.toIso8601String(),
        "apiExecutionTime": apiExecutionTime,
        "trackId": trackId,
      };
}

class Value {
  String? partnerId;
  String? partnerName;
  String? displayName;
  int? displaySequence;
  String? partnerCurrencyCode;
  int? status;
  int? delinkExpiry;
  int? multiLink;
  List<FieldColumn>? fieldColumns;
  String? regex;
  String? regexDesc;
  int? regexLength;
  String? tnc;
  String? partnerCatergory;
  List<PartnerTier>? partnerTier;
  List<PartnerCurrency>? partnerCurrency;
  String? partnerType;

  Value(
      {this.partnerId,
      this.partnerName,
      this.displayName,
      this.displaySequence,
      this.partnerCurrencyCode,
      this.status,
      this.delinkExpiry,
      this.multiLink,
      this.fieldColumns,
      this.regex,
      this.regexDesc,
      this.regexLength,
      this.tnc,
      this.partnerCatergory,
      this.partnerTier,
      this.partnerCurrency,
      this.partnerType});

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        partnerId: json["partnerID"],
        partnerName: json["partnerName"],
        displayName: json["displayName"],
        displaySequence: json["displaySequence"],
        partnerCurrencyCode: json["partnerCurrencyCode"],
        status: json["status"],
        delinkExpiry: json["delink_expiry"],
        multiLink: json["multi_link"],
        fieldColumns: json["fieldColumns"] == null
            ? []
            : List<FieldColumn>.from(
                json["fieldColumns"]!.map((x) => FieldColumn.fromJson(x))),
        regex: json["regex"],
        regexDesc: json["regex_desc"],
        regexLength: json["regexLength"],
        tnc: json["tnc"],
        partnerType: json["partnerType"],
        partnerCatergory: json["partnerCatergory"],
        partnerTier: json["partnerTier"] == null
            ? []
            : List<PartnerTier>.from(
                json["partnerTier"]!.map((x) => PartnerTier.fromJson(x))),
        partnerCurrency: json["partnerCurrency"] == null
            ? []
            : List<PartnerCurrency>.from(json["partnerCurrency"]!
                .map((x) => PartnerCurrency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "partnerID": partnerId,
        "partnerName": partnerName,
        "displayName": displayName,
        "displaySequence": displaySequence,
        "partnerCurrencyCode": partnerCurrencyCode,
        "status": status,
        "delink_expiry": delinkExpiry,
        "multi_link": multiLink,
        "fieldColumns": fieldColumns == null
            ? []
            : List<dynamic>.from(fieldColumns!.map((x) => x.toJson())),
        "regex": regex,
        "regex_desc": regexDesc,
        "regexLength": regexLength,
        "tnc": tnc,
        "partnerCatergory": partnerCatergory,
        "partnerType": partnerType,
        "partnerTier": partnerTier == null
            ? []
            : List<dynamic>.from(partnerTier!.map((x) => x.toJson())),
        "partnerCurrency": partnerCurrency == null
            ? []
            : List<dynamic>.from(partnerCurrency!.map((x) => x.toJson())),
      };
}

class FieldColumn {
  String? type;
  String? pattern;
  String fieldName;
  String? validations;
  int? patternLength;
  String? displayFieldName;

  FieldColumn({
    this.type,
    this.pattern,
    required this.fieldName,
    this.validations,
    this.patternLength,
    this.displayFieldName,
  });

  factory FieldColumn.fromJson(Map<String, dynamic> json) => FieldColumn(
        type: json["type"],
        pattern: json["pattern"],
        fieldName: json["fieldName"],
        validations: json["validations"],
        patternLength: json["patternLength"],
        displayFieldName: json["displayFieldName"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "pattern": pattern,
        "fieldName": fieldName,
        "validations": validations,
        "patternLength": patternLength,
        "displayFieldName": displayFieldName,
      };
}

class PartnerCurrency {
  String? partnerCurrencyId;
  String? partnerCurrencyName;

  PartnerCurrency({
    this.partnerCurrencyId,
    this.partnerCurrencyName,
  });

  factory PartnerCurrency.fromJson(Map<String, dynamic> json) =>
      PartnerCurrency(
        partnerCurrencyId: json["partnerCurrencyId"],
        partnerCurrencyName: json["partnerCurrencyName"],
      );

  Map<String, dynamic> toJson() => {
        "partnerCurrencyId": partnerCurrencyId,
        "partnerCurrencyName": partnerCurrencyName,
      };
}

class PartnerTier {
  String? code;
  String? tierName;
  String? tierCode;
  String? partnerCode;

  PartnerTier({
    this.code,
    this.tierName,
    this.tierCode,
    this.partnerCode,
  });

  factory PartnerTier.fromJson(Map<String, dynamic> json) => PartnerTier(
        code: json["code"],
        tierName: json["tier_name"],
        tierCode: json["tier_code"],
        partnerCode: json["partner_code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "tier_name": tierName,
        "tier_code": tierCode,
        "partner_code": partnerCode,
      };
}
