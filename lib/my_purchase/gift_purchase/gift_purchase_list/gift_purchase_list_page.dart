import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_homepage.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_db_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_details/gift_purchase_details_page.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_view.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../common_widget/bottombar.dart';

class GiftPurchaseListPage extends StatefulWidget {
  const GiftPurchaseListPage({Key? key}) : super(key: key);

  @override
  _GiftPurchaseListPageState createState() => _GiftPurchaseListPageState();
}

class _GiftPurchaseListPageState extends State<GiftPurchaseListPage>
    implements GiftPurchaseListView {
  bool? _isLoading = false;
  GiftCardPurchaseListModel? _cardPurchaseListModel;
  bool? _noDataFound = true;

  @override
  void initState() {
    super.initState();

    _giftCardApiCall();
  }

  Future<List<GiftCardPurchaseListDbModel>> getgiftCardPurchaseDataFromDb() {
    var data = GiftCardPurchaseListDBHelper().getGiftcardPurchaseListData();
    return data;
  }

  _giftCardApiCall() {
    getgiftCardPurchaseDataFromDb().then((value) async {
      if (value.length > 0) {
        GiftPurchaseListPresenter(this)
            .giftPurchaseListApiRes(GemsGLobals.membershipNo, 20);
      } else {
        Internetconnectivity().isConnected().then((result) async {
          if (result) {
            GiftPurchaseListPresenter(this)
                .giftPurchaseListApiRes(GemsGLobals.membershipNo, 20);
          } else {
            var connectionResult = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NoInternet()));
            if (connectionResult != null) {
              _giftCardApiCall();
            } else {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }


  List giftPurchaselistArray = [];


  Map<String, List> giftpurchaseListingarray = {};

  void giftSortingByMonth() {
    giftpurchaseListingarray = {};

    for (var j = 0; j < giftPurchaselistArray.length; j++) {
      var date = giftPurchaselistArray[j].purchasedDate;
      var fromatedDate = DateTime.parse(date);
      // Duration dur = DateTime.now().difference(fromatedDate);
      // var days = dur.inDays;

      String _date = getDate(fromatedDate);
      giftpurchaseListingarray[_date] ??= [];

      giftpurchaseListingarray[_date]?.add(giftPurchaselistArray[j]);
    }
  }

  String getDate(DateTime dateTime) {
    Duration dur = DateTime.now().difference(dateTime);
    // .date.difference(dateTime.date);
    var days = dur.inDays;

    switch (days) {
      case 0:
        return DateFormat("MMMM yyyy").format(dateTime);

      default:
        return DateFormat("MMMM yyyy").format(dateTime);
    }
  }

  Widget giftPurchaseList() {
    return Container(
      child: ListView.builder(
          itemCount: giftpurchaseListingarray.keys.toList().length,
          itemBuilder: (BuildContext context, int index) {
            final _key = giftpurchaseListingarray.keys.toList()[index];
            return Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 5),
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: _key,
                      size: text_font_medium15_size,
                      color: date_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: giftpurchaseListingarray[_key]!.length,
                    itemBuilder: (BuildContext context, int i) {
                      final giftpurchaseList =
                          giftpurchaseListingarray[_key]![i];

                      return GestureDetector(
                        onTap: () {                          

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GiftPurchaseDetailsPage(
                                        type: "purchase",
                                        giftPurhaseDetails: giftpurchaseList,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          //height: 115,
                          child: Card(
                            semanticContainer: true,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.3, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      height: 55,
                                      width: 55,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: FadeInImage.assetNetwork(
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              ImageConstants.noimages,
                                              fit: BoxFit.fill,
                                            );
                                          },
                                          fit: BoxFit.fill,
                                          placeholder: ImageConstants.noimages,
                                          image: giftpurchaseList.mobileImage,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    Container(
                                      width: 160,
                                      margin: const EdgeInsets.only(
                                        top: 15,
                                        left: 5,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: giftpurchaseList.productName,
                                            color: purchase_text_color,
                                            weight: FontWeight.w600,
                                            size: text_font_medium15_size,
                                            overflow: TextOverflow.ellipsis,
                                            softwrap: true,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: 'AED ' +
                                                giftpurchaseList.amountPaid
                                                    .toString() +
                                                ' Giftcard',
                                            color: date_text_color,
                                            size: text_font_size_small,
                                            weight: FontWeight.normal,
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      alignment: Alignment.topRight,
                                      margin:
                                          EdgeInsets.only(right: 10, top: 15),
                                      child: TextWidget(
                                        text: dateformate(
                                            giftpurchaseList.purchasedDate),
                                        color: date_text_color,
                                        weight: FontWeight.w400,
                                        size: text_font_size_x_small,
                                      ),
                                    )
                                  ],
                                ),
                                new SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      giftpurchaseList.transactionStatus ==
                                              "SUCCESS"
                                          ? Expanded(
                                              child: Container(
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     2.3,
                                                alignment: Alignment.bottomLeft,
                                                child: TextWidget(
                                                  text: giftpurchaseList
                                                              ?.transactionType !=
                                                          "RD"
                                                      ? "${giftpurchaseList.earnPoints ?? ""}" +
                                                          " GEMS Points has been credited"
                                                      : "${giftpurchaseList.pointsRedeemed ?? ""}" +
                                                          " GEMS Points redeemed",
                                                  size: 14,
                                                  color: appbar_color,
                                                  softwrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : giftpurchaseList
                                                      .transactionStatus ==
                                                  "PENDING"
                                              ? Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: TextWidget(
                                                      text: "${giftpurchaseList.earnPoints ?? ""}" +
                                                          " GEMS Points will be credited",
                                                      size: 11,
                                                      color: appbar_color,
                                                      softwrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      weight: FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                              : giftpurchaseList
                                                          .transactionStatus ==
                                                      "FAILED"
                                                  ? Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: TextWidget(
                                                          text:
                                                              "No GEMS Points credited due to cancellation",
                                                          size: 11,
                                                          color: appbar_color,
                                                          softwrap: true,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    ),
                                    ],
                                  ),
                                ),

                                // Container(
                                //   margin: EdgeInsets.only(left: 10, right: 10),
                                //   alignment: Alignment.centerLeft,
                                //   child: TextWidget(
                                //     text: 'Purchase Date: ' +
                                //         dateformate(
                                //             giftpurchaseList.purchasedDate),
                                //     color: date_text_color,
                                //     weight: FontWeight.w400,
                                //     size: text_font_size_x_small,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: TextWidget(
                                          text: 'Transaction ID -' +
                                              giftpurchaseList.transactionId,
                                          color: date_text_color,
                                          weight: FontWeight.w400,
                                          size: text_font_size_x_small,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _nodataFound() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 35, 15, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                ImageConstants.noResultFound,
                height: 160,
                width: 160,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: TextWidget(
                  text:
                      "Not yet purchased a Gift card?\n Click here to purchase.",
                  size: text_font_medium_size,
                  weight: FontWeight.w500,
                  alignment: TextAlign.center,
                )),
            new SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GradientButtonWidget(
                      height: 50,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contex) => GiftCardCategory(
                                    // tabIndex: 0,
                                    )));
                      },
                      color: appbar_color,
                      child: TextWidget(
                        text: "Purchase Gift Card",
                        size: text_font_medium15_size,
                        color: white_text_color,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      color: const Color(0xfff6f6f6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _noDataFound == false
              ? Expanded(
                  child: Container(
                  child: giftPurchaseList(),
                  //  giftPurchaseList(),
                ))
              : _nodataFound()
        ],
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
        centerTitle: true,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.only(top: 10),
          child: const TextWidget(
            text: 'Gift Cards',
            size: 22,
            // alignment: TextAlign.left,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                shape: BoxShape.rectangle,
                color: const Color(0xff3cabea)),
            child: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        flexibleSpace: Image.asset(
          ImageConstants.appbarbgimage,
          fit: BoxFit.fill,
        ));
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: GradientAppBar(
            title: AppTexts.giftCardsText,
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 100,
          ),
        ),
        body: _body(),
        bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }

  @override
  void gcPurchaseListErrorRes(Error error) {
    setState(() {
      _noDataFound = true;
      _isLoading = false;
    });
  }

  @override
  void gcPurchaseListSuccessRes(
      GiftCardPurchaseListModel giftCardPurchaseListModel) async {
    setState(() {
      _isLoading = false;
    });
    if (giftCardPurchaseListModel.status == true) {
      setState(() {
        _cardPurchaseListModel = giftCardPurchaseListModel;

        giftPurchaselistArray = _cardPurchaseListModel!.objects!;

        giftSortingByMonth();

        if (giftPurchaselistArray.length == 0) {
          _noDataFound = true;
        } else {
          _noDataFound = false;
        }
      });

      getgiftCardPurchaseDataFromDb().then((value) async {
        if (value.length < 1) {
          /* if nodata in db Insert puchase list data into database */
          return GiftCardPurchaseListDBHelper().save(
              GiftCardPurchaseListDbModel(
                  null, json.encode(giftCardPurchaseListModel.toJson())));
        }
      });
    } else {
      if (giftCardPurchaseListModel.message == "timeout") {
        _isLoading = false;
        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');
        if (notresponding != null) {
          setState(() {
            _isLoading = true;
          });
          _giftCardApiCall();
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _noDataFound = true;
          _isLoading = false;
        });
      }
    }
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = new DateFormat('dd MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}
