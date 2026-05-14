// import 'package:flutter/material.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/my_profile_module/other_pages/app_web_view.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DetailsPage extends StatefulWidget {
//   List? titlekeyaboutus, titlekeycustomer, titlekeycontact;
//   /*String key1, key2, key3;
//   String key4, key5, key6;*/

//   final appbarname;

//   DetailsPage(
//       {this.titlekeyaboutus,
//       this.titlekeycustomer,
//       this.titlekeycontact,
//       this.appbarname});

//   @override
//   _DetailsPageState createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   var noConnection;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     internetCall(
//         context,
//         () => setState(() {
//               listData();
//             }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: white_color,
//       child: SafeArea(
//         child: Scaffold(
//             appBar: PreferredSize(
//                 child: AppBarWidget(
//                   color: theme_color,
//                   title: this.widget.appbarname,
//                   size: 17,
//                   weight: FontWeight.w600,
//                 ),
                
//                 preferredSize: Size.fromHeight(50)),
//             /*AppBar(
//               iconTheme: IconThemeData(
//                 color: Colors.black,
//               ),
//               backgroundColor: Colors.white,
//               title: TextWidget(
//                 text: this.widget.appbarname,
//                 size: text_size_18,
//                 weight: FontWeight.w800,
//                 color: black_color,
//               ),
//               centerTitle: true,
//             ),*/
//             /*PreferredSize(
//                 preferredSize: Size.fromHeight(50.0),
//                 child:  Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(color: white_color, boxShadow: [
//                     BoxShadow(color: Colors.grey[300], blurRadius: 5)
//                   ]),
//                   padding: EdgeInsets.only(top: 35, right: 10, left: 15),
//                   child: TextWidget(
//                     text: this.widget.appbarname,
//                     size: text_size_18,
//                     weight: FontWeight.w800,
//                   ),
//                 )
//             ),*/
//             body: _body()
//             /*ListView(
//             children: [
//               widget.key1 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key1,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//               widget.key2 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key2,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//               widget.key3 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key3,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//               widget.key4 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key4,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//               widget.key5 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key5,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//               widget.key6 != "" ? Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextWidget(
//                       text: widget.key6,
//                       size: text_font_small,
//                     ),
//                     Divider(
//                       color: Colors.grey[400],
//                     )
//                   ],
//                 ),
//               ) : Container(),
//             ],
//           ),*/
//             ),
//       ),
//     );
//   }

//   Widget _body() {
//     return Container(
//       margin: EdgeInsets.only(top: 8.0),
//       child: ListView.builder(
//           itemCount: _data!.length,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 String url = _data![index]!.link.toString();
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AppWebView(
//                             urlKey: url,
//                             title: _data![index]?.title?.toString())));
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
//                     child: TextWidget(
//                       text: _data![index]?.title?.toString() ?? "",
//                       // size: text_font_small,
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.grey[400],
//                   )
//                 ],
//               ),
//             );
//           }),
//     );
//   }

//   List? _data;

//   void listData() {
//     if (widget.titlekeyaboutus != null) {
//       _data = widget.titlekeyaboutus!.toList();
//     } else if (widget.titlekeycustomer != null) {
//       _data = widget.titlekeycustomer!.toList();
//     } else if (widget.titlekeycontact != null) {
//       _data = widget.titlekeycontact!.toList();
//     }
//   }
// }
