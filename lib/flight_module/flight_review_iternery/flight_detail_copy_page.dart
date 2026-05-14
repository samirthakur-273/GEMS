// /*
// Auther Name: Animesh Banerjee
// Discription : This is the copy of flight details page just an overview
// */

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gems_revamp/common_widget/appbar_widget.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/common_widget/font_size.dart';
// import 'package:gems_revamp/common_widget/text_widget.dart';
// import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
// import 'package:gems_revamp/utils/gemsGlobals.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;

// class DetailsCopyPage extends StatefulWidget {
//   // final String? tripTyp;
//   // final guestData;
//   // final String? tripSubTyp;
//   // final String? paymentTyp;
//   // final totatPrice;
//   // final baseprice;
//   // final taxprice;
//   DetailsCopyPage(
//       // this.tripTyp,
//       {
//     // @required this.guestData,
//     // @required this.paymentTyp,
//     // this.tripSubTyp,
//     // this.baseprice,
//     // this.taxprice,
//     // this.totatPrice,
//     Key? key,
//   }) : super(key: key);
//   @override
//   _DetailsCopyPageState createState() => _DetailsCopyPageState();
// }

// class _DetailsCopyPageState extends State<DetailsCopyPage> {
//   bool isLoading = false;
//   bool _noData = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // void mseventFunction(_fno, flt) {
//   //   String keyName = "On booking Review flights";
//   //   var segmentReq = {
//   //     "Action": "View flight detials",
//   //     "cateogory": widget.paymentTyp,
//   //     "Flight Origin Code": widget.flightRequestHolder.originCity,
//   //     "Flight Destination Code": widget.flightRequestHolder.destinationCity,
//   //     "Flight Origin Airport": widget.flightRequestHolder.airportOriginCode,
//   //     "Flight Destination Airport":
//   //         widget.flightRequestHolder.airportDestinationCode,
//   //     "Flight Departure Date": widget.flightRequestHolder.departureDate,
//   //     "Flight Return Date": widget.flightRequestHolder.returnDate,
//   //     "Type": widget.tripTyp == "1" ? "oneway" : "twoway",
//   //     "Booking Class": widget.guestData != null
//   //         ? widget.guestData.cabinClassName
//   //         : "Economy",
//   //     "Flight type": "$flt",
//   //     "Flight Traveller Adult":
//   //         widget.guestData != null ? widget.guestData.adultNumber : 1,
//   //     "Flight Traveller Child":
//   //         widget.guestData != null ? widget.guestData.childNumber : 0,
//   //     "Flight Traveller Infant":
//   //         widget.guestData != null ? widget.guestData.infentNumber : 0,
//   //     "Flight number": "$_fno",
//   //     "Base Price": "${widget.baseprice}",
//   //     "Taxes": "${widget.taxprice}",
//   //     "Total": "${widget.totatPrice}",
//   //     "Earn BOUNZ": widget.tripTyp == "1" || widget.tripSubTyp != "D"
//   //         ? "${_flightDetailsModel?.data?.values?.flightDetail[0]?.bnzAccrPnts[0]}"
//   //         : "${_returnJrnyDetailsFlightModel?.data?.values?.flightDetail?.bnzAccrPnts[0] + _returnJrnyDetailsFlightModel?.data?.values?.flightDetailReturn[0]?.bnzAccrPnts[0]}",
//   //   };

//   //   MSEVENTCLASS.makesenseEventsApi(http.Client(), segmentReq, keyName);
//   // }

//   _dateFormat(String date) {
//     DateTime _date = DateTime.parse(date);
//     final DateFormat formatter = DateFormat('EEE, dd MMM yyyy');
//     final String formatted = formatter.format(_date);
//     return formatted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // String stringToDateAndDateToStringFormatter() {
//     //   DateFormat journeyDateFormate = DateFormat("dd EEE");
//     //   if (widget.tripTyp == "1") {
//     //     DateTime simpleSingleJourneyDate =
//     //         DateTime.parse(widget.flightRequestHolder.departureDate);
//     //     widget.flightRequestHolder.formattedDepartureDate =
//     //         journeyDateFormate.format(simpleSingleJourneyDate);

//     //     return "${widget.flightRequestHolder.formattedDepartureDate}";
//     //   } else if (widget.tripTyp == "2") {
//     //     DateTime singleJourneyDate =
//     //         DateTime.parse(widget.flightRequestHolder.departureDate);

