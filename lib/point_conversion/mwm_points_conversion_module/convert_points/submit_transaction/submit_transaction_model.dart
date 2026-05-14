import 'dart:convert';

SubmitTransactionModel submitTransactionModelFromJson(String str) =>
    SubmitTransactionModel.fromJson(json.decode(str));

String submitTransactionModelToJson(SubmitTransactionModel data) =>
    json.encode(data.toJson());

class SubmitTransactionModel {
  String? message;
  String? code;
  bool? status;
  int? statusCode;
  String? statusMessage;
  List<TransactionDetails>? values;
  DateTime? responseTime;
  String? apiExecutionTime;

  SubmitTransactionModel({
    this.message,
    this.code,
    this.status,
    this.statusCode,
    this.statusMessage,
    this.values,
    this.responseTime,
    this.apiExecutionTime,
  });

  factory SubmitTransactionModel.fromJson(Map<String, dynamic> json) =>
      SubmitTransactionModel(
        message: json['message'],
        code: json['code'],
        status: json['status'],
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        values: json['values'] == null
            ? null
            : List<TransactionDetails>.from(
                json['values'].map((x) => TransactionDetails.fromJson(x))),
        responseTime: json['responseTime'] == null
            ? null
            : DateTime.parse(json['responseTime']),
        apiExecutionTime: json['apiExecutionTime'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'status': status,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'values': values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        'responseTime': responseTime?.toIso8601String(),
        'apiExecutionTime': apiExecutionTime,
      };
}

class TransactionDetails {
  String? referenceId;
  int? transactionStatusCode;
  String? transactionStatus;
  DateTime? createdAt;

  TransactionDetails({
    this.referenceId,
    this.transactionStatusCode,
    this.transactionStatus,
    this.createdAt,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
        referenceId: json['referenceId'],
        transactionStatusCode: json['transactionStatusCode'],
        transactionStatus: json['transactionStatus'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'referenceId': referenceId,
        'transactionStatusCode': transactionStatusCode,
        'transactionStatus': transactionStatus,
        'createdAt': createdAt?.toIso8601String(),
      };
}
