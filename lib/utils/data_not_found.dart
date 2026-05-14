// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../common_widget/Gradient_button.dart';
// import '../common_widget/appbar_widget.dart';
// import '../common_widget/colors_widget.dart';
// import '../common_widget/font_size.dart';
// import '../common_widget/text_widget.dart';

// class DataNotFound extends StatefulWidget {
//   const DataNotFound({Key? key}) : super(key: key);

//   @override
//   _DataNotFoundState createState() => _DataNotFoundState();
// }

// class _DataNotFoundState extends State<DataNotFound> {
//   var customeCare;
//   @override
//   void initState() {
//     getCustomecareData();
//     super.initState();
//   }

//   Future<void> getCustomecareData() async {
//     var sharedprefs = await SharedPreferences.getInstance();

//     var data = sharedprefs.getString('customercareResponse');

//     setState(() {
//       customeCare = json.decode(data!);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async => false,
//         child: Container(
//           decoration: BoxDecoration(gradient: gradient_theme_color),
//           child: SafeArea(
//               top: false,
//               bottom: true,
//               child: Scaffold(
//                 backgroundColor: grey200_color,
//                 appBar: PreferredSize(
//                   preferredSize: Size.fromHeight(0.0),
//                   child: StatusBarColor(),
//                 ),
//                 body: SingleChildScrollView(child: retrydata()),
//               )),
//         ));
//   }

//   Widget _contactSupport() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   // Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) => FAQWEBVIEW()));
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(70),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           AppAssets.faq_help,
//                           width: 35,
//                           height: 33,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         TextWidget(
//                           text: 'FAQ',
//                           color: black_color,
//                           weight: FontWeight.bold,
//                           size: size_16,
//                           alignment: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 3,
//               ),
//               TextWidget(
//                 text: 'Queries\nAnswered',
//                 color: grey_color,
//                 weight: FontWeight.w500,
//                 size: text_font_small,
//                 alignment: TextAlign.center,
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   phonecall("${customeCare['contact_no'] ?? ''}");
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(70),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           AppAssets.customer_help,
//                           width: 35,
//                           height: 33,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         TextWidget(
//                           text: 'Customer\nCare',
//                           color: black_color,
//                           weight: FontWeight.bold,
//                           size: text_font_small,
//                           alignment: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 3,
//               ),
//               TextWidget(
//                 text: customeCare != null
//                     ? "${customeCare['timing'] ?? ''}\n${customeCare['days'] ?? ''}"
//                     : '',
//                 color: grey_color,
//                 weight: FontWeight.w500,
//                 size: text_font_small,
//                 alignment: TextAlign.center,
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   String subject1 = Uri.encodeComponent('Contact Us');
//                   String body = Uri.encodeComponent(
//                       '''Please leave the information below so we can better assist you:\n\n\n\n\n\n\n\n\n\n\n\n\n${CityGLobals.osType} version:${CityGLobals.deviceversion}\nApp version:${CityGLobals.appVersion}''');
//                   String toMailId = 'support@bounz.ae';
//                   gmailurl(toMailId, subject1, body);
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(70),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Image.asset(
//                           AppAssets.email_help,
//                           width: 35,
//                           height: 33,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         TextWidget(
//                           text: 'Email Us',
//                           color: black_color,
//                           weight: FontWeight.bold,
//                           size: text_font_small,
//                           alignment: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 3,
//               ),
//               TextWidget(
//                 text: 'Mail us\n',
//                 color: grey_color,
//                 weight: FontWeight.w500,
//                 size: text_font_small,
//                 alignment: TextAlign.center,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget retrydata() {
//     return Center(
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 80,
//             ),
//             Container(
//               alignment: Alignment.center,
//               width: MediaQuery.of(context).size.width / 1.5,
//               child: Image.asset(
//                 'images/common/Group 10887.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             TextWidget(
//               alignment: TextAlign.center,
//               textAlign: TextAlign.center,
//               softwrap: true,
//               text: "Oops! It's not you, it's us.",
//               weight: FontWeight.bold,
//               size: 22,
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               width: 260,
//               height: 60,
//               // decoration: BoxDecoration(color: deepdark_orange_color),
//               child: GradientButtonWidget(
//                 shadowColor: BoxShadow(
//                     color: orange_color.withOpacity(0.3),
//                     offset: Offset(1.0, 3.0),
//                     blurRadius: 5.0,
//                     spreadRadius: 3.0),
//                 onTap: () {
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => HelpAndSupport()));
                  
//                 },
//                 child: TextWidget(
//                   text: 'Contact Support',
//                   color: Color(0xffffffff),
//                   size: 20,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 45,
//             ),
//             _contactSupport(),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
