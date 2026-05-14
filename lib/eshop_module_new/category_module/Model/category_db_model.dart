class CategoryDbModel {
  int? id;
  dynamic categorydata;

  CategoryDbModel(this.id, this.categorydata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'categorydata': categorydata,
    };
    return map;
  }

  CategoryDbModel.fromMap(Map<dynamic, dynamic> map) {
     id = map['id'];
    categorydata = map['categorydata'];
  }
}