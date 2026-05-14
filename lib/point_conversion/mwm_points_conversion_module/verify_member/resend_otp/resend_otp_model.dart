import 'dart:convert';

ResendOtpModal resendOtpModalFromJson(String str) =>
    ResendOtpModal.fromJson(json.decode(str));

String resendOtpModalToJson(ResendOtpModal data) => json.encode(data.toJson());

class ResendOtpModal {
  bool? status;
  int? statusCode;
  String? statusMessage;
  List<Values>? values;
  String? message;
  String? code;
  DateTime? requestTime;
  DateTime? responseTime;
  String? apiExecutionTime;
  String? trackId;

  ResendOtpModal({
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

  factory ResendOtpModal.fromJson(Map<String, dynamic> json) => ResendOtpModal(
        status: json["status"],
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
        values: json["values"] == null
            ? []
            : List<Values>.from(json["values"]!.map((x) => Values.fromJson(x))),
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
        "message": message,
        "code": code,
        "requestTime": requestTime?.toIso8601String(),
        "responseTime": responseTime?.toIso8601String(),
        "apiExecutionTime": apiExecutionTime,
        "trackId": trackId,
      };
}

class Values {
  String? linkMemberId;
  bool? isOtpRequired;
  String? otpToken;
  String? otp;
  String? mobileNumber;

  Values({
    this.linkMemberId,
    this.isOtpRequired,
    this.otpToken,
    this.otp,
    this.mobileNumber,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        linkMemberId: json["linkMemberId"],
        isOtpRequired: json["isOtpRequired"],
        otpToken: json["otpToken"],
        otp: json["otp"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "linkMemberId": linkMemberId,
        "isOtpRequired": isOtpRequired,
        "otpToken": otpToken,
        "otp": otp,
        "mobileNumber": mobileNumber,
      };
}

class ResendOtpRequest {
  final String? linkMemberId;

  ResendOtpRequest({this.linkMemberId});

  Map<String, dynamic> toJson() {
    return {
      "linkMemberId": linkMemberId,
    };
  }
}
