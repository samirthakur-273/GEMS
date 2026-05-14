import 'dart:convert';

MyPointsModel myPointsModelFromJson(String str) => MyPointsModel.fromJson(json.decode(str));

String myPointsModelToJson(MyPointsModel data) => json.encode(data.toJson());

class MyPointsModel {
    MyPointsModel({
        this.status,
        this.message,
        this.values,
    });

    bool? status;
    String? message;
    Values? values;

    factory MyPointsModel.fromJson(Map<String, dynamic> json) => MyPointsModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "values": values == null ? null : values!.toJson(),
    };
}

class Values {
    Values({
        this.pointBalance,
        this.tentativePoints,
        this.firstName,
        this.lastName,
        this.pointRate,
        this.minPointsAllowed,
        this.maxPointsAllowed,
    });

    int? pointBalance;
    int? tentativePoints;
    String? firstName;
    String? lastName;
    double? pointRate;
    int? minPointsAllowed;
    int? maxPointsAllowed;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        pointBalance: json["point_balance"] == null ? null : json["point_balance"],
        tentativePoints: json["tentative_points"] == null ? null : json["tentative_points"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        pointRate: json["point_rate"] == null ? null : json["point_rate"].toDouble(),
        minPointsAllowed: json["min_points_allowed"] == null ? null : json["min_points_allowed"],
        maxPointsAllowed: json["max_points_allowed"] == null ? null : json["max_points_allowed"],
    );

    Map<String, dynamic> toJson() => {
        "point_balance": pointBalance == null ? null : pointBalance,
        "tentative_points": tentativePoints == null ? null : tentativePoints,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "point_rate": pointRate == null ? null : pointRate,
        "min_points_allowed": minPointsAllowed == null ? null : minPointsAllowed,
        "max_points_allowed": maxPointsAllowed == null ? null : maxPointsAllowed,
    };
}
