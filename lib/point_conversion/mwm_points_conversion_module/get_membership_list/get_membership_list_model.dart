import 'dart:convert';

GetMembershipListModel getMembershipListModelFromJson(String str) =>
    GetMembershipListModel.fromJson(json.decode(str));

String getMembershipListModelToJson(GetMembershipListModel data) =>
    json.encode(data.toJson());

class GetMembershipListModel {
  String? message;
  String? code;
  bool? status;
  int? statusCode;
  String? statusMessage;
  List<MembershipListInfo>? values;
  DateTime? responseTime;
  String? apiExecutionTime;
  int? totalCount;

  GetMembershipListModel({
    this.message,
    this.code,
    this.status,
    this.statusCode,
    this.statusMessage,
    this.values,
    this.responseTime,
    this.apiExecutionTime,
    this.totalCount,
  });

  factory GetMembershipListModel.fromJson(Map<String, dynamic> json) =>
      GetMembershipListModel(
        message: json['message'],
        code: json['code'],
        status: json['status'],
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        values: json['values'] == null
            ? []
            : List<MembershipListInfo>.from(
                json['values']!.map((x) => MembershipListInfo.fromJson(x))),
        responseTime: json['responseTime'] == null
            ? null
            : DateTime.parse(json['responseTime']),
        apiExecutionTime: json['apiExecutionTime'],
        totalCount: json['totalCount'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'status': status,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'values': values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        'responseTime': responseTime?.toIso8601String(),
        'apiExecutionTime': apiExecutionTime,
        'totalCount': totalCount,
      };
}

class MembershipListInfo {
  String? linkBookingRefNo;
  String? tierCode;
  ClientDetails? clientDetails;
  PartnerDetails? partnerDetails;
  String? status;
  CustomerDetails? customerDetails;
  DateTime? creationTime;
  DateTime? modifiedTime;

  MembershipListInfo({
    this.linkBookingRefNo,
    this.tierCode,
    this.clientDetails,
    this.partnerDetails,
    this.status,
    this.customerDetails,
    this.creationTime,
    this.modifiedTime,
  });

  factory MembershipListInfo.fromJson(Map<String, dynamic> json) =>
      MembershipListInfo(
        linkBookingRefNo: json['linkBookingRefNo'],
        tierCode: json['tier_code'],
        clientDetails: json['clientDetails'] == null
            ? null
            : ClientDetails.fromJson(json['clientDetails']),
        partnerDetails: json['partnerDetails'] == null
            ? null
            : PartnerDetails.fromJson(json['partnerDetails']),
        status: json['status'],
        customerDetails: json['customerDetails'] == null
            ? null
            : CustomerDetails.fromJson(json['customerDetails']),
        creationTime: json['creationTime'] == null
            ? null
            : DateTime.parse(json['creationTime']),
        modifiedTime: json['modifiedTime'] == null
            ? null
            : DateTime.parse(json['modifiedTime']),
      );

  Map<String, dynamic> toJson() => {
        'linkBookingRefNo': linkBookingRefNo,
        'tier_code': tierCode,
        'clientDetails': clientDetails?.toJson(),
        'partnerDetails': partnerDetails?.toJson(),
        'status': status,
        'customerDetails': customerDetails?.toJson(),
        'creationTime': creationTime?.toIso8601String(),
        'modifiedTime': modifiedTime?.toIso8601String(),
      };
}

class ClientDetails {
  String? clientName;
  String? clientId;
  String? clientProgramId;
  String? customerMemberId;
  String? clientCurrencyId;

  ClientDetails({
    this.clientName,
    this.clientId,
    this.clientProgramId,
    this.customerMemberId,
    this.clientCurrencyId,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> json) => ClientDetails(
        clientName: json['clientName'],
        clientId: json['clientId'],
        clientProgramId: json['clientProgramId'],
        customerMemberId: json['customerMemberId'],
        clientCurrencyId: json['clientCurrencyId'],
      );

  Map<String, dynamic> toJson() => {
        'clientName': clientName,
        'clientId': clientId,
        'clientProgramId': clientProgramId,
        'customerMemberId': customerMemberId,
        'clientCurrencyId': clientCurrencyId,
      };
}

class CustomerDetails {
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNo;
  String? dateOfBirth;
  String? passportNo;
  String? address;
  String? pinCode;

  CustomerDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNo,
    this.dateOfBirth,
    this.passportNo,
    this.address,
    this.pinCode,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        firstName: json['firstname'],
        lastName: json['lastname'],
        email: json['email'],
        mobileNo: json['mobileNo'],
        dateOfBirth: json['dob'],
        passportNo: json['passportNo'],
        address: json['address'],
        pinCode: json['pinCode'],
      );

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'mobileNo': mobileNo,
        'dob': dateOfBirth,
        'passportNo': passportNo,
        'address': address,
        'pinCode': pinCode,
      };
}

class PartnerDetails {
  String? partnerId;
  String? partnerName;
  String? partnerProgramId;
  String? partnerProgramName;
  String? partnerMemberId;
  String? partnerLogo;

  PartnerDetails({
    this.partnerId,
    this.partnerName,
    this.partnerProgramId,
    this.partnerProgramName,
    this.partnerMemberId,
    this.partnerLogo,
  });

  factory PartnerDetails.fromJson(Map<String, dynamic> json) => PartnerDetails(
        partnerId: json['partnerId'],
        partnerName: json['partnerName'],
        partnerProgramId: json['partnerProgramId'],
        partnerProgramName: json['partnerProgramName'],
        partnerMemberId: json['partnerMemberId'],
        partnerLogo: json['partnerLogo'],
      );

  Map<String, dynamic> toJson() => {
        'partnerId': partnerId,
        'partnerName': partnerName,
        'partnerProgramId': partnerProgramId,
        'partnerProgramName': partnerProgramName,
        'partnerMemberId': partnerMemberId,
        'partnerLogo': partnerLogo,
      };
}

class MemberListRequestBody {
  final int limit;
  final int offset;
  final String clientMemberId;
  final String transactionFrom;
  final String transactionTo;

  MemberListRequestBody({
    required this.limit,
    required this.offset,
    required this.clientMemberId,
    required this.transactionFrom,
    required this.transactionTo,
    
    
  });

  Map<String, dynamic> toJson() => {
        'limit': limit,
        'offset': offset,
        'clientMemberId': clientMemberId,
        'transactionFrom':transactionFrom,
        'transactionTo':  transactionTo,
      };
}
