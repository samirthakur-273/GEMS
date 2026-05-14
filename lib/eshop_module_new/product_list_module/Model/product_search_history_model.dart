class ProductSearchHistory {
  int? id;
  String? productName;

  ProductSearchHistory(this.id, this.productName);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'productName': productName,
    };
    return map;
  }

  ProductSearchHistory.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    productName = map['productName'];
  }
}