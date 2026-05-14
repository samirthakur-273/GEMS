class ProductFilterDataModel {
  int? id;
  dynamic filterdata;

  ProductFilterDataModel(this.id, this.filterdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'filterdata': filterdata,
    };
    return map;
  }

  ProductFilterDataModel.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    filterdata = map['filterdata'];
  }
}