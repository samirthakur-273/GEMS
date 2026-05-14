// To parse this JSON data, do
//
//     final hoteldetailModel = hoteldetailModelFromJson(jsonString);

import 'dart:convert';

HoteldetailModel hoteldetailModelFromJson(String str) => HoteldetailModel.fromJson(json.decode(str));

String hoteldetailModelToJson(HoteldetailModel data) => json.encode(data.toJson());

class HoteldetailModel {
    HoteldetailModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory HoteldetailModel.fromJson(Map<String, dynamic> json) => HoteldetailModel(
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
    Values({
        this.isEurope,
        this.checkInDate,
        this.checkOutDate,
        this.rooms,
        this.uniqueId,
        this.hoteldetails,
        this.earnRate,
        this.redeemRate,
    });

    String? isEurope;
    String? checkInDate;
    String? checkOutDate;
    List<Room>? rooms;
    String? uniqueId;
    Hoteldetails? hoteldetails;
    var earnRate;
    var redeemRate;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        isEurope: json["is_europe"] == null ? null : json["is_europe"],
        checkInDate: json["check_in_date"] == null ? null : json["check_in_date"],
        checkOutDate: json["check_out_date"] == null ? null : json["check_out_date"],
        rooms: json["rooms"] == null ? null : List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
        uniqueId: json["unique_id"] == null ? null : json["unique_id"],
        hoteldetails: json["hoteldetails"] == null ? null : Hoteldetails.fromJson(json["hoteldetails"]),
        earnRate: json["earn_rate"] == null ? null : json["earn_rate"].toDouble(),
        redeemRate: json["redeem_rate"] == null ? null : json["redeem_rate"],
    );

    Map<String, dynamic> toJson() => {
        "is_europe": isEurope == null ? null : isEurope,
        "check_in_date": checkInDate == null ? null : checkInDate,
        "check_out_date": checkOutDate == null ? null : checkOutDate,
        "rooms": rooms == null ? null : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "unique_id": uniqueId == null ? null : uniqueId,
        "hoteldetails": hoteldetails == null ? null : hoteldetails!.toJson(),
        "earn_rate": earnRate == null ? null : earnRate,
        "redeem_rate": redeemRate == null ? null : redeemRate,
    };
}

class Hoteldetails {
    Hoteldetails({
        this.images,
        this.facilities,
        this.attractions,
        this.descriptions,
        this.info,
        this.review,
        this.hotelId,
        this.bnzAccrPnts,
        this.bnzReddemPnts,
        this.convRate,
    });

    List<HoteldetailsImage>? images;
    List<Facility>? facilities;
    List<Attraction>? attractions;
    String? descriptions;
    Info? info;
    Review? review;
    int? hotelId;
    int? bnzAccrPnts;
    int? bnzReddemPnts;
    int? convRate;

    factory Hoteldetails.fromJson(Map<String, dynamic> json) => Hoteldetails(
        images: json["images"] == null ? null : List<HoteldetailsImage>.from(json["images"].map((x) => HoteldetailsImage.fromJson(x))),
        facilities: json["facilities"] == null ? null : List<Facility>.from(json["facilities"].map((x) => Facility.fromJson(x))),
        attractions: json["attractions"] == null ? null : List<Attraction>.from(json["attractions"].map((x) => Attraction.fromJson(x))),
        descriptions: json["descriptions"] == null ? null : json["descriptions"],
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
        hotelId: json["hotel_id"] == null ? null : json["hotel_id"],
        bnzAccrPnts: json["bnz_accr_pnts"] == null ? null : json["bnz_accr_pnts"],
        bnzReddemPnts: json["bnz_reddem_pnts"] == null ? null : json["bnz_reddem_pnts"],
        convRate: json["convRate"] == null ? null : json["convRate"],
    );

    Map<String, dynamic> toJson() => {
        "images": images == null ? null : List<dynamic>.from(images!.map((x) => x.toJson())),
        "facilities": facilities == null ? null : List<dynamic>.from(facilities!.map((x) => x.toJson())),
        "attractions": attractions == null ? null : List<dynamic>.from(attractions!.map((x) => x.toJson())),
        "descriptions": descriptions == null ? null : descriptions,
        "info": info == null ? null : info!.toJson(),
        "review": review == null ? null : review!.toJson(),
        "hotel_id": hotelId == null ? null : hotelId,
        "bnz_accr_pnts": bnzAccrPnts == null ? null : bnzAccrPnts,
        "bnz_reddem_pnts": bnzReddemPnts == null ? null : bnzReddemPnts,
        "convRate": convRate == null ? null : convRate,
    };
}

class Attraction {
    Attraction({
        this.type,
        this.values,
    });

    String? type;
    List<Value>? values;

    factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
        type: json["type"] == null ? null : json["type"],
        values: json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "values": values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
    };
}

