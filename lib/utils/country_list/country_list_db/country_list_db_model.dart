class CountryListDbModel {
  int? id;
  dynamic countrylistdata;

  CountryListDbModel(this.id, this.countrylistdata);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'countrylistdata': countrylistdata,
    };
    return map;
  }

  CountryListDbModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    countrylistdata = map['countrylistdata'];
  }
}
