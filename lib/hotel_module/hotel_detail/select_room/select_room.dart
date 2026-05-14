import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/font_style.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_guestdetials/hotel_guestdetailspage.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:page_view_indicators/circle_page_indicator.dart';

class HotelRoomTypePage extends StatefulWidget {
  final mop;
  final roomData;
  final hotelName;
  final checkindate;
  final checkoutdate;
  final checkinTime;
  final checkoutTime;
  final roomcount;
  final roomtype;
  final uniqueid;
  final cancelPolicy;
  final hotelAddress;
  final guestcount;
  final roomMember;
  final redeemrate;
  final countrycode;
  final star;

  const HotelRoomTypePage({
    Key? key,
    this.roomData,
    this.hotelName,
    this.checkindate,
    this.checkoutdate,
    this.roomtype,
    this.uniqueid,
    this.cancelPolicy,
    this.hotelAddress,
    this.guestcount,
    this.checkinTime,
    this.checkoutTime,
    this.roomcount,
    this.roomMember,
    this.mop,
    this.redeemrate,
    this.countrycode, this.star,
  }) : super(key: key);

  @override
  _HotelRoomTypePageState createState() => _HotelRoomTypePageState();
}

class _HotelRoomTypePageState extends State<HotelRoomTypePage>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: _appBar(),
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return PreferredSize(
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
                        margin: EdgeInsets.only(right: 30),
                        child: TextWidget(
                          text: "Select Room",
                          size: 18,
                          weight: FontWeight.w500,
                          color: white_text_color,
                        )),
                  )
                ],
              ),
            )));
    // return GradientAppBar(
    //   height: 90,
    //   centerTitle: true,
    //   title: 'Select Room',
    //   size: 18.5,
    //   weight: FontWeight.w600,
    // );
  }

  Widget _body() {
    return this.widget.roomData != null
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
                  alignment: Alignment.centerLeft,
                  child: TextWidget(
                    text: this.widget.hotelName,
                    weight: FontWeight.w600,
                    color: black_color,
                    size: 19,
                    textAlign: TextAlign.left,
                  ),
                ),
                TabBar(
                    isScrollable: true,
                    controller: tabController,
                    indicatorColor: Colors.transparent,
                    tabs: List.generate(
                        this.widget.roomData.length,
                        (index) => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration(
                                      gradient: tabController.index == index
                                          ? gradient_theme_color
                                          : gradient_white_color,
                                      border: tabController.index == index
                                          ? null
                                          : Border.all(color: grey_color_300),
                                      borderRadius: BorderRadius.circular(
                                        25.0,
                                      ),
                                      // boxShadow: tabController.index == index
                                      //     ? [
                                      //         BoxShadow(
                                      //             color: blue_color
                                      //                 .withOpacity(0.2),
                                      //             offset: new Offset(0, 11),
                                      //             blurRadius: 11,
                                      //             spreadRadius: 0.0)
                                      //       ]
                                      //     : [],
                                    ),
                                    child: TextWidget(
                                      text: this
                                          .widget
                                          .roomData[index]
                                          .roomTypes[0]
                                          .name,
                                      size: text_font_medium14_size,
                                      color: tabController.index == index
                                          ? white_text_color
                                          : black_color,
                                    ),
                                  )
                                ],
                              ),
                            ))),
                SizedBox(
                  height: 3,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 280,
                  padding: EdgeInsets.only(bottom: 10),
                    child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: List.generate(
                      this.widget.roomData.length,
                      (index) => TabBarViewPage(
                            this.widget.mop,
                            this.widget.roomData,
                            tabController,
                            this.widget.hotelName,
                            this.widget.roomtype,
                            this.widget.checkindate,
                            this.widget.checkoutdate,
                            this.widget.checkinTime,
                            this.widget.checkoutTime,
                            this.widget.roomcount,
                            this.widget.uniqueid,
                            this.widget.hotelAddress,
                            this.widget.guestcount,
                            () {
                              setState(() {
                                _count = AddRoom.rooms.length;
                              });
                            },
                            this.widget.roomMember,
                            this.widget.redeemrate,
                            this.widget.countrycode,
                            this.widget.star
                          )),
                )),
                _proceed(),
              ],
            ),
          )
        : Container(
            child: Center(
                child: TextWidget(
              text: "No Room Types are available",
              size: text_font_medium18_size,
            )),
          );
  }