class Value {
    Value({
        this.dist,
        this.name,
    });

    double? dist;
    String? name;

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        dist: json["dist"] == null ? null : json["dist"].toDouble(),
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "dist": dist == null ? null : dist,
        "name": name == null ? null : name,
    };
}

class Facility {
    Facility({
        this.category,
        this.categoryId,
        this.amenities,
    });

    String? category;
    int? categoryId;
    List<Amenity>? amenities;

    factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        category: json["category"] == null ? null : json["category"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        amenities: json["amenities"] == null ? null : List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "category": category == null ? null : category,
        "category_id": categoryId == null ? null : categoryId,
        "amenities": amenities == null ? null : List<dynamic>.from(amenities!.map((x) => x.toJson())),
    };
}

class Amenity {
    Amenity({
        this.id,
        this.name,
        this.typeId,
    });

    dynamic? id;
    String? name;
    int? typeId;

    factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        name: json["name"] == null ? null : json["name"],
        typeId: json["type_id"] == null ? null : json["type_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name == null ? null : name,
        "type_id": typeId == null ? null : typeId,
    };
}

class HoteldetailsImage {
    HoteldetailsImage({
        this.category,
        this.image,
        this.orgName,
    });

    String? category;
    List<ImageImage>? image;
    String? orgName;

    factory HoteldetailsImage.fromJson(Map<String, dynamic> json) => HoteldetailsImage(
        category: json["category"] == null ? null : json["category"],
        image: json["image"] == null ? null : List<ImageImage>.from(json["image"].map((x) => ImageImage.fromJson(x))),
        orgName: json["org_name"] == null ? null : json["org_name"],
    );

    Map<String, dynamic> toJson() => {
        "category": category == null ? null : category,
        "image": image == null ? null : List<dynamic>.from(image!.map((x) => x.toJson())),
        "org_name": orgName == null ? null : orgName,
    };
}

class ImageImage {
    ImageImage({
        this.caption,
        this.imageUrl,
        this.height,
        this.width,
    });

    String? caption;
    String? imageUrl;
    String? height;
    String? width;

    factory ImageImage.fromJson(Map<String, dynamic> json) => ImageImage(
        caption: json["caption"] == null ? null : json["caption"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        height: json["height"] == null ? null : json["height"],
        width: json["width"] == null ? null : json["width"],
    );

    Map<String, dynamic> toJson() => {
        "caption": caption == null ? null : caption,
        "image_url": imageUrl == null ? null : imageUrl,
        "height": height == null ? null : height,
        "width": width == null ? null : width,
    };
}

class Info {
    Info({
        this.hotelName,
        this.cityName,
        this.starRating,
        this.countryCode,
        this.latitude,
        this.longitude,
        this.address,
        this.checkout,
        this.checkin,
        this.zipCode,
        this.phoneNo,
        this.faxNo,
        this.themes,
        this.thumbnails,
    });

