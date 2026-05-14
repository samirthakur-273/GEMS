import 'dart:convert';

PurchaseOrderModal purchaseOrderModalFromJson(String str) =>
    PurchaseOrderModal.fromJson(json.decode(str));

String purchaseOrderModalToJson(PurchaseOrderModal data) =>
    json.encode(data.toJson());

class PurchaseOrderModal {
  PurchaseOrderModal({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory PurchaseOrderModal.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
      };
}

class Values {
  Values({this.bookResult, this.bookStatus, this.saveAsPdf});

  BookResult? bookResult;
  BookStatus? bookStatus;
  String? saveAsPdf;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        bookResult: json["bookResult"] == null
            ? null
            : BookResult.fromJson(json["bookResult"]),
        bookStatus: json["bookStatus"] == null
            ? null
            : BookStatus.fromJson(json["bookStatus"]),
        saveAsPdf: json["save_as_pdf"] == null ? null : json["save_as_pdf"],
      );

  Map<String, dynamic> toJson() => {
        "bookResult": bookResult == null ? null : bookResult!.toJson(),
        "bookStatus": bookStatus == null ? null : bookStatus!.toJson(),
        "save_as_pdf": saveAsPdf == null ? null : saveAsPdf,
      };
}

class BookResult {
  BookResult({
    this.status,
    this.result,
  });

  String? status;
  BookResultResult? result;

  factory BookResult.fromJson(Map<String, dynamic> json) => BookResult(
        status: json["status"] == null ? null : json["status"],
        result: json["result"] == null
            ? null
            : BookResultResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "result": result == null ? null : result!.toJson(),
      };
}

class BookResultResult {
  BookResultResult({
    this.confirmationNumber,
    this.clientReferenceNumber,
    this.bookingStatus,
    this.bookingId,
    this.userRefNo,
    this.hotelInfo,
    this.paxData,
    this.saveAsPdf,
  });

  String? confirmationNumber;
  String? clientReferenceNumber;
  String? bookingStatus;
  String? bookingId;
  String? userRefNo;
  HotelInfo? hotelInfo;
  List<PaxDatum>? paxData;
  String? saveAsPdf;

  factory BookResultResult.fromJson(Map<String, dynamic> json) =>
      BookResultResult(
        confirmationNumber: json["confirmation_number"] == null
            ? null
            : json["confirmation_number"],
        clientReferenceNumber: json["client_reference_number"] == null
            ? null
            : json["client_reference_number"],
        bookingStatus:
            json["booking_status"] == null ? null : json["booking_status"],
        bookingId: json["booking_id"] == null ? null : json["booking_id"],
        userRefNo: json["user_ref_no"] == null ? null : json["user_ref_no"],
        hotelInfo: json["hotel_info"] == null
            ? null
            : HotelInfo.fromJson(json["hotel_info"]),
        paxData: json["pax_data"] == null
            ? null
            : List<PaxDatum>.from(
                json["pax_data"].map((x) => PaxDatum.fromJson(x))),
        saveAsPdf: json["save_as_pdf"] == null ? null : json["save_as_pdf"],
      );

  Map<String, dynamic> toJson() => {
        "confirmation_number":
            confirmationNumber == null ? null : confirmationNumber,
        "client_reference_number":
            clientReferenceNumber == null ? null : clientReferenceNumber,
        "booking_status": bookingStatus == null ? null : bookingStatus,
        "booking_id": bookingId == null ? null : bookingId,
        "user_ref_no": userRefNo == null ? null : userRefNo,
        "hotel_info": hotelInfo == null ? null : hotelInfo!.toJson(),
        "pax_data": paxData == null
            ? null
            : List<dynamic>.from(paxData!.map((x) => x.toJson())),
        "save_as_pdf": saveAsPdf == null ? null : saveAsPdf,
      };
}

class HotelInfo {
  HotelInfo({
    this.htlName,
    this.htlAddress,
    this.htlImage,
    this.checkInTime,
    this.checkOutTime,
    this.checkInDate,
    this.checkOutDate,
    this.earnBnzPnts,
    this.totalAmount,
    this.transactionType,
    this.redeemPnts,
    this.partialAmount,
  });

  String? htlName;
  String? htlAddress;
  String? htlImage;
  String? checkInTime;
  String? checkOutTime;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String? earnBnzPnts;
  String? totalAmount;
  String? transactionType;
  int? redeemPnts;
  int? partialAmount;

  factory HotelInfo.fromJson(Map<String, dynamic> json) => HotelInfo(
        htlName: json["htl_name"] == null ? null : json["htl_name"],
        htlAddress: json["htl_address"] == null ? null : json["htl_address"],
        htlImage: json["htl_image"] == null ? null : json["htl_image"],
        checkInTime:
            json["check_in_time"] == null ? null : json["check_in_time"],
        checkOutTime:
            json["check_out_time"] == null ? null : json["check_out_time"],
        checkInDate: json["check_in_date"] == null
            ? null
            : DateTime.parse(json["check_in_date"]),
        checkOutDate: json["check_out_date"] == null
            ? null
            : DateTime.parse(json["check_out_date"]),
        earnBnzPnts:
            json["earn_bnz_pnts"] == null ? null : json["earn_bnz_pnts"],
        totalAmount: json["total_amount"] == null
            ? null
            : json["total_amount"].toString(),
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
        redeemPnts: json["redeem_pnts"] == null ? null : json["redeem_pnts"],
        partialAmount:
            json["partial_amount"] == null ? null : json["partial_amount"],
      );

