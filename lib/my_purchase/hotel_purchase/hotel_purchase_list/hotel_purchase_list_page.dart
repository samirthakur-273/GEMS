import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_db_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/hotel_purchase_details_page.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_view.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../common_widget/bottombar.dart';
import '../../../utils/constants_files/text_constants.dart';

class HotelPurchaseListPage extends StatefulWidget {
  const HotelPurchaseListPage({Key? key}) : super(key: key);

  @override
  _HotelPurchaseListPageState createState() => _HotelPurchaseListPageState();
}

class _HotelPurchaseListPageState extends State<HotelPurchaseListPage>
    with SingleTickerProviderStateMixin
    implements HotelPurchaseListView {
  TabController? _tabController;
  int? _index;

  bool _isupcomingSelected = true;
  bool _iscompletedSelected = false;
  bool _iscancelledSelected = false;
  var _hotelData;
  bool _isLoading = false;
  var _upcomingData = [];
  var _completedData = [];
  var _cancelledData = [];
  var _showData = [];

  @override
  void initState() {
    super.initState();
    _hotelPurchaseApiCall();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    // _tabController!.addListener(tablistner());
  }

  Future<List<HotelPurchaseListDbModel>> getHLTPurchaseListDataFromDb() {
    var data = HotelPurchaseListDBHelper().getHLTPurchaseListData();
    return data;
  }

  _hotelPurchaseApiCall() {
    getHLTPurchaseListDataFromDb().then((value) async {
      if (value.length > 0) {
        HotelPurchaseListPresenter(this)
            .hotelPurchaseListResApi(GemsGLobals.membershipNo);
      } else {
        Internetconnectivity().isConnected().then((result) async {
          if (result) {
            HotelPurchaseListPresenter(this)
                .hotelPurchaseListResApi(GemsGLobals.membershipNo);
          } else {
            var connectionResult = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NoInternet()));
            if (connectionResult != null) {
              _hotelPurchaseApiCall();
            } else {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  String? getHotelImageUrl(String? imagesJson) {
    if (imagesJson == null || imagesJson.isEmpty) return null;

    try {
      final decoded = jsonDecode(imagesJson);

      if (decoded is List && decoded.isNotEmpty) {
        if (decoded[0] is Map && decoded[0].containsKey('image_url')) {
          return decoded[0]['image_url'];
        }

        if (decoded[0].containsKey('image') &&
            decoded[0]['image'] is List &&
            decoded[0]['image'].isNotEmpty) {
          return decoded[0]['image'][0]['image_url'];
        }
      }
    } catch (e) {
      print('$e');
    }

    return null;
  }

  List<Widget> hotelList(hotelPurchaselistArray) {
    List<Widget> _hotelList = [];
    for (var i = 0; i < hotelPurchaselistArray.length; i++) {
      final item = hotelPurchaselistArray[i];
      String? imageUrl = getHotelImageUrl(hotelPurchaselistArray[i].htlImages);
      _hotelList.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
  child: hotelPurchaselistArray[i].htlImages == null ||
          hotelPurchaselistArray[i].htlImages.isEmpty
      ? SizedBox()
      : GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HotelPurchaseDetailsPage(
                          bookingBrfNo: hotelPurchaselistArray[i].htlBrfNo,
                          brf_no: hotelPurchaselistArray[i].htlTpcBrfNo,
                          country: hotelPurchaselistArray[i].htlName,
                          checkinDate: hotelPurchaselistArray[i].htlCheckinDate,
                          checkoutDate:
                              hotelPurchaselistArray[i].htlCheckoutDate,
                          type: "transactionList",
                        )));
          },
          child: Column(
            children: [
              Container(
                height: 160,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          ImageConstants.htl_placeholder,
                          fit: BoxFit.fill,
                        );
                      },
                      placeholder: ImageConstants.htl_placeholder,
                      image: imageUrl != null && imageUrl.isNotEmpty
                          ? imageUrl
                            : ImageConstants.htl_placeholder,
                      ))
              ),
              const SizedBox(
                height: 10,
              ),
              item != null
                  ? Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: TextWidget(
                  text: hotelPurchaselistArray[i].htlName,
                  size: text_font_medium15_size,
                  color: purchase_text_color,
                  weight: FontWeight.w500,
                ),
              )
            : SizedBox(),
              const SizedBox(
                height: 5,
              ),
              item != null
            ? Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: TextWidget(
                  text: hotelPurchaselistArray[i].htlAddres,
                  size: text_font_size_small,
                  color: date_text_color,
                  weight: FontWeight.w600,
                ),
              )
                  : SizedBox(),
              const SizedBox(
                height: 20,
              ),
              item != null
            ? Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const TextWidget(
                          text: "Check-In",
                          size: text_font_small,
                          color: date_text_color,
                          weight: FontWeight.w400,
                        ),
                        // Container(
                        //   height: 5,
                        // ),
                        TextWidget(
                          text: hotelPurchaselistArray[i].htlCheckinDate,
                          size: text_font_medium15_size,
                          weight: FontWeight.w600,
                          color: purchase_text_color,
                        ),
                        TextWidget(
                          text: hotelPurchaselistArray[i].htlCheckinTime ??"",
                          size: text_font_small,
                          color: date_text_color,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                    if (hotelPurchaselistArray[i]?.noOfNights != null)
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black),
                        child: Center(
                          child: TextWidget(
                            text: hotelPurchaselistArray[i]
                                        .noOfNights
                                        .toString() ==
                                    "1"
                                ? hotelPurchaselistArray[i].noOfNights +
                                    ' night'
                                : hotelPurchaselistArray[i].noOfNights +
                                    ' nights',
                            size: text_font_size_x_small,
                            color: white_text_color,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const TextWidget(
                          text: "Check-Out",
                          size: text_font_small,
                          color: date_text_color,
                          weight: FontWeight.w400,
                        ),
                        // Container(
                        //   height: 5,
                        // ),
                        TextWidget(
                          text: hotelPurchaselistArray[i].htlCheckoutDate ?? "",
                          size: text_font_medium15_size,
                          weight: FontWeight.w600,
                          color: purchase_text_color,
                        ),
                        TextWidget(
                          text: hotelPurchaselistArray[i].htlCheckoutTime ??
                              "",
                          size: text_font_small,
                          color: date_text_color,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
                    )
                  : SizedBox(),
              const SizedBox(
                height: 10,
              ),
              item != null
            ? Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                width: MediaQuery.of(context).size.width,
                child: TextWidget(
                  text:
                      '${hotelPurchaselistArray[i].htlRoomType}  x ${1}    Guest x ${hotelPurchaselistArray[i].htlGstCount}',
                  color: date_text_color,
                  size: text_font_small,
                  weight: FontWeight.w400,
                  softwrap: true,
                  maxLines: 2,
                ),
              )
            : SizedBox(),
              const SizedBox(
                height: 10,
              ),
                item != null
              ? _iscompletedSelected == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      alignment: Alignment.bottomLeft,
                      child: TextWidget(
                        text: hotelPurchaselistArray[i].htlTransactionType !=
                                "RD"
                            ? "${pointsFormatter(int.parse(hotelPurchaselistArray[i].bnzAccrPnts ?? "0"))}" +
                                " GEMS Points earned"
                            : "${pointsFormatter(hotelPurchaselistArray[i].htlTotalAmt ?? 0)}" +
                                " GEMS Points has been redeemed",
                        size: text_font_medium14_size,
                        color: appbar_color,
                        softwrap: true,
                        maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        weight: FontWeight.w600,
                      ),
                    )
                  : _isupcomingSelected == true
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          alignment: Alignment.bottomLeft,
                          child: TextWidget(
                            text: hotelPurchaselistArray[i]
                                        .htlTransactionType !=
                                    "RD"
                                ? "${pointsFormatter(int.parse(hotelPurchaselistArray[i].bnzAccrPnts ?? "0"))}" +
                                    " GEMS Points will be credited"
                                : "${pointsFormatter(hotelPurchaselistArray[i].htlTotalAmt ?? 0)}" +
                                    " GEMS redeemed",
                            size: text_font_medium14_size,
                            color: appbar_color,
                            softwrap: true,
                            maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                            weight: FontWeight.w600,
                          ),
                        )
                      : Container(
                          height: 0,
                        )
                  : SizedBox(),
              const SizedBox(
                height: 5,
              ),
        item != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: TextWidget(
                        text: 'Transaction ID -' +
                            hotelPurchaselistArray[i].htlTpcBrfNo,
                        color: date_text_color,
                        weight: FontWeight.w400,
                        size: text_font_medium14_size,
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ));
    }
    return _hotelList;
  }

  Widget _hotelListingWidget(hotelPurchaselistArray) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: hotelList(hotelPurchaselistArray),
      ),
    );
  }

  Widget _hotelStatusWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 55,
      width: MediaQuery.of(context).size.width / 1,
      decoration: BoxDecoration(
          color: white_text_color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 1, color: Colors.grey.shade300)),
      child: FittedBox(
        child: Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = true;
                    _iscompletedSelected = false;
                    _iscancelledSelected = false;
                    _showData = _upcomingData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _isupcomingSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Upcoming",
                      size: text_font_medium15_size,
                      color: _isupcomingSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _isupcomingSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = false;
                    _iscompletedSelected = true;
                    _iscancelledSelected = false;
                    _showData = _completedData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _iscompletedSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Completed",
                      size: text_font_medium15_size,
                      color: _iscompletedSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _iscompletedSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = false;
                    _iscompletedSelected = false;
                    _iscancelledSelected = true;
                    _showData = _cancelledData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _iscancelledSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Cancelled",
                      size: text_font_medium15_size,
                      color: _iscancelledSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _iscancelledSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                      "Not yet booked a hotel?\n Click here to book your stay.",
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
                                builder: (contex) => HotelHomePage(
                                    // tabIndex: 0,
                                    )));
                      },
                      color: appbar_color,
                      child: TextWidget(
                        text: "Book a Hotel",
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
      color: const Color(0xffF6F6F6),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _hotelStatusWidget(),
          const SizedBox(
            height: 10,
          ),

          _showData.length != 0
              ? _hotelListingWidget(_showData)
              : _nodataFound()
          // _hotelListingWidget(hotelPurchaselistArray),
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
            text: 'Hotels',
            size: 22,
            // alignment: TextAlign.left,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
          fit: BoxFit.cover,
        ));
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
    return Container(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: GradientAppBar(
              title: AppTexts.hotelsText,
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 100,
            ),
          ),
          body: _body(),
          bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
        ),
      ),
    );
  }

  @override
  void hltPurchaseListErrorRes(Error error) {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void hltPurchaseListSuccessRes(
      HotelPurchaseListModel hotelPurchaseListModel) async {
    setState(() {
      _isLoading = false;
    });
    if (hotelPurchaseListModel.status == true) {
      setState(() {
        _hotelData = hotelPurchaseListModel.values;

        for (var i = 0; i < _hotelData.length; i++) {
          if (_hotelData[i].htlBookStatus == 1) {
            _upcomingData.add(_hotelData[i]);
          } else if (_hotelData[i].htlBookStatus == 2) {
            _completedData.add(_hotelData[i]);
          } else if (_hotelData[i].htlBookStatus == 6) {
            _cancelledData.add(_hotelData[i]);
          } else {}
        }
        _showData = _upcomingData;
        getHLTPurchaseListDataFromDb().then((value) async {
          if (value.length < 1) {
            return HotelPurchaseListDBHelper().save(HotelPurchaseListDbModel(
                null, json.encode(hotelPurchaseListModel.toJson())));
          }
        });
      });
    } else {
      _showData = [];

      if (hotelPurchaseListModel.message == "timeout") {
        _isLoading = true;
        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');
        if (notresponding != null) {
          _hotelPurchaseApiCall();
        } else {
          Navigator.pop(context);
        }
      } else {
        _showData = [];
      }
    }
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = DateFormat('dd MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}

timeformate(format) {
  DateTime now = DateTime.parse(format);
  String formattedDate = DateFormat('hh:mm a').format(now);

  return formattedDate;
}
