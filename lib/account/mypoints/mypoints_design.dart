import 'package:flutter/material.dart';
import 'package:gems_revamp/account/mypoints/model_mypoints.dart';
import 'package:gems_revamp/account/mypoints/presenter_mypoints.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';
import 'view_mypoints.dart';

class MyPointsDesignPage extends StatefulWidget {
  const MyPointsDesignPage({Key? key}) : super(key: key);

  @override
  State<MyPointsDesignPage> createState() => _MyPointsDesignPageState();
}

class _MyPointsDesignPageState extends State<MyPointsDesignPage>
    implements MyPointsView {
  bool _isLoading = false;
  bool _nodatafound = false;
  ScrollController _controller = new ScrollController();

  bool _loadMore = false;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  MyPointsModel corpcarddata = MyPointsModel();
  MyPointsPresenter? _pointspresenter;
  MyPointsModel? mypointsresponse;
  var mypointsdata;
  bool _ismypointsloader = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);

    _pointspresenter = MyPointsPresenter(this);
    callmypointsapi();
  }

  _scrollListener() {
    
  }
  dateformate(format) {
    var now = DateTime.parse(format);
    var formatter = new DateFormat('dd MMM yyyy');
    var formated = formatter.format(now);

    return formated;
  }

  void callmypointsapi() {
    var request = {
      "offset": "0",
      "limit": "100",
      "membership_no": GemsGLobals.membershipNo,
      "type": GemsGLobals.userType,
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _pointspresenter!.myPointsAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _pointspresenter!.myPointsAPI(request);
        }
      }
    });
  }

  /* mysaving Listing UI*/
  List<Widget> _mySavingData() {
    List<Widget> data = <Widget>[];
    int len = mypointsdata != null ? mypointsdata.length : 0;
    for (var i = 0; i < len; i++) {
      data.add(InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            semanticContainer: true,
            // shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.3, color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 0, top: 0),
                        height: 55,
                        width: 55,
                        child: mypointsdata[i].activityCode == "FA" ||
                                mypointsdata[i].activityCode == "FR" ||
                                mypointsdata[i].activityCode == "FLT"
                            ? Icon(
                                Icons.flight,
                                color: white_color,
                                size: 25,
                              )
                            : mypointsdata[i].activityCode == "HA" ||
                                    mypointsdata[i].activityCode == "HR" ||
                                    mypointsdata[i].activityCode == "HTL"
                                ? Icon(
                                    Icons.hotel,
                                    color: white_color,
                                    size: 25,
                                  )
                                : mypointsdata[i].activityCode == "GVS" ||
                                        mypointsdata[i].activityCode == "GCA" ||
                                        mypointsdata[i].activityCode == "GCR"
                                    ? Icon(
                                        Icons.card_giftcard,
                                        color: white_color,
                                        size: 25,
                                      )
                                    : mypointsdata[i].activityCode == "GTATR" ||
                                            mypointsdata[i].activityCode ==
                                                "GTARRP"
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.asset(
                                              ImageConstants.airmiles1,
                                              fit: BoxFit.cover,
                                            ))
                                        : mypointsdata[i].activityCode ==
                                                    "ATGTA" ||
                                                mypointsdata[i].activityCode ==
                                                    "ATGRRR"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7.0),
                                                  child: Image.asset(
                                                    ImageConstants.gemsNewLogo,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ))
                                            : mypointsdata[i].activityCode ==
                                                    "STA"
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    child: Image.asset(
                                                      ImageConstants.smiles,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : mypointsdata[i]
                                                            .activityCode ==
                                                        "STR"
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        child: Image.asset(
                                                          ImageConstants.smiles,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.local_offer,
                                                        color: white_color,
                                                        size: 25,
                                                      ),
                        decoration: BoxDecoration(
                          color: mypointsdata[i].activityCode == "ATGTA" ||
                                  mypointsdata[i].activityCode == "GTATR" ||
                                  mypointsdata[i].activityCode == "GTARRP" ||
                                  mypointsdata[i].activityCode == "ATGRRR" ||
                                  mypointsdata[i].activityCode == "STA" ||
                                  mypointsdata[i].activityCode == "STR"
                              ? transColor
                              : appbar_color,
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(width: 1, color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 140,
                          margin: EdgeInsets.only(right: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 10),
                            child: TextWidget(
                              text: mypointsdata[i].activityName ?? '',
                              size: text_font_medium15_size,
                              color: purchase_text_color,
                              // softwrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: TextWidget(
                                text: "Status",
                                size: text_font_medium14_size,
                                weight: FontWeight.w400,
                                color: common_grey_text_color,
                                softwrap: true,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: TextWidget(
                                // text: "Mon, 24 feb 2020",
                                text: toBeginningOfSentenceCase(
                                        mypointsdata[i].transactionStatus) ??
                                    '',

                                size: text_font_medium15_size,
                                weight: FontWeight.w700,
                                color: mypointsdata[i]
                                            .transactionStatus
                                            .toString()
                                            .toLowerCase() ==
                                        "approved"
                                    ? fnf_list_status_green_color
                                    : deepdark_orange_color,

                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            mypointsdata[i].transactionId != null &&
                                    mypointsdata[i].transactionId != ''
                                ? TextWidget(
                                    text: "Transaction ID",
                                    color: grey_gunsmoke_text_color,
                                    softwrap: true,
                                    size: text_font_size_small,
                                    // textAlign: TextAlign.start,
                                  )
                                : TextWidget(
                                    text: "",
                                    color: grey_gunsmoke_text_color,
                                    softwrap: true,
                                    size: text_font_size_small,
                                    // textAlign: TextAlign.start,
                                  ),
                            Container(
                              width: 100,
                              child: TextWidget(
                                text: mypointsdata[i].transactionId ?? '',
                                color: black_color,
                                softwrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                size: text_font_medium14_size,
                                // textAlign: TextAlign.start,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: mypointsdata[i]
                                          .transactionType
                                          .toString()
                                          .toLowerCase() ==
                                      "credit"
                                  ? "GEMS Earned"
                                  : "GEMS  Redeemed",
                              color: grey_gunsmoke_text_color,
                              softwrap: true,
                              size: text_font_size_small,
                              textAlign: TextAlign.start,
                            ),
                            TextWidget(
                              text: mypointsdata[i].points.toString(),
                              color: black_color,
                              softwrap: true,
                              size: text_font_medium14_size,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "Date",
                              color: grey_gunsmoke_text_color,
                              softwrap: true,
                              size: text_font_size_small,
                            ),
                            TextWidget(
                              // text: "Mon, 24 feb 2020",
                              text:
                                  "${dateformate(mypointsdata[i].transactionDate.toString()) ?? ''}",
                              color: black_color,
                              softwrap: true,
                              size: text_font_medium14_size,

                              weight: FontWeight.w500,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return data;
  }

  Widget _body() {
    return _ismypointsloader == true
        ? SpinKitCircle(
            color: blue_color,
          )
        : _nodatafound == false
            ? Container(
                height: MediaQuery.of(context).size.height,
                color: bg_color,
                child: ListView(
                  controller: _controller,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: _mySavingData(),
                      ),
                    ),
                    // SizedBox(
                    //   height: 75,
                    // ),
                    // _loadMore == true
                    // ? Container(
                    //     margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    //     height: 40,
                    //     child: Center(
                    //         child: SpinKitCircle(
                    //       color: Colors.yellow,
                    //     )))
                    // : Container(
                    //     height: 0,
                    //   )
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //   child: Image.asset(
                    //     AppAssets.nodatapng,
                    //     height: 200,
                    //     width: 200,
                    //   ),
                    // ),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: GradientAppBar(
              title: AppTexts.myPointsText,
              color: white_text_color,
              size: text_font_medium18_size,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            ),
          ),
          body: _body(),
          bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
        ));
  }

  @override
  void mypointsResponseSuccess(MyPointsModel mypointsModel) {
    mypointsresponse = mypointsModel;
    setState(() {
      if (mypointsresponse!.status == true) {
        _ismypointsloader = false;
        mypointsdata = mypointsModel.values?.data;
      } else {
        _ismypointsloader = false;
        _nodatafound = true;
      }
    });
  }
}
