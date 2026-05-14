// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

// import 'product_list_module/View/Components/product_list_filter_detail.dart';

// class ProductListFilter extends StatefulWidget {
//   @override
//   _ProductListFilterState createState() => _ProductListFilterState();
// }

// class _ProductListFilterState extends State<ProductListFilter> {
//   bool isSwitchedKsa = false;
//   bool isSwitchedDiscount = false;
//   List filterdeails = [
//     "Category",
//     "Colors",
//     "Sizes",
//     "Prices",
//     "Material",
//     "Style",
//     "New Arrivals",
//     "Bundles",
//     "Ships from KSA",
//     "Discounts only"
//   ];
//   int view = 0;
//   List colors = [
//     {"code": Colors.red, "name": "Red"},
//     {"code": Colors.green, "name": "Green"},
//     {"code": Colors.blue, "name": "Blue"},
//     {"code": Colors.orange, "name": "Orange"},
//     {"code": Colors.pink, "name": "Pink"},
//     {"code": Colors.purple, "name": "Purple"},
//   ];

//   List size = [
//     {"name": "XS"},
//     {"name": "S"},
//     {"name": "M"},
//     {"name": "L"},
//     {"name": "XL"},
//     {"name": "XLL"},
//   ];
//   List price = [
//     {"name": "AED 0 - AED 100"},
//     {"name": "AED 100 - AED 1000"},
//     {"name": "AED 1000 - AED 2000"},
//     {"name": "AED 2000 - AED 3000"},
//     {"name": "AED 3000 - AED 4000"},
//     {"name": "AED 4000 - AED 5000"},
//   ];
//   List material = [
//     {"name": "Cotton"}
//   ];
//   List arrivals = [
//     {"name": "This week"},
//     {"name": "Last week"},
//     {"name": "This month"},
//   ];
//   List categories = [
//     {"name": "Shirts"},
//     {"name": "T-Shirts"},
//     {"name": "Jeans"},
//     {"name": "Shorts"},
//     {"name": "Sports Wear"},
//   ];
//   List style = [
//     {"name": "Logo"},
//     {"name": "Oversized"},
//     {"name": "Pen"},
//     {"name": "Brush"},
//     {"name": "Eye"},
//   ];
//   List colorsSelected = [];
//   List sizeSelected = [];
//   List priceSelected = [];
//   List materialSelected = [];
//   List styleSelected = [];
//   List arrivalsSelected = [];
//   List bundleSSelected = [];
//   List categoriesSelected = [];
//   bool showHiddenItems = false;
//   String valuesDisplay(String title) {
//     if (title == "Category") {
//       if (categoriesSelected.isNotEmpty) {
//         return categoriesSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Colors") {
//       if (colorsSelected.isNotEmpty) {
//         return colorsSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Sizes") {
//       if (sizeSelected.isNotEmpty) {
//         return sizeSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Prices") {
//       if (priceSelected.isNotEmpty) {
//         return priceSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Material") {
//       if (materialSelected.isNotEmpty) {
//         return materialSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Style") {
//       if (styleSelected.isNotEmpty) {
//         return styleSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "New Arrivals") {
//       if (arrivalsSelected.isNotEmpty) {
//         return arrivalsSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Bundles") {
//       if (bundleSSelected.isNotEmpty) {
//         return bundleSSelected.map((e) => e["name"]).toList().join(", ");
//       } else {
//         return "ANY";
//       }
//     } else if (title == "Ships from KSA" && title == "Discounts only") {
//       return "";
//     } else {
//       return "ANY";
//     }
//   }

