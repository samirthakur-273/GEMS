

class OfferSearchHistory {
  int? id;
  String? productNamee;
   dynamic offersearchdata;


  OfferSearchHistory(this.id, this.productNamee,this.offersearchdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'productNamee': productNamee,
      'offersearchdata':offersearchdata
    };
    return map;
  }

  OfferSearchHistory.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    productNamee = map['productNamee'];
    offersearchdata=map['offersearchdata'];
  }
}