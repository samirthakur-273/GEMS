/* Items*/
class ReturnableItem {
  int? id;
  String? value;

  ReturnableItem({this.id, this.value});

  static List<ReturnableItem> getItems() {
    return <ReturnableItem>[
      ReturnableItem(id: 1, value: 'Knitted Short Sleeve Dress'),
      ReturnableItem(id: 2, value: 'R & B Black Slim Pants'),
      ReturnableItem(id: 3, value: 'R & B Patterned Blouse'),
    ];
  }
}

/* Resolution*/
class Resolution {
  int? id;
  String? value;

  Resolution({this.id, this.value});

  static List<Resolution> getResolution() {
    return <Resolution>[
      Resolution(id: 1, value: 'R & B Credit'),
      Resolution(id: 2, value: 'Bank Transfer'),
      Resolution(id: 3, value: 'Refund'),
    ];
  }
}

/* Reason To Return*/
// class ReasonToReturn {
//   int id;
//   String value;

//   ReasonToReturn({this.id, this.value});

//   static List<ReasonToReturn> getReasonToReturn() {
//     return <ReasonToReturn>[
//       ReasonToReturn(id: 1, value: 'Item arrived late'),
//       ReasonToReturn(id: 2, value: 'Found better pricing'),
//       ReasonToReturn(id: 3, value: 'No longer interested in the item'),
//       ReasonToReturn(id: 4, value: 'Shipment packing is damaged'),
//       ReasonToReturn(id: 5, value: 'Item damage'),
//       ReasonToReturn(id: 6, value: 'Defective'),
//       ReasonToReturn(id: 7, value: 'Missing part(s) or accessories'),
//       ReasonToReturn(id: 8, value: 'Unsatisfactory quality'),
//       ReasonToReturn(id: 10, value: 'Unsuitable size (big/small)'),
//       ReasonToReturn(id: 11, value: 'Wrong item received'),
//       ReasonToReturn(id: 12, value: 'Others'),
//     ];
//   }
// }

/* Item Condition*/
// class ItemConditions {
//   int id;
//   String value;

//   ItemConditions({this.id, this.value});

//   static List<ItemConditions> getItemCondition() {
//     return <ItemConditions>[
//       ItemConditions(id: 1, value: 'Unopened'),
//       ItemConditions(id: 2, value: 'Opened'),
//       ItemConditions(id: 3, value: 'Damaged'),
//     ];
//   }
// }

class CreateReturnSuccess {
  String? success;
  String? message;

  CreateReturnSuccess({
    this.success,
    this.message,
  });
  factory CreateReturnSuccess.fromJson(Map<String, dynamic> json) {
    return CreateReturnSuccess(
      success: json['success'] != null ? json['success'] : null,
      message:
          json['message'] != null ? json['message'] : "Something went wrong",
    );
  }
}
