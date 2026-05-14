// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:gems_revamp/eshop_module_new/constants.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
// import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/order_return_module/Model/order_return_model.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/order_return_module/Presenter/order_return_presenter.dart';

// class ReturnItemForm extends StatefulWidget {
//   final List<ReturnableItems> ?model;
//   final orderId;
//   var customEmail;
//   ReturnableItems ?returnableItemsResponse;

//   ReturnItemForm(
//       {required this.model,
//       @required this.orderId,
//       this.customEmail,
//       this.returnableItemsResponse,
//       Key? key})
//       : super(key: key);

//   @override
//   _ReturnItemFormState createState() => _ReturnItemFormState();
// }

// class _ReturnItemFormState extends State<ReturnItemForm>
//     implements OrderReturnContract {
//   OrderReturnPresenter _presenter;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _autoValidate = false;
//   var _quantityToReturnController = TextEditingController();
//   var _bankNameController = TextEditingController();
//   var _accountholderController = TextEditingController();
//   var _accountnoController = TextEditingController();
//   var _branchController = TextEditingController();
//   var _ifscController = TextEditingController();
//   var _commentsController = TextEditingController();
//   ReturnReasons _selectedReasonToReturnValue;
//   var _selectedReasonToReturnKey;
//   var _selectedResolutionKey;
//   var _selectedItemConditionKey;

//   int _state = 0;
//   ResolutionOptions _selectedResolution;
//   ItemCondition _selectedItemCondition;

//   var gender = 'Male';

//   @override
//   void onOrderReturnViewSuccess(CreateReturnSuccess response) {
//     if (response.success == "true") {
//       _state = 0;
//       int count = 3;
//       Navigator.of(context).popUntil((_) => count-- <= 0);
//       Fluttertoast.showToast(
//           msg: response.message.toString(),
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Color(0xAA000000),
//           textColor: white_text_color,
//           gravity: ToastGravity.BOTTOM);
//     } else {
//       _state = 0;
//       Fluttertoast.showToast(
//           msg: response.message.toString(),
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Color(0xAA000000),
//           textColor: white_text_color,
//           gravity: ToastGravity.BOTTOM);
//     }
//     setState(() {});
//   }

//   _ReturnItemFormState() {
//     _presenter = OrderReturnPresenter(this);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         TextWidget(
//           text: 'Product Details',
//           color: black_color,
//           size: text_font_medium_size,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         _paymentForm(),
//       ],
//     );
//   }

