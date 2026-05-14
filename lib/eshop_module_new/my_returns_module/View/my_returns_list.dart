// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
// import 'package:flutter/material.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Presenter/my_return_presenter.dart';
// import 'package:gems_revamp/eshop_module_new/order_return_module/View/order_return_view.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class MyReturnList extends StatefulWidget {
//   @override
//   _MyReturnListState createState() => _MyReturnListState();
// }

// class _MyReturnListState extends State<MyReturnList>
//     implements MyReturnsViewContract {
//   MyReturnsModel _model;
//   List selected = [];
//   bool _isLoading = true;
//   bool _nodata = false;
//   List<Widget> returnItemList = [];
//   MyReturnsPresenter _presenter;
//   _MyReturnListState() {
//     _presenter = MyReturnsPresenter(this);
//   }
//   @override
//   void initState() {
//     super.initState();
//     _presenter.getMyReturnData();
//   }

//   @override
//   void onMyReturnsViewSuccess(MyReturnsModel response) {
//     setState(() {
//       if (response.success == 'true') {
//         _model = response;
//         _isLoading = false;
//         _nodata = false;
//       } else {
//         _isLoading = false;
//         _nodata = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading == false &&
//         _nodata == false &&
//         _model.returnableItems != null) {
//       for (int i = 0; i < _model.returnableItems.length; i++) {
//         returnItemList = List<Widget>.generate(
//             _model.returnableItems.length,
//             (int i) => _returnListWidget(
//                   _model.returnableItems[i],
//                   i,
//                 )).toList();
//       }
//     }

//     Widget _body() {
//       return SafeArea(
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           children: returnItemList,
//         ),
//       );
//     }

//     return SafeArea(
//       child: Scaffold(
//         appBar: _appBar(),
//         body: _isLoading ? Loader() : _body(),
//         bottomNavigationBar: _isLoading ? SizedBox() : _bottomNavigation(),
//       ),
//     );
//   }

//   Widget _appBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: black_color,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           }),
//       title: TextWidget(
//         text: 'NEW RETURN',
//         weight: FontWeight.bold,
//         color: black_color,
//         size: 17,
//       ),
//     );
//   }

//   Widget _returnListWidget(ReturnableItems returnItems, index) {
//     return InkWell(
//       onTap: () {
//         _model.returnableItems
//             .forEach((element) => element.selectedItem = false);
//         returnItems.selectedItem = true;
//         setState(() {});
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             color: white_color,
//             border:
//                 Border(bottom: BorderSide(width: 2, color: Colors.grey[200]))),
//         padding: EdgeInsets.fromLTRB(15, 15, 4, 15),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 100,
//               width: 80,
//               color: black_color,
//               child: CachedNetworkImage(
//                 imageUrl: "",
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Image.network(
//                   returnItems?.image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextWidget(
//                       text: returnItems?.sku ?? "",
//                       size: text_font_size_x_small,
//                       color: black_color,
//                       weight: FontWeight.bold,
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 3.5,
//                     ),
//                     returnItems.selectedItem
//                         ? Icon(
//                             Icons.check_box,
//                             color: theme_color,
//                           )
//                         : Icon(
//                             Icons.check_box_outline_blank,
//                             color: theme_color,
//                           )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 2,
//                 ),
//                 TextWidget(
//                   text: "Size " + ": " + returnItems?.sizeValue ?? "",
//                   size: text_font_size_x_small,
//                   color: black_color,
//                 ),
//                 SizedBox(
//                   height: 2,
//                 ),
//                 TextWidget(
//                   text: "Price " + returnItems?.price ?? "",
//                   size: text_font_size_x_small,
//                   color: black_color,
//                 ),
//                 SizedBox(
//                   height: 2,
//                 ),
//                 TextWidget(
//                   text: "Order Id: " + returnItems?.orderItemId ?? "",
//                   size: text_font_size_x_small,
//                   color: black_color,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _bottomNavigation() {
//     return Container(
//       height: 90,
//       color: theme_color,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 var selectedValue = _model.returnableItems
//                     .any((element) => element.selectedItem);
//                 if (selectedValue == true) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => OrderReturnView(
//                                 model: _model.returnableItems,
//                                 orderId: _model.returnableItems
//                                     .firstWhere((element) =>
//                                         element.selectedItem == true)
//                                     .orderItemId,
//                                 returnableItemsResponse: _model.returnableItems
//                                     .firstWhere((element) =>
//                                         element.selectedItem == true),
//                               )));
//                 } else {
//                   Fluttertoast.showToast(
//                       msg: 'Please select item to return',
//                       gravity: ToastGravity.BOTTOM,
//                       backgroundColor: Color(0xAA000000),
//                       textColor: white_text_color,
//                       toastLength: Toast.LENGTH_LONG);
//                 }
//               });
//             },
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   color: selected.isNotEmpty ? white_color : Colors.grey[400],
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: black_color, width: 2)),
//               margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
//               height: 40,
//               child: TextWidget(
//                 text: "Return Item",
//                 size: text_font_medium_x_size,
//                 color: Colors.black,
//                 weight: FontWeight.bold,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void onMyReturnsViewError(error) {
//     setState(() {
//       _isLoading = false;
//       _nodata = true;
//     });
//   }

//   @override
//   void onTimeout() {
//     if (mounted)
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (cxt) => ServiceUnavailable(
//                   onRetry: () => MyReturnsPresenter(this).getMyReturnData())));
//   }
// }