  Map<String, dynamic> toJson() => {
        "htl_name": htlName == null ? null : htlName,
        "htl_address": htlAddress == null ? null : htlAddress,
        "htl_image": htlImage == null ? null : htlImage,
        "check_in_time": checkInTime == null ? null : checkInTime,
        "check_out_time": checkOutTime == null ? null : checkOutTime,
        "check_in_date":
            checkInDate == null ? null : checkInDate!.toIso8601String(),
        "check_out_date":
            checkOutDate == null ? null : checkOutDate!.toIso8601String(),
        "earn_bnz_pnts": earnBnzPnts == null ? null : earnBnzPnts,
        "total_amount": totalAmount == null ? null : totalAmount,
        "transaction_type": transactionType == null ? null : transactionType,
        "redeem_pnts": redeemPnts == null ? null : redeemPnts,
        "partial_amount": partialAmount == null ? null : partialAmount,
      };
}

class PaxDatum {
  PaxDatum({
    this.title,
    this.firstName,
    this.lastName,
    this.age,
    this.isLeadGuest,
    this.email,
    this.phoneNo,
    this.passangerType,
  });

  String? title;
  String? firstName;
  String? lastName;
  int? age;
  String? isLeadGuest;
  String? email;
  String? phoneNo;
  String? passangerType;

  factory PaxDatum.fromJson(Map<String, dynamic> json) => PaxDatum(
        title: json["title"] == null ? null : json["title"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        age: json["age"] == null ? null : json["age"],
        isLeadGuest:
            json["is_lead_guest"] == null ? null : json["is_lead_guest"],
        email: json["email"] == null ? null : json["email"],
        phoneNo: json["phone_no"] == null ? null : json["phone_no"],
        passangerType:
            json["passanger_type"] == null ? null : json["passanger_type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "age": age == null ? null : age,
        "is_lead_guest": isLeadGuest == null ? null : isLeadGuest,
        "email": email == null ? null : email,
        "phone_no": phoneNo == null ? null : phoneNo,
        "passanger_type": passangerType == null ? null : passangerType,
      };
}

class BookStatus {
  BookStatus({
    this.status,
    this.result,
  });

  String? status;
  BookStatusResult? result;

  factory BookStatus.fromJson(Map<String, dynamic> json) => BookStatus(
        status: json["status"] == null ? null : json["status"],
        result: json["result"] == null
            ? null
            : BookStatusResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "result": result == null ? null : result!.toJson(),
      };
}

class BookStatusResult {
  BookStatusResult({
    this.confirmationNumber,
    this.clientReferenceNumber,
    this.bookingId,
    this.bookingStatus,
    this.noOfRooms,
    this.noOfNights,
    this.noOfGuest,
    this.rooms,
  });

  String? confirmationNumber;
  String? clientReferenceNumber;
  String? bookingId;
  String? bookingStatus;
  int? noOfRooms;
  String? noOfNights;
  int? noOfGuest;
  List<Room>? rooms;

  factory BookStatusResult.fromJson(Map<String, dynamic> json) =>
      BookStatusResult(
        confirmationNumber: json["confirmation_number"] == null
            ? null
            : json["confirmation_number"],
        clientReferenceNumber: json["client_reference_number"] == null
            ? null
            : json["client_reference_number"],
        bookingId: json["booking_id"] == null ? null : json["booking_id"],
        bookingStatus:
            json["booking_status"] == null ? null : json["booking_status"],
        noOfRooms: json["no_of_rooms"] == null ? null : json["no_of_rooms"],
        noOfNights: json["no_of_nights"] == null ? null : json["no_of_nights"],
        noOfGuest: json["no_of_guest"] == null ? null : json["no_of_guest"],
        rooms: json["rooms"] == null
            ? null
            : List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "confirmation_number":
            confirmationNumber == null ? null : confirmationNumber,
        "client_reference_number":
            clientReferenceNumber == null ? null : clientReferenceNumber,
        "booking_id": bookingId == null ? null : bookingId,
        "booking_status": bookingStatus == null ? null : bookingStatus,
        "no_of_rooms": noOfRooms == null ? null : noOfRooms,
        "no_of_nights": noOfNights == null ? null : noOfNights,
        "no_of_guest": noOfGuest == null ? null : noOfGuest,
        "rooms": rooms == null
            ? null
            : List<dynamic>.from(rooms!.map((x) => x.toJson())),
      };
}

class Room {
  Room({
    this.roomType,
    this.leadPax,
    this.confirmationNumber,
    this.checkin,
    this.checkout,
    this.adults,
    this.childrenAge,
    this.cancellationPolicy,
    this.price,
  });

  String? roomType;
  String? leadPax;
  String? confirmationNumber;
  String? checkin;
  String? checkout;
  int? adults;
  List<dynamic>? childrenAge;
  CancellationPolicy? cancellationPolicy;
  RoomPrice? price;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomType: json["room_type"] == null ? null : json["room_type"],
        leadPax: json["lead_pax"] == null ? null : json["lead_pax"],
        confirmationNumber: json["confirmation_number"] == null
            ? null
            : json["confirmation_number"],
        checkin: json["checkin"] == null ? null : json["checkin"],
        checkout: json["checkout"] == null ? null : json["checkout"],
        adults: json["adults"] == null ? null : json["adults"],
        childrenAge: json["children_age"] == null
            ? null
            : List<dynamic>.from(json["children_age"].map((x) => x)),
        cancellationPolicy: json["cancellation_policy"] == null
            ? null
            : CancellationPolicy.fromJson(json["cancellation_policy"]),
        price: json["price"] == null ? null : RoomPrice.fromJson(json["price"]),
      );

  Map<String, dynamic> toJson() => {
        "room_type": roomType == null ? null : roomType,
        "lead_pax": leadPax == null ? null : leadPax,
        "confirmation_number":
            confirmationNumber == null ? null : confirmationNumber,
        "checkin": checkin == null ? null : checkin,
        "checkout": checkout == null ? null : checkout,
        "adults": adults == null ? null : adults,
        "children_age": childrenAge == null
            ? null
            : List<dynamic>.from(childrenAge!.map((x) => x)),
        "cancellation_policy":
            cancellationPolicy == null ? null : cancellationPolicy!.toJson(),
        "price": price == null ? null : price!.toJson(),
      };
}

class CancellationPolicy {
  CancellationPolicy({
    this.cancellationPolicyDefault,
    this.cancellation,
  });

