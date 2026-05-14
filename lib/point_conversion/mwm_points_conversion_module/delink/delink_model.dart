import 'dart:convert';

DelinkModel delinkModelFromJson(String str) =>
    DelinkModel.fromJson(json.decode(str));

String delinkModelToJson(DelinkModel data) => json.encode(data.toJson());

class DelinkModel {
  String? message;
  String? code;
  bool? status;
  int? statusCode;
  String? statusMessage;
  DateTime? responseTime;
  String? apiExecutionTime;
  String? error;

  DelinkModel({
    this.message,
    this.code,
    this.status,
    this.statusCode,
    this.statusMessage,
    this.responseTime,
    this.apiExecutionTime,
    this.error,
  });

  factory DelinkModel.fromJson(Map<String, dynamic> json) => DelinkModel(
        message: json['message'],
        code: json['code'],
        status: json['status'],
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        responseTime: json['responseTime'] == null
            ? null
            : DateTime.parse(json['responseTime']),
        apiExecutionTime: json['apiExecutionTime'],
        error: json['error'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'status': status,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'responseTime': responseTime?.toIso8601String(),
        'apiExecutionTime': apiExecutionTime,
        'error': error,
      };
}
