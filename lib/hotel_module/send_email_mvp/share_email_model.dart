import 'dart:convert';

ShareViaEmailModel shareViaEmailModelFromMap(String str) =>
    ShareViaEmailModel.fromMap(json.decode(str));

String shareViaEmailModelToMap(ShareViaEmailModel data) =>
    json.encode(data.toMap());

class ShareViaEmailModel {
  ShareViaEmailModel({
    this.message,
    this.code,
    this.status,
    this.values,
    this.error,
  });

  String? message;
  String? code;
  bool? status;
  Error? values;
  Error? error;

  factory ShareViaEmailModel.fromMap(Map<String, dynamic> json) =>
      ShareViaEmailModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Error.fromMap(json["values"]),
        error: json["error"] == null ? null : Error.fromMap(json["error"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toMap(),
        "error": error == null ? null : error!.toMap(),
      };
}

class Error {
  Error({
    this.message,
  });

  String? message;

  factory Error.fromMap(Map<String, dynamic> json) => Error(
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
      };
}
