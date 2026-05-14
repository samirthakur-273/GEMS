
import 'dart:convert';



VerifyPartnerModel verifyPartnerModelFromJson(String str) => VerifyPartnerModel.fromJson(json.decode(str));

String verifyPartnerModelToJson(VerifyPartnerModel data) => json.encode(data.toJson());

class VerifyPartnerModel {
    bool? status;
    int? statusCode;
    String? statusMessage;
    List<Value>? values;
    String? message;
    String? code;
    DateTime? requestTime;
    DateTime? responseTime;
    String? apiExecutionTime;
    String? trackId;

    VerifyPartnerModel({
        this.status,
        this.statusCode,
        this.statusMessage,
        this.values,
        this.message,
        this.code,
        this.requestTime,
        this.responseTime,
        this.apiExecutionTime,
        this.trackId,
    });

    factory VerifyPartnerModel.fromJson(Map<String, dynamic> json) => VerifyPartnerModel(
        status: json["status"],
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
        values: json["values"] == null ? [] : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
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
        "message": message,
        "code": code,
        "requestTime": requestTime?.toIso8601String(),
        "responseTime": responseTime?.toIso8601String(),
        "apiExecutionTime": apiExecutionTime,
        "trackId": trackId,
    };
}

class Value {
    String? linkMemberId;
    String? clientMemberId;
    bool? isOtpRequired;
    String? otpToken;
    String? otp;
    String? mobileNumber;
    int? otpExpireTimeInMinutes;
    int? resendOtpCount;
    int? resendOtpGapInMinutes;

    Value({
        this.linkMemberId,
        this.clientMemberId,
        this.isOtpRequired,
        this.otpToken,
        this.otp,
        this.mobileNumber,
        this.otpExpireTimeInMinutes,
        this.resendOtpCount,
        this.resendOtpGapInMinutes,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        linkMemberId: json["linkMemberId"],
        clientMemberId: json["clientMemberId"],
        isOtpRequired: json["isOtpRequired"],
        otpToken: json["otpToken"],
        otp: json["otp"],
        mobileNumber: json["mobileNumber"],
        otpExpireTimeInMinutes: json["otpExpireTimeInMinutes"],
        resendOtpCount: json["resendOtpCount"],
        resendOtpGapInMinutes: json["resendOtpGapInMinutes"],
    );

    Map<String, dynamic> toJson() => {
        "linkMemberId": linkMemberId,
        "clientMemberId": clientMemberId,
        "isOtpRequired": isOtpRequired,
        "otpToken": otpToken,
        "otp": otp,
        "mobileNumber": mobileNumber,
        "otpExpireTimeInMinutes": otpExpireTimeInMinutes,
        "resendOtpCount": resendOtpCount,
        "resendOtpGapInMinutes": resendOtpGapInMinutes,
    };
}
class VerifyLinkRequest {
  final String transactionFrom;
  final String transactionTo;

  final String clientMemberId;
  final Map<String, dynamic> memberDetails;

  VerifyLinkRequest({
    required this.transactionFrom,
    required this.transactionTo,
    required this.clientMemberId,
    required this.memberDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionFrom': transactionFrom,
      'transactionTo': transactionTo,
      'clientMemberId': clientMemberId,
      "memberDetails": memberDetails,
    };
  }
}
