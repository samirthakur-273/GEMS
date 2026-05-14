class ProductFilterModel {
  var catId;
  String? success;
  String? message;
  List<String>? filteroptions;
  List<Filtercollection>? filtercollection;
  var listType;
  ProductFilterModel(
      {this.catId,
      this.success,
      this.message,
      this.filteroptions,
      this.filtercollection,
      this.listType});

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) {
    return ProductFilterModel(
      catId: json['catId'] != null ? json['catId'] : null,
      success: json['success'] != null ? json['success'] : null,
      message: json['message'] != null ? json['message'] : null,
      filteroptions: json['filteroptions'] != null
          ? List<String>.from(json["filteroptions"].map((x) => x))
          : null,
      filtercollection: json['Filtercollection'] != null
          ? List<Filtercollection>.from(
              json["Filtercollection"].map((x) => Filtercollection.fromJson(x)))
          : null,
      listType: json['listType'] != null ? json['listType'] : 2,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catId'] = this.catId;
    data['success'] = this.success;
    data['message'] = this.message;
    data['filteroptions'] = this.filteroptions;
    if (this.filtercollection != null) {
      data['Filtercollection'] =
          this.filtercollection!.map((v) => v.toJson()).toList();
    }
    data['listType'] = this.listType;
    return data;
  }
}

class Filtercollection {
  String? title;
  String? frontendLabel;
  List<Datum>? data;
  String? selectedData;
  Map? filterJson;
  Map? filterDisplayJson;
  Map? filterDisplayDataID;
  Filtercollection(
      {this.selectedData,
      this.title,
      this.data,
      this.filterJson,
      this.filterDisplayJson,
      this.filterDisplayDataID,
      this.frontendLabel});
  factory Filtercollection.fromJson(Map<String, dynamic> json) {
    return Filtercollection(
      filterJson: json['filterJson'] != null ? json['filterJson'] : {},
      filterDisplayJson:
          json['filterDisplayJson'] != null ? json['filterDisplayJson'] : {},
      filterDisplayDataID:
          json['filterDisplayDataID'] != null ? json['filterDisplayDataID'] : {},    
      selectedData: json['selectedData'] != '' ? json['selectedData'] : '',
      title: json['title'] != null ? json['title'] : null,
      frontendLabel:
          json['title'] != null ? json['title'] : null,
      data: json["data"] != null
          ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filterJson'] = this.filterJson;
    data['filterDisplayJson'] = this.filterDisplayJson;
    data['filterDisplayDataID'] = this.filterDisplayDataID;
    data['selectedData'] = this.selectedData;
    data['title'] = this.title;
    data['frontend_label'] = this.title;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datum {
  String? label;
  String? swatchcode;
  String? optioncode;
  bool? isSelected;

  Datum({this.isSelected, this.label, this.optioncode, this.swatchcode});
  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      isSelected: json['isSelected'] != null ? json['isSelected'] : false,
      label: json['label'] != null ? json['label'] : null,
      swatchcode: json['swatchcode'] != null ? json['swatchcode'] : null,
      optioncode: json['optioncode'] != null ? json['optioncode'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSelected'] = this.isSelected;
    data['label'] = this.label;
    data['optioncode'] = this.optioncode;
    data['swatchcode'] = this.swatchcode;
    return data;
  }
}