/* Proceed button widget */
  Widget _proceed() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: white_text_color,
      padding: EdgeInsets.only(left: 20, right: 20,bottom: 20),
      child: GestureDetector(
        onTap: () {
          if (GemsGLobals.userType == "guest") {
            setState(() {
              showLoginAlert(context);
            });
          } else if (_count == 1) {
            var roomdata = {
              "hotelname": this.widget.hotelName,
              "roomtype": this.widget.roomtype,
              "checkindate": this.widget.checkindate,
              "checkoutdate": this.widget.checkoutdate,
              "uniqueid": this.widget.uniqueid,
              "hoteladdress": this.widget.hotelAddress,
              "guestcount": this.widget.guestcount,
              "checkinTime": this.widget.checkinTime,
              "checkoutTime": this.widget.checkoutTime,
              "mop": this.widget.mop,
              "rooms": AddRoom.rooms,
              "roomMember": this.widget.roomMember,
              "policy": FullPolicy._policy,
              "mandatory_fee": MandatoryFee.mandatoryfee,
              "redeemrate": this.widget.redeemrate
            };

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GuestDetailsPage(roomdata: roomdata)));
          }
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 2.7,
          decoration: BoxDecoration(
              gradient: (_count == 1)
                  ? gradient_theme_color
                  : LinearGradient(
                      colors: [grey_color_300, grey_color_300]),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextWidget(
                text: "Proceed",
                color: white_text_color,
                size: text_font_medium18_size,
                weight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(
        length: this.widget.roomData.length, vsync: this, initialIndex: 0);
    tabController.addListener(tabListener);
    AddRoom.rooms = [];
    SetRoomcount.count = 0;
    AddRoom.selectedid = [];
    CheckOccupancy._roomMemberData = List.empty(growable: true);
    CheckOccupancy.validroom = List.empty(growable: true);
    CheckOccupancy._roomMemberData = this.widget.roomMember;

    MandatoryFee.mandatoryfee = [];
    FullPolicy._policy = '';
    _selectedroom();
    CheckOccupancy()._setGuestcount();
  }

  void tabListener() {
    setState(() {});
  }

  void _selectedroom() {
    setState(() {
      _count = AddRoom.rooms.length;
    });
  }
}

/* Tabbar  */
class TabBarViewPage extends StatefulWidget {
  final mop;
  final TabController tabController;
  final List listRooms;
  final hotelname;
  final checkindate;
  final checkoutdate;
  final checkinTime;
  final checkoutTime;
  final roomcount;
  final roomtype;
  final uniqueid;
  final hotelAddress;
  final guestcount;
  final VoidCallback onSelected;
  final roomMember;
  final redeemrate;
  final countrycode;
  final star;
  TabBarViewPage(
      this.mop,
      this.listRooms,
      this.tabController,
      this.hotelname,
      this.roomtype,
      this.checkindate,
      this.checkoutdate,
      this.checkinTime,
      this.checkoutTime,
      this.roomcount,
      this.uniqueid,
      this.hotelAddress,
      this.guestcount,
      this.onSelected,
      this.roomMember,
      this.redeemrate,this.countrycode, this.star);

