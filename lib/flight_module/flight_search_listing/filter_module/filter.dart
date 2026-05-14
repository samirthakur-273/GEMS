// /*
// Auther Name: Animesh Banerjee
// Discription : This is the flight FILTER PAGE
// */
// import 'package:citypoints_mobile_app/common_widgets/appbar_widget.dart';
// import 'package:citypoints_mobile_app/common_widgets/button_widget.dart';
// import 'package:citypoints_mobile_app/common_widgets/colors_widget.dart';
// import 'package:citypoints_mobile_app/common_widgets/error_widget.dart';
// import 'package:citypoints_mobile_app/common_widgets/fontsize.dart';
// import 'package:citypoints_mobile_app/common_widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:another_xlider/another_xlider.dart';
// import '../../../gemsGlobals.dart';
// import '../return_srch_modal.dart' as ret;
// import '../search_list_modal.dart';

// class Filter extends StatefulWidget {
//   final FlightsMenu? flightsMenuSingle;
//   final ret.FlightsMenu? flightsMenuRetrn;
//   final String tripTyp;
//   final callBackData;
//   final nonStpFLT;
//   Filter({
//     required this.flightsMenuSingle,
//     required this.flightsMenuRetrn,
//     required this.tripTyp,
//     required this.callBackData,
//     required this.nonStpFLT,
//     Key? key,
//   }) : super(key: key);
//   @override
//   _FilterState createState() => _FilterState();
// }

// class _FilterState extends State<Filter> with SingleTickerProviderStateMixin {
//   late TabController _controller;
//   bool _refund = false;
//   String? _sortByData;
//   int tabIndex = 0;
//   ret.FlightsMenu? flightsMenuRetrnValue;
//   List _sortDataList = [
//     "Price Per Adult",
//     "Duration",
//     "Departure",
//     "Arrival",
//     "BOUNZ Earning"
//   ];
//   int? _selectedSortBy;
//   int? _selectedDeparture;
//   int? _depMin;
//   int? _depMax;
//   int? _selectedStp;
//   final _startrangecontroller = TextEditingController();
//   final _endrangecontroller = TextEditingController();
//   int minvalue = 100;
//   int maxvalue = 10000;
//   var _startvalue = '100';
//   var _endvalue = '10000';
//   List _isSelectedANM = [];
//   List _stps = [];
//   List _selectedStps = [];
//   double? _minStrt;
//   double? _maxStrt;
//   bool _sortSelected = true;
//   bool _resetData = false;
//   List<double>? _values;
//   bool _addArilines = false;
//   @override
//   void initState() {
//     flightsMenuRetrnValue = widget.flightsMenuRetrn;
//     _controller = TabController(length: 2, vsync: this);
//     if (widget.tripTyp == "1") {
//       minvalue = widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0;
//       maxvalue = widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0;
//     } else {
//       minvalue = flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0;
//       maxvalue = flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0;
//     }

//     if (widget.nonStpFLT == true && widget.callBackData == null) {
//       _selectedStp = 0;
//       _selectedStps.clear();
//       _selectedStps.add(0);
//       _resetData = true;
//     }
//     if (widget.callBackData != null) {
//       _refund = widget.callBackData["is_refund"] == 0 ? false : true;

//       switch (widget.callBackData["sort_by"]) {
//         case "prc_lth":
//           _sortSelected = false;
//           _selectedSortBy = 0;
//           _sortByData = "prc_lth";
//           break;
//         case "prc_htl":
//           _sortSelected = true;
//           _selectedSortBy = 0;
//           _sortByData = "prc_htl";
//           break;
//         case "jtym_htl":
//           _sortSelected = true;
//           _selectedSortBy = 1;
//           _sortByData = "jtym_htl";
//           break;
//         case "jtym_lth":
//           _sortSelected = false;
//           _selectedSortBy = 1;
//           _sortByData = "jtym_lth";
//           break;
//         case "dtym_htl":
//           _sortSelected = true;
//           _sortByData = "dtym_htl";
//           _selectedSortBy = 2;
//           break;
//         case "dtym_lth":
//           _sortSelected = false;
//           _sortByData = "dtym_lth";
//           _selectedSortBy = 2;
//           break;
//         case "atym_htl":
//           _sortSelected = true;
//           _sortByData = "atym_htl";
//           _selectedSortBy = 3;
//           break;
//         case "atym_lth":
//           _sortSelected = false;
//           _sortByData = "atym_lth";
//           _selectedSortBy = 3;
//           break;
//         case "pnts_htl":
//           _sortSelected = true;
//           _sortByData = "pnts_htl";
//           _selectedSortBy = 4;
//           break;
//         case "pnts_lth":
//           _sortSelected = false;
//           _sortByData = "pnts_lth";
//           _selectedSortBy = 4;
//           break;
//         default:
//       }

//       switch (widget.callBackData["pa_dtym_min"]) {
//         case 0:
//           _selectedDeparture = 1;
//           _resetData = true;
//           _depMin = 00;
//           _depMax = 06;
//           break;
//         case 6:
//           _selectedDeparture = 2;
//           _resetData = true;
//           _depMin = 06;
//           _depMax = 12;
//           break;
//         case 12:
//           _selectedDeparture = 3;
//           _resetData = true;
//           _depMin = 12;
//           _depMax = 18;
//           break;
//         case 18:
//           _selectedDeparture = 4;
//           _resetData = true;
//           _depMin = 18;
//           _depMax = 00;
//           break;
//         default:
//       }
//       if (widget.callBackData["stp"] != null) {
//         switch (widget.callBackData["stp"][0]) {
//           case 0:
//             _selectedStp = 0;
//             _selectedStps.clear();
//             _selectedStps.add(0);
//             _resetData = true;
//             break;
//           case 1:
//             _selectedStp = 1;
//             _selectedStps.clear();
//             _selectedStps.add(1);
//             _resetData = true;
//             break;
//           case 2:
//             _selectedStp = 2;
//             _selectedStps.clear();
//             _selectedStps.add(2);
//             _resetData = true;
//             break;
//           default:
//         }
//       }
//       if (widget.callBackData["min_price"] != '' &&
//           widget.callBackData["max_price"] != '') {
//         _minStrt = double.tryParse(widget.callBackData["min_price"].toString());
//         _maxStrt = double.tryParse(widget.callBackData["max_price"].toString());
//         _startrangecontroller.text = widget.callBackData["min_price"];
//         _endrangecontroller.text = widget.callBackData["max_price"];
//         _values = [_minStrt ?? 0, _maxStrt ?? 0];
//       } else {
//         if (widget.tripTyp == "1") {
//           _values = [
//             widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min
//                     ?.roundToDouble() ??
//                 0.0,
//             widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max
//                     ?.roundToDouble() ??
//                 0.0
//           ];
//           _startvalue =
//               "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
//           _endvalue =
//               "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
//         } else {
//           _values = [
//             flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min
//                     ?.roundToDouble() ??
//                 0.0,
//             flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max
//                     ?.roundToDouble() ??
//                 0.0
//           ];
//           _startvalue =
//               "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
//           _endvalue =
//               "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
//         }
//       }
//     } else {
//       if (widget.tripTyp == "1") {
//         _startvalue =
//             "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
//         _endvalue =
//             "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
//         _values = [
//           widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min
//                   ?.roundToDouble() ??
//               0.0,
//           widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max
//                   ?.roundToDouble() ??
//               0.0
//         ];
//       } else {
//         _startvalue =
//             "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
//         _endvalue =
//             "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
//         _values = [
//           flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min
//                   ?.roundToDouble() ??
//               0.0,
//           flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max
//                   ?.roundToDouble() ??
//               0.0
//         ];
//       }
//     }

//     _controller.addListener(() {
//       setState(() {});
//     });
//     final _list = widget.flightsMenuSingle?.normal?.pivot?.anm ?? [];
//     if (widget.tripTyp == "1") {
//       for (int i = 0; i < _list.length; i++) {
//         if (widget.callBackData != null && widget.callBackData["anm"] != null) {
//           for (var a = 0; a < widget.callBackData["anm"].length; a++) {
//             if ((_list[i].value ?? '')
//                 .contains(widget.callBackData["anm"][a])) {
//               _isSelectedANM
//                   .add({"status": true, "name": widget.callBackData["anm"][a]});
//               _addArilines = false;
//               _resetData = true;
//               break;
//             } else {
//               _addArilines = true;
//             }
//           }
//           if (_addArilines) {
//             _isSelectedANM.add({"status": false, "name": ""});
//           }
//         } else {
//           _isSelectedANM.add({"status": false, "name": ""});
//         }
//       }

