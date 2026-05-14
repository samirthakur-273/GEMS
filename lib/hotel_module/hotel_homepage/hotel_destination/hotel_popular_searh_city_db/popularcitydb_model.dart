class PopularCityListDbModel {
  int? id;
  dynamic popularcitydata;

  PopularCityListDbModel(this.id, this.popularcitydata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'popularcitydata': popularcitydata,
    };
    return map;
  }

  PopularCityListDbModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    popularcitydata = map['popularcitydata'];
  }
}
