import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/account/mysaving/my_saving_presenter.dart';
import 'package:gems_revamp/account/mysaving/my_saving_view.dart';
import 'package:gems_revamp/account/mysaving/my_savings_model.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/bottombar.dart';

class MySaveingDesignPage extends StatefulWidget {
  final initialIndex;
  const MySaveingDesignPage({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<MySaveingDesignPage> createState() => _MySaveingDesignPageState();
}

class _MySaveingDesignPageState extends State<MySaveingDesignPage>
    implements MySavingView {
  bool _isLoading = false;
  bool _nodatafound = false;
  ScrollController _controller = new ScrollController();

  bool _loadMore = false;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  MySavingPresenter? _mySavingPresenter;
  MySavingsModel? _savingsModel;

  @override
  void initState() {
    _mySavingPresenter = MySavingPresenter(this);
    mySavingApiResponseCall();
    super.initState();
    _controller.addListener(_scrollListener);
  }

  mySavingApiResponseCall() {
    var req = {'customer_id': GemsGLobals.membershipNo.toString()};
    setState(() {
      _isLoading = true;
    });
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _mySavingPresenter!.mySavingApiResponse(req);
      } else {
        _mySavingPresenter!.mySavingApiResponse(req);
      }
    });
  }

  _scrollListener() {}

  /* mysaving Listing UI*/
  List<Widget> _mySavingData() {
    List<Widget> _savingList = <Widget>[];
    for (var i = 0; i < _savingsModel!.values!.length; i++) {
      _savingList.add(InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            // elevation: 0.0,
            // shadowColor: white_text_color.withOpacity(0.4),
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.3, color: Colors.grey),
                borderRadius: BorderRadius.circular(14)),
            child: Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: bg_color),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  ImageConstants.gems_placeholder,
                                  fit: BoxFit.cover,
                                );
                              },
                              fit: BoxFit.cover,
                              placeholder: ImageConstants.gems_placeholder,
                              image: _savingsModel!.values![i].brandLogo == null
                                  ? ImageConstants.gems_placeholder
                                  : _savingsModel!.values![i].brandLogo!,
                            )),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // width: 120,
                              child: TextWidget(
                                text:
                                    '${_savingsModel!.values![i].offerTitle ?? ''}',
                                size: text_font_size_x_small,
                                color: black_color,
                                softwrap: true,
                                weight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              // width: 120,
                              child: TextWidget(
                                text: _savingsModel!.values![i].outletName,
                                size: text_font_x_small,
                                color: common_grey_text_color,
                                softwrap: true,
                                weight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: TextWidget(
                                text: "Total saving",
                                size: text_font_x_small,
                                color: flight_text_black_color,
                                weight: FontWeight.w400,
                                softwrap: true,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: TextWidget(
                                text:
                                    'AED ${_savingsModel!.values![i].savedAmount}',
                                size: text_font_medium15_size,
                                weight: FontWeight.w700,
                                color: appbar_color,
                                softwrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: TextWidget(
                          text:
                              'Transaction ID - ${_savingsModel!.values![i].transactionId ?? ''}',
                          color: common_grey_text_color,
                          softwrap: true,
                          size: text_font_size_small,
                          textAlign: TextAlign.end,
                          weight: FontWeight.w400,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: TextWidget(
                            text: _savingsModel!.values![i].transactionDate,
                            color: common_grey_text_color,
                            softwrap: true,
                            size: text_font_size_small,
                            textAlign: TextAlign.end,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return _savingList;
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height - 151,
      color: bg_color,
      child: ListView(
        controller: _controller,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            child: Column(
              children: _mySavingData(),
            ),
          ),
          SizedBox(
            height: 75,
          ),
        ],
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
        tabvalue: "myaccount",
      ),
    );
  }

  Widget _noDataFound() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: TextWidget(
              text: "No Transactions Found",
              size: 20,
              weight: FontWeight.w500,
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
              extendBody: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: Container(
                    decoration: BoxDecoration(gradient: gradient_theme_color),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(
                      top: 25,
                    ),
                    height: Platform.isIOS ? 100 : 90,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).maybePop();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue[400],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 22,
                                    color: white_text_color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 40),
                                child: TextWidget(
                                  text: "My Savings",
                                  color: white_text_color,
                                  size: text_font_medium18_size,
                                  weight: FontWeight.w500,
                                )),
                          )
                        ],
                      ),
                    )),
                // GradientAppBar(
                //   title: "My Savings",
                //   color: white_text_color,
                //   size: text_font_medium18_size,
                //   weight: FontWeight.w500,
                //   centerTitle: true,
                //   height: 90,
                // ),
              ),
              body: _isLoading == true
                  ? Center(
                      child: SpinKitCircle(
                      color: btn_bg_color,
                    ))
                  : _nodatafound == false
                      ? _body()
                      : _noDataFound(),
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
  }

  @override
  void mySavingListError(error) {
    // TODO: implement mySavingListError
  }

  @override
  void mySavingListSuccessRes(MySavingsModel _mySavingsModel) {
    setState(() {
      if (_mySavingsModel.status == true) {
        _savingsModel = _mySavingsModel;

        if (_savingsModel!.values!.length == 0) {
          setState(() {
            _isLoading = false;
            _nodatafound = true;
          });
        } else {
          setState(() {
            _isLoading = false;
            _nodatafound = false;
            _savingsModel = _mySavingsModel;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _nodatafound = true;
        });
      }
    });
  }
}
