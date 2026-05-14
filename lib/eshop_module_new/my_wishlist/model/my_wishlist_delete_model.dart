import 'dart:convert';

List<MyWishlistDeleteModel> wishlistDeleteFromJson(String str) => List<MyWishlistDeleteModel>.from(json.decode(str).map((x) => MyWishlistDeleteModel.fromJson(x)));

String wishlistDeleteToJson(List<MyWishlistDeleteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyWishlistDeleteModel {
  MyWishlistDeleteModel({
     this.success,
     this.message,
  });

   String? success;
   String? message;

  factory MyWishlistDeleteModel.fromJson(Map<String, dynamic> json) => MyWishlistDeleteModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
