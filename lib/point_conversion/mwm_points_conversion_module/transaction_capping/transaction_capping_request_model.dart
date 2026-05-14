class TransactionCappingRequestModel {
  final String clientMemberId;
  final String transactionFrom;
  final String transactionTo;
  final String clientTierCode;
  final String partnerTierCode;
  final String partnerMemberId;

  TransactionCappingRequestModel({
    required this.clientMemberId,
    required this.transactionFrom,
    required this.transactionTo,
    required this.clientTierCode,
    required this.partnerTierCode,
    required this.partnerMemberId,
  });

  factory TransactionCappingRequestModel.fromJson(Map<String, dynamic> json) =>
      TransactionCappingRequestModel(
        clientMemberId: json['clientMemberId'] ?? '',
        transactionFrom: json['transactionFrom'] ?? '',
        transactionTo: json['transactionTo'] ?? '',
        clientTierCode: json['clientTierCode'] ?? '',
        partnerTierCode: json['partnerTierCode'] ?? '',
        partnerMemberId: json['partnerMemberId'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'clientMemberId': clientMemberId,
        'transactionFrom': transactionFrom,
        'transactionTo': transactionTo,
        'clientTierCode': clientTierCode,
        'partnerTierCode': partnerTierCode,
        'partnerMemberId': partnerMemberId,
      };
}
