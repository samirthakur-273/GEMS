import 'dart:convert';

TransactionCappingModel transactionCappingModelFromJson(String str) =>
  TransactionCappingModel.fromJson(json.decode(str));

String transactionCappingModelToJson(TransactionCappingModel data) =>
  json.encode(data.toJson());

class TransactionCappingModel {
  bool? status;
  int? statusCode;
  String? statusMessage;
  List<CappedTransactionValue>? values;
  String? message;
  String? code;
  DateTime? requestTime;
  DateTime? responseTime;
  String? apiExecutionTime;
  String? trackId;

  TransactionCappingModel({
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

  factory TransactionCappingModel.fromJson(Map<String, dynamic> json) =>
    TransactionCappingModel(
    status: json["status"],
    statusCode: json["statusCode"],
    statusMessage: json["statusMessage"],
    values: json["values"] == null
      ? []
      : List<CappedTransactionValue>.from(json["values"]!.map((x) => CappedTransactionValue.fromJson(x))),
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

class CappedTransactionValue {
  int? minTransfer;
  dynamic maxTransfer;
  String? redemptionRatio;
  int? incrementalValue;
  int? pointBalance;
  List<dynamic>? slab;

  CappedTransactionValue({
  this.minTransfer,
  this.maxTransfer,
  this.redemptionRatio,
  this.incrementalValue,
  this.pointBalance,
  this.slab,
  });

  factory CappedTransactionValue.fromJson(Map<String, dynamic> json) => CappedTransactionValue(
    minTransfer: json["minTransfer"],
    maxTransfer: json["maxTransfer"],
    redemptionRatio: json["redemptionRatio"],
    incrementalValue: json["incrementalValue"],
    pointBalance: json["pointBalance"],
    slab: json["slab"] == null
      ? []
      : List<dynamic>.from(json["slab"]!.map((x) => x)),
    );

  Map<String, dynamic> toJson() => {
    "minTransfer": minTransfer,
    "maxTransfer": maxTransfer,
    "redemptionRatio": redemptionRatio,
    "incrementalValue": incrementalValue,
    "pointBalance": pointBalance,
    "slab": slab == null ? [] : List<dynamic>.from(slab!.map((x) => x)),
    };
}
