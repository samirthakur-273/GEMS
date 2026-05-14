class DelinkRequestModel {
  final String mode;
  final String clientMemberId;
  final String linkBookingRefNo;

  DelinkRequestModel({
    required this.mode,
    required this.clientMemberId,
    required this.linkBookingRefNo,
  });

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'clientMemberId': clientMemberId,
        'linkBookingRefNo': linkBookingRefNo,
      };
}
