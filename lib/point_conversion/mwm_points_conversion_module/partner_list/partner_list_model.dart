
import 'dart:convert';

PartnerListModel partnerListModelFromJson(String str) => PartnerListModel.fromJson(json.decode(str));

String partnerListModelToJson(PartnerListModel data) => json.encode(data.toJson());

class PartnerListModel {
    bool? status;
    int? statusCode;
    String? statusMessage;
    List<PartnerListDetails>? values;
    int? partnerCount;
    String? message;
    String? code;
    DateTime? requestTime;
    DateTime? responseTime;
    String? apiExecutionTime;
    String? trackId;

    PartnerListModel({
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

    factory PartnerListModel.fromJson(Map<String, dynamic> json) => PartnerListModel(
        status: json["status"],
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
        values: json["values"] == null ? [] : List<PartnerListDetails>.from(json["values"]!.map((x) => PartnerListDetails.fromJson(x))),
        partnerCount: json["partnerCount"],
        message: json["message"],
        code: json["code"],
        requestTime: json["requestTime"] == null ? null : DateTime.parse(json["requestTime"]),
        responseTime: json["responseTime"] == null ? null : DateTime.parse(json["responseTime"]),
        apiExecutionTime: json["apiExecutionTime"],
        trackId: json["trackId"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "statusMessage": statusMessage,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x.toJson())),
        "partnerCount": partnerCount,
        "message": message,
        "code": code,
        "requestTime": requestTime?.toIso8601String(),
        "responseTime": responseTime?.toIso8601String(),
        "apiExecutionTime": apiExecutionTime,
        "trackId": trackId,
    };
}

class PartnerListDetails {
    String? partnerId;
    String? partnerName;
    String? displayName;
    int? displaySequence;
    String? partnerLogo;
    String? partnerCurrencyId;
    String? partnerCurrencyName;
    String? status;
    String? partnerCatergory;
    String? partnerType;

    PartnerListDetails({
        this.partnerId,
        this.partnerName,
        this.displayName,
        this.displaySequence,
        this.partnerLogo,
        this.partnerCurrencyId,
        this.partnerCurrencyName,
        this.status,
        this.partnerCatergory,
        this.partnerType
    });

    factory PartnerListDetails.fromJson(Map<String, dynamic> json) => PartnerListDetails(
        partnerId: json["partnerID"],
        partnerName: json["partnerName"],
        displayName: json["displayName"],
        displaySequence: json["displaySequence"],
        partnerLogo: json["partnerLogo"],
        partnerCurrencyId: json["partnerCurrencyId"],
        partnerCurrencyName: json["partnerCurrencyName"],
        status: json["status"],
        partnerCatergory: json["partnerCatergory"],
        partnerType:json['partner_type']
    );

    Map<String, dynamic> toJson() => {
        'partnerID': partnerId,
        'partnerName': partnerName,
        "displayName": displayName,
        "displaySequence": displaySequence,
        "partnerLogo": partnerLogo,
        "partnerCurrencyId": partnerCurrencyId,
        "partnerCurrencyName": partnerCurrencyName,
        "status": status,
        "partnerCatergory": partnerCatergory,
        'partner_type':partnerType
    };
}