//   clearAllList() {
//     colorsSelected = [];
//     sizeSelected = [];
//     priceSelected = [];
//     materialSelected = [];
//     styleSelected = [];
//     arrivalsSelected = [];
//     bundleSSelected = [];
//     categoriesSelected = [];
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     if (categoriesSelected.isEmpty &&
//         colorsSelected.isEmpty &&
//         sizeSelected.isEmpty &&
//         priceSelected.isEmpty &&
//         material.isEmpty &&
//         styleSelected.isEmpty &&
//         arrivalsSelected.isEmpty &&
//         bundleSSelected.isEmpty) {
//       showHiddenItems = true;
//     } else {
//       showHiddenItems = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> _filterData() {
//       List<Widget> _data = new List();
//       for (var i = 0; i < filterdeails.length; i++) {
//         _data.add(GestureDetector(
//           onTap: () {
//             if (filterdeails[i] == "Category") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: categories,
//                             title: filterdeails[i],
//                             selected: categoriesSelected,
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   categoriesSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   categoriesSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//               ;
//             } else if (filterdeails[i] == "Colors") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: colors,
//                             title: filterdeails[i],
//                             selected: colorsSelected,
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   colorsSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   colorsSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "Sizes") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: size,
//                             title: filterdeails[i],
//                             selected: sizeSelected,
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   sizeSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   sizeSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "Prices") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: price,
//                             title: filterdeails[i],
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   priceSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   priceSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "Material") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: material,
//                             title: filterdeails[i],
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   materialSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   materialSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "Style") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: style,
//                             title: filterdeails[i],
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   styleSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   styleSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "New Arrivals") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: arrivals,
//                             title: filterdeails[i],
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   arrivalsSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   arrivalsSelected = [];
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             } else if (filterdeails[i] == "Bundles") {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductListFilterDetail(
//                             data: price,
//                             title: filterdeails[i],
//                           ))).then((value) {
//                 if (value is List && (value?.isNotEmpty ?? false)) {
//                   bundleSSelected = List.from(value);
//                   showHiddenItems = true;
//                   setState(() {});
//                 } else {
//                   showHiddenItems = false;
//                   setState(() {});
//                 }
//               });
//             }
//           },
//           child: Container(
//             margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 border: Border(
//                     bottom: BorderSide(color: Colors.grey[300], width: 2))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: filterdeails[i],
//                       color: black_color,
//                       size: text_font_small,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     TextWidget(
//                       text: valuesDisplay(filterdeails[i]),
//                       color: light_text_color,
//                       size: text_font_size_x_small,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//                 filterdeails[i] != "Ships from KSA" &&
//                         filterdeails[i] != "Discounts only"
//                     ? Container()
//                     : Switch(
//                         value: filterdeails[i] == "Ships from KSA"
//                             ? isSwitchedKsa
//                             : isSwitchedDiscount,
//                         onChanged: (value) {
//                           setState(() {
//                             filterdeails[i] == "Ships from KSA"
//                                 ? isSwitchedKsa = value
//                                 : isSwitchedDiscount = value;
//                             //print(filterdeails[i]);
//                           });
//                         },
//                         activeTrackColor: gold_color,
//                         activeColor: white_color,
//                       ),
//               ],
//             ),
//           ),
//         ));
//       }
//       return _data;
//     }

//     Widget _body() {
//       return Container(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 15),
//                 child: TextWidget(
//                   text: "FILTERS",
//                   color: black_color,
//                   size: text_font_size_x_small,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 decoration: BoxDecoration(boxShadow: [
//                   BoxShadow(color: Colors.grey[300], blurRadius: 5)
//                 ], color: white_color),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: _filterData(),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 15),
//                 child: TextWidget(
//                   text: "VIEWS",
//                   color: black_color,
//                   size: text_font_size_x_small,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 height: 70,
//                 padding: EdgeInsets.only(left: 15, top: 10),
//                 decoration: BoxDecoration(boxShadow: [
//                   BoxShadow(color: Colors.grey[300], blurRadius: 5),
//                 ], color: white_color),
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   //mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           view = 0;
//                         });
//                       },
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               child: Icon(
//                                 Icons.grid_on,
//                                 color:
//                                     view == 0 ? black_color : Colors.grey[400],
//                                 size: 20,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextWidget(
//                               text: "Grid view",
//                               color: view == 0 ? black_color : Colors.grey[400],
//                               size: text_font_small,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           view = 1;
//                         });
//                       },
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               child: Icon(
//                                 Icons.view_list,
//                                 color:
//                                     view == 1 ? black_color : Colors.grey[400],
//                                 size: 20,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextWidget(
//                               text: "List view",
//                               color: view == 1 ? black_color : Colors.grey[400],
//                               size: text_font_small,
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: showHiddenItems
//             ? Container(
//                 alignment: Alignment.center,
//                 height: 40,
//                 color: gold_color,
//                 child: TextWidget(
//                   text: "Apply",
//                   color: white_color,
//                   size: text_font_medium_size,
//                   weight: FontWeight.normal,
//                 ),
//               )
//             : Container(
//                 height: 0,
//               ),
//         appBar: PreferredSize(
//             child: Container(
//               height: 60,
//               padding: EdgeInsets.only(top: 10),
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(color: grey200_color, blurRadius: 3)
//               ], color: white_color),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: 5),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Icon(
//                               Icons.close,
//                               color: black_color,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           TextWidget(
//                             text: "Refine",
//                             color: gold_color,
//                             size: appbar_text_size,
//                             weight: FontWeight.bold,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   showHiddenItems
//                       ? GestureDetector(
//                           onTap: () {
//                             clearAllList();
//                             showHiddenItems = false;
//                             setState(() {});
//                           },
//                           child: AbsorbPointer(
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 40,
//                               margin: EdgeInsets.only(right: 5),
//                               child: TextWidget(
//                                 text: "CLEAR ALL",
//                                 color: gold_color,
//                                 size: text_font_size_x_small,
//                                 weight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Container()
//                 ],
//               ),
//             ),
//             preferredSize: Size.fromHeight(60)),
//         backgroundColor: Color(0xffffffff),
//         body: _body(),
//       ),
//     );
//   }
// }
