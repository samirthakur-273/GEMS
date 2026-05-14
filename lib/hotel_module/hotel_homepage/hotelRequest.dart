// To parse this JSON data, do
//
//     final hotelRequestParameter = hotelRequestParameterFromJson(jsonString);

import 'dart:convert';

HotelRequestParameter hotelRequestParameterFromJson(String str) =>
    HotelRequestParameter.fromJson(json.decode(str));

String hotelRequestParameterToJson(HotelRequestParameter data) =>
    json.encode(data.toJson());

class HotelRequestParameter {
  HotelRequestParameter(
      {this.searchText,
      this.searchType,
      this.city,
      this.nationality,
      this.currency,
      this.checkInDate,
      this.checkOutDate,
      this.limit,
      this.offset,
      this.searchBy,
      this.language,
      this.rooms,
      this.travIds,
      this.vId,
      this.travelType});

  String? searchText;
  int? searchType;
  String? nationality;
  String? currency;
  String? checkInDate;
  String? checkOutDate;
  int? limit;
  int? offset;
  String? language;
  String? city;
  String? searchBy;
  List<Room>? rooms;
  List<GuestDetails>? guestDetails;
  List<int>? travIds;
  List<String>? vId;
  String? travelType;

  factory HotelRequestParameter.fromJson(Map<String, dynamic> json) =>
      HotelRequestParameter(
        searchText: json["search_text"],
        searchType: json["search_type"],
        nationality: json["nationality"],
        currency: json["currency"],
        searchBy: json["search_by"],
        checkInDate: json["check_in_date"],
        checkOutDate: json["check_out_date"],
        limit: json["limit"],
        offset: json["offset"],
        language: json["language"],
        travelType: json["traveltype"],
        rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
        travIds: json["trav_ids"] == null
            ? null
            : List<int>.from(json["trav_ids"].map((x) => x)),
        vId: json["v_id"] == null
            ? null
            : List<String>.from(json["v_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "search_text": searchText,
        "search_type": searchType,
        "nationality": nationality,
        "search_by": searchBy,
        "currency": currency,
        "traveltype": travelType,
        "check_in_date": checkInDate,
        "check_out_date": checkOutDate,
        "limit": limit,
        "offset": offset,
        "language": language,
        "rooms": List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "trav_ids":
            travIds == null ? null : List<dynamic>.from(travIds!.map((x) => x)),
        "v_id": vId == null ? null : List<dynamic>.from(vId!.map((x) => x)),
      };
}

class GuestDetails {
  String guestName;
  String guestId;

  GuestDetails(this.guestName, this.guestId);
}
// class Room {
//   Room({
//     this.adultCount,
//     this.childs,
//   });

//   int adultCount;
//   int childs;

//   factory Room.fromJson(Map<String, dynamic> json) => Room(
//     adultCount: json["adult_count"],
//     childs: json["childs"],
//   );

//   Map<String, dynamic> toJson() => {
//     "adult_count": adultCount,
//     "childs": childs,
//   };
// }
class Room {
  Room({
    this.adultCount,
    this.childs,
  });

  int? adultCount;
  List<Child>? childs;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        adultCount: json["adult_count"] == null ? null : json["adult_count"],
        childs: json["childs"] == null
            ? null
            : List<Child>.from(json["childs"].map((x) => Child.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "adult_count": adultCount == null ? null : adultCount,
        "childs": childs == null
            ? null
            : List<dynamic>.from(childs!.map((x) => x.toJson())),
      };
}

class Child {
  Child({
    this.age,
  });

  String? age;
  String? agevalue;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        age: json["age"] == null ? null : json["age"],
      );

  Map<String, dynamic> toJson() => {
        "age": age == null ? null : age,
      };
}
