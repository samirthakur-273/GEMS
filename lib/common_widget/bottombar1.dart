// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gems_revamp/account/my_account.dart';
// import 'package:gems_revamp/account/mysaving/mysaving_design.dart';
// import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
// import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
// import 'package:gems_revamp/account/profile/user_profile_model.dart';
// import 'package:gems_revamp/account/profile/user_profile_presenter.dart';
// import 'package:gems_revamp/account/profile/user_profile_view.dart';
// import 'package:gems_revamp/advanced_plus/advanced_plus_page.dart';
// import 'package:gems_revamp/advanced_plus/advantage_plus_clubs.dart';
// import 'package:gems_revamp/advanced_plus/advplus_cache.dart';
// import 'package:gems_revamp/advanced_plus/api_utils/advantageplus_apiconfig.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/common_widget/font_size.dart';
// import 'package:gems_revamp/common_widget/tabbarpage.dart';
// import 'package:gems_revamp/common_widget/text_widget.dart';
// import 'package:gems_revamp/utilities/auth_utils.dart';
// import 'package:gems_revamp/utils/connectivity.dart';
// import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
// import 'package:gems_revamp/utils/dialogAlert.dart';
// import 'package:gems_revamp/utils/gemsGlobals.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class BottomBarOld extends StatefulWidget {
//   final initialIndex;
//   final tabvalue;

//   const BottomBarOld({Key? key, this.initialIndex, this.tabvalue})
//       : super(key: key);

//   @override
//   State<BottomBarOld> createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBarOld>
//     with SingleTickerProviderStateMixin
//     implements UserProfileView {
//   bool _reloadHomePage = false;
//   late int _tabindex;
//   var _tabval;

//   TabController? _tabController;
//   List<bool> _isDisabled = [false, true, false];

//   int _selectedPageIndex = 0;
//   late UserProfilePresenter? _userProfilePresenter;
//   bool hideCrash = false;
//   var advCardStatus = '';
//   var gemsPlusIsMemberOrNot;
//   var gemsPlusMembershipNo;
//   var gemsPlusExpiryDate;
//   var gemsPlusMemberPhoto;
//   var gemsMemberRelationCode;
//   var userFamilyInfo;
//   UserProfileModel? _profileModel;
//   Color _textcolor = Color(0xff71726a);
//   Color advplusCardColor = advantagePlus_member_tile_color;
//   String advPlusgif = ImageConstants.advplus_arwdwn;

//   final GlobalKey<ScaffoldState> _tabscaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     _selectedPageIndex = widget.initialIndex;

//     _tabController = TabController(
//         initialIndex: widget.initialIndex, length: 3, vsync: this);
//     _tabController!.addListener(_selectPage);

//     super.initState();
//   }

//   void _selectPage() {
//     setState(() {
//       _selectedPageIndex = _tabController!.index;
//     });
//   }

//   void userProfileApi(membershipNo) {
//     Internetconnectivity().isConnected().then((connected) async {
//       if (connected) {
//         _userProfilePresenter!.userProfileResonse(membershipNo);
//       }
//     });
//   }

//   void getAdvancedPlusMemberData() {
//     //Print("InsideMethod");
//     AdvPlusCache().fetchAdvantagePlusMemberDetailsData().then((value) {
//       //Print("-==--=-=-=ValueDATA-=-=-=-=-=");
//       //Print(value);
//       if (value == null) {
//         AdvantageplusApiConfig.advantagePlusDetailsDataApi(
//                 http.Client(), GemsGLobals.gemsPlusMembershipNo)
//             .then((response) {
//           if (response["status"] == true) {
//             //Print(response["values"]);
//             userFamilyInfo = response["values"];
//             advCardStatus = userFamilyInfo["membership_status"];
//             if (advCardStatus == 'Expired') {
//           advplusCardColor = advantagePlus_grey_color;
//           _textcolor = advantagePlus_text_grey_color;
//           advPlusgif = ImageConstants.advArrow_grey;
//         } else if (advCardStatus == 'Payment defaulted on hold'||advCardStatus == 'Cancelled') {
//           advplusCardColor = advantagePlus_red_color;
//           _textcolor = advantagePlus_whitetext_red_color;
//           advPlusgif = ImageConstants.advArrow_forRed;
//             } else {
//               advplusCardColor = advantagePlus_member_tile_color;
//               _textcolor = Color(0xff71726a);
//               advPlusgif = ImageConstants.advplus_arwdwn;
//             }

//             //Print(userFamilyInfo);
//             AdvPlusCache().saveAdvantagePlusMemberDetailsData(userFamilyInfo);
//           } else {
//             setState(() {
//               hideCrash = true;
//             });
//           }
//         });
//       } else {
//         userFamilyInfo = jsonDecode(value);
//         advCardStatus = userFamilyInfo["membership_status"];
//            if (advCardStatus == 'Expired') {
//           advplusCardColor = advantagePlus_grey_color;
//           _textcolor = advantagePlus_text_grey_color;
//           advPlusgif = ImageConstants.advArrow_grey;
//         } else if (advCardStatus == 'Payment defaulted on hold'||advCardStatus == 'Cancelled') {
//           advplusCardColor = advantagePlus_red_color;
//           _textcolor = advantagePlus_whitetext_red_color;
//           advPlusgif = ImageConstants.advArrow_forRed;
//             } else {
//               advplusCardColor = advantagePlus_member_tile_color;
//               _textcolor = Color(0xff71726a);
//               advPlusgif = ImageConstants.advplus_arwdwn;
//             }

//       }
//     });
//   }

//   Widget _tabbar() {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             offset: Offset(0, -3), //(x,y)
//             blurRadius: 10.0,
//           ),
//         ],
//         color: white_text_color,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16.0),
//           topRight: Radius.circular(16.0),
//         ),
//       ),
//       padding: EdgeInsets.fromLTRB(3, 6, 3, 4),
//       child: TabBar(
//         isScrollable: false,
//         controller: _tabController,
//         indicatorColor: transColor,
//         labelColor: black_color,
//         tabs: [
//           Tab(
//             child: FittedBox(
//               child: Column(
//                 children: [
//                   Container(
//                       child:
//                           _selectedPageIndex == 0 || _tabController!.index == 0
//                               ? SvgPicture.asset(
//                                   ImageConstants.slt_home_icon,
//                                   height: 20,
//                                 )
//                               : SvgPicture.asset(
//                                   ImageConstants.un_slt_home_icon,
//                                   height: 20,
//                                 )),
//                   TextWidget(
//                     text: "Home",
//                     size: text_font_size_xx_small,
//                     color: _selectedPageIndex == 0 || _tabController!.index == 0
//                         ? home_tabbar_text_slt_color
//                         : home_tabbar_text_un_color,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Tab(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 2.0, top: 15),
//               child: FittedBox(
//                 child: TextWidget(
//                   text: "GEMS Rewards Plus",
//                   size: 15,
//                   color: home_tabbar_text_un_color,
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: Container(
//               margin: const EdgeInsets.only(left: 10.0),
//               child: FittedBox(
//                 child: Column(
//                   children: [
//                     Container(
//                       child: Padding(
//                           padding: const EdgeInsets.only(bottom: 1),
//                           child: _selectedPageIndex == 2 ||
//                                   _tabController!.index == 2
//                               ? SvgPicture.asset(
//                                   ImageConstants.slt_account_icon,
//                                   height: 20,
//                                 )
//                               : SvgPicture.asset(
//                                   ImageConstants.un_slt_account_icon,
//                                   height: 20,
//                                 )),
//                     ),
//                     TextWidget(
//                       text: "My Account",
//                       size: text_font_size_xx_small,
//                       color:
//                           _selectedPageIndex == 2 || _tabController!.index == 2
//                               ? home_tabbar_text_slt_color
//                               : home_tabbar_text_un_color,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//         onTap: (tabIndex) {
//           if (_isDisabled[_tabController!.index]) {
//             int index = _tabController!.previousIndex;
//             setState(() {
//               _tabController!.index = index;
//             });
//           }
//           switch (tabIndex) {
//             case 0:
//               _selectedPageIndex = 0;
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (contex) => TabsScreen(
//                             initialIndex: 0,
//                           )));

//               _tabindex = 0;
//               _tabval = "Home";
//               break;

//             case 1:
//               break;
//             case 2:
//               _selectedPageIndex = 2;
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (contex) => TabsScreen(
//                             initialIndex: 2,
//                           )));
//               _tabindex = 2;
//               _tabval = "myaccount";

//               break;

//             default:
//               _selectedPageIndex = 0;
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _onWillPop() {
//       return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0))),
//             child: Container(
//               margin: EdgeInsets.only(top: 25, left: 15, right: 15),
//               height: 120,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     child: TextWidget(
//                       text: 'Are you sure you',
//                       size: 12,
//                       weight: FontWeight.bold,
//                       color: Colors.grey[700]!,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     child: TextWidget(
//                       text: 'want to exit?',
//                       size: 12,
//                       weight: FontWeight.bold,
//                       color: Colors.grey[700]!,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 22),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 width: 1.0,
//                                 color: Colors.grey,
//                               ),
//                               borderRadius: BorderRadius.circular(3)),
//                           child: MaterialButton(
//                             child: TextWidget(
//                                 text: 'No',
//                                 alignment: TextAlign.center,
//                                 size: 12,
//                                 weight: FontWeight.bold),
//                             onPressed: () {
//                               Navigator.of(context).pop(false);
//                             },
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 width: 1.0,
//                                 color: Colors.grey,
//                               ),
//                               borderRadius: BorderRadius.circular(3)),
//                           child: MaterialButton(
//                             child: TextWidget(
//                                 text: 'Yes',
//                                 alignment: TextAlign.center,
//                                 size: 12,
//                                 weight: FontWeight.bold),
//                             onPressed: () async {
//                               SystemChannels.platform
//                                   .invokeMethod('SystemNavigator.pop');
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }

//     void showAdvantagePlusMemberDetailDialog(
//         BuildContext context, userFamilyInfo) {
//       //Print("=-=-=-=-=-=-=-");
//       //Print(userFamilyInfo);

//       showDialog(
//         barrierDismissible: true,
//         barrierColor: white_text_color.withOpacity(0.9),
//         context: context,
//         builder: (BuildContext cxt) {
//           return Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//               padding: EdgeInsets.only(top: 70, right: 10, left: 10),
//               child: Material(
//                 color: advplusCardColor,//advantagePlus_member_tile_color,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding: EdgeInsets.all(0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Stack(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 // margin: EdgeInsets.only(
//                                 //   left: 15,
//                                 // ),
//                                 height: 60,
//                                 width: 160,
//                                 decoration: BoxDecoration(
//                                   color: black_color,
//                                   borderRadius: BorderRadius.only(
//                                       bottomLeft: Radius.circular(10.0),
//                                       bottomRight: Radius.circular(10.0)),
//                                 ),
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                     left: 0.8,
//                                     right: 0.8,
//                                     bottom: 0.8,
//                                   ),
//                                   height: 60,
//                                   width: 160,
//                                   decoration: BoxDecoration(
//                                     color: white_text_color,
//                                     image: DecorationImage(
//                                         image: AssetImage(
//                                             ImageConstants.gems_advplus_logo),
//                                         fit: BoxFit.fitWidth),
//                                     borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(10.0),
//                                         bottomRight: Radius.circular(10.0)),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.only(left: 15, top: 10),
//                                 child: TextWidget(
//                                     weight: FontWeight.bold,
//                                     color: _textcolor,
//                                     text: "Member Name".toUpperCase(),
//                                     size: text_font_medium_x_size),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.only(left: 15, top: 0),
//                                 child: TextWidget(
//                                     weight: FontWeight.bold,
//                                     color: _textcolor,
//                                     text:
//                                         "${GemsGLobals.userFirstName} ${GemsGLobals.userLastName}",
//                                     size: 19),
//                               ),
//                               GemsGLobals.gemsMemberRelationCode == "JUNIOR"
//                                   ? Container(
//                                       margin: EdgeInsets.only(left: 15, top: 5),
//                                       child: TextWidget(
//                                           weight: FontWeight.normal,
//                                           color: _textcolor,
//                                           text: "(under 21)",
//                                           size: text_font_size_x_small),
//                                     )
//                                   : Container(
//                                       height: 0,
//                                     )
//                             ],
//                           ),
//                           Align(
//                               alignment: Alignment.topRight,
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width / 2.2,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           margin:
//                                               EdgeInsets.only(right: 0, top: 0),
//                                           child: TextWidget(
//                                             text: "Powered by ADV+ "
//                                                 .toUpperCase(),
//                                             weight: FontWeight.bold,
//                                             color: _textcolor,
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Container(
//                                             margin: EdgeInsets.only(top: 0),
//                                             child: Image.asset(
//                                               ImageConstants.adv_close_icon,
//                                               height: 35,
//                                               color: _textcolor,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     new SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       height: 100,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           border: Border.all(
//                                               width: 0.8, color: black_color)),
//                                       child: Container(
//                                         color: white_text_color,
//                                         child: GemsGLobals
//                                                     .gemsPlusMemberPhoto ==
//                                                 null
//                                             ? Image.asset(
//                                                 ImageConstants.gems_logo_black,
//                                                 color: Colors.grey[400],
//                                                 fit: BoxFit.fill,
//                                               )
//                                             : CachedNetworkImage(
//                                                 imageUrl: GemsGLobals
//                                                     .gemsPlusMemberPhoto,
//                                                 placeholder: (context, url) =>
//                                                     Image.asset(
//                                                         ImageConstants
//                                                             .gems_logo_black,
//                                                         color:
//                                                             Colors.grey[400]),
//                                                 fit: BoxFit.fill,
//                                               ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       new SizedBox(height: 10),
//                       Container(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 10, top: 10),
//                                       child: TextWidget(
//                                           weight: FontWeight.bold,
//                                           color: _textcolor,
//                                           text:
//                                               "Membership Number".toUpperCase(),
//                                           size: text_font_medium_x_size),
//                                     ),
//                                     Container(
//                                       margin: EdgeInsets.only(left: 10, top: 0),
//                                       child: TextWidget(
//                                           color: _textcolor,
//                                           text: GemsGLobals.gemsPlusMembershipNo
//                                               .toString(),
//                                           size: 20),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             new SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               child: Image.asset(
//                                 advPlusgif,
//                                 height: advPlusgif == ImageConstants.advplus_arwdwn?30: 15,
//                                   width: advPlusgif == ImageConstants.advplus_arwdwn?30:15,
//                               ),
//                             ),
//                             Expanded(
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(right: 10, top: 10),
//                                       child: TextWidget(
//                                           weight: FontWeight.bold,
//                                           color: _textcolor,
//                                           text: "Expired On".toUpperCase(),
//                                           size: text_font_medium_x_size),
//                                     ),
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(right: 10, top: 0),
//                                       child: TextWidget(
//                                           // fontStyle: FontStylefa.italic,
//                                           color: _textcolor,
//                                           text: GemsGLobals.gemsPlusExpiryDate
//                                               .toString(),
//                                           size: 20),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(left: 15, top: 10),
//                               child: TextWidget(
//                                   weight: FontWeight.bold,
//                                   color: _textcolor,
//                                   text: "Membership Type".toUpperCase(),
//                                   size: text_font_medium_x_size),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(left: 15, top: 0),
//                               child: TextWidget(
//                                   weight: FontWeight.bold,
//                                   color: _textcolor,
//                                   text: toBeginningOfSentenceCase(
//                                       userFamilyInfo["membership_type"]
//                                           .toString()),
//                                   size: 19),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   userFamilyInfo["kids"].length != 0
//                                       ? Container(
//                                           margin: EdgeInsets.only(
//                                               left: 10, top: 10),
//                                           child: TextWidget(
//                                               weight: FontWeight.bold,
//                                               color: _textcolor,
//                                               text: "CHILDREN",
//                                               size: text_font_medium_x_size),
//                                         )
//                                       : Container(height: 0),
//                                   Container(
//                                     child: ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount:
//                                             userFamilyInfo["kids"].length,
//                                         itemBuilder:
//                                             (BuildContext context, int index) {
//                                           return Container(
//                                             margin: EdgeInsets.only(
//                                                 left: 10, top: 0),
//                                             child: TextWidget(
//                                                 softwrap: true,
//                                                 weight: FontWeight.w400,
//                                                 color: _textcolor,
//                                                 text: "${userFamilyInfo["kids"][index]["first_name"] ?? ""} ${userFamilyInfo["kids"][index]["last_name"] ?? ""}" +
//                                                     " | " +
//                                                     "${userFamilyInfo["kids"][index]["age"]} years",
//                                                 size: 14),
//                                           );
//                                         }),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               DialogAlert.whatsappBottomModalAdvPlusDrawer(
//                                   context, "971521294354");
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(left: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.only(bottom: 0),
//                                     child: Image(
//                                       image: AssetImage(
//                                           ImageConstants.adv_whatsapp_logo),
//                                       height: 20,
//                                       color: _textcolor,
//                                     ),
//                                   ),
//                                   new SizedBox(
//                                     width: 5,
//                                   ),
//                                   TextWidget(
//                                     text: "Help Desk",
//                                     weight: FontWeight.bold,
//                                     color: _textcolor,
//                                     size: text_font_medium_x_size,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               //Print("=========");
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           AdvantagePlusClubsWebPage()));
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(top: 10, left: 20),
//                               width: 180,
//                               child: TextWidget(
//                                 fontStyle: FontStyle.italic,
//                                 decoration: TextDecoration.underline,
//                                 weight: FontWeight.bold,
//                                 color: _textcolor,
//                                 size: text_font_medium_x_size,
//                                 text:
//                                     "View real-time clubs availability and discounts",
//                                 softwrap: true,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       new SizedBox(
//                         height: 10,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }

//     return Container(
//       color: Colors.white,
//       child:
//           // WillPopScope(
//           // onWillPop: () async {
//           //   Navigator.pop(context);
//           //   return false;
//           // },
//           // child:
//           Scaffold(
//         resizeToAvoidBottomInset: false,
//         key: _tabscaffoldKey,
//         appBar: PreferredSize(
//             child: Container(height: 0), preferredSize: Size.fromHeight(0)),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: InkWell(
//           onTap: () {
//             if (GemsGLobals.userType == "guest") {
//               setState(() {
//                 DialogAlert.showLoginAlert(context);
//               });
//             } else {
//               setState(() {
//                 //Print("isloadingvalue1");
//                 // //Print(isLoading);
//                 //Print(GemsGLobals.gemsPlusIsMemberOrNot);
//                 // checkFlag = true;
//               });

//               if (GemsGLobals.gemsPlusIsMemberOrNot != "yes" ||
//                   GemsGLobals.gemsPlusIsMemberOrNot == null) {
//                 Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AdvantagePlusWebPage()))
//                     .whenComplete(() {
//                   setState(() {
//                     //Print("isloadingvalue2");
//                     // //Print(isLoading);

//                     // _isloading = true;
//                     userProfileApi(GemsGLobals.membershipNo);
//                     // if () {
//                     //   getUserProfile();
//                     // }
//                   });
//                 });
//               } else {
//                 showAdvantagePlusMemberDetailDialog(context, userFamilyInfo);
//               }
//             }
//           },
//           child: Container(
//             height: 50,
//             width: 50,
//             child: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Image.asset(
//                 ImageConstants.gemsadvlogo,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: white_color,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey,

//                   offset: Offset(0, -3), //(x,y)
//                   blurRadius: 10.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: SizedBox(height: 70, child: _tabbar()),
//       ),

//       // ),
//     );
//   }

//   @override
//   void networkError(err) {
//     // TODO: implement networkError
//   }

//   @override
//   void userProfileErrorRespone(Error error) {
//     // TODO: implement userProfileErrorRespone
//   }

//   @override
//   void userProfileSuceessRespone(UserProfileModel userProfileModel) {
//     _profileModel = userProfileModel;
//     if (_profileModel!.status == true) {
//       setState(() {
//         GemsGLobals.membershipNo = _profileModel!.values!.membershipNo;
//         GemsGLobals.userFirstName = _profileModel!.values!.firstName;
//         GemsGLobals.userLastName = _profileModel!.values!.lastName;

//         GemsGLobals.mobilenumber = _profileModel!.values!.phone;
//         GemsGLobals.countryCode = _profileModel!.values!.countryCode;
//         GemsGLobals.useremail = _profileModel!.values!.email.toString();

//         GemsGLobals.gemsPlusIsMemberOrNot =
//             _profileModel!.values!.isAdvantagePlusMember;
//         GemsGLobals.gemsPlusMembershipNo =
//             _profileModel!.values!.advantagePlusCardNo;
//         GemsGLobals.gemsPlusExpiryDate =
//             _profileModel!.values!.advantagePlusExpiryDate;
//         GemsGLobals.gemsPlusMemberPhoto =
//             _profileModel!.values!.advantagePlusPhoto;

//         AuthUtils.saveGemsPlusMemberOrNot(
//             _profileModel!.values!.isAdvantagePlusMember);

//         AuthUtils.saveGemsPlusMembershipNo(
//             _profileModel!.values!.advantagePlusCardNo);

//         AuthUtils.saveGemsPlusExpiryDate(
//             _profileModel!.values!.advantagePlusExpiryDate);

//         AuthUtils.saveGemsPlusMemberPhoto(
//             _profileModel!.values!.advantagePlusPhoto);

//         AuthUtils.saveGemsPlusRelationShipCode(
//             _profileModel!.values!.relationshipCode);

//         gemsPlusIsMemberOrNot = _profileModel!.values!.isAdvantagePlusMember;

//         gemsPlusMembershipNo = _profileModel!.values!.advantagePlusCardNo;

//         gemsPlusExpiryDate = _profileModel!.values!.advantagePlusExpiryDate;

//         gemsPlusMemberPhoto = _profileModel!.values!.advantagePlusPhoto;

//         gemsMemberRelationCode = _profileModel!.values!.relationshipCode;

//         GemsGLobals.gemsPlusAdvantagePlusMember =
//             GemsGLobals.gemsPlusIsMemberOrNot;

//         GemsGLobals.gemsPlusMembershipNoUpdate =
//             GemsGLobals.gemsPlusMembershipNo;
//         GemsGLobals.gemsPlusExpiryDateUpdate = GemsGLobals.gemsPlusExpiryDate;

//         GemsGLobals.gemsPlusMemberPhotoUpdate = GemsGLobals.gemsPlusMemberPhoto;
//         //Print("gemsPlusAdvantagePlusMembeUpdate=-=-=-=-=-=-");
//         //Print(GemsGLobals.gemsPlusAdvantagePlusMember);
//         //Print(GemsGLobals.gemsPlusMembershipNoUpdate);
//         //Print(GemsGLobals.gemsPlusExpiryDateUpdate);
//         //Print(GemsGLobals.gemsPlusMemberPhotoUpdate);
//         //Print("gemsPlusAdvantagePlusMembeUpdate=-=-=-=-=-=-");
//         if (gemsPlusIsMemberOrNot == "yes") {
//           //Print("Member1");
//           getAdvancedPlusMemberData();
//         } else {
//           //Print("Not Member");
//         }

//         //Print(_profileModel?.values?.dob);
//         AuthUtils.setStringValue("pointbalance",
//             gemsPointsFormatter(_profileModel!.values!.pointBalance!));
//         GemsGLobals.pointbalance = _profileModel!.values!.pointBalance!;
//         UserProfileDbHelper().insertUserProfileData(
//             UserProfileDbModel(null, json.encode(userProfileModel.toJson())));

//         //Print(_profileModel?.values?.dob);
//         AuthUtils.setStringValue("pointbalance",
//             gemsPointsFormatter(_profileModel!.values!.pointBalance!));
//         GemsGLobals.pointbalance = _profileModel!.values!.pointBalance!;
//         UserProfileDbHelper().insertUserProfileData(
//             UserProfileDbModel(null, json.encode(userProfileModel.toJson())));
//       });
//     }
//   }
// }