//       _stps = widget.flightsMenuSingle?.normal?.pivot?.stp ?? [];
//     } else {
//       for (int i = 0; i < _list.length; i++) {
//         if (widget.callBackData != null && widget.callBackData["anm"] != null) {
//           for (var a = 0; a < widget.callBackData["anm"].length; a++) {
//             if ((_list[i].value ?? '')
//                 .contains(widget.callBackData["anm"][a])) {
//               _isSelectedANM
//                   .add({"status": true, "name": widget.callBackData["anm"][a]});
//               _addArilines = false;
//               _resetData = true;
//               break;
//             } else {
//               _addArilines = true;
//             }
//           }

//           if (_addArilines) {
//             _isSelectedANM.add({"status": false, "name": ""});
//           }
//         } else {
//           _isSelectedANM.add({"status": false, "name": ""});
//         }
//       }
//       _stps = flightsMenuRetrnValue?.normal?.pivot?.stp ?? [];
//     }

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     PreferredSize _appbar() {
//       return PreferredSize(
//         preferredSize: Size.fromHeight(55),
//         child: Container(
//           child: GradientAppBar(
//             title: "Sort & Filter",
//             color: white_text_color,
//             size: large_text_size_17,
//             weight: FontWeight.w600,
//             centerTitle: true,
//             height: 90,
//           ),
//         ),
//       );
//     }

//     Widget _title(String title) {
//       return TextWidget(
//         text: title,
//         size: large_text_size_17,
//         color: text_color,
//         weight: FontWeight.bold,
//       );
//     }

//     Widget _tabsFilter() {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         margin: EdgeInsets.only(top: 15),
//         width: MediaQuery.of(context).size.width,
//         height: 50,
//         child: Row(
//           children: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 tabIndex = 0;
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   TextWidget(
//                     text: "Onward",
//                     size: 20,
//                     weight: FontWeight.bold,
//                     color: tabIndex == 0 ? golden_yellow : text_dark_color,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Container(
//                     width: 80,
//                     height: 4,
//                     decoration: BoxDecoration(
//                         gradient: tabIndex == 0 ? gradient_theme_color : null),
//                   ),
//                   Container(
//                     width: 80,
//                     height: 0.5,
//                     decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 0.5, color: shadow_color)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   tabIndex = 1;
//                   setState(() {});
//                 },
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: TextWidget(
//                           text: "  Return",
//                           size: 20,
//                           weight: FontWeight.bold,
//                           color:
//                               tabIndex == 1 ? golden_yellow : text_dark_color,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         width: 80,
//                         height: 4,
//                         margin: const EdgeInsets.only(left: 20),
//                         decoration: BoxDecoration(
//                             gradient:
//                                 tabIndex == 1 ? gradient_theme_color : null),
//                       ),
//                       Container(
//                         // width: 80,
//                         height: 0.5,
//                         decoration: BoxDecoration(
//                           border: Border(
//                               bottom:
//                                   BorderSide(width: 0.5, color: shadow_color)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget _filters() {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: _title("FILTERS"),
//                 ),
//                 // InkWell(
//                 //   onTap: () {
//                 //     // _sortByData = null;
//                 //     // _selectedSortBy = null;
//                 //     _refund = false;
//                 //     _selectedStps.clear();
//                 //     _selectedStp = null;
//                 //     _startrangecontroller.clear();
//                 //     _endrangecontroller.clear();

//                 //     _selectedDeparture = null;
//                 //     _depMin = null;
//                 //     _depMax = null;

//                 //     for (var i = 0; i < _isSelectedANM?.length ?? 0; i++) {
//                 //       _isSelectedANM[i]["status"] = false;
//                 //       _isSelectedANM[i]["name"] = null;
//                 //     }
//                 //     // _resetData = false;
//                 //     if (widget.tripTyp == "1") {
//                 //       minvalue = widget.flightsMenuSingle?.normal?.stats
//                 //               ?.totalPrice?.min ??
//                 //           0;
//                 //       maxvalue = widget.flightsMenuSingle?.normal?.stats
//                 //               ?.totalPrice?.max ??
//                 //           0;
//                 //       _startvalue =
//                 //           "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
//                 //       _endvalue =
//                 //           "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
//                 //     } else {
//                 //       minvalue = flightsMenuRetrnValue
//                 //               ?.normal?.stats?.totalPrice?.min ??
//                 //           0;
//                 //       maxvalue = flightsMenuRetrnValue
//                 //               ?.normal?.stats?.totalPrice?.max ??
//                 //           0;
//                 //       _startvalue =
//                 //           "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
//                 //       _endvalue =
//                 //           "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
//                 //     }
//                 //     _values = [minvalue.toDouble(), maxvalue.toDouble()];

//                 //     setState(() {});
//                 //   },
//                 //   child: Padding(
//                 //     padding: const EdgeInsets.only(right: 15),
//                 //     child: TextWidget(
//                 //       text: "Reset Filters",
//                 //       size: large_text_size_17,
//                 //       color: golden_yellow,
//                 //       weight: FontWeight.w600,
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//             InkWell(
//               onTap: () {
//                 if (_refund) {
//                   _refund = false;
//                 } else {
//                   _refund = true;
//                 }
//                 _resetData = true;
//                 setState(() {});
//               },
//               child: Container(
//                 color: transColor,
//                 padding: const EdgeInsets.only(top: 20, bottom: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(
//                       width: 15,
//                     ),
//                     !_refund
//                         ? Container(
//                             height: 22,
//                             width: 22,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 width: 0.5,
//                                 color: grey_text_color,
//                               ),
//                             ))
//                         : Image.asset(
//                             "images/flt_icons/check.png",
//                             height: 24,
//                           ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     TextWidget(
//                       text: "Refundable flights",
//                       size: size_16,
//                       color: black_color,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             )
//           ],
//         ),
//       );
//     }

//     Widget _dep(String path, String duration, int id, int? selected) {
//       return Column(
//         children: <Widget>[
//           Image.asset(
//             path,
//             height: 50,
//             color: selected == id ? golden_yellow : img_bg_navyblue,
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           TextWidget(
//               text: duration,
//               size: size_16,
//               color: dark_text_color,
//               weight: selected == id ? FontWeight.bold : null)
//         ],
//       );
//     }

//     Widget _departure() {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _title("DEPARTURE"),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 InkWell(
//                     onTap: () {
//                       _selectedDeparture = 1;
//                       _resetData = true;
//                       _depMin = 00;
//                       _depMax = 06;
//                       setState(() {});
//                     },
//                     child: _dep(
//                         "images/flt_icons/1. Icons - Line -  cloudy-day.png",
//                         "00 - 06",
//                         1,
//                         _selectedDeparture)),
//                 InkWell(
//                   onTap: () {
//                     _selectedDeparture = 2;
//                     _resetData = true;
//                     _depMin = 06;
//                     _depMax = 12;
//                     setState(() {});
//                   },
//                   child: _dep("images/flt_icons/1. Icons - Line -  sun.png",
//                       "06 - 12", 2, _selectedDeparture),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _selectedDeparture = 3;
//                     _resetData = true;
//                     _depMin = 12;
//                     _depMax = 18;
//                     setState(() {});
//                   },
//                   child: _dep(
//                       "images/flt_icons/1. Icons - Line -  snow-night.png",
//                       "12 - 18",
//                       3,
//                       _selectedDeparture),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     _selectedDeparture = 4;
//                     _resetData = true;
//                     _depMin = 18;
//                     _depMax = 00;
//                     setState(() {});
//                   },
//                   child: _dep("images/flt_icons/1. Icons - Line -  moon.png",
//                       "18 - 00", 4, _selectedDeparture),
//                 )
//               ],
//             )
//           ],
//         ),
//       );
//     }

//     Widget _selectStps() {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           _stps.length > 0
//               ? InkWell(
//                   onTap: () {
//                     _selectedStp = 0;
//                     _selectedStps.clear();
//                     _selectedStps.add(0);
//                     _resetData = true;
//                     setState(() {});
//                   },
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: 55,
//                         width: 55,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                               width: 0.5,
//                               color: _selectedStp == 0
//                                   ? golden_yellow
//                                   : shadow_color),
//                         ),
//                         child: TextWidget(
//                           text: "0",
//                           size: large_text_size_17,
//                           color: _selectedStp == 0
//                               ? golden_yellow
//                               : grey_background,
//                           weight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : SizedBox(
//                   height: 0,
//                 ),
//           SizedBox(
//             width: 20,
//           ),
//           _stps.length > 1
//               ? InkWell(
//                   onTap: () {
//                     _selectedStp = 1;
//                     _selectedStps.clear();
//                     _selectedStps.add(1);
//                     _resetData = true;
//                     setState(() {});
//                   },
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: 55,
//                         width: 55,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                               width: 0.5,
//                               color: _selectedStp == 1
//                                   ? golden_yellow
//                                   : shadow_color),
//                         ),
//                         child: TextWidget(
//                           text: "1",
//                           size: large_text_size_17,
//                           color: _selectedStp == 1
//                               ? golden_yellow
//                               : grey_background,
//                           weight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : SizedBox(height: 0),
//           SizedBox(
//             width: 20,
//           ),
//           _stps.length > 2
//               ? InkWell(
//                   onTap: () {
//                     _selectedStp = 2;
//                     _selectedStps.clear();
//                     _selectedStps.add(2);
//                     _resetData = true;
//                     setState(() {});
//                   },
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: 55,
//                         width: 55,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                               width: 0.5,
//                               color: _selectedStp == 2
//                                   ? golden_yellow
//                                   : shadow_color),
//                         ),
//                         child: TextWidget(
//                           text: "2+",
//                           size: large_text_size_17,
//                           color: _selectedStp == 2
//                               ? golden_yellow
//                               : grey_background,
//                           weight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : SizedBox(
//                   height: 0,
//                 )
//         ],
//       );
//     }

//     Widget _stops() {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _title("STOPS"),
//             SizedBox(
//               height: 15,
//             ),
//             _selectStps(),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _card(int index, Anm anm) {
//       return InkWell(
//         onTap: () {},
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 5),
//           color: transColor,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 height: 30,
//                 child: Checkbox(
//                     value: _isSelectedANM[index]["status"] ? true : false,
//                     activeColor: golden_yellow,
//                     onChanged: (value) {
//                       _isSelectedANM[index]["status"] =
//                           !_isSelectedANM[index]["status"];

//                       _isSelectedANM[index]["name"] = anm.value ?? "";
//                       if (_isSelectedANM[index]["status"] == true) {
//                         _resetData = true;
//                       }
//                       setState(() {});
//                     }),
//               ),
//               TextWidget(
//                 text: "${anm.value ?? ""} (${anm.count})",
//                 size: size_16,
//                 color: text_color,
//               ),
//               Spacer(),
//               TextWidget(
//                 text:
//                     "AED ${gemsPointsFormatter(anm.stats?.statsFields?.totalPrice?.min ?? 0)}",
//                 size: size_16,
//                 color: text_color,
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _cardRetrn(int index, ret.Anm anm) {
//       return InkWell(
//         onTap: () {},
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 5),
//           color: transColor,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 height: 30,
//                 child: Checkbox(
//                     value: _isSelectedANM[index]["status"] ? true : false,
//                     activeColor: golden_yellow,
//                     onChanged: (value) {
//                       _isSelectedANM[index]["status"] =
//                           !_isSelectedANM[index]["status"];

//                       _isSelectedANM[index]["name"] = anm.value ?? "";
//                       _resetData = true;
//                       setState(() {});
//                     }),
//               ),
//               TextWidget(
//                 text: "${anm.value ?? ""} (${anm.count})",
//                 size: 15,
//                 color: text_color,
//               ),
//               Spacer(),
//               TextWidget(
//                 text:
//                     "AED ${gemsPointsFormatter(anm.stats?.statsFields?.totalPrice?.min ?? 0)}",
//                 size: 15,
//                 color: text_color,
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _sortCard(int index, String title) {
//       return InkWell(
//         onTap: () {
//           _selectedSortBy = index;
//           _sortSelected = !_sortSelected;
//           switch (_selectedSortBy) {
//             case 0:
//               if (_sortSelected) {
//                 _sortByData = "prc_htl";
//               } else {
//                 _sortByData = "prc_lth";
//               }
//               break;
//             case 1:
//               if (_sortSelected) {
//                 _sortByData = "jtym_htl";
//               } else {
//                 _sortByData = "jtym_lth";
//               }
//               break;
//             case 2:
//               if (_sortSelected) {
//                 _sortByData = "dtym_htl";
//               } else {
//                 _sortByData = "dtym_lth";
//               }
//               break;
//             case 3:
//               if (_sortSelected) {
//                 _sortByData = "atym_htl";
//               } else {
//                 _sortByData = "atym_lth";
//               }
//               break;
//             case 4:
//               if (_sortSelected) {
//                 _sortByData = "pnts_htl";
//               } else {
//                 _sortByData = "pnts_lth";
//               }
//               break;
//             default:
//           }
//           _resetData = true;

//           setState(() {});
//         },
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//           color: transColor,
//           child: Row(
//             children: <Widget>[
//               _selectedSortBy == index
//                   ? RotatedBox(
//                       quarterTurns:
//                           _selectedSortBy == index && _sortSelected ? 3 : 1,
//                       child: SvgPicture.asset(
//                         "images/common/back_arrow.svg",
//                         height: 12,
//                         color: golden_yellow,
//                       ),
//                     )
//                   : SizedBox(
//                       width: 12,
//                     ),
//               SizedBox(
//                 width: 5,
//               ),
//               TextWidget(
//                 text: title,
//                 size: size_16,
//                 color: _selectedSortBy == index ? golden_yellow : text_color,
//               ),
//               Spacer(),
//               if (_selectedSortBy == 0 && _selectedSortBy == index)
//                 TextWidget(
//                   text: !_sortSelected ? "Cheapest First" : "Expensive First",
//                   size: size_16,
//                   color: golden_yellow,
//                 ),
//               if (_selectedSortBy == 1 && _selectedSortBy == index)
//                 TextWidget(
//                   text: !_sortSelected ? "Shortest First" : "Longest First",
//                   size: size_16,
//                   color: golden_yellow,
//                 ),
//               if (_selectedSortBy == 2 && _selectedSortBy == index)
//                 TextWidget(
//                   text: !_sortSelected ? "Earlier First" : "Latest First",
//                   size: size_16,
//                   color: golden_yellow,
//                 ),
//               if (_selectedSortBy == 3 && _selectedSortBy == index)
//                 TextWidget(
//                   text: !_sortSelected ? "Earlier First" : "Latest First",
//                   size: size_16,
//                   color: golden_yellow,
//                 ),
//               if (_selectedSortBy == 4 && _selectedSortBy == index)
//                 TextWidget(
//                   text: !_sortSelected ? "Lowest First" : "Highest First",
//                   size: size_16,
//                   color: golden_yellow,
//                 ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _airlineList(FlightsMenu? flightsMenu) {
//       final _list = flightsMenu?.normal?.pivot?.anm ?? [];
//       return ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _list.length,
//           itemBuilder: (context, index) => _card(index, _list[index]));
//     }

//     Widget _airlineListRetrn(ret.FlightsMenu? flightsMenu) {
//       final _list = flightsMenu?.normal?.pivot?.anm ?? [];

//       return ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _list.length,
//           itemBuilder: (context, index) => _cardRetrn(index, _list[index]));
//     }

//     Widget _sortData() {
//       return ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: _sortDataList.length,
//           itemBuilder: (context, index) =>
//               _sortCard(index, _sortDataList[index]));
//     }

//     Widget _airlines() {
//       return Container(
//         padding: EdgeInsets.only(right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: _title("AIRLINES"),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             widget.tripTyp == "1"
//                 ? _airlineList(widget.flightsMenuSingle)
//                 : _airlineListRetrn(flightsMenuRetrnValue)
//           ],
//         ),
//       );
//     }

//     Widget _sortBy() {
//       return Container(
//         padding: EdgeInsets.only(right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: _title("SORT BY"),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             _sortData()
//           ],
//         ),
//       );
//     }

//     Widget _slider() {
//       return FlutterSlider(
//         values: _values ?? [],
//         min: minvalue.toDouble(),
//         max: maxvalue.toDouble(),
//         rangeSlider: true,
//         handlerWidth: 25,
//         handlerHeight: 25,
//         onDragging: (handlerIndex, lowerValue, upperValue) {
//           setState(() {
//             _startvalue = lowerValue.toString().split('.')[0];
//             _endvalue = upperValue.toString().split('.')[0];
//             _startrangecontroller.text = _startvalue;
//             _endrangecontroller.text = _endvalue;
//             _resetData = true;
//             _values = [lowerValue, upperValue];
//           });
//         },
//         onDragCompleted: (handlerIndex, lowerValue, upperValue) {
//           setState(() {
//             _startvalue = lowerValue.toString().split('.')[0];
//             _endvalue = upperValue.toString().split('.')[0];
//             _startrangecontroller.text = _startvalue;
//             _endrangecontroller.text = _endvalue;
//             _resetData = true;
//             _values = [lowerValue, upperValue];
//           });
//         },
//         onDragStarted: (handlerIndex, lowerValue, upperValue) {
//           setState(() {
//             _startvalue = lowerValue.toString().split('.')[0];
//             _endvalue = upperValue.toString().split('.')[0];
//             _startrangecontroller.text = _startvalue;
//             _endrangecontroller.text = _endvalue;
//             _resetData = true;
//             _values = [lowerValue, upperValue];
//           });
//         },
//         trackBar: FlutterSliderTrackBar(
//           inactiveTrackBar: BoxDecoration(color: grey_color_300),
//           activeTrackBarHeight: 4,
//           activeTrackBar: BoxDecoration(color: golden_yellow),
//         ),
//         handler: FlutterSliderHandler(
//           decoration: BoxDecoration(),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: golden_yellow, borderRadius: BorderRadius.circular(25)),
//             padding: EdgeInsets.all(2),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: white_text_color,
//                   borderRadius: BorderRadius.circular(25)),
//             ),
//           ),
//         ),
//         jump: true,
//         rightHandler: FlutterSliderHandler(
//           decoration: BoxDecoration(),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: golden_yellow, borderRadius: BorderRadius.circular(25)),
//             padding: EdgeInsets.all(2),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: white_text_color,
//                   borderRadius: BorderRadius.circular(25)),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget _applyBtn() {
//       return Container(
//         height: 60,
//         color: white_text_color,
//         margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: GradientButtonWidget(
//                 onTap: () {
//                   List _anm = [];
//                   for (var i = 0; i < _isSelectedANM.length; i++) {
//                     if (_isSelectedANM[i]["status"] == true) {
//                       _anm.add(_isSelectedANM[i]["name"]);
//                     }
//                   }

//                   var _filterData = {
//                     "search_code": widget.tripTyp == "1"
//                         ? "${widget.flightsMenuSingle?.searchCode ?? ""}"
//                         : "${flightsMenuRetrnValue?.searchCode ?? ""}",
//                     "is_refund": _refund ? 1 : 0,
//                     "sort_by": _sortByData,
//                     "min_price": _startrangecontroller.text,
//                     "max_price": _endrangecontroller.text,
//                     "stp": _selectedStps.length > 0 ? _selectedStps : null,
//                     "anm": _anm.length > 0 ? _anm : null,
//                     "pa_dtym_min": _depMin,
//                     "pa_dtym_max": _depMax,
//                   };
//                   setState(() {});
//                   Navigator.pop(context, _filterData);
//                 },
//                 shadowColor: BoxShadow(
//                     color: textColor.withOpacity(0.1),
//                     offset: new Offset(0, 10.0),
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0),
//                 child: TextWidget(
//                   text: 'Apply',
//                   size: large_text_size_17,
//                   color: white_text_color,
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Expanded(
//               child: GradientButtonWidget(
//                 onTap: _resetData
//                     ? () {
//                         _sortByData = null;
//                         _selectedSortBy = null;
//                         _refund = false;
//                         _selectedStps.clear();
//                         _selectedStp = null;
//                         _startrangecontroller.clear();
//                         _endrangecontroller.clear();

//                         _selectedDeparture = null;
//                         _depMin = null;
//                         _depMax = null;

//                         for (var i = 0; i < _isSelectedANM.length; i++) {
//                           _isSelectedANM[i]["status"] = false;
//                           _isSelectedANM[i]["name"] = null;
//                         }
//                         _resetData = false;
//                         if (widget.tripTyp == "1") {
//                           minvalue = widget.flightsMenuSingle?.normal?.stats
//                                   ?.totalPrice?.min ??
//                               0;
//                           maxvalue = widget.flightsMenuSingle?.normal?.stats
//                                   ?.totalPrice?.max ??
//                               0;
//                           _startvalue =
//                               "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.min ?? 0}";
//                           _endvalue =
//                               "${widget.flightsMenuSingle?.normal?.stats?.totalPrice?.max ?? 0}";
//                         } else {
//                           minvalue = flightsMenuRetrnValue
//                                   ?.normal?.stats?.totalPrice?.min ??
//                               0;
//                           maxvalue = flightsMenuRetrnValue
//                                   ?.normal?.stats?.totalPrice?.max ??
//                               0;
//                           _startvalue =
//                               "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.min ?? 0}";
//                           _endvalue =
//                               "${flightsMenuRetrnValue?.normal?.stats?.totalPrice?.max ?? 0}";
//                         }
//                         _values = [minvalue.toDouble(), maxvalue.toDouble()];

//                         setState(() {});
//                       }
//                     : () {},
//                 gradientcolor:
//                     _resetData ? gradient_theme_color : gradient_grey_bg_color,
//                 shadowColor: BoxShadow(
//                     color: textColor.withOpacity(0.09),
//                     offset: new Offset(0, 10.0),
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0),
//                 child: TextWidget(
//                   text: 'Reset',
//                   size: large_text_size_17,
//                   color: _resetData ? white_text_color : text_color,
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget price() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: _title("PRICE")),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             child: _slider(),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextWidget(
//                     text: "AED " +
//                         (_startrangecontroller.text.isEmpty
//                             ? gemsPointsFormatter(minvalue)
//                             : gemsPointsFormatter(
//                                 int.parse(_startrangecontroller.text))),
//                     size: large_text_size_17,
//                     weight: FontWeight.w600,
//                   ),
//                 ),
//                 TextWidget(
//                   text: "AED " +
//                       (_endrangecontroller.text.isEmpty
//                           ? gemsPointsFormatter(maxvalue)
//                           : gemsPointsFormatter(
//                               int.parse(_endrangecontroller.text))),
//                   size: large_text_size_17,
//                   weight: FontWeight.w600,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }

//     Widget _body() {
//       try {
//         return Container(
//           color: white_text_color,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               widget.tripTyp == "1"
//                   ? SizedBox(
//                       height: 0,
//                     )
//                   : _tabsFilter(),
//               SizedBox(
//                 height: 25,
//               ),
//               _sortBy(),
//               SizedBox(
//                 height: 30,
//               ),
//               Divider(
//                 indent: 15,
//                 endIndent: 15,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               _filters(),
//               _departure(),
//               SizedBox(
//                 height: 15,
//               ),
//               _stops(),
//               price(),
//               SizedBox(
//                 height: 30,
//               ),
//               _airlines(),
//               SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         );
//       } catch (e) {
//         //Print(e);
//         return ErrorWidgetClass();
//       }
//     }

//     return Container(
//       decoration: BoxDecoration(gradient: gradient_theme_color),
//       child: SafeArea(
//           top: false,
//           bottom: true,
//           child: Scaffold(
//             backgroundColor: white_text_color,
//             appBar: _appbar(),
//             body: SingleChildScrollView(child: _body()),
//             bottomNavigationBar: _applyBtn(),
//           )),
//     );
//   }
// }