  String? cancellationPolicyDefault;
  List<Cancellation>? cancellation;

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      CancellationPolicy(
        cancellationPolicyDefault:
            json["default"] == null ? null : json["default"],
        cancellation: json["cancellation"] == null
            ? null
            : List<Cancellation>.from(
                json["cancellation"].map((x) => Cancellation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "default": cancellationPolicyDefault == null
            ? null
            : cancellationPolicyDefault,
        "cancellation": cancellation == null
            ? null
            : List<dynamic>.from(cancellation!.map((x) => x.toJson())),
      };
}

class Cancellation {
  Cancellation({
    this.customerPrice,
    this.fromDate,
    this.toDate,
    this.currency,
    this.charges,
  });

  CustomerPrice? customerPrice;
  String? fromDate;
  String? toDate;
  String? currency;
  double? charges;

  factory Cancellation.fromJson(Map<String, dynamic> json) => Cancellation(
        customerPrice: json["customer_price"] == null
            ? null
            : CustomerPrice.fromJson(json["customer_price"]),
        fromDate: json["from_date"] == null ? null : json["from_date"],
        toDate: json["to_date"] == null ? null : json["to_date"],
        currency: json["currency"] == null ? null : json["currency"],
        charges: json["charges"] == null ? null : json["charges"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "customer_price":
            customerPrice == null ? null : customerPrice!.toJson(),
        "from_date": fromDate == null ? null : fromDate,
        "to_date": toDate == null ? null : toDate,
        "currency": currency == null ? null : currency,
        "charges": charges == null ? null : charges,
      };
}

class CustomerPrice {
  CustomerPrice({
    this.charges,
    this.currency,
  });

  double? charges;
  String? currency;

  factory CustomerPrice.fromJson(Map<String, dynamic> json) => CustomerPrice(
        charges: json["charges"] == null ? null : json["charges"].toDouble(),
        currency: json["currency"] == null ? null : json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "charges": charges == null ? null : charges,
        "currency": currency == null ? null : currency,
      };
}

class RoomPrice {
  RoomPrice({
    this.preNetRate,
    this.preInclusive,
    this.perNight,
    this.netRate,
    this.roomTax,
    this.discount,
    this.total,
    this.currency,
  });

  int? preNetRate;
  int? preInclusive;
  dynamic perNight;
  double? netRate;
  double? roomTax;
  int? discount;
  String? total;
  String? currency;

  factory RoomPrice.fromJson(Map<String, dynamic> json) => RoomPrice(
        preNetRate: json["pre_netRate"] == null ? null : json["pre_netRate"],
        preInclusive:
            json["pre_inclusive"] == null ? null : json["pre_inclusive"],
        perNight: json["per_night"],
        netRate: json["net_rate"] == null ? null : json["net_rate"].toDouble(),
        roomTax: json["room_tax"] == null ? null : json["room_tax"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"],
        total: json["total"] == null ? null : json["total"].toString(),
        currency: json["currency"] == null ? null : json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "pre_netRate": preNetRate == null ? null : preNetRate,
        "pre_inclusive": preInclusive == null ? null : preInclusive,
        "per_night": perNight,
        "net_rate": netRate == null ? null : netRate,
        "room_tax": roomTax == null ? null : roomTax,
        "discount": discount == null ? null : discount,
        "total": total == null ? null : total.toString(),
        "currency": currency == null ? null : currency,
      };
}
