// Author: Ashlesha Dhumal
// Description: Hotel Listing page

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/no_result_found.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/hotel_detail_design.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/database/database.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_model.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_view.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/sort_filter_hotel.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants_files/text_constants.dart';

class HotelList extends StatefulWidget {
  final country;
  final roomcount;
  final checkinDate;
  final checkoutDate;
  final roomType;
  final guestcount;
  final adultcount;
  final childage;
  final childcount;
  final destinationid;
  final destinationtype;
  final roomDetails;
  final mop;
  final serachtype;

  const HotelList(
      {Key? key,
      this.country,
      this.roomcount,
      this.checkinDate,
      this.checkoutDate,
      this.roomType,
      this.guestcount,
      this.adultcount,
      this.childage,
      this.childcount,
      this.destinationid,
      this.destinationtype,
      this.roomDetails,
      this.mop,
      this.serachtype})
      : super(key: key);

  @override
  _HotelListState createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> implements HotelListView {
  var _hotelcount;
  List roomDetails = List.empty(growable: true);
  var _hotelData;
  var _filtermenu;
  var startdate, enddate;
  var _rqid;
  var accrpoints;
  bool _isloading = true;
  HotelListPresenter? _hotelListPresenter;
  SortFilterPresenter? sortFilterPresenter;

  @override
  void initState() {
    super.initState();
    _hotelListPresenter = HotelListPresenter(this);
    sortFilterPresenter = SortFilterPresenter(this);


    _apicall();
  }

  /* Search api call */
  _apicall() {
    setState(() {
      roomDetails = this.widget.roomDetails;
      var room = [
        {"adult_count": 1, "children": []}
      ];
      if (roomDetails.isEmpty) {
        roomDetails = room;
      }
      var reqbody;

      if (this.widget.serachtype == 21) {
        reqbody = {
          "hotel_id": [this.widget.destinationid],
          "destination_id": this.widget.destinationid.toString(),
          "search_type": this.widget.serachtype,
          "nationality": "IN",
          "currency": "USD",
          "check_in_date":
              DateFormat("yyyy-MM-dd").format(this.widget.checkinDate),
          "check_out_date":
              DateFormat("yyyy-MM-dd").format(this.widget.checkoutDate),
          "language": "en",
          "mop": "${this.widget.mop}",
          "rooms": roomDetails
        };
      } else {
        reqbody = {
          "destination_id": this.widget.destinationid.toString(),
          "search_type": this.widget.serachtype,
          "nationality": "IN",
          "currency": "USD",
          "check_in_date":
              DateFormat("yyyy-MM-dd").format(this.widget.checkinDate),
          "check_out_date":
              DateFormat("yyyy-MM-dd").format(this.widget.checkoutDate),
          "language": "en",
          "mop": "${this.widget.mop}",
          "rooms": roomDetails
        };
      }

 Internetconnectivity().isConnected().then((result) async {
        if (result) {
          _hotelListPresenter!.hotellistdata(reqbody);
        } else {
          await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NoInternet()))
              .then((value) {
            _hotelListPresenter!.hotellistdata(reqbody);
          });
        }
      });
    });
  }

  /* Sort filter api call */
  _sortFilterapicall(req) {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        sortFilterPresenter!.sortFilterdata(req);
      } else {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NoInternet())).then((value) {
          sortFilterPresenter!.sortFilterdata(req);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
          top: false,
          bottom: true,
      child: Scaffold(
          body: _body(),
          bottomNavigationBar: _hotelcount != null
              ? Container(
                  height: MediaQuery.of(context).size.height / 14,
                  color: transColor,
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => SortFilter(
                                    rqid: _rqid,
                                    city: this.widget.country,
                                    checkin: DateFormat("dd MMM yyyy")
                                        .format(this.widget.checkinDate),
                                    checkout: DateFormat("dd MMM yyyy")
                                        .format(this.widget.checkoutDate),
                                    room: this.widget.roomType,
                                    filtermenu: _filtermenu,
                                  ))).then((req) {
                        setState(() {
                          _filtermenu = req;
                          if (_filtermenu['isEmpty'] == true &&
                              RefreshData.isEmpty == _filtermenu['isEmpty']) {
                            _isloading = false;
                          } else {
                            _isloading = true;
                            _sortFilterapicall(_filtermenu['filterreq']);
                          }
                          RefreshData.isEmpty = _filtermenu['isEmpty'];
                        });
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: white10_color,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              child: Center(
                                  child: Row(
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  ImageConstants.sorticon,
                                  color: black_color,
                                ),
                              ),
                              TextWidget(
                                text: AppTexts.sortText,
                                size: text_font_medium17_size,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ))),
                          Container(
                            width: 1,
                            height: 30,
                            color: grey_color.withAlpha((0.4 * 255).toInt()),
                          ),
                          Container(
                              child: Center(
                                  child: Row(
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(6),
                                child: SvgPicture.asset(
                                  ImageConstants.filtericon,
                                  height: 22,
                                ),
                              ),
                              TextWidget(
                                text: AppTexts.filterText,
                                size: text_font_medium17_size,
                                color: black_color,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ))),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 0,
                )),
    );
  }

  Widget _body() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            padding: EdgeInsets.fromLTRB(0, 35, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
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
                    )),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // width: MediaQuery.of(context).size.width - 90,
                          child: TextWidget(
                            text: this.widget.country.toString(),
                            color: white_text_color,
                            size: text_font_medium19_size,
                            weight: FontWeight.w500,
                            alignment: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          //  alignment: Alignment.center,
                          child: FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TextWidget(
                                  text: DateFormat("dd MMM yyyy")
                                          .format(this.widget.checkinDate) +
                                      " - " +
                                      DateFormat("dd MMM yyyy")
                                          .format(this.widget.checkoutDate) +
                                      " | ",
                                  color: white_text_color,
                                  size: 12,
                                ),
                                TextWidget(
                                  text: this.widget.roomType,
                                  color: white_text_color,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 6, 20, 10),
            child: TextWidget(
              text: _hotelcount != null
                  ? _hotelcount.toString() + " Properties available"
                  : "",
              size: text_font_medium14_size,
              weight: FontWeight.w500,
              color: grey_gunsmoke_text_color,
            ),
          ),
          _isloading == true
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: SpinKitCircle(
                    color: blue_color,
                  ))
              : Expanded(
                  child: _hotelData != null && _hotelData.length != 0
                      ? SingleChildScrollView(
                          child: Column(
                          children: _propertyListing(_hotelData),
                        ))
                      : NoResultFoundNew()
                  //  Container(
                  //     alignment: Alignment.center,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Image.asset(ImageConstants.notFoundimg),
                  //         SizedBox(
                  //           height: 30,
                  //         ),
                  //         TextWidget(
                  //           text: "Sorry! No result found:(",
                  //           size: text_font_large20_size,
                  //           weight: FontWeight.w500,
                  //           alignment: TextAlign.center,
                  //         ),
                  //         TextWidget(
                  //           text:
                  //               "We're sorry what you were looking for.\n Please try another way",
                  //           size: text_font_medium16_size,
                  //           alignment: TextAlign.center,
                  //           color: grey600_color,
                  //         ),
                  //         SizedBox(
                  //           height: 50,
                  //         ),
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(12),
                  //               gradient: const LinearGradient(
                  //                 begin: Alignment.topRight,
                  //                 end: Alignment.bottomLeft,
                  //                 colors: [
                  //                   bluishgradient,
                  //                   blue_color,
                  //                 ],
                  //               )),
                  //           width: MediaQuery.of(context).size.width / 2.2,
                  //           height: 50,
                  //           child: TextButton(
                  //             child: TextWidget(
                  //               text: "Try Again",
                  //               color: white_text_color,
                  //               size: 20,
                  //             ),
                  //             onPressed: () async {
                  //               Internetconnectivity()
                  //                   .isConnected()
                  //                   .then((result) {
                  //                 if (result) {
                  //                   Navigator.pop(context, "1");
                  //                 }
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // ),
                  )
        ]));
    // }
  }

