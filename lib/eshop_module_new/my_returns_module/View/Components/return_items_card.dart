// import 'package:flutter/material.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';

// class ReturnItemsCards extends StatefulWidget {
//   final ReturnedItem? returnedItems;
//   final totalItems;
//   ReturnItemsCards({Key? key, required this.returnedItems, this.totalItems})
//       : super(key: key);

//   @override
//   _ReturnItemsCardsState createState() => _ReturnItemsCardsState();
// }

// class _ReturnItemsCardsState extends State<ReturnItemsCards> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(height: 1, color: Color(0xffcccccc)),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextWidget(
//                     text: 'Request No:',
//                     weight: FontWeight.bold,
//                   ),
//                   TextWidget(
//                     text: widget.returnedItems?.requestNo ?? '',
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextWidget(
//                     text: 'Request on :',
//                     weight: FontWeight.bold,
//                   ),
//                   TextWidget(
//                     text: widget.returnedItems?.requestedOn ?? '1/15/21',
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextWidget(
//                     text: 'Items :',
//                     weight: FontWeight.bold,
//                   ),
//                   TextWidget(
//                     text: widget.totalItems.toString(),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: TextWidget(
//               text: 'Status',
//               weight: FontWeight.bold,
//             ),
//           ),
//           TextWidget(text: widget.returnedItems?.status ?? ""),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Wrap(
//               direction: Axis.vertical,
//               spacing: 5,
//               children: [
//                 TextWidget(
//                   text: 'Pickup Address:',
//                   weight: FontWeight.bold,
//                 ),
//                 TextWidget(
//                   text:
//                       '${widget.returnedItems?.pickupAddress?.firstname} ${widget.returnedItems?.pickupAddress?.lastname}' ,
//                 ),
//                 TextWidget(
//                   text: widget.returnedItems?.pickupAddress?.address ?? "",
//                 ),
//                 TextWidget(
//                   text: "${widget.returnedItems?.pickupAddress?.city}  ${widget.returnedItems?.pickupAddress?.region}",
//                 ),
//                 TextWidget(
//                   text: widget.returnedItems.pickupAddress.countryId ?? "",
//                 ),
//                 TextWidget(
//                   text: 'T: ' + widget.returnedItems.pickupAddress.telephone ??
//                       "",
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width / 2,
//                   child: TextWidget(
//                     text: 'Address: ' +
//                             widget.returnedItems.pickupAddress.address ??
//                         "",
//                     maxLines: 5,
//                   ),
//                 ),
//                 TextWidget(
//                   text: 'House No: ' +
//                           widget.returnedItems.pickupAddress.houseNo ??
//                       "",
//                 ),
//                 TextWidget(
//                   text: 'Address Type: ' +
//                           widget.returnedItems.pickupAddress.addressType ??
//                       "",
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(height: 1, color: Color(0xffcccccc)),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(
//                   height: 80,
//                   child:
//                       Image.network(widget.returnedItems.items[0].image ?? "")),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 2,
//                     child: TextWidget(
//                       text: widget.returnedItems.items[0].productName ?? "",
//                       weight: FontWeight.bold,
//                       maxLines: 2,
//                       size: text_font_medium_size,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: 'Order ID :',
//                         weight: FontWeight.bold,
//                       ),
//                       TextWidget(
//                         text:
//                             widget.returnedItems.items[0].orderId.toString() ??
//                                 "",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: 'SKU :',
//                         weight: FontWeight.bold,
//                       ),
//                       TextWidget(
//                         text: widget.returnedItems.items[0].sku ?? "",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: 'Item :',
//                         weight: FontWeight.bold,
//                       ),
//                       TextWidget(
//                         text:
//                             widget.returnedItems.items[0].item.toString() ?? "",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: 'Create At :',
//                         weight: FontWeight.bold,
//                       ),
//                       TextWidget(
//                         text: widget.returnedItems.items[0].createdAt
//                                 .toString() ??
//                             "",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Row(
//                     children: [
//                       TextWidget(
//                         text: 'Size :',
//                         weight: FontWeight.bold,
//                       ),
//                       TextWidget(
//                         text: widget.returnedItems.items[0].sizeValue
//                                 .toString() ??
//                             "",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
