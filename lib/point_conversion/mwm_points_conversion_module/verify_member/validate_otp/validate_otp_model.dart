
import 'dart:convert';

ValidateOtp validateOtpFromJson(String str) => ValidateOtp.fromJson(json.decode(str));

String validateOtpToJson(ValidateOtp data) => json.encode(data.toJson());

class ValidateOtp {
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

    ValidateOtp({
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

    factory ValidateOtp.fromJson(Map<String, dynamic> json) => ValidateOtp(
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
    String? message;

    Value({
        this.linkMemberId,
        this.message,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        linkMemberId: json["linkMemberId"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "linkMemberId": linkMemberId,
        "message": message,
    };
}
class ValidateOtpRequest {
  final String? linkMemberId;
  final String? otpToken;
  final String otp;

  ValidateOtpRequest({
    this.linkMemberId,
    this.otpToken,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "linkMemberId": linkMemberId,
      "otpToken": otpToken,
      "otp": otp,
    };
  }
}
