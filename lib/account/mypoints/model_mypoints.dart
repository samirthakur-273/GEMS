import 'dart:convert';

MyPointsModel myPointsModelFromJson(String str) =>
    MyPointsModel.fromJson(json.decode(str));

String myPointsModelToJson(MyPointsModel data) => json.encode(data.toJson());

class MyPointsModel {
  MyPointsModel({
    this.status,
    this.message,
    this.statusCode,
    this.values,
  });

  bool? status;
  String? message;
  String? statusCode;
  Values? values;

  factory MyPointsModel.fromJson(Map<String, dynamic> json) => MyPointsModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "status_code": statusCode == null ? null : statusCode,
        "values": values == null ? null : values!.toJson(),
      };
}

class Values {
  Values({
    this.totalValues,
    this.data,
  });

  int? totalValues;
  List<Datum>? data;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        totalValues: json["total_values"] == null ? null : json["total_values"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_values": totalValues == null ? null : totalValues,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.membershipNo,
      this.gemsCustomerId,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobileNumber,
      this.points,
      this.transactionId,
      this.tyTransactionId,
      this.transactionDate,
      this.isTentative,
      this.tentativePeriod,
      this.processingDate,
      this.transactionType,
      this.amount,
      this.activityName,
      this.activityCode,
      this.transactionStatus});

  String? membershipNo;
  String? gemsCustomerId;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobileNumber;
  int? points;
  String? transactionId;
  dynamic tyTransactionId;
  DateTime? transactionDate;
  int? isTentative;
  dynamic tentativePeriod;
  DateTime? processingDate;
  String? transactionType;
  int? amount;
  String? activityName;
  String? activityCode;
  String? transactionStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      membershipNo:
          json["membership_no"] == null ? null : json["membership_no"],
      gemsCustomerId:
          json["gems_customer_id"] == null ? null : json["gems_customer_id"],
      firstName: json["first_name"] == null ? null : json["first_name"],
      lastName: json["last_name"] == null ? null : json["last_name"],
      email: json["email"] == null ? null : json["email"],
      countryCode: json["country_code"] == null ? null : json["country_code"],
      mobileNumber:
          json["mobile_number"] == null ? null : json["mobile_number"],
      points: json["points"] == null ? null : json["points"],
      transactionId:
          json["transaction_id"] == null ? null : json["transaction_id"],
      tyTransactionId: json["ty_transaction_id"],
      transactionDate: json["transaction_date"] == null
          ? null
          : DateTime.parse(json["transaction_date"]),
      isTentative: json["is_tentative"] == null ? null : json["is_tentative"],
      tentativePeriod: json["tentative_period"],
      processingDate: json["processing_date"] == null
          ? null
          : DateTime.parse(json["processing_date"]),
      transactionType:
          json["transaction_type"] == null ? null : json["transaction_type"],
      amount: json["amount"] == null ? null : json["amount"],
      activityName:
          json["activity_name"] == null ? null : json["activity_name"],
      activityCode:
          json["activity_code"] == null ? null : json["activity_code"],    
      transactionStatus: json["transaction_status"] == null
          ? null
          : json["transaction_status"]);

  Map<String, dynamic> toJson() => {
        "membership_no": membershipNo == null ? null : membershipNo,
        "gems_customer_id": gemsCustomerId == null ? null : gemsCustomerId,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "country_code": countryCode == null ? null : countryCode,
        "mobile_number": mobileNumber == null ? null : mobileNumber,
        "points": points == null ? null : points,
        "transaction_id": transactionId == null ? null : transactionId,
        "ty_transaction_id": tyTransactionId,
        "transaction_date":
            transactionDate == null ? null : transactionDate!.toIso8601String(),
        "is_tentative": isTentative == null ? null : isTentative,
        "tentative_period": tentativePeriod,
        "processing_date":
            processingDate == null ? null : processingDate!.toIso8601String(),
        "transaction_type": transactionType == null ? null : transactionType,
        "amount": amount == null ? null : amount,
        "activity_name": activityName == null ? null : activityName,
        "activity_code": activityCode == null ? null : activityCode,
        "transaction_status":
            transactionStatus == null ? null : transactionStatus,
      };
}