//     //     DateTime returnJourneyDate =
//     //         DateTime.parse(widget.flightRequestHolder.returnDate);

//     //     widget.flightRequestHolder.formattedDepartureDate =
//     //         journeyDateFormate.format(singleJourneyDate);
//     //     widget.flightRequestHolder.formattedReturnDate =
//     //         journeyDateFormate.format(returnJourneyDate);

//     //     return "${widget.flightRequestHolder.formattedDepartureDate} - ${widget.flightRequestHolder.formattedReturnDate}";
//     //   }
//     //   return "";
//     // }

//     Widget _fromTo(_data) {
//       return Row(
//         children: <Widget>[
//           TextWidget(
//             text: 'Mumbai'.toString().toUpperCase(),
//             size: text_font_small,
//             weight: FontWeight.w400,
//             color: flight_text_black_color,
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 5),
//             child: SvgPicture.asset(
//               ImageConstants.flt_line_arrow_right,
//               height: 8,
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           TextWidget(
//             text: 'Dubai'.toString().toUpperCase(),
//             size: text_font_small,
//             weight: FontWeight.w400,
//             color: flight_text_black_color,
//           )
//         ],
//       );
//     }

//     Widget _orignDet(_details) {
//       return Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   TextWidget(
//                     text: "BOM" " 18:25",
//                     // "${_details["dtym"].toString().length > 5 ? _details["dtym"].toString().substring(11) : _details["dtym"]}",
//                     size: text_font_medium17_size,
//                     color: flight_text_black_color,
//                     weight: FontWeight.w400,
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   TextWidget(
//                       text: "${_dateFormat('2021-08-31 09:23:36')}",
//                       size: text_font_small,
//                       weight: FontWeight.w400,
//                       color: flight_text_black_color)
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 gradient: gradient_theme_color,
//               ),
//               child: TextWidget(
//                 text: "3h 40m",
//                 size: text_font_size_x_small,
//                 color: white_text_color,
//               ),
//             ),
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   TextWidget(
//                     text: "DXB" " 3:40",
//                     // "${_details["atym"].toString().length > 5 ? _details["atym"].toString().substring(11) : _details["atym"]}",
//                     size: text_font_medium17_size,
//                     color: flight_text_black_color,
//                     weight: FontWeight.w400,
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   TextWidget(
//                       text: "${_dateFormat('2021-08-31 09:23:36')}",
//                       size: text_font_small,
//                       weight: FontWeight.w400,
//                       color: flight_text_black_color)
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget _terminaldet(_details) {
//       return Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2.2,
//                     child: TextWidget(
//                       text: "Terminal 1",
//                       size: text_font_medium14_size,
//                       color: flight_text_black_color,
//                       weight: FontWeight.w400,
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width / 2.2,
//                     child: TextWidget(
//                       text: "Chhatrapati shivaji maharaj international airport",
//                       size: text_font_medium14_size,
//                       color: flight_text_black_color,
//                       weight: FontWeight.w400,
//                       softwrap: true,
//                       maxLines: 2,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: MediaQuery.of(context).size.width / 3,
//                     child: TextWidget(
//                       alignment: TextAlign.right,
//                       text: "Terminal 1,",
//                       size: text_font_medium14_size,
//                       color: flight_text_black_color,
//                       weight: FontWeight.w400,
//                     ),
//                   ),
//                   TextWidget(
//                     text: "Dubai Airport",
//                     size: text_font_medium14_size,
//                     color: flight_text_black_color,
//                     weight: FontWeight.w400,
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget _baggageInfo(_details) {
//       return Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextWidget(
//               text: "Baggage info",
//               size: text_font_medium16_size,
//               color: flight_text_black_color,
//               weight: FontWeight.w500,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: <Widget>[
//                 TextWidget(
//                   text: "BOM",
//                   size: text_font_medium14_size,
//                   color: flight_text_black_color,
//                   weight: FontWeight.w400,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 SvgPicture.asset(
//                   ImageConstants.flt_line_arrow_right,
//                   height: 10,
//                   width: 10,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 TextWidget(
//                   text: "DXB",
//                   size: text_font_medium14_size,
//                   color: flight_text_black_color,
//                   weight: FontWeight.w400,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: <Widget>[
//                 SvgPicture.asset(
//                   ImageConstants.flt_suitcase,
//                   height: 15,
//                   color: flight_text_black_color,
//                 ),
//                 SizedBox(
//                   width: 13,
//                 ),
//                 TextWidget(
//                     text: 'Check in ',
//                     size: text_font_medium14_size,
//                     weight: FontWeight.w400,
//                     color: flight_text_black_color),
//                 Spacer(),
//                 TextWidget(
//                   text:
//                       // _details["bgwgt"] == "0"
//                       //     ? "Not Allowed"
//                       //     :
//                       "13"
//                       "Kg",
//                   size: text_font_medium14_size,
//                   weight: FontWeight.w400,
//                   color: flight_text_black_color,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: <Widget>[
//                 SvgPicture.asset(
//                   ImageConstants.flt_luggage,
//                   color: flight_text_black_color,
//                   height: 15,
//                 ),
//                 SizedBox(
//                   width: 6,
//                 ),
//                 TextWidget(
//                     text: "Cabin",
//                     size: text_font_medium14_size,
//                     weight: FontWeight.w400,
//                     color: flight_text_black_color),
//                 Spacer(),
//                 TextWidget(
//                   text: "7 kg",
//                   size: text_font_medium14_size,
//                   weight: FontWeight.w400,
//                   color: flight_text_black_color,
//                 )
//               ],
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _nonrefund(String ref, _pax) {
//       return Container(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         alignment: Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextWidget(
//               text:
//                   //  ref == "false"
//                   //     ?
//                   "Non refundable".toUpperCase(),
//               // : "Refundable".toUpperCase(),
//               size: text_font_medium17_size,
//               color: flight_text_black_color,
//             ),
//             // _pax["ccp"] == 0
//             //     ? SizedBox(
//             //         height: 0,
//             //       )
//             //     : Container(
//             //         padding: EdgeInsets.symmetric(vertical: 5),
//             //         child: Row(
//             //           children: <Widget>[
//             //             TextWidget(
//             //               text: "Cancellation Price",
//             //               size: size_16,
//             //               color: text_light_grey,
//             //               weight: FontWeight.w600,
//             //             ),
//             //             Spacer(),
//             //             TextWidget(
//             //               text: "AED ${_pax["ccp"]}",
//             //               size: size_16,
//             //               color: text_light_grey,
//             //               weight: FontWeight.w600,
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//           ],
//         ),
//       );
//     }

//     Widget _flightDetailsTowards(int index, _lgs, pax) {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             _fromTo(_lgs),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: <Widget>[
//                 Container(
//                   height: 30,
//                   width: 30,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: FadeInImage.assetNetwork(
//                           placeholder: ImageConstants.flt_no_image_flight,
//                           height: 20,
//                           width: 20,
//                           image: ImageConstants.flt_no_image_flight)),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 TextWidget(
//                   text: "Indiogo" + " - " + "6E 31",
//                   size: text_font_medium15_size,
//                   color: flight_text_black_color,
//                   weight: FontWeight.w400,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             _orignDet(_lgs),
//             _terminaldet(_lgs),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//             _baggageInfo(_lgs),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//             _nonrefund('', ''),
//             // _nonrefund(
//             //     widget.tripTyp == "1" || widget.tripSubTyp == "I"
//             //         ? _flightDetailsModel?.data?.values?.flightDetail[0]?.ref
//             //         : _returnJrnyDetailsFlightModel
//             //             ?.data?.values?.flightDetail?.ref,
//             //     pax),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//           ],
//         ),
//       );
//     }

//     // Widget _payback() {
//     //   return Container(
//     //     alignment: Alignment.centerLeft,
//     //     child: Column(
//     //       crossAxisAlignment: CrossAxisAlignment.start,
//     //       children: <Widget>[
//     //         TextWidget(
//     //           text: "Payback",
//     //           weight: FontWeight.bold,
//     //           color: text_color,
//     //           size: size_16,
//     //         ),
//     //         SizedBox(
//     //           height: 15,
//     //         ),
//     //         Row(
//     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //           children: <Widget>[
//     //             TextWidget(
//     //               text: "Payback Mobile/Card no",
//     //               size: medium_text_size_14,
//     //               color: text_color.withOpacity(0.6),
//     //             ),
//     //           ],
//     //         ),
//     //         SizedBox(
//     //           height: 10,
//     //         ),
//     //         SizedBox(
//     //           height: 20,
//     //           child: Divider(),
//     //         ),
//     //       ],
//     //     ),
//     //   );
//     // }

//     String _cancelText(cancelData) {
//       return "Before " +
//           "${cancelData["Cancel_Data"][0]["endhr"] > 24 ? (cancelData["Cancel_Data"][0]["endhr"] / 24).toInt() : cancelData["Cancel_Data"][0]["endhr"]}" +
//           "${cancelData["Cancel_Data"][0]["endhr"] > 24 ? " days" : " hours"}" +
//           " till " +
//           "${cancelData["Cancel_Data"][0]["starthr"] > 24 ? (cancelData["Cancel_Data"][0]["starthr"] / 24).toInt() : cancelData["Cancel_Data"][0]["starthr"]}" +
//           "${cancelData["Cancel_Data"][0]["starthr"] > 24 ? " days" : " hours"}" +
//           " before departure";
//     }

//     Widget _cancelPolicy(bnd) {
//       var cancelData = jsonDecode(bnd["farerule"]);

//       return
//           // cancelData["Cancel_Data"].length > 0
//           // ?
//           Container(
//         alignment: Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             TextWidget(
//               text: "Cancellation policy".toUpperCase(),
//               size: text_font_medium16_size,
//               color: flight_text_black_color,
//               weight: FontWeight.bold,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextWidget(
//               text: "365 days before policy",
//               //  _cancelText(cancelData),
//               size: text_font_medium14_size,
//               color: flight_text_black_color,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//           ],
//         ),
//       );
//       // : SizedBox(
//       //     height: 0,
//       //   );
//     }

//     Widget _flightDetailsReturn(int index, _lgs, pax) {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             _fromTo(_lgs),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               children: <Widget>[
//                 Container(
//                   height: 30,
//                   width: 30,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: FadeInImage.assetNetwork(
//                           placeholder: ImageConstants.flt_no_image_flight,
//                           height: 20,
//                           width: 20,
//                           image: ImageConstants.flt_no_image_flight)),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 TextWidget(
//                   text: "Indiogo" + " - " + "6E 31",
//                   size: text_font_medium15_size,
//                   color: flight_text_black_color,
//                   weight: FontWeight.w400,
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             _orignDet(_lgs),
//             _terminaldet(_lgs),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//             _baggageInfo(_lgs),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//             _nonrefund('ref', ''),
//             // _nonrefund(
//             //     widget.tripSubTyp == "I"
//             //         ? _flightDetailsModel
//             //             ?.data?.values?.flightDetail[0]?.bnds[1]
//             //         : _returnJrnyDetailsFlightModel
//             //             ?.data?.values?.flightDetailReturn[0]?.ref,
//             //     pax),
//             SizedBox(
//               height: 20,
//               child: Divider(),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _fareBrkup(int conFeeOnwrd, int conFeeRtn, int onbfr, int retbfr,
//         int ontax, int rettax, int onttl, int retttl) {
//       var _totalConFee = conFeeOnwrd + conFeeRtn;
//       var _totalBP = onbfr + retbfr;
//       var _totalTax = ontax + rettax;
//       var _totalTP = onttl + retttl;

//       return Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextWidget(
//               text: "Fare Breakup",
//               size: text_font_medium16_size,
//               color: flight_text_black_color,
//               weight: FontWeight.w600,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextWidget(
//                   text: "Convenience Fee",
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//                 TextWidget(
//                   text: "AED ${gemsPointsFormatter(_totalConFee)}",
//                   weight: FontWeight.w600,
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextWidget(
//                   text: "Base Price",
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//                 TextWidget(
//                   text: "AED ${gemsPointsFormatter(_totalBP)}",
//                   weight: FontWeight.w600,
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextWidget(
//                   text: "Taxes",
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//                 TextWidget(
//                   text: "AED ${gemsPointsFormatter(_totalTax)}",
//                   weight: FontWeight.w600,
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextWidget(
//                   text: "Total",
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//                 TextWidget(
//                   text:
//                       //  widget.paymentTyp == "cash"
//                       //     ?
//                       "AED ${gemsPointsFormatter(300)}",
//                   // : widget.tripTyp == "1" || widget.tripSubTyp != "D"
//                   //     ? "${gemsPointsFormatter(_flightDetailsModel?.data?.values?.flightDetail[0]?.bnzReddemPnts[0])} BOUNZ"
//                   //     : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel?.data?.values?.flightDetail?.bnzReddemPnts[0] + _returnJrnyDetailsFlightModel?.data?.values?.flightDetailReturn[0]?.bnzReddemPnts[0])} BOUNZ",
//                   weight: FontWeight.bold,
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 12,
//             ),
//             // widget.paymentTyp == "cash"
//             //     ?
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextWidget(
//                   text: "Earn",
//                   color: flight_text_black_color,
//                   size: text_font_medium16_size,
//                 ),
//                 TextWidget(
//                   text: "1000 BOUNZ",
//                   //  widget.tripTyp == "1" || widget.tripSubTyp != "D"
//                   //     ? "${gemsPointsFormatter(_flightDetailsModel?.data?.values?.flightDetail[0]?.bnzAccrPnts[0])} BOUNZ"
//                   //     : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel?.data?.values?.flightDetail?.bnzAccrPnts[0] + _returnJrnyDetailsFlightModel?.data?.values?.flightDetailReturn[0]?.bnzAccrPnts[0])} BOUNZ",
//                   weight: FontWeight.bold,
//                   color: appbar_color,

//                   size: text_font_medium16_size,
//                 ),
//               ],
//             ),
//             // : SizedBox(
//             //     height: 0,
//             //   ),
//             SizedBox(
//               height: 12,
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _body(String bnd, String retBnd) {
//       var bndsData = jsonDecode(bnd);
//       var retbndData = retBnd != "" ? jsonDecode(retBnd) : "";
//       try {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: TextWidget(
//                   text: "Onward Journey Details :",
//                   size: text_font_medium17_size,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//               Container(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: bndsData["lgs"]?.length ?? 0,
//                   itemBuilder: (context, j) {
//                     return _flightDetailsTowards(
//                         j, bndsData["lgs"][j], bndsData["pax"][0]);
//                   },
//                 ),
//               ),
//               // widget.tripTyp == "1"
//               //     ? Container(
//               //         height: 0,
//               //       )
//               //     : Container(
//               //         alignment: Alignment.centerLeft,
//               //         padding: EdgeInsets.symmetric(vertical: 10),
//               //         child: TextWidget(
//               //           text: "Return Journey Details :",
//               //           size: large_text_size_17,
//               //           weight: FontWeight.bold,
//               //         ),
//               //       ),
//               // widget.tripTyp == "1"
//               //     ? Container(
//               //         height: 0,
//               //       )
//               //     : Container(
//               //         child: ListView.builder(
//               //           shrinkWrap: true,
//               //           physics: NeverScrollableScrollPhysics(),
//               //           itemCount: retbndData["lgs"]?.length ?? 0,
//               //           itemBuilder: (context, j) {
//               //             return _flightDetailsReturn(
//               //                 j, retbndData["lgs"][j], retbndData["pax"][0]);
//               //           },
//               //         ),
//               //       ),
//               SizedBox(
//                 height: 5,
//               ),
//               _cancelPolicy('bndsData'),
//               _fareBrkup(100, 500, 232, 353, 75757, 57575, 5757, 4232),
//               // _fareBrkup(
//               //     widget.tripTyp == "1" || widget.tripSubTyp != "D"
//               //         ? _flightDetailsModel
//               //             ?.data?.values?.flightDetail[0]?.convFee
//               //         : _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetail?.convFee,
//               //     widget.tripTyp == "2" && widget.tripSubTyp == "D"
//               //         ? _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetailReturn[0]?.convFee
//               //         : 0,
//               //     widget.tripTyp == "1" || widget.tripSubTyp != "D"
//               //         ? _flightDetailsModel?.data?.values?.flightDetail[0]?.bfr
//               //         : _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetail?.bfr,
//               //     widget.tripTyp == "2" && widget.tripSubTyp == "D"
//               //         ? _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetailReturn[0]?.bfr
//               //         : 0,
//               //     widget.tripTyp == "1" || widget.tripSubTyp != "D"
//               //         ? _flightDetailsModel?.data?.values?.flightDetail[0]?.ttx
//               //         : _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetail?.ttx,
//               //     widget.tripTyp == "2" && widget.tripSubTyp == "D"
//               //         ? _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetailReturn[0]?.ttx
//               //         : 0,
//               //     widget.tripTyp == "1" || widget.tripSubTyp != "D"
//               //         ? _flightDetailsModel
//               //             ?.data?.values?.flightDetail[0]?.totalPrice
//               //         : _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetail?.totalPrice,
//               //     widget.tripTyp == "2" && widget.tripSubTyp == "D"
//               //         ? _returnJrnyDetailsFlightModel
//               //             ?.data?.values?.flightDetailReturn[0]?.totalPrice
//               //         : 0),
//               SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         );
//       } catch (e) {
//         // //Print(e);
//         return null!;
//       }
//     }

//     Widget _appbarUpdated() {
//       return GradientAppBar(
//         title: "Flight Details",
//         color: white_text_color,
//         size: text_font_medium17_size,
//         weight: FontWeight.w600,
//         centerTitle: true,
//         height: 85,
//       );
//     }

//     return Container(
//       decoration: BoxDecoration(gradient: gradient_theme_color),
//       child: SafeArea(
//           top: false,
//           bottom: true,
//           child: Scaffold(
//             appBar: PreferredSize(
//                 child: _appbarUpdated(), preferredSize: Size.fromHeight(85)),
//             body: SingleChildScrollView(
//                 child:
//                     // isLoading != true
//                     //     ? _noData
//                     //         ? Container(
//                     //             height: MediaQuery.of(context).size.height - 200,
//                     //             width: MediaQuery.of(context).size.width,
//                     //             child: Column(
//                     //               mainAxisAlignment: MainAxisAlignment.center,
//                     //               children: <Widget>[
//                     //                 Image.asset(
//                     //                   AppAssets.flt_illustration,
//                     //                   height: 120,
//                     //                 ),
//                     //                 SizedBox(
//                     //                   height: 25,
//                     //                 ),
//                     //                 Container(
//                     //                   child: TextWidget(
//                     //                     text: 'No records found',
//                     //                     size: 22,
//                     //                     weight: FontWeight.w600,
//                     //                   ),
//                     //                 ),
//                     //                 SizedBox(
//                     //                   height: 5,
//                     //                 ),
//                     //               ],
//                     //             ),
//                     //           )
//                     //  :
//                     _body('', '')
//                 //     widget.tripTyp == "1" || widget.tripSubTyp != "D"
//                 //         ? _flightDetailsModel
//                 //             ?.data?.values?.flightDetail[0]?.bnds[0]
//                 //         : _returnJrnyDetailsFlightModel
//                 //             ?.data?.values?.flightDetail?.bnds[0],
//                 //     widget.tripTyp == "2" && widget.tripSubTyp != "D"
//                 //         ? _flightDetailsModel
//                 //             ?.data?.values?.flightDetail[0]?.bnds[1]
//                 //         : widget.tripTyp == "2" &&
//                 //                 widget.tripSubTyp == "D"
//                 //             ? _returnJrnyDetailsFlightModel?.data?.values
//                 //                 ?.flightDetailReturn[0]?.bnds[0]
//                 //             : "")
//                 // : Center(
//                 //     child: LoaderGif(),
//                 //   ),
//                 ),
//           )),
//     );
//   }

//   // @override
//   // void allErr(error) {
//   //   //Print("===========>>");
//   //   //Print(error);
//   //   setState(() {
//   //     _noData = true;
//   //   });
//   // }

//   // @override
//   // void response(DetailsFlightModel flightDetailsModel) {
//   //   setState(() {
//   //     _flightDetailsModel = flightDetailsModel;
//   //     isLoading = false;
//   //     if (_flightDetailsModel?.status == false) _noData = true;
//   //   });
//   // }

//   // @override
//   // void retunJrnyresponse(
//   //     ReturnJrnyDetailsFlightModel returnJrnyDetailsFlightModel) {
//   //   setState(() {
//   //     _returnJrnyDetailsFlightModel = returnJrnyDetailsFlightModel;
//   //     isLoading = false;
//   //     if (_returnJrnyDetailsFlightModel?.status == false) _noData = true;
//   //   });
//   // }
// }
