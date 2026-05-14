class ApplyCouponModel {
  ApplyCouponModel({
     this.success,
     this.message,
  });

  final String? success;
  final String? message;

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) =>
      ApplyCouponModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