  @override
  _TabBarViewPageState createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage> {
  var roomdata;
  final _currentPageNotifier = ValueNotifier<int>(0);
  PageController _pageControlller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 12),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: widget
                    .listRooms[widget.tabController.index].roomTypes[0].name,
                weight: FontWeight.w600,
                size: text_font_medium15_size,
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              height: 200,
                child: PageView.builder(
                    controller: _pageControlller,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.listRooms[widget.tabController.index]
                                .thumbnails.length ==
                            0
                        ? 1
                        : widget.listRooms[widget.tabController.index]
                            .thumbnails.length,
                    itemBuilder: (contex, index) => Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 400,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: CachedNetworkImage(
                                imageUrl: widget
                                            .listRooms[
                                                widget.tabController.index]
                                            .thumbnails
                                            .length ==
                                        0
                                    ? ''
                                    : widget
                                        .listRooms[widget.tabController.index]
                                        .thumbnails[index],
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Image.asset(
                                  ImageConstants.noimages,
                                  fit: BoxFit.fill,
                                ),
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.fill,
                                  );
                                },
                              )),
                        ),
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CirclePageIndicator(
                dotColor: greyshades,
                selectedDotColor: blue_color,
                selectedSize: 6,
                size: 6,
                itemCount: widget.listRooms[widget.tabController.index]
                            .thumbnails.length ==
                        0
                    ? 1
                    : widget.listRooms[widget.tabController.index].thumbnails
                        .length,
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
            Container(
              // height: 470,
              child: RoomTypesList(
                context,
                widget.mop,
                widget.listRooms[widget.tabController.index].roomTypes,
                widget.hotelname,
                widget.roomtype,
                widget.checkindate,
                widget.checkoutdate,
                widget.checkinTime,
                widget.checkoutTime,
                widget.roomcount,
                widget.uniqueid,
                widget.listRooms,
                widget.hotelAddress,
                widget.guestcount,
                widget.onSelected,
                widget.roomMember,
                widget.redeemrate,
                widget.countrycode,
                widget.star
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}

/* Room types  */
class RoomTypesList extends StatelessWidget {
  var mop;
  List? listRoomType;
  List? selectedRoom = List.empty(growable: true);
  BuildContext context;
  List? finalLowestPriceRoomTypeList = List.empty(growable: true);
  bool? isbreakfast, isRefundable;
  var hotelname;
  var checkindate;
  var checkoutdate;
  var checkinTime;
  var checkoutTime;
  var roomcount;
  var roomtype;
  var uniqueid;
  List? listRooms;
  var hotelAddress;
  var guestcount;
  VoidCallback? onSelected;
  var roomMember;
  var star;
  var redeemrate;
  var countrycode;

  RoomTypesList(
      this.context,
      this.mop,
      this.listRoomType,
      this.hotelname,
      this.roomtype,
      this.checkindate,
      this.checkoutdate,
      this.checkinTime,
      this.checkoutTime,
      this.roomcount,
      this.uniqueid,
      this.listRooms,
      this.hotelAddress,
      this.guestcount,
      this.onSelected,
      this.roomMember,
      this.redeemrate,this.countrycode,this.star) {
    int n = listRoomType!.length;
    int i, j;

    for (i = 0; i < n; ++i) {
      for (i = 0; i < n; i++) {
        for (j = 0; j < i; j++) {
          if (listRoomType?[i].roomNo == listRoomType![j].roomNo) {}
        }
        if (i == j) finalLowestPriceRoomTypeList!.add(listRoomType![i]);
      }
    }
  }

  void showDialogRoomselection(String msg, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 120,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                TextWidget(text:msg,size: 13,
                        weight: FontWeight.bold,
                        color: Colors.grey[700]!,),
                Container(
                  margin: EdgeInsets.only(top: 22),
                  child: Row(
                  //  crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                        child: MaterialButton(
                          child: TextWidget(
                            text: "Yes",
                            alignment: TextAlign.center,
                                size: 12,
                                weight: FontWeight.bold
                          ),
                          onPressed: () {
                            if (AddRoom.selectedid.contains(data.id) != true) {
                              AddRoom.rooms = [];
                              SetRoomcount.count = 0;
                              AddRoom.selectedid = [];
                              CheckOccupancy._roomMemberData =
                                  List.empty(growable: true);
                              CheckOccupancy.validroom = List.empty(growable: true);

                              FullPolicy._policy = '';
                              this.onSelected!();
                              _selectRoom(data);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                        child: MaterialButton(
                          child: TextWidget(
                            text: "No",
                            alignment: TextAlign.center,
                                size: 12,
                                weight: FontWeight.bold
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDialogMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListView(
            shrinkWrap: true,
            children: [
              Text(msg),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  child: TextWidget(
                    text: "ok",
                    color: blue_color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
int index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      //   ListView.builder(
      // physics: NeverScrollableScrollPhysics(),
      //   itemCount: finalLowestPriceRoomTypeList?.length,
      //   itemBuilder: (context, index) =>
         child:   itemRoom(index, finalLowestPriceRoomTypeList!));
  }

/* select room  */
  void _selectRoom(data) {
    if (AddRoom.selectedid.contains(data.id) == true) {
      if (data.additionalInfo != '' || data.additionalInfo != null) {
        FullPolicy._policy = data.additionalInfo;
      }

      for (int i = 0; i < AddRoom.rooms.length; i++) {
        if (AddRoom.rooms[i]['roomid'] == data.id) {
          AddRoom().removeRoomdata(i);
          AddRoom().removeid(data.id);
          // check occupancy========
          CheckOccupancy()
              ._removeMemberData(data.occupancy.adult, data.occupancy.child);
        }
      }
      this.onSelected!();
    } else if (AddRoom.rooms.length < 1) {
      /* check occupancy of room */

      if (CheckOccupancy()._check(data.occupancy.adult, data.occupancy.child) ==
          true) {
        if (FullPolicy._policy == '') {
          FullPolicy._policy = data.additionalInfo;
        }

        AddRoom().selectRoom(
            data.name,
            data.roomNo,
            data.id,
            this.mop == 'cash'
                ? data.price.netRate.toString()
                : (data.price.bnzReddemPnts ?? 0),
            data.price.bnzAccrPnts,
            data.price.bnzReddemPnts,
            data.cancellationPolicy,
            data.price.roomTax,
            data.price.perNight,
            data.noOfNights,
            data.isRefundable,
            data.price.mandatoryFee);
        SetRoomcount().addcount();
        this.onSelected!();
        AddRoom().addid(data.id);
      } else {
        showDialogMessage('Select Room based on the number of members');
      }
    } else {
      showDialogRoomselection(
          'You have already selected one room type. Do you want to switch your preference?',
          data);
    }
  }

  

/* check if room is already selected */
  bool isselected(roomid, selectedid) {
    if (selectedid == roomid) {
      return true;
    } else {
      return false;
    }
  }

/* Rooms options */
  Widget itemRoom(index, List thelist) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 0),
          decoration: BoxDecoration(
            color: blue_color.withAlpha((0.1 * 255).toInt()),
            // index == 0
            //     ? Color.fromRGBO(255, 249, 235, 0.8)
            //     : Color.fromRGBO(244, 244, 244, 0.8),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: blue_color),
          ),
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      text: "Option : ${index + 1}",
                      size: text_font_medium17_size,
                      weight: FontWeight.w600,
                    ),
                    TextWidget(
                      text:
                          "${(thelist[index].isRefundable ? 'Refundable' : 'Non-refundable')}",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                TextWidget(
                  text:
                      "Occupancy : ${thelist[index].occupancy.adult} ${(int.parse(thelist[index].occupancy.adult.toString()) == 1 ? 'Adult' : 'Adults')} ${(int.parse(thelist[index].occupancy.child.toString()) == 0 ? '' : (thelist[index].occupancy.child))} ${(int.parse(thelist[index].occupancy.child.toString()) == 0 ? '' : int.parse(thelist[index].occupancy.child.toString()) == 1 ? 'Child' : 'Children')}",
                  size: text_font_medium15_size,
                  weight: FontWeight.normal,
                ),
                SizedBox(
                  height: 3,
                ),
                TextWidget(
                  text: "Room Plan",
                  size: text_font_medium15_size,
                  weight: FontWeight.w600,
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 50,
                    children: getAminitiesList(thelist[index].amenities),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextWidget(
                  text: "Cancellation Policy",
                  size: text_font_medium15_size,
                  // color: grey_color,
                  weight: FontWeight.w600,
                ),
                SizedBox(
                  height: 3,
                ),
              thelist[index].cancellationPolicy.isStatic
                    ? Container(
                        margin: EdgeInsets.all(20),
                        child: Html(
                          data: thelist[index].cancellationPolicy.cancelHtml ??
                              "",
                          style: {
                            "p": Style(
                                fontFamily: sans_font_family,
                                fontSize: FontSize.medium),
                            "li": Style(
                                fontFamily:sans_font_family,
                                fontSize: FontSize.medium),
                            "ul": Style(
                                fontFamily: sans_font_family,
                                fontSize: FontSize.medium),
                          },
                        ),
                      )
                    : thelist[index].cancellationPolicy.cancellation.length != 0
                        ? Container(
                            child: Column(
                              children: getCancellationpolicy(thelist[index]
                                  .cancellationPolicy
                                  .cancellation),
                            ),
                          )
                        : Container(
                            child: TextWidget(
                              text:GemsGLobals.hotelDetails
                                  ,
                              size: text_font_medium14_size,
                            ),
                          ),

                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 4),
                  child: Row(
                    children: <Widget>[
                      GemsGLobals.mop == 'cash'
                          ? TextWidget(
                              text:
                                  "AED ${pointsFormatter(int.parse(thelist[index].price.perNight.toString()))} per night",
                              size: text_font_medium15_size,
                              color: black_color,
                              softwrap: true,
                              weight: FontWeight.w600,
                            )
                          : TextWidget(
                              text:
                                  "${pointsFormatter(int.parse(thelist[index].price.bnzPrNigtReddemPnts.toString()))} GEMS per night",
                              size: text_font_medium15_size,
                              color: black_color,
                              softwrap: true,
                              weight: FontWeight.w600,
                            )
                    ],
                  ),
                ),
                this.mop == 'cash'
                    ? Container(
                        child: TextWidget(
                          text:
                              "Earn ${pointsFormatter(int.parse(thelist[index].price.bnzAccrPnts.toString()))} GEMS Points",
                          size: text_font_medium15_size,
                          weight: FontWeight.w600,
                          color: blue_color,
                        ),
                      )
                    : new Container(),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _selectRoom(thelist[index]);
          },
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AddRoom.selectedid.contains(thelist[index].id) == true
                  ? LinearGradient(colors: [grey_color_300, grey_color_300])
                  : gradient_theme_color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AddRoom.selectedid.contains(thelist[index].id) == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.check,
                          color: white_text_color,
                        ),
                      )
                    : SizedBox(),
                TextWidget(
                  size: text_font_medium18_size,
                  text: "Select Room",
                  color: white_text_color,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isSelectedRoomType(index) {
    if (finalLowestPriceRoomTypeList?[index].isBreakfast == isbreakfast &&
        finalLowestPriceRoomTypeList?[index].isRefundable == isRefundable) {
      return true;
    } else
      return false;
  }
}

/* List of amenities  */
List<Widget> getAminitiesList(aminitys) {
  List<Widget> list = [];
  for (int i = 0; i < aminitys.length; i++) {
    Widget amts = Row(
      children: <Widget>[
        SvgPicture.asset(
          ImageConstants.select,
          color: blue_color,
        ),
        SizedBox(
          width: 5,
        ),
        TextWidget(
          text: aminitys[i],
          size: text_font_medium15_size,
        )
      ],
    );
    list.add(amts);
  }
  return list;
}

/* cancellation policy  */
List<Widget> getCancellationpolicy(cancellation) {
  List<Widget> list = [];

  for (int i = 0;
      i < (cancellation.length < 0 ? 0 : cancellation.length);
      i++) {
    Widget amts = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.fiber_manual_record,
            size: 11,
            color: grey_color,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          width: 270,
          child: Wrap(
            children: <Widget>[
              TextWidget(
                text:
                    "If cancelled from ${cancellation[i]["from_date"].toString().substring(0, 10)} : ${cancellation[i]["charge_currency"] ?? ''} ${cancellation[i]["AED_charges"] ?? ''} Charge.",
                size: text_font_medium14_size,
                color: grey_color,
                weight: FontWeight.normal,
              ),
            ],
          ),
        )
      ],
    );
    list.add(amts);
  }
  return list;
}

String getInclusion(amenity) {
  String inclusiondata = '';
  for (int i = 0; i < amenity.length; i++) {
    if (i == 0) {
      inclusiondata = '${amenity[i]}';
    } else {
      inclusiondata = inclusiondata + ', ${amenity[i]}';
    }
  }

  return inclusiondata;
}

class AddRoom {
  static var rooms = [];
  static List selectedid = [];
  void selectRoom(
    roomname,
    roomno,
    roomid,
    cost,
    earnpoints,
    redemoints,
    cancelPolicyDate,
    roomTax,
    pernight,
    noofnight,
    isrefundable,
    mandatoryFee,
  ) {
    rooms.add({
      "roomName": roomname,
      "roomno": roomno,
      "roomid": roomid,
      "cost": cost,
      "earnpoints": earnpoints,
      "redempoints": redemoints,
      "cancelPolicyDate": cancelPolicyDate,
      "roomtax": roomTax,
      "pernight": pernight,
      "noofnight": noofnight,
      "is_refundable": isrefundable,
      "mandatory_fee": mandatoryFee != null ? mandatoryFee : []
    });
  }

  void addid(roomid) {
    selectedid.add(roomid);
  }

  void removeRoomdata(index) {
    rooms.removeAt(index);
  }

  void removeid(id) {
    selectedid.removeAt(selectedid.indexOf(id));
  }
}

class SetRoomcount {
  static int count = 0;
  void addcount() {
    count = AddRoom.rooms.length;
  }

  int getcount() {
    return count;
  }
}

class FullPolicy {
  static String _policy = '';
}

class MandatoryFee {
  static List mandatoryfee = [];

  void addMandatoryFee(value) {
    if (value != '') {
      mandatoryfee.add(value);
    } else {
      mandatoryfee.add('0');
    }
  }

  void removeMandatoryfee() {}
}

class CheckOccupancy {
  static List? _roomMemberData;
  static List? validroom;
  static var totaladult;
  static var totalchild;

  void _setGuestcount() {
    totaladult = 0;
    totalchild = 0;
    for (int i = 0; i < _roomMemberData!.length; i++) {
      totaladult = totaladult + _roomMemberData?[i]['adult_count'];
      totalchild = totalchild + (_roomMemberData?[i]['children'].length);
    }
  }

  bool _check(adultcount, childcount) {
    for (int i = 0; i < 1; i++) {
      if (validroom!.contains(i)) {
      } else {
        if (totaladult == int.parse(adultcount.toString()) &&
            totalchild == int.parse(childcount.toString())) {
          validroom!.add(i);

          return true;
        }
      }
    }

    return false;
  }

  void _removeMemberData(adultcount, childcount) {
    for (int i = 0; i < 1; i++) {
      if ((validroom!.contains(i)) == true &&
          totaladult == int.parse(adultcount.toString()) &&
          totalchild == int.parse(childcount.toString())) {
        validroom!.remove(i);

        break;
      }
    }
  }
}

Future<dynamic> showLoginAlert(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Container(
          margin: EdgeInsets.only(top: 25, left: 15, right: 15),
          height: 120,
          child: Column(
            children: <Widget>[
              Container(
                child: TextWidget(
                  text: "To continue ahead you need to login.",
                  size: text_font_size_small,
                  weight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              new SizedBox(
                height: 10,
              ),
              Container(
                child: TextWidget(
                  text: "Do you want to login?",
                  size: text_font_size_small,
                  weight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: blue_color,
                          ),
                          borderRadius: BorderRadius.circular(3)),
                      child: new TextButton(
                        child: TextWidget(
                          text: "No",
                          color: blue_color,
                          textAlign: TextAlign.center,
                          size: text_font_size_small,
                          weight: FontWeight.bold,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: blue_color,
                          ),
                          borderRadius: BorderRadius.circular(3)),
                      child: new TextButton(
                        child: TextWidget(
                          text: "Yes",
                          color: blue_color,
                          textAlign: TextAlign.center,
                          size: text_font_size_small,
                          weight: FontWeight.bold,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginHomePage()));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // actions: <Widget>[],
      );
    },
  );
}
