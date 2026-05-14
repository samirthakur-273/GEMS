import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/booking_slots/model/addwplticket_model.dart';
import 'package:gems_revamp/booking_slots/model/getwplticket_model.dart';
import 'package:gems_revamp/booking_slots/presenter/addWpl_presenter.dart';
import 'package:gems_revamp/booking_slots/presenter/getWpl_presenter.dart';
import 'package:gems_revamp/booking_slots/view/addWpl_view.dart';
import 'package:gems_revamp/booking_slots/view/getWpl_view.dart';
import 'package:gems_revamp/booking_slots/wpl_thankyou.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:intl/intl.dart';

import '../eshop_module_new/common_widget/text_widget.dart';
import '../offer_module/offer_webview.dart';

class BookingSlots extends StatefulWidget {
  final slotBanner;
  const BookingSlots({Key? key, this.slotBanner}) : super(key: key);

  @override
  State<BookingSlots> createState() => _BookingSlotsState();
}

class _BookingSlotsState extends State<BookingSlots>
    implements AddWplView, GetWplView {
  List<dynamic> bookingSlots = [
    {
      'section_name': 'World Padel League 2023',
      'section_image': ImageConstants.flight_purchase,
      'day': 'Thursday',
      'date': '08 June 2023'
    },
    {
      'section_name': 'Simply Red - Live',
      'section_image': ImageConstants.flight_purchase,
      'day': 'Friday',
      'date': '08 June 2023'
    },
    {
      'section_name': 'Nicky Remero - Live',
      'section_image': ImageConstants.flight_purchase,
      'day': 'Saturday',
      'date': '08 June 2023'
    },
    {
      'section_name': 'Mithun - Live',
      'section_image': ImageConstants.flight_purchase,
      'day': 'Sunday',
      'date': '08 June 2023'
    },
  ];

  AddWplPresenter? _addWplPresenter;
  GetWplPresenter? _getWplPresenter;
  List slotArray = [];
  bool _isLoading = false;
  var limitReached;
  var wplTicketstatus;
  var wpldate;
  var email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _addWplPresenter = AddWplPresenter(this);
    _getWplPresenter = GetWplPresenter(this);
    getWplApicall();
  }

  addWplApicall(date) {
    var req = {
      "membership_no": GemsGLobals.membershipNo.toString(),
      "wpl_date": date
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _addWplPresenter!.addWplTicket(req);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          _addWplPresenter!.addWplTicket(req);
        }
      }
    });
  }

  getWplApicall() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        setState(() {
          _getWplPresenter!.getWplTicket();
        });
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          _getWplPresenter!.getWplTicket();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _offerCards() {
      List<Widget> _offerList = [];
      for (int i = 0; i < slotArray.length; i++) {
        _offerList.add(Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 180,
                    width: 120,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.3, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: CachedNetworkImage(
                          imageUrl: slotArray[i].imgUrl.toString(),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            )),
                          ),
                          fadeInDuration: Duration(microseconds: 0),
                          placeholderFadeInDuration: Duration(microseconds: 0),
                          fadeOutDuration: Duration(microseconds: 0),
                          placeholder: (context, url) => Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 12, left: 2, right: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            child: TextWidget(
                              text:
                                  '${(slotArray[i].showSlotDate.toString())}', //bookingSlots[i]['date'] ?? '',
                              size: 12,
                              weight: FontWeight.w400,
                              color: atoz_color,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: 220,
                            child: TextWidget(
                              text: slotArray[i].slotName ?? '',
                              weight: FontWeight.w600,
                              size: text_font_medium14_size,
                            ),
                          ),
                          Container(
                            width: 220,
                            child: TextWidget(
                              text: slotArray[i].slotTime ?? '',
                              weight: FontWeight.w600,
                              size: text_font_medium14_size,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 180,
                            child: TextWidget(
                              text:
                                  '${(slotArray[i].description.toString())}', //bookingSlots[i]['date'] ?? '',
                              weight: FontWeight.w600,
                              size: text_font_medium14_size,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              String date =
                                  dateformatt(slotArray[i].slotDate.toString());
                              addWplApicall(date);
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: limitReached == true
                                    ? grey_color
                                    : atoz_color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(6),
                              child: TextWidget(
                                text: 'Book Ticket',
                                size: 12,
                                alignment: TextAlign.center,
                                // color: _resetData ? grey_background : text_color,
                                color: white_color,
                                weight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
      }
      return _offerList;
    }

    Widget _body() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 20),
        color: white_color,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 200,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Card(
                        color: Colors.transparent,
                        elevation: 0.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.fill,
                              );
                            },
                            imageUrl: widget
                                .slotBanner, //"${list[i]['bnr_image']}", //+ catimage,

                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              child: Image.asset(ImageConstants.noimages,
                                  fit: BoxFit.fill),
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: '  Booking Slots',
                  weight: FontWeight.bold,
                  size: text_font_medium18_size,
                  alignment: TextAlign.left,
                ),
                Column(
                  children: _offerCards(),
                ),
                TextWidget(text: 'By clicking on "Free Ticket" I agree to the terms and conditions'),
                TextWidget(text: 'Terms & Conditions:',weight: FontWeight.bold,),
                Row(
                  children: [
                    TextWidget(text: '1.  Every 1 booking will permit 1 adult and 1 child'),



                  ],
                ),
                Row(
                  children: [
                    TextWidget(text: '2. Limited tickets only per event day',),
                  ],
                )
,
                TextWidget(text: '3. Every GEMS student to be accompanied by one\n parent',),
                Row(
                  children: [
                    TextWidget(text: 'For more information visit ',),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForYouWeb(
                                appbarname: "Gems Rewards",
                                weburl:
                                "https://wplworld.com/",
                              )),
                        );
                      },
                      child: Text(
                        "https://wplworld.com/",
                        style: TextStyle(
                            fontSize: text_font_medium15_size,
                            color: blue_color,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,)


              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(

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
                    ),
                  ),
                  // GemsGLobals.userType == 'referral'
                  //     ? Container(
                  //         alignment: Alignment.center,
                  //         margin: EdgeInsets.only(right: 30),
                  //       )
                  //     :
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 30),
                        child: TextWidget(
                          text: "GEMS Rewards",
                          size: text_font_medium18_size,
                          weight: FontWeight.w500,
                          color: white_text_color,
                        )),
                  )
                ],
              ),
            )),
      ),
      backgroundColor: white_color,
      body: _isLoading == true ? SpinKitCircle(color: blue_color) : _body(),
    );
  }

  @override
  void addingWplView(AddWplModel addWplModel) {
    if (addWplModel.status == true) {

      setState(() {
        _isLoading = false;
        var date = addWplModel.values.showWplDate;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ThankYouWpl(wpldate: date, email: email)));
      });
    }
  }

  @override
  void allErr(error) {}

  @override
  void getWplView(GetWplModel getWplModel) {
    if (getWplModel.status == true) {
      setState(() {
        _isLoading = false;
        slotArray = getWplModel.values!.slotArray!;
        limitReached = getWplModel.values!.limitReached;
        wplTicketstatus = getWplModel.values!.wplTicketStatus;
        wpldate = getWplModel.values!.showWplDate;
        email = getWplModel.values!.email;
        if (wplTicketstatus == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ThankYouWpl(wpldate: wpldate, email: email)));
        }
      });
    }
  }
}

dateformatt(format) {
  var now = DateTime.parse(format);
  var formatter = new DateFormat("yyyy-MM-dd");
  var formated = formatter.format(now);

  return formated;
}