/* ---- Hotels List ---  */
  Widget _propertyListData(hotelData, index) {
    _rqid = hotelData[index].rqid;
    accrpoints = hotelData[index].bnzAccrPnts.toString() == 'null'
        ? "0"
        : pointsFormatter(int.parse(hotelData[index].bnzAccrPnts.toString()));

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 7),
      child: GestureDetector(
          onTap: ()  {
            Map<String, dynamic> row = {
              "city": "${this.widget.country}",
              "destination_id": this.widget.destinationid,
              "destinationType": this.widget.destinationtype.toString(),
              "searchType": this.widget.serachtype,
              "searchText": this.widget.country.toString(),
              "searchId": _hotelData[index].sid,
              "checkindate":
                  '${DateFormat("yyyy-MM-dd").format(this.widget.checkinDate)}',
              "checkoutdate":
                  '${DateFormat("yyyy-MM-dd").format(this.widget.checkoutDate)}',
              "image": _hotelData[index].thumbnail != null
                  ? _hotelData[index].thumbnail
                  : ImageConstants.noimages,
              "guests": this.widget.guestcount,
              "adult": this.widget.adultcount,
              "child": this.widget.childcount,
              "rooms": this.widget.roomcount,
              "uniqueid": _hotelData[index].uniqueId,
              "hotelid": _hotelData[index].htlId,
              "mop": this.widget.mop
            };

            final dbHelper = DatabaseHelper.instance;
            dbHelper.insertHotelRecentSearch(row);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contex) => HoteldetailPage(
                          roomMember: roomDetails,
                          searchid: _hotelData[index].sid,
                          hotelid: _hotelData[index].htlId,
                          uniqueid: _hotelData[index].uniqueId,
                          checkindate: this.widget.checkinDate,
                          checkoutedate: this.widget.checkoutDate,
                          roomdata: this.widget.roomType,
                          roomcount: this.widget.roomcount,
                          mop: this.widget.mop,
                          hotellocation: hotelData[index].cityName,
                          hotelcountry: widget.country,
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            ),
                          ),
                      imageUrl: hotelData[index].thumbnail != null
                          ? hotelData[index].thumbnail
                          : "",
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          ),
                        );
                      }),
                ),
                height: 160,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GemsGLobals.usedGems == 'cash'
                        ? Container(
                            child: TextWidget(
                              text: "Earn upto $accrpoints GEMS Points",
                              size: text_font_size_small,
                              color: blue_color,
                              weight: FontWeight.normal,
                              softwrap: true,
                            ),
                          )
                        : Container(),
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width / 5,
                      alignment: Alignment.topRight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int i) {
                          int noofstar = hotelData[index].starRating ?? 0;
                          return i < noofstar
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: SvgPicture.asset(
                                    ImageConstants.unselect_Star,
                                    color: blue_color,
                                  ),
                                )
                              : SvgPicture.asset(
                                  ImageConstants.unselect_Star,
                                  color: grey_gunsmoke_text_color,
                                );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 2),
                child: TextWidget(
                  text: hotelData[index].htlName ?? "",
                  size: text_font_medium15_size,
                  color: purchase_text_color,
                  weight: FontWeight.w600,
                  softwrap: true,
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 2),
              //   child: TextWidget(
              //     text: hotelData[index]["room_left"],
              //     size: text_font_size_small,
              //     color: blue_color,
              //     softwrap: true,
              //   ),
              // ),
              GemsGLobals.usedGems == 'cash'
                  ? TextWidget(
                      text:
                          "AED ${pointsFormatter(hotelData[index].totalAmount)}" +
                              "${GemsGLobals.hotelPrice}",
                      size: text_font_medium14_size,
                      color: blackish,
                      softwrap: true,
                      weight: FontWeight.w400,
                    )
                  : TextWidget(
                      text:
                          "\t${pointsFormatter(hotelData[index].bnzReddemPnts)}" +
                              "${GemsGLobals.hotelReedemPoints}",
                      size: text_font_medium14_size,
                      color: blackish,
                      softwrap: true,
                      weight: FontWeight.w400,
                    ),
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 2),
                child: TextWidget(
                  text: hotelData[index].cityName,
                  size: text_font_medium14_size,
                  color: blackish,
                  softwrap: true,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

/* Add hotel data  */
  List<Widget> _propertyListing(_hotelData) {
    List<Widget> list = [];
    for (var i = 0; i < _hotelData.length; i++) {
      list.add(_propertyListData(_hotelData, i));
    }
    return list;
  }

  @override
  void hotellistData(HotelListModel response) async {
    setState(() {
      _isloading = false;
    });
    if (response.status == true) {
      setState(() {
        _isloading = false;
        _hotelData = response.values?.hotels;
        _hotelcount = response.values?.totalCnt ?? 0;
        Map<String, dynamic> row = {
              "city": "${this.widget.country}",
              "destination_id": this.widget.destinationid,
              "destinationType": this.widget.destinationtype.toString(),
              "searchType": this.widget.serachtype,
              "searchText": this.widget.country.toString(),
              "searchId": _hotelData[0].sid,
              "checkindate":
                  '${DateFormat("yyyy-MM-dd").format(this.widget.checkinDate)}',
              "checkoutdate":
                  '${DateFormat("yyyy-MM-dd").format(this.widget.checkoutDate)}',
              "image": _hotelData[0].thumbnail != null
                  ? _hotelData[0].thumbnail
                  : ImageConstants.noimages,
              "guests": this.widget.guestcount,
              "adult": this.widget.adultcount,
              "child": this.widget.childcount,
              "rooms": this.widget.roomcount,
              "uniqueid": _hotelData[0].uniqueId,
              "hotelid": _hotelData[0].htlId,
              "mop": this.widget.mop
            };

            final dbHelper = DatabaseHelper.instance;
            dbHelper.insertHotelRecentSearch(row);

      });
    } else {
      if (response.message == "timeout") {
        setState(() {
          _isloading = false;
        });
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));

        if (notresponding != null) {
          setState(() {
            _isloading = true;
          });
          _apicall();
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  void hotellistmError(error) {
    setState(() {
      _isloading = false;
    });

    // TODO: implement hotellistmError
  }
}

class RefreshData {
  static bool isEmpty = true;
}
