class SubmitTransactionRequestModel {
  final String transactionTo;
  final String transactionFrom;
  final String clientMemberId;
  final ClientDetails clientDetails;
  final PartnerDetails partnerDetails;
  final String clientTierCode;
  final String partnerTierCode;

  SubmitTransactionRequestModel({
    required this.transactionTo,
    required this.transactionFrom,
    required this.clientMemberId,
    required this.clientDetails,
    required this.partnerDetails,
    required this.clientTierCode,
    required this.partnerTierCode,
  });

  Map<String, dynamic> toJson() => {
        'transactionTo': transactionTo,
        'transactionFrom': transactionFrom,
        'clientMemberId': clientMemberId,
        'clientDetails': clientDetails.toJson(),
        'partnerDetails': partnerDetails.toJson(),
        'clientTierCode': clientTierCode,
        'partnerTierCode': partnerTierCode, 
      };
}

class ClientDetails {
  final String linkMemberId;
  final int pointsTransferred;

  ClientDetails({
    required this.linkMemberId,
    required this.pointsTransferred,
  });

  Map<String, dynamic> toJson() => {
        'linkMemberId': linkMemberId,
        'pointsTransfered': pointsTransferred,
      };
}

class PartnerDetails {
  final String partnerMemberId;
  final int pointsToBeTransferred;

  PartnerDetails({
    required this.partnerMemberId,
    required this.pointsToBeTransferred,
  });

  Map<String, dynamic> toJson() => {
        'partnerMemberId': partnerMemberId,
        'pointsToBeTransferred': pointsToBeTransferred,
      };
}
