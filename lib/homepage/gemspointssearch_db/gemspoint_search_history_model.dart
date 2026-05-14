class GemsPointSearchHistory {
  int? id;
  String? productNames;
  String? affiliateId;

  GemsPointSearchHistory(this.id, this.productNames,this.affiliateId);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'productNames': productNames,
      'affiliateId': affiliateId,
    };
    return map;
  }

  GemsPointSearchHistory.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    productNames = map['productNames'];
    affiliateId=map['affiliateId'];
  }
}