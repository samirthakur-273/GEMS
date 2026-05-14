class PopularCityListDbModel {
  int? cityId;
  dynamic fltpopularlistdata;

  PopularCityListDbModel(this.cityId, this.fltpopularlistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': cityId,
      'fltpopulardata': fltpopularlistdata,
    };
    return map;
  }

  PopularCityListDbModel.fromMap(Map<String, dynamic> map) {
    cityId = map['id'];
    fltpopularlistdata = map['fltpopulardata'];
  }
}
