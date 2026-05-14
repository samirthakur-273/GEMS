import 'dart:convert';

List<ForgotPasswordModel> forgotpasswordFromJson(String str) => List<ForgotPasswordModel>.from(json.decode(str).map((x) => ForgotPasswordModel.fromJson(x)));

String forgotpasswordToJson(List<ForgotPasswordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForgotPasswordModel {
  ForgotPasswordModel({
    this.success,
    this.message,
  });

  String? success;
  String? message;

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) => ForgotPasswordModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}