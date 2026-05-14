// import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
// import 'package:flutter/material.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/Presenter/my_return_presenter.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/View/Components/return_items_card.dart';
// import 'package:gems_revamp/eshop_module_new/my_returns_module/View/my_returns_list.dart';

// class MyReturnsView extends StatefulWidget {
//   MyReturnsView({Key key}) : super(key: key);

//   @override
//   _MyReturnsViewState createState() => _MyReturnsViewState();
// }

// class _MyReturnsViewState extends State<MyReturnsView>
//     implements MyReturnsViewContract {
//   MyReturnsModel _model;
//   MyReturnsPresenter _presenter;
//   bool _isLoading = true;
//   bool _nodata = false;
//   bool _noreturnableItems = false;
//   List<Widget> returnItemList = [];

//   _MyReturnsViewState() {
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
//         // _nodata = true;
//         _noreturnableItems = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading == false && _nodata == false) {
//       if (_model?.returnedItems != null) {
//         for (int i = 0; i < _model.returnedItems.length; i++) {
//           returnItemList = List<Widget>.generate(
//               _model.returnedItems.length,
//               (int i) => ReturnItemsCards(
//                     returnedItems: _model.returnedItems[i],
//                     totalItems: _model.returnedItems.length,
//                   )).toList();
//         }
//       }
//     }

//     return Container(
//       color: theme_color,
//       child: SafeArea(
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: PreferredSize(
//                 child: AppBarWidget(
//                   color: theme_color,
//                   title: 'MY RETURNS',
//                 ),
//                 preferredSize: Size.fromHeight(50)),
//             body: _isLoading
//                 ? Loader()
//                 : _nodata
//                     ? Center(
//                         child: TextWidget(
//                           text: 'No data found',
//                           weight: FontWeight.bold,
//                           color: theme_color,
//                         ),
//                       )
//                     : Column(
//                         children: <Widget>[
//                           _model?.returnableItems == null
//                               ? returnItemWidget()
//                               : returnItemWidget(),
//                           returnItemList.isNotEmpty
//                               ? _returnItems()
//                               : _noReturnItem()
//                         ],
//                       )),
//       ),
//     );
//   }

//   Widget returnItemWidget() {
//     return Container(
//       height: MediaQuery.of(context).size.height / 3,
//       child: ListView(
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         children: [
//           Center(
//               child: InkWell(
//                   onTap: _model?.returnableItems == null
//                       ? () {}
//                       : () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => MyReturnList()));
//                         },
//                   child: Container(
//                       width: 150,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: _model?.returnableItems == null
//                             ? Colors.grey[400]
//                             : theme_color,
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: TextWidget(
//                           weight: FontWeight.bold,
//                           alignment: TextAlign.center,
//                           text: 'NEW RETURN',
//                           color: white_text_color)))),
//           SizedBox(
//             height: 10,
//           ),
//           _rulesForReturn(),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _noReturnItem() {
//     return Container(
//       color: white_color,
//       height: 350,
//       padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
//       child: TextWidget(
//         alignment: TextAlign.center,
//         text: "noreturnitem",
//         size: text_size_18,
//         color: black_color,
//         weight: FontWeight.w800,
//       ),
//     );
//   }

//   Card _noReturnableItems() {
//     return Card(
//       elevation: 2,
//       child: Container(
//           padding: EdgeInsets.all(14),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextWidget(
//                   text: "You don't have any \n Returnable Products",
//                   size: text_font_medium_size,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                     child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                             width: 150,
//                             padding: EdgeInsets.all(10),
//                             color: black_color,
//                             child: TextWidget(
//                                 alignment: TextAlign.center,
//                                 text: 'Go Back',
//                                 color: white_text_color))))
//               ])),
//     );
//   }

//   Widget _rulesForReturn() {
//     return Container(
//         color: white_color,
//         padding: EdgeInsets.all(10),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextWidget(
//                 text: "rulesreturn",
//                 weight: FontWeight.bold,
//                 size: text_font_medium_size,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextWidget(
//                 text: "firstreturnrule",
//                 color: black_color,
//                 weight: FontWeight.bold,
//                 size: text_font_small,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               TextWidget(
//                 text: "secondreturnrule",
//                 weight: FontWeight.bold,
//                 color: black_color,
//                 size: text_font_small,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               TextWidget(
//                 text: "thirdreturnrule",
//                 weight: FontWeight.bold,
//                 color: black_color,
//                 size: text_font_small,
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//             ]));
//   }

//   Widget _returnItems() {
//     return Card(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextWidget(
//               text: "Your Return Items",
//               weight: FontWeight.bold,
//               size: text_font_medium_size,
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           LimitedBox(
//             maxHeight: MediaQuery.of(context).size.height / 2.4,
//             child: ListView(
//               shrinkWrap: true,
//               children: returnItemList,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void onMyReturnsViewError(error) {
//     setState(() {
//       _isLoading = false;
//       // _nodata = true;
//     });
//   }

//   @override
//   void onTimeout() {
//     if (mounted)
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (cxt) => ServiceUnavailable(
//                   onRetry: () => MyReturnsPresenter(this)
//                       .getMyReturnData())));
//   }
// }