    String? hotelName;
    String? cityName;
    int? starRating;
    String? countryCode;
    double? latitude;
    double? longitude;
    String? address;
    String? checkout;
    String? checkin;
    String? zipCode;
    String? phoneNo;
    String? faxNo;
    List<Theme>? themes;
    List<dynamic>? thumbnails;

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        hotelName: json["hotel_name"] == null ? null : json["hotel_name"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        starRating: json["star_rating"] == null ? null : json["star_rating"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        address: json["address"] == null ? null : json["address"],
        checkout: json["checkout"] == null ? null : json["checkout"],
        checkin: json["checkin"] == null ? null : json["checkin"],
        zipCode: json["zip_code"] == null ? null : json["zip_code"],
        phoneNo: json["phone_no"] == null ? null : json["phone_no"],
        faxNo: json["fax_no"] == null ? null : json["fax_no"],
        themes: json["themes"] == null ? null : List<Theme>.from(json["themes"].map((x) => Theme.fromJson(x))),
        thumbnails: json["thumbnails"] == null ? null : List<dynamic>.from(json["thumbnails"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "hotel_name": hotelName == null ? null : hotelName,
        "city_name": cityName == null ? null : cityName,
        "star_rating": starRating == null ? null : starRating,
        "country_code": countryCode == null ? null : countryCode,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "address": address == null ? null : address,
        "checkout": checkout == null ? null : checkout,
        "checkin": checkin == null ? null : checkin,
        "zip_code": zipCode == null ? null : zipCode,
        "phone_no": phoneNo == null ? null : phoneNo,
        "fax_no": faxNo == null ? null : faxNo,
        "themes": themes == null ? null : List<dynamic>.from(themes!.map((x) => x.toJson())),
        "thumbnails": thumbnails == null ? null : List<dynamic>.from(thumbnails!.map((x) => x)),
    };
}

class Theme {
    Theme({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Theme.fromJson(Map<String, dynamic> json) => Theme(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}

class Review {
    Review({
        this.count,
        this.excellent,
        this.vGood,
        this.good,
        this.okay,
        this.poor,
    });

    int? count;
    int? excellent;
    int? vGood;
    int? good;
    int? okay;
    int? poor;

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        count: json["count"] == null ? null : json["count"],
        excellent: json["excellent"] == null ? null : json["excellent"],
        vGood: json["v_good"] == null ? null : json["v_good"],
        good: json["good"] == null ? null : json["good"],
        okay: json["okay"] == null ? null : json["okay"],
        poor: json["poor"] == null ? null : json["poor"],
    );

    Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "excellent": excellent == null ? null : excellent,
        "v_good": vGood == null ? null : vGood,
        "good": good == null ? null : good,
        "okay": okay == null ? null : okay,
        "poor": poor == null ? null : poor,
    };
}

class Room {
    Room({
        this.groupName,
        this.thumbnails,
        this.roomTypes,
    });

    String? groupName;
    List<String>? thumbnails;
    List<RoomType>? roomTypes;

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        groupName: json["group_name"] == null ? null : json["group_name"],
        thumbnails: json["thumbnails"] == null ? null : List<String>.from(json["thumbnails"].map((x) => x)),
        roomTypes: json["room_types"] == null ? [] : List<RoomType>.from(json["room_types"]!.map((x) => RoomType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "group_name": groupName == null ? null : groupName,
        "thumbnails": thumbnails == null ? null : List<dynamic>.from(thumbnails!.map((x) => x)),
        "room_types": roomTypes == null ? null : List<dynamic>.from(roomTypes!.map((x) => x.toJson())),
    };
}

class RoomType {
    RoomType({
        this.id,
        this.roomNo,
        this.name,
        this.availableRooms,
        this.bedType,
        this.isBreakfast,
        this.isRefundable,
        this.occupancy,
        this.additionalInfo,
        this.amenities,
        this.noOfNights,
        this.price,
        this.cancellationPolicy,
    });

    String? id;
    String? roomNo;
    String? name;
    int? availableRooms;
    String? bedType;
    bool? isBreakfast;
    bool? isRefundable;
    Occupancy? occupancy;
    String? additionalInfo;
    List<String>? amenities;
    int? noOfNights;
    Price? price;
    CancellationPolicy? cancellationPolicy;

    factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        id: json["id"] == null ? null : json["id"],
        roomNo: json["room_no"] == null ? null : json["room_no"],
        name: json["name"] == null ? null : json["name"],
        availableRooms: json["available_rooms"] == null ? null : json["available_rooms"],
        bedType: json["bed_type"] == null ? null : json["bed_type"],
        isBreakfast: json["is_breakfast"] == null ? null : json["is_breakfast"],
        isRefundable: json["is_refundable"] == null ? null : json["is_refundable"],
        occupancy: json["occupancy"] == null ? null : Occupancy.fromJson(json["occupancy"]),
        additionalInfo: json["additional_info"] == null ? null : json["additional_info"],
        amenities: json["amenities"] == null ? null : List<String>.from(json["amenities"].map((x) => x)),
        noOfNights: json["no_of_nights"] == null ? null : json["no_of_nights"],
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        cancellationPolicy: json["cancellation_policy"] == null ? null : CancellationPolicy.fromJson(json["cancellation_policy"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "room_no": roomNo == null ? null : roomNo,
        "name": name == null ? null : name,
        "available_rooms": availableRooms == null ? null : availableRooms,
        "bed_type": bedType == null ? null : bedType,
        "is_breakfast": isBreakfast == null ? null : isBreakfast,
        "is_refundable": isRefundable == null ? null : isRefundable,
        "occupancy": occupancy == null ? null : occupancy!.toJson(),
        "additional_info": additionalInfo == null ? null : additionalInfo,
        "amenities": amenities == null ? null : List<dynamic>.from(amenities!.map((x) => x)),
        "no_of_nights": noOfNights == null ? null : noOfNights,
        "price": price == null ? null : price!.toJson(),
        "cancellation_policy": cancellationPolicy == null ? null : cancellationPolicy!.toJson(),
    };
}

class CancellationPolicy {
    String? cancellationPolicyDefault;
    bool? isStatic;
    List<dynamic>? cancellation;
    String? cancelHtml;

    CancellationPolicy({
        this.cancellationPolicyDefault,
        this.isStatic,
        this.cancellation,
        this.cancelHtml,
    });

    factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
        cancellationPolicyDefault: json["default"] == null ? null : json["default"],
        isStatic: json["is_static"] == null ? null : json["is_static"],
        cancellation: json["cancellation"] == null ? [] : List<dynamic>.from(json["cancellation"]!.map((x) => x)),
        cancelHtml: json["cancel_html"] == null ? null : json["cancel_html"],
    );

    Map<String, dynamic> toJson() => {
        "default": cancellationPolicyDefault == null ? null : cancellationPolicyDefault,
        "is_static": isStatic  == null ? null : isStatic,
        "cancellation": cancellation == null ? [] : List<dynamic>.from(cancellation!.map((x) => x)),
        "cancel_html": cancelHtml == null ? null : cancelHtml,
    };
}

class Occupancy {
    Occupancy({
        this.adult,
        this.child,
    });

    int? adult;
    int? child;

    factory Occupancy.fromJson(Map<String, dynamic> json) => Occupancy(
        adult: json["adult"] == null ? null : json["adult"],
        child: json["child"] == null ? null : json["child"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult == null ? null : adult,
        "child": child == null ? null : child,
    };
}

class Price {
    Price({
        this.priceType,
        this.currency,
        this.perNight,
        this.netRate,
        this.roomTax,
        this.salesTax,
        this.mandatoryFee,
        this.supplierPerNight,
        this.supplierRoomTax,
        this.supplierNetRate,
        this.supplierSalesTax,
        this.supplierMinDiscount,
        this.bnzAccrPnts,
        this.bnzReddemPnts,
        this.bnzPrNigtAccrPnts,
        this.bnzPrNigtReddemPnts,
    });

    String? priceType;
    String? currency;
    String? perNight;
    int? netRate;
    String? roomTax;
    int? salesTax;
    List<dynamic>? mandatoryFee;
    String? supplierPerNight;
    String? supplierRoomTax;
    String? supplierNetRate;
    int? supplierSalesTax;
    dynamic supplierMinDiscount;
    int? bnzAccrPnts;
    int? bnzReddemPnts;
    int? bnzPrNigtAccrPnts;
    int? bnzPrNigtReddemPnts;

    factory Price.fromJson(Map<String, dynamic> json) => Price(
        priceType: json["price_type"] == null ? null : json["price_type"],
        currency: json["currency"] == null ? null : json["currency"],
        perNight: json["per_night"] == null ? null : json["per_night"],
        netRate: json["net_rate"] == null ? null : json["net_rate"],
        roomTax: json["room_tax"] == null ? null : json["room_tax"],
        salesTax: json["sales_tax"] == null ? null : json["sales_tax"],
        mandatoryFee: json["mandatory_fee"] == null ? null : List<dynamic>.from(json["mandatory_fee"].map((x) => x)),
        supplierPerNight: json["supplier_per_night"] == null ? null : json["supplier_per_night"],
        supplierRoomTax: json["supplier_room_tax"] == null ? null : json["supplier_room_tax"],
        supplierNetRate: json["supplier_net_rate"] == null ? null : json["supplier_net_rate"],
        supplierSalesTax: json["supplier_sales_tax"] == null ? null : json["supplier_sales_tax"],
        supplierMinDiscount: json["supplier_min_discount"],
        bnzAccrPnts: json["bnz_accr_pnts"] == null ? null : json["bnz_accr_pnts"],
        bnzReddemPnts: json["bnz_reddem_pnts"] == null ? null : json["bnz_reddem_pnts"],
        bnzPrNigtAccrPnts: json["bnz_pr_nigt_accr_pnts"] == null ? null : json["bnz_pr_nigt_accr_pnts"],
        bnzPrNigtReddemPnts: json["bnz_pr_nigt_reddem_pnts"] == null ? null : json["bnz_pr_nigt_reddem_pnts"],
    );

    Map<String, dynamic> toJson() => {
        "price_type": priceType == null ? null : priceType,
        "currency": currency == null ? null : currency,
        "per_night": perNight == null ? null : perNight,
        "net_rate": netRate == null ? null : netRate,
        "room_tax": roomTax == null ? null : roomTax,
        "sales_tax": salesTax == null ? null : salesTax,
        "mandatory_fee": mandatoryFee == null ? null : List<dynamic>.from(mandatoryFee!.map((x) => x)),
        "supplier_per_night": supplierPerNight == null ? null : supplierPerNight,
        "supplier_room_tax": supplierRoomTax == null ? null : supplierRoomTax,
        "supplier_net_rate": supplierNetRate == null ? null : supplierNetRate,
        "supplier_sales_tax": supplierSalesTax == null ? null : supplierSalesTax,
        "supplier_min_discount": supplierMinDiscount,
        "bnz_accr_pnts": bnzAccrPnts == null ? null : bnzAccrPnts,
        "bnz_reddem_pnts": bnzReddemPnts == null ? null : bnzReddemPnts,
        "bnz_pr_nigt_accr_pnts": bnzPrNigtAccrPnts == null ? null : bnzPrNigtAccrPnts,
        "bnz_pr_nigt_reddem_pnts": bnzPrNigtReddemPnts == null ? null : bnzPrNigtReddemPnts,
    };
}
