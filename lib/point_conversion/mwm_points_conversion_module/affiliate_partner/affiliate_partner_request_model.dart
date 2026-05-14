import '../../../utils/constants_files/text_constants.dart';

class AffiliatePartnerRequestModel {
  final String customerId;
  final String partnerId;

  AffiliatePartnerRequestModel({
    required this.customerId,
    required this.partnerId,
  });

  Map<String, dynamic> toJson() => {
        AppTexts.customerIdKey: customerId,
        AppTexts.partnerIdKey: partnerId,
      };
}