//   _paymentForm() {
//     return Form(
//       key: _formKey,
//       autovalidateMode: _autoValidate
//           ? AutovalidateMode.onUserInteraction
//           : AutovalidateMode.disabled,
//       // autovalidate: _autoValidate,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           RichText(
//             text: TextSpan(
//                 text: 'Item',
//                 style:
//                     TextStyle(color: black_color, fontWeight: FontWeight.bold),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.redAccent),
//                   )
//                 ]),
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           returnableItemWidget(),
//           SizedBox(height: 20),
//           RichText(
//             text: TextSpan(
//                 text: 'Quantity to Return',
//                 style:
//                     TextStyle(color: black_color, fontWeight: FontWeight.bold),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.redAccent),
//                   )
//                 ]),
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           textFieldWidget('Quantity to Return *', _quantityToReturnController,
//               (String arg) {
//             if (arg.length < 3 && arg.isEmpty) {
//               return "Please enter quantity to return";
//             } else {
//               return null;
//             }
//           }, TextInputType.number),
//           SizedBox(height: 5),
//           TextWidget(
//             text: 'Remaining Quantity : ' +
//                     widget.returnableItemsResponse.qty.toString() ??
//                 "",
//             color: black_color,
//             fontfamily: 'robotu',
//           ),
//           SizedBox(height: 20),
//           RichText(
//             text: TextSpan(
//                 text: 'Resolution',
//                 style:
//                     TextStyle(color: black_color, fontWeight: FontWeight.bold),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.redAccent),
//                   )
//                 ]),
//           ),
//           SizedBox(height: 5),
//           resolutionWidget(),
//           SizedBox(height: 20),
//           _selectedResolutionKey == 217 ? _bankDetails() : SizedBox(),
//           RichText(
//             text: TextSpan(
//                 text: 'Reason to Return',
//                 style:
//                     TextStyle(color: black_color, fontWeight: FontWeight.bold),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: Colors.redAccent),
//                   )
//                 ]),
//           ),
//           SizedBox(height: 5),
//           reasonToReturnWidget(),
//           SizedBox(height: 20),
//           TextWidget(
//             text: 'Item Condition',
//             weight: FontWeight.w900,
//             color: black_color,
//             fontfamily: 'robotu',
//           ),
//           SizedBox(height: 5),
//           itemConditionWidget(),
//           SizedBox(height: 20),
//           TextWidget(
//             text: 'Comments',
//             weight: FontWeight.bold,
//             color: Colors.black,
//             fontfamily: 'robotu',
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width / 2,
//             child: TextField(
//               maxLines: 4,
//               enabled: _state == 0 ? true : false,
//               controller: _commentsController,
//               decoration: InputDecoration(
//                 border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           _submitBtn()
//         ],
//       ),
//     );
//   }

//   Widget _bankDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         TextWidget(
//           text: 'Bank Name',
//           weight: FontWeight.bold,
//           color: black_color,
//           fontfamily: 'robotu',
//         ),
//         SizedBox(
//           height: 4,
//         ),
//         textFieldWidget('Bank Name', _bankNameController, null, null),
//         SizedBox(height: 20),
//         TextWidget(
//           text: 'Account Holder Name',
//           weight: FontWeight.bold,
//           color: black_color,
//           fontfamily: 'robotu',
//         ),
//         SizedBox(
//           height: 4,
//         ),
//         textFieldWidget(
//             'Account Holder Name', _accountholderController, null, null),
//         SizedBox(height: 20),
//         TextWidget(
//           text: 'Account Number',
//           weight: FontWeight.bold,
//           color: black_color,
//           fontfamily: 'robotu',
//         ),
//         SizedBox(
//           height: 4,
//         ),
//         textFieldWidget('Account Number', _accountnoController, null, null),
//         SizedBox(height: 20),
//         TextWidget(
//           text: 'Branch',
//           weight: FontWeight.bold,
//           color: black_color,
//           fontfamily: 'robotu',
//         ),
//         SizedBox(
//           height: 4,
//         ),
//         textFieldWidget('Branch', _branchController, null, null),
//         SizedBox(height: 20),
//         TextWidget(
//           text: 'Ifsc Code',
//           weight: FontWeight.bold,
//           color: black_color,
//           fontfamily: 'robotu',
//         ),
//         SizedBox(
//           height: 4,
//         ),
//         textFieldWidget('Ifsc Code', _ifscController, null, null),
//         SizedBox(
//           height: 20,
//         ),
//       ],
//     );
//   }

//   Widget textFieldWidget(label, _controller, validator, keyboardType) {
//     return TextFormField(
//         keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
//         enabled: _state == 0 ? true : false,
//         style: _textStyle(),
//         decoration: textFormStyle(label),
//         controller: _controller,
//         validator: validator);
//   }

//   Widget returnableItemWidget() {
//     return DropdownButtonFormField<ReturnableItems>(
//       isDense: true,
//       isExpanded: true,
//       disabledHint: Text(widget.returnableItemsResponse.sku),
//       items: widget.model.map((ReturnableItems i) {
//         return new DropdownMenuItem<ReturnableItems>(
//           value: i,
//           child: new Text(
//             i.sku,
//             style: _textStyle(),
//           ),
//         );
//       }).toList(),
//       onChanged: null,
//       decoration: textFormStyleDropDown('items'),
//     );
//   }

//   Widget resolutionWidget() {
//     return DropdownButtonFormField<ResolutionOptions>(
//       isDense: true,
//       isExpanded: true,
//       items: widget.returnableItemsResponse.resolutionOptions.map((dynamic i) {
//         return new DropdownMenuItem<ResolutionOptions>(
//           onTap: () => _selectedResolutionKey = i.id,
//           value: i,
//           child: new Text(
//             i.label.toString(),
//             style: _textStyle(),
//           ),
//         );
//       }).toList(),
//       validator: (value) {
//         if (value == null) {
//           return 'Please select resolution method';
//         }
//         return null;
//       },
//       value: _selectedResolution,
//       onChanged: _state == 0
//           ? (dynamic selectedValue) {
//               setState(() {
//                 FocusScope.of(context).requestFocus(new FocusNode());
//                 _selectedResolution = selectedValue;
//               });
//             }
//           : null,
//       onSaved: (val) {
//         //print(val);
//       },
//       decoration: textFormStyleDropDown('items'),
//     );
//   }

//   Widget reasonToReturnWidget() {
//     return DropdownButtonFormField<ReturnReasons>(
//       items: widget.returnableItemsResponse.returnReasons.map((dynamic i) {
//         return new DropdownMenuItem<ReturnReasons>(
//           onTap: () => _selectedReasonToReturnKey = i.id,
//           value: i,
//           child: new Text(
//             i.label.toString(),
//             style: _textStyle(),
//           ),
//         );
//       }).toList(),
//       validator: (value) {
//         if (value == null) {
//           return 'Please select reason to return';
//         }
//         return null;
//       },
//       value: _selectedReasonToReturnValue,
//       onChanged: _state == 0
//           ? (dynamic selectedValue) {
//               setState(() {
//                 FocusScope.of(context).requestFocus(new FocusNode());
//                 _selectedReasonToReturnValue = selectedValue;
//               });
//             }
//           : null,
//       onSaved: (val) {
//         //print(val);
//       },
//       decoration: textFormStyleDropDown('items'),
//     );
//   }

//   Widget itemConditionWidget() {
//     return DropdownButtonFormField<ItemCondition>(
//       items: widget.returnableItemsResponse.itemConditions.map((dynamic i) {
//         return new DropdownMenuItem<ItemCondition>(
//           onTap: () => _selectedItemConditionKey = i.id,
//           value: i,
//           child: new Text(
//             i.label.toString(),
//             style: _textStyle(),
//           ),
//         );
//       }).toList(),
//       validator: (value) {
//         if (value == null) {
//           return 'Please select item condition';
//         }
//         return null;
//       },
//       value: _selectedItemCondition,
//       onChanged: _state == 0
//           ? (dynamic selectedValue) {
//               setState(() {
//                 FocusScope.of(context).requestFocus(new FocusNode());
//                 _selectedItemCondition = selectedValue;
//               });
//             }
//           : null,
//       onSaved: (val) {
//         //print(val);
//       },
//       decoration: textFormStyleDropDown('items'),
//     );
//   }

//   _addItems() {
//     return Material(
//       color: Color(0xffefefef),
//       child: InkWell(
//         splashColor: theme_color,
//         onTap: () {},
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Center(
//               child: TextWidget(
//             text: 'Add Item To Return',
//           )),
//         ),
//       ),
//     );
//   }

//   /* TextField Style  : Textfield*/
//   textFormStyle(
//     label,
//   ) {
//     return InputDecoration(
//       isDense: true,
//       contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
//       hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
//       alignLabelWithHint: true,
//       prefixStyle: TextStyle(fontSize: 10, color: Colors.grey),
//       focusColor: theme_color,
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         borderSide: const BorderSide(color: theme_color, width: 1.0),
//       ),
//       labelStyle: TextStyle(
//         color: _state == 0 ? black_color : grey_color,
//         fontWeight: FontWeight.w600,
//         fontSize: 12,
//       ),
//       counterText: "",
//       errorMaxLines: 2,
//       border: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//       ),
//     );
//   }

//   /* TextField Style : Drop down */
//   textFormStyleDropDown(
//     label,
//   ) {
//     return InputDecoration(
//       isDense: true,
//       contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
//       hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
//       alignLabelWithHint: true,
//       prefixStyle: TextStyle(fontSize: 10, color: Colors.grey),
//       focusColor: theme_color,
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         borderSide: const BorderSide(color: theme_color, width: 1.0),
//       ),
//       labelStyle: TextStyle(
//         color: _state == 0 ? black_color : grey_color,
//         fontWeight: FontWeight.w600,
//         fontSize: 12,
//       ),
//       counterText: "",
//       errorMaxLines: 2,
//       border: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//       ),
//     );
//   }

//   _textStyle() {
//     return TextStyle(fontWeight: FontWeight.w600, fontSize: 10);
//   }

//   _validateInputs() {
//     if (_formKey.currentState.validate() == true) {
//       setState(() {
//         if (int.parse(_quantityToReturnController.text) >
//             widget.returnableItemsResponse.qty) {
//           Fluttertoast.showToast(
//               msg: "Quantity cannot be more than " +
//                   widget.returnableItemsResponse.qty.toString(),
//               toastLength: Toast.LENGTH_LONG,
//               backgroundColor: Color(0xAA000000),
//               textColor: white_text_color,
//               gravity: ToastGravity.CENTER);
//         } else {
//           _state = 1;
//           _formKey.currentState.save();
//           var request = {
//             "action": "create",
//             "brandcode": Constants.brandCode,
//             "country_code": Constants.countryCode,
//             "lang_code": Constants.langCode,
//             "customer_custom_email": widget.customEmail ?? "",
//             "comments": _commentsController.text ?? "",
//             "bank_name": _bankNameController.text ?? "",
//             "account_holder_name": _accountholderController.text ?? "",
//             "account_number": _accountnoController.text ?? "",
//             "branch": _branchController.text ?? "",
//             "ifsc_code": _ifscController.text ?? "",
//             "resolution": _selectedResolutionKey.toString() ?? "",
//             "order_increment_id":
//                 widget.returnableItemsResponse.incrementId.toString() ?? "",
//             "order_item_id": widget.orderId.toString() ?? "",
//             widget.orderId: {
//               "qty": _quantityToReturnController.text.toString() ?? "",
//               "reason": _selectedReasonToReturnKey.toString() ?? "",
//               "item_condition": _selectedItemConditionKey.toString() ?? "",
//             }
//           };
//           //print(request);
//           _presenter.sendOrderReturnData(request);
//         }
//       });
//     } else {
//       setState(() {
//         _state = 0;
//         _autoValidate = true;
//       });
//     }
//   }

//   Widget _submitBtn() {
//     return _state == 0
//         ? Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50,
//             decoration: BoxDecoration(
//               color: black_color,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             margin: EdgeInsets.only(top: 15),
//             child: MaterialButton(
//               child: TextWidget(
//                 text: 'SUBMIT',
//                 color: white_text_color,
//                 size: text_font_medium_size,
//                 weight: FontWeight.bold,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _validateInputs();
//                 });
//               },
//             ),
//           )
//         : Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: black_color,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             width: MediaQuery.of(context).size.width,
//             child: Center(
//               child: SpinKitThreeBounce(
//                 color: white_text_color,
//                 size: text_font_large_size,
//               ),
//             ),
//           );
//   }

//   BoxDecoration boxDecoration() {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//             offset: Offset(
//               0,
//               10,
//             ),
//             blurRadius: 20,
//             color: Color(0xFF4056C6).withOpacity(.15))
//       ],
//     );
//   }

//   @override
//   void onOrderReturnViewError(error) {
//     _state = 0;
//     //print(error.toString());
//     Fluttertoast.showToast(
//         msg: error.toString() ?? "Something went wrong",
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Color(0xAA000000),
//         textColor: white_text_color,
//         gravity: ToastGravity.BOTTOM);
//     setState(() {});
//   }

//   @override
//   void onTimeout() {
//     var request = {
//       "action": "create",
//       "brandcode": Constants.brandCode,
//       "country_code": Constants.countryCode,
//       "lang_code": Constants.langCode,
//       "customer_custom_email": widget.customEmail ?? "",
//       "comments": _commentsController.text ?? "",
//       "bank_name": _bankNameController.text ?? "",
//       "account_holder_name": _accountholderController.text ?? "",
//       "account_number": _accountnoController.text ?? "",
//       "branch": _branchController.text ?? "",
//       "ifsc_code": _ifscController.text ?? "",
//       "resolution": _selectedResolutionKey.toString() ?? "",
//       "order_increment_id":
//           widget.returnableItemsResponse.incrementId.toString() ?? "",
//       "order_item_id": widget.orderId.toString() ?? "",
//       widget.orderId: {
//         "qty": _quantityToReturnController.text.toString() ?? "",
//         "reason": _selectedReasonToReturnKey.toString() ?? "",
//         "item_condition": _selectedItemConditionKey.toString() ?? "",
//       }
//     };
//     if (mounted)
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (cxt) => ServiceUnavailable(
//                   onRetry: () => _presenter.sendOrderReturnData(request))));
//   }
// }
