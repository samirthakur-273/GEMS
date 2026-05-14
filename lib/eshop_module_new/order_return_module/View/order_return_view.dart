// import 'package:flutter/material.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
// import 'package:gems_revamp/eshop_module_new/order_return_module/View/Components/return_items_form.dart';

// class OrderReturnView extends StatefulWidget {
//   final model;
//   final orderId;
//   ReturnableItems returnableItemsResponse;
//   OrderReturnView(
//       {Key key,
//       @required this.model,
//       @required this.orderId,
//       @required this.returnableItemsResponse})
//       : super(key: key);

//   @override
//   _OrderReturnViewState createState() => _OrderReturnViewState();
// }

// class _OrderReturnViewState extends State<OrderReturnView> {
//   var _customEmailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.black,
//           ),
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: black_color,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//           title: TextWidget(
//             text: 'Create New Return',
//             toUpperCase: true,
//             weight: FontWeight.bold,
//             color: black_color,
//             size: text_size_18,
//           ),
//         ),
//         body: SafeArea(
//           child: Container(
//             color: Colors.white,
//             child: ListView(
//               padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               children: [
//                 _orderDetails(),
//                 ReturnItemForm(
//                     model: widget.model,
//                     orderId: widget.orderId,
//                     customEmail: _customEmailController.text ?? "",
//                     returnableItemsResponse: widget.returnableItemsResponse)
//               ],
//             ),
//           ),
//         ));
//   }

//   Container _orderDetails() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           TextWidget(
//             text: 'New Return for Order: ' + widget.orderId,
//             color: black_color,
//             size: text_font_medium_size,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextWidget(
//             text: 'Order ID',
//             color: black_color,
//             size: text_font_medium_x_size,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           TextWidget(
//             text: widget.orderId ?? "",
//             weight: FontWeight.bold,
//             color: theme_color,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextWidget(
//             text: 'Customer Name',
//             color: black_color,
//             size: text_font_medium_x_size,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           TextWidget(
//             text:
//                 "${widget.returnableItemsResponse?.shippingAddress?.firstname} ${widget.returnableItemsResponse?.shippingAddress?.lastname}",
//             color: black_color,
//             size: text_font_medium_x_size,
//             weight: FontWeight.bold,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextWidget(
//             text: 'Email',
//             color: black_color,
//             size: text_font_medium_x_size,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           TextWidget(
//             text: "${widget.returnableItemsResponse?.shippingAddress?.email} ",
//             weight: FontWeight.bold,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           _contactEmail(),
//           _shippingAddress()
//         ],
//       ),
//     );
//   }

//   Widget _contactEmail() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextWidget(
//           text: 'Contact Email Address',
//           color: black_color,
//           size: text_font_medium_x_size,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         SizedBox(
//           width: MediaQuery.of(context).size.width / 1.5,
//           height: 30,
//           child: TextField(
//             controller: _customEmailController,
//             decoration: InputDecoration(
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//       ],
//     );
//   }

//   _shippingAddress() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         TextWidget(
//           text: 'Order Shipping address',
//           color: black_color,
//           size: text_font_medium_x_size,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           width: 180,
//           child: TextWidget(
//             softwrap: true,
//             text:
//                 "${widget.returnableItemsResponse?.shippingAddress?.firstname} ${widget.returnableItemsResponse?.shippingAddress?.lastname}\n${widget.returnableItemsResponse?.shippingAddress?.houseNo}, ${widget.returnableItemsResponse?.shippingAddress?.address} ${widget.returnableItemsResponse?.shippingAddress?.street}\n${widget.returnableItemsResponse?.shippingAddress?.area ?? ""} ${widget.returnableItemsResponse?.shippingAddress?.city}\nT:- ${widget.returnableItemsResponse?.shippingAddress?.countryCode} ${widget.returnableItemsResponse?.shippingAddress?.telephone}",
//             color: black_color,
//             size: text_font_medium_x_size,
//             weight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
