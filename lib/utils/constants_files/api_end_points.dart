class ApiEndPoints {
  static const String submitTransaction = 'transaction/v1/verifytransaction';
  static const String delink = 'linkMember/v1/delink';
  static const String getMembershipList = 'linkMember/v1/list';
  static const String verifyMember = 'linkMember/v1/verify';
  static const String partnerDetails =
      'detail/v1/partner_detail?partnerCurrencyCode=';
  static const String partnerList = 'detail/v1/partner';
  static const String validateOtp = 'linkMember/v1/validate_otp';
  static const String transactionCapping = 'transaction/v1/cappingLimit';
  static const String resendOtp = 'linkMember/v1/resend_otp';
}
