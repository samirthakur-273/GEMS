import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/hotel_module/hotel_guestdetials/full_policy.dart';
import 'package:gems_revamp/hotel_module/hotel_review/hotel_reviewpage.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/country_list/country_code_list.dart';
import 'package:gems_revamp/utils/country_list/country_list_db/countr_list_dbhelper.dart';
import 'package:gems_revamp/utils/country_list/country_list_model.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../family_and_friends/family_friends_master_list/master_list_model.dart';

class GuestDetailsPage extends StatefulWidget {
  final roomdata;

  const GuestDetailsPage({
    Key? key,
    this.roomdata,
  }) : super(key: key);
  @override
  _GuestDetailsState createState() => _GuestDetailsState();
}

class _GuestDetailsState extends State<GuestDetailsPage> {
  final ScrollController topcontroller = ScrollController();
  GlobalKey<ScaffoldState> _tabscaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _checkedValue = false,
      _checkTerms = false,
      _isstaying = false,
      _contactErr = false,
      _iscontactEmpty = false;

  var _countrydata;
  var countrydata;
  String nationality = 'IN';
  String? _countryImage = '';
  int? _numberLength;
  List mandatoryfee = List.empty(growable: true);
  int _totalmandatoryfee = 0;
  String _nationality = '971', _guestTitle = 'Mr';
  List _roomno = List.empty(growable: true);
  List _roomdetails = List.empty(growable: true);
  TextEditingController _contactNo = TextEditingController();
  TextEditingController _emailId = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _request = TextEditingController();
  TextEditingController _promoCode = TextEditingController();
  List<String> _title = ['Mr', 'Ms', 'Mrs'];
  int _selectedIndex = 0;
  var myfocus, _countryid = 0, _countrycode = '';
  double tabheigth = 150;
  bool _isemailvalid = true,
      _isfirstnameempty = false,
      _islastnamevalid = true,
      _islastnameempty = false,
      _isfirstnamevalid = true;
  FocusNode _contact = FocusNode();
  FocusNode _fname = FocusNode();
  FocusNode _lname = FocusNode();
  FocusNode _email = FocusNode();
  FocusNode specialreq = FocusNode();
  dynamic totalcost = 0, earnpoints = 0, redempoints = 0;

  List? countryCodeData = [];
  CountryListModel? _countryListModel;
  MasterListModel? _masterListModel;

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double _bottomsheetheight = 170.0;

  @override
  void initState() {
    super.initState();
    fetchMasterListData();

    // fetchcoutryList();

    _numberLength = GemsGLobals.mobilenumberlength != null
        ? GemsGLobals.mobilenumberlength
        : GemsGLobals.mobilenumber.length;
    _countryImage = GemsGLobals.countryImage;


    _countryid = GemsGLobals.countryid ?? 2;
    _countrycode = GemsGLobals.countryCode.toString();
    _nationality = GemsGLobals.countryCode.toString();
    for (int i = 0; i < this.widget.roomdata['rooms'].length; i++) {
      totalcost = totalcost +
          int.parse(this.widget.roomdata['rooms'][i]['cost'].toString());
      earnpoints =
          earnpoints + this.widget.roomdata['rooms'][i]['earnpoints'] ?? 0;

      redempoints =
          redempoints + this.widget.roomdata['rooms'][i]['redempoints'] ?? 0;
    }
    _getmandatoryFee();
    _isstaying = true;
    setPassengerDetails();
  }

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);

      countryCodeData = _masterListModel!.values!.countryList;

      
    });
  }

/* set mandatory fee */
  void _getmandatoryFee() {
    setState(() {
      for (int i = 0; i < this.widget.roomdata['rooms'].length; i++) {
        for (int j = 0;
            j < this.widget.roomdata['rooms'][i]['mandatory_fee'].length;
            j++) {
          mandatoryfee.add(
              this.widget.roomdata['rooms'][i]['mandatory_fee'][j]['amount']);

          _totalmandatoryfee += (double.tryParse(mandatoryfee[j])!.ceil());
        }
      }
      if (mandatoryfee.length > 0) {
        _bottomsheetheight += 10.0;
      }
    });
  }

  fetchcoutryList() {
    CountryListDbHelper().fetchMasterListData().then((value) {
      _countryListModel = countryListModelFromJson(value[0].countrylistdata);

      countryCodeData = _countryListModel!.data;

    });
  }

/* set room data */
  void _displayRoomData() {
    List? roomNos;
    List? roomIds;
    setState(() {
      _roomno = [];
      _roomdetails = [];
    });
    for (int i = 0; i < this.widget.roomdata['rooms'].length; i++) {
      setState(() {
        roomNos =
            this.widget.roomdata['rooms'][i]['roomno'].toString().split(',');
        roomIds =
            this.widget.roomdata['rooms'][i]['roomid'].toString().split(',');
      });

      List adult = [];
      List child = [];

      if (roomIds!.length == 1) {
        /* for single room */

        _roomno.add(this.widget.roomdata['rooms'][i]['roomno']);
        for (int j = 0;
            j < this.widget.roomdata['roomMember'][i]['adult_count'];
            j++) {
          adult.add({
            "title": _guestTitle,
            "first_name": _firstName.text,
            "last_name": _lastName.text,
            "age": '23',
            "is_lead_guest": j == 0 ? true : false
          });
        }
        if (this.widget.roomdata['roomMember'][i]['children'].length > 0) {
          for (int l = 0;
              l < this.widget.roomdata['roomMember'][i]['children'].length;
              l++) {
            child.add({
              "title": _guestTitle,
              "first_name": _firstName.text,
              "last_name": _lastName.text,
              "age": this.widget.roomdata['roomMember'][i]['children'][l]
                      ['age'] ??
                  '',
              "is_lead_guest": false
            });
          }
        }
        int totalguest =
            (this.widget.roomdata['roomMember'][i]['children'].length +
                this.widget.roomdata['roomMember'][i]['adult_count']);

        int adultCount = 0;
        int childCount = 0;
        for (int k = 0; k < totalguest; k++) {
          if (adultCount <
              this.widget.roomdata['roomMember'][i]['adult_count']) {
            if (childCount <
                this.widget.roomdata['roomMember'][i]['children'].length) {
              _roomdetails.add({
                "id": this.widget.roomdata['rooms'][i]['roomid'],
                "adults": [adult[k]],
                "children": [child[k]]
              });
              childCount++;
              adultCount++;
            } else {
              _roomdetails.add({
                "id": this.widget.roomdata['rooms'][i]['roomid'],
                "adults": adult.isEmpty ? [] : [adult[k]],
                "children": []
              });
              adultCount++;
            }
          } else if (childCount <
              this.widget.roomdata['roomMember'][i]['children'].length) {
            _roomdetails.add({
              "id": this.widget.roomdata['rooms'][i]['roomid'],
              "adults": [],
              "children": [child[k]]
            });
            childCount++;
          } else {
            break;
          }
        }
      } else {
        /* for multiple room  */

        for (int n = 0; n < roomIds!.length; n++) {
          _roomno.add(roomNos![n]);
          List adult = [];
          List child = [];
          for (int j = 0;
              j < this.widget.roomdata['roomMember'][n]['adult_count'];
              j++) {
            adult.add({
              "title": _guestTitle,
              "first_name": _firstName.text,
              "last_name": _lastName.text,
              "age": '23',
              "is_lead_guest": j == 0 ? true : false
            });
          }
          if (this.widget.roomdata['roomMember'][n]['children'].length > 0) {
            for (int l = 0;
                l < this.widget.roomdata['roomMember'][n]['children'].length;
                l++) {
              child.add({
                "title": _guestTitle,
                "first_name": _firstName.text,
                "last_name": _lastName.text,
                "age": this.widget.roomdata['roomMember'][n]['children'][l]
                        ['age'] ??
                    '',
                "is_lead_guest": false
              });
            }
          }
          _roomdetails
              .add({"id": roomIds![n], "adults": adult, "children": child});
        }
      }
    }
  }

  _extractMobileNo(mobileno, countrycode) {
    var countrycodelen = countrycode.toString().length;
    var contactno = mobileno.toString().substring(countrycodelen);
    return contactno;
  }

/* set passenger details */
  void setPassengerDetails() {
    setState(() {
      _emailId.text = GemsGLobals.useremail.toString() == 'null'
          ? ''
          : GemsGLobals.useremail.toString();
      _firstName.text = GemsGLobals.userFirstName.toString() == 'null'
          ? ''
          : GemsGLobals.userFirstName.toString();
      _lastName.text = GemsGLobals.userLastName.toString() == 'null'
          ? ''
          : GemsGLobals.userLastName.toString();

      _contactNo.text = GemsGLobals.mobilenumber.toString() == 'null'
          ? ''
          : GemsGLobals.mobilenumber;
      _nationality = GemsGLobals.countryCode == 'null'
          ? '971'
          : GemsGLobals.countryCode.toString();
      _numberLength = _contactNo.text.isNotEmpty
          ? _contactNo.text.length
          : GemsGLobals.mobilenumberlength;

      _countryid = GemsGLobals.countryid.toString() == 'null'
          ? GemsGLobals.countryid ?? 2
          : GemsGLobals.countryid;
      _countrycode = GemsGLobals.countryCode.toString() == 'null'
          ? GemsGLobals.countryCode.toString()
          : GemsGLobals.countryCode.toString();
      _countryImage = GemsGLobals.countryImage;

      validateEmail(_emailId.text);
      validateFirstname(_firstName.text);
      validateLastname(_lastName.text);
    });
  }

  void resetDetails() {
    setState(() {
      _emailId.text = '';
      _firstName.text = '';
      _lastName.text = '';
      _contactNo.text = '';
      _nationality = GemsGLobals.countryCode;
      // _numberLength = GemsGLobals.mobilenumberlength;

      _countryImage = GemsGLobals.countryImage;
      _countryid = GemsGLobals.countryid ?? 2;
      _countrycode = GemsGLobals.countryCode;
    });
  }

  void _internet() async {
    CheckInternet().apiCall().then((value) {
      if (value == true) {
        if (_checkedValue == true) {
          _checkTerms = false;
          _displayRoomData();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReviewHotels(
                      redeemrate: this.widget.roomdata['redeemrate'],
                      additionalInfo: this.widget.roomdata['policy'],
                      roomdata: this.widget.roomdata,
                      roomdetails: _roomdetails,
                      roomno: _roomno,
                      uniqueid: this.widget.roomdata['uniqueid'],
                      hotelname: this.widget.roomdata['hotelname'],
                      hoteladd: this.widget.roomdata['hoteladdress'],
                      checkin: this.widget.roomdata['checkindate'],
                      checkout: this.widget.roomdata['checkoutdate'],
                      roomtype: this.widget.roomdata['roomtype'],
                      email: _emailId.text,
                      phoneNumber: _contactNo.text,
                      nationality: _nationality.toString() == 'null'
                          ? '${GemsGLobals.countryCode.countryCode}'
                          : _nationality.toString(),
                      title: _guestTitle,
                      firstname: _firstName.text,
                      lastname: _lastName.text,
                      earnpoints: earnpoints,
                      redempoints: redempoints,
                      checkinTime: this.widget.roomdata['checkinTime'],
                      checkoutTime: this.widget.roomdata['checkoutTime'],
                      specialreq: _request.text,
                      cost: totalcost)));
        }
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
      }
    });
  }

/* contact validation */
  void validatecontact(value) {
    if (value.isEmpty) {
      setState(() {
        _iscontactEmpty = true;
        // _contactErr = true;
      });
    } else if (value.length < _numberLength || value.length > _numberLength) {
      setState(() {
        _contactErr = true;
      });
    } else {
      setState(() {
        _contactErr = false;
        _iscontactEmpty = false;
      });
    }
  }

/* email validation */
  void validateEmail(value) {
    bool emailregex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (value.isEmpty ||
        EmailValidator.validate(value, true, true) == false ||
        emailregex == false) {
      setState(() {
        _isemailvalid = false;
      });
    } else {
      setState(() {
        _isemailvalid = true;
      });
    }
  }

/* first name validation */
  void validateFirstname(value) {
    String pattern = '[a-zA-Z]{3,}';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      setState(() {
        _isfirstnameempty = true;
      });
    } else if (!regex.hasMatch(value)) {
      setState(() {
        _isfirstnamevalid = false;
      });
    } else {
      setState(() {
        _isfirstnameempty = false;
        _isfirstnamevalid = true;
      });
    }
  }

/* last name validation */
  void validateLastname(value) {
    String pattern = '[a-zA-Z]{3,}';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      setState(() {
        _islastnameempty = true;
      });
    } else if (!regex.hasMatch(value)) {
      setState(() {
        _islastnamevalid = false;
      });
    } else {
      setState(() {
        _islastnameempty = false;
        _islastnamevalid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Scaffold(
        key: _tabscaffoldKey,
        body: Column(
          children: <Widget>[
            Container(
              height: 5,
              decoration: BoxDecoration(gradient: gradient_theme_color),
            ),
            tabcontent(),
            _body(),
          ],
        ),
      ),
    );
  }

/* list of cancellation policy */
  List<Widget> getCancellationpolicy() {
    List<Widget> list = [];
    for (int i = 0; i < this.widget.roomdata['rooms'].length; i++) {
      Widget _cancellationPolicy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          this.widget.roomdata['rooms'].length != 1
              ? TextWidget(
                  text: "Room ${i + 1}",
                  size: text_font_medium14_size,
                  weight: FontWeight.w600,
                )
              : new Container(
                  height: 0.0,
                ),
          SizedBox(
            height: 4,
          ),
          this
                      .widget
                      .roomdata['rooms'][i]['cancelPolicyDate']
                      .cancellation
                      .length !=
                  0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: getpolicy(this
                      .widget
                      .roomdata['rooms'][i]['cancelPolicyDate']
                      .cancellation),
                )
              : TextWidget(
                  text:
                      "Details not available, please reach out to us at support@gemsrewards.com for more information.",
                  size: text_font_medium14_size,
                ),
          SizedBox(
            height: 4,
          ),
        ],
      );
      list.add(_cancellationPolicy);
    }
    return list;
  }

/* get policy */
  List<Widget> getpolicy(cancellation) {
    List<Widget> _policydate = [];
    for (int j = 0; j < cancellation.length; j++) {
      Widget policy = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.fiber_manual_record,
              size: 11,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.82,
            child: Wrap(
              children: <Widget>[
                TextWidget(
                  text:
                      "If cancelled from ${cancellation[j].fromDate.toString().substring(0, 10)} : ${cancellation[j].chargeCurrency ?? ''} ${cancellation[j].aedCharges ?? ''} Charge.",
                  size: text_font_medium14_size,
                  weight: FontWeight.normal,
                ),
              ],
            ),
          )
        ],
      );
      _policydate.add(policy);
    }
    return _policydate;
  }

  Widget _body() {
    try {
      return Expanded(
        child: Form(
            key: _formKey,
            child: NotificationListener(
              onNotification: (notificationInfo) {
                if (notificationInfo is ScrollStartNotification) {}
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 0),
                child: SingleChildScrollView(
                  controller: topcontroller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 1.0),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 1.0, 0.0, 12.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 1.0, 6.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                        text: 'Guest Contact Details',
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: grey200_color,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 6.0, 8.0, 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new GestureDetector(
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: black_color),
                                                  color: transColor),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SvgPicture.asset(
                                                  ImageConstants.select,
                                                  color: _isstaying
                                                      ? blue_color
                                                      : transColor,
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              _isstaying = !_isstaying;

                                              if (_isstaying == true) {
                                                // _checkTerms = true;
                                                setPassengerDetails();
                                              } else {
                                                // _checkTerms = false;
                                                resetDetails();
                                              }
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new TextWidget(
                                            text: "I am Staying",
                                            size: text_font_medium14_size,
                                            color: black_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 10.0, 6.0, 3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                        text: 'MOBILE NUMBER',
                                        size: text_font_medium14_size,
                                        color: grey600_color,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 1.0, 2.0, 8.0),
                                  child: getContactNo(),
                                ),
                                _iscontactEmpty || _contactErr
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            height: 20,
                                          ),
                                          new Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: new TextWidget(
                                              text: _iscontactEmpty
                                                  ? 'Please enter valid Mobile Number'
                                                  : 'Please enter $_numberLength digit Mobile\nNumber',
                                              alignment: TextAlign.left,
                                              size: 11.5,
                                              color: Colors.red[800],
                                            ),
                                          ),
                                        ],
                                      )
                                    : new Container(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 4.0, 6.0, 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                          text: 'E-MAIL ID',
                                          size: text_font_medium14_size,
                                          color: grey600_color),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0.0, 6.0, 8.0),
                                  child: getEmailId(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 10.0, 6.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                        text: 'Guest Details',
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 6.0, 6.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                          text: 'TITLE',
                                          size: text_font_medium14_size,
                                          color: grey600_color),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 3.0, 6.0, 8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        _customRadio(_title[0], 0),
                                        _customRadio(_title[1], 1),
                                        _customRadio(_title[2], 2),
                                      ],
                                    ),
                                  ),
                                ),
                                getName(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 10.0, 6.0, 1.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                        text: 'Special Request',
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 3.0, 4.0, 8.0),
                                  child: getSpecialRequest(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 10.0, 6.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new TextWidget(
                                        text: 'Cancellation policy',
                                        size: 16,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //     padding: const EdgeInsets.fromLTRB(
                                //         0, 1.0, 6.0, 8.0),
                                //     child: Column(
                                //       children: getCancellationpolicy(),
                                //     )),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 1.0, 6.0, 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  FullPolicyPage(
                                                      policy:
                                                          this.widget.roomdata[
                                                              'policy'])));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        this.widget.roomdata['policy'] != ''
                                            ? new TextWidget(
                                                text: 'Full Policy',
                                                size: text_font_medium14_size,
                                                color: blue_color,
                                                weight: FontWeight.w600,
                                              )
                                            : new Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 1.0, 6.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new GestureDetector(
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: black_color),
                                                  color: transColor),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SvgPicture.asset(
                                                  ImageConstants.select,
                                                  color: _checkedValue
                                                      ? blue_color
                                                      : transColor,
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              _checkedValue = !_checkedValue;

                                              if (_checkedValue != true) {
                                                _checkTerms = true;
                                              } else {
                                                _checkTerms = false;
                                              }
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _checkedValue =
                                                        !_checkedValue;

                                                    if (_checkedValue != true) {
                                                      _checkTerms = true;
                                                    } else {
                                                      _checkTerms = false;
                                                    }
                                                  });
                                                },
                                                child: TextWidget(
                                                    text: 'I agree with the ',
                                                    size: 13,
                                                    color: grey600_color),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ForYouWeb(
                                                              appbarname:
                                                                  "Terms and Conditions",
                                                              weburl:
                                                                  "https://www.gemsrewards.com/terms-and-conditions",
                                                            )),
                                                  );
                                                },
                                                child: new TextWidget(
                                                  text: 'terms and conditions',
                                                  size: 13,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color.fromRGBO(
                                                      45, 76, 179, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _checkTerms
                                    ? new Container(
                                        child: new TextWidget(
                                          text:
                                              '* You must agree with the Terms and Condition',
                                          color: Colors.red[800],
                                          size: text_font_size_x_small,
                                        ),
                                      )
                                    : new Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 8.0),
                        child: new GestureDetector(
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: blue_color.withOpacity(0.2),
                                //       offset: new Offset(0, 11),
                                //       blurRadius: 11,
                                //       spreadRadius: 0.0)
                                // ],
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: new TextWidget(
                                text: 'Submit',
                                color: Colors.white,
                                weight: FontWeight.w500,
                                size: text_font_medium18_size,
                              ),
                            ),
                          ),
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            if (_checkedValue != true) {
                              _checkTerms = true;
                            } else {
                              _checkTerms = false;
                            }
                            if (_contactNo.text.length == _numberLength) {
                              setState(() {
                                _contactErr = false;
                                _iscontactEmpty = false;
                              });
                            }
                            validatecontact(_contactNo.text);
                            validateEmail(_emailId.text);
                            validateFirstname(_firstName.text);
                            validateLastname(_lastName.text);

                            if (checkValidation() == true) {
                              _formKey.currentState!.save();

                              if (_contactNo.text.length == _numberLength) {
                                setState(() {
                                  _contactErr = false;
                                  _iscontactEmpty = false;
                                });      
                                _internet();
                              }
                            }
                          },
                        ),
                      ),
                      new SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            )),
      );
    } catch (e) {
      //print(e);
      return Container();
    }
  }

/* contact number widget */
  Widget getContactNo() {
    try {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 3.8,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: shadow_color),
            )),
            child: Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () async {
                      var _countrydata = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (cxt) => CountryCodeListPage(
                                    countryListData: countryCodeData,
                                  )));

                      setState(() {
                        countrydata = _countrydata;

                        nationality = countrydata.countryCode;

                        _numberLength = countrydata.mobileNumberLength;

                        GemsGLobals.mobilenumberlength = _numberLength;

                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.8,
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(1, 0.0, 3.0, 1.0),
                            child: SvgPicture.asset(
                              ImageConstants.downarrow,
                              height: 6,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          countrydata != null ||
                                  GemsGLobals.countryImage != null
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: grey_background,
                                    image: DecorationImage(
                                        image: countrydata != null
                                            ? NetworkImage(
                                                '${countrydata.image}')
                                            : NetworkImage(
                                                '${GemsGLobals.countryImage}'),
                                        fit: BoxFit.fill),
                                  ),
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: shadow_color),
                                ),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                              width: 50,
                              child: TextWidget(
                                text: countrydata != null
                                    ? "+${countrydata.countryCode}"
                                    : GemsGLobals.countryCode != null
                                        ? "+${GemsGLobals.countryCode}"
                                        : "",
                                size: 16,
                                weight: FontWeight.w500,
                              ))
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.7,
            child: new TextFormField(
                controller: _contactNo,
                focusNode: _contact,
                autofocus: false,
                keyboardType: TextInputType.phone,
                enableInteractiveSelection: false,
                maxLength: _numberLength ?? GemsGLobals.mobilenumberlength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // ignore: missing_return
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _iscontactEmpty = true;
                      // _contactErr = true;
                    });
                  } else if (value.length < _numberLength! ||
                      value.length > _numberLength!) {
                    setState(() {
                      _contactErr = true;
                      _iscontactEmpty = false;
                    });
                  } else {
                    _contactErr = false;
                    _iscontactEmpty = false;
                  }
                },
                // readOnly: true,
                onChanged: (value) async {
                  // if (value.length == _numberLength) {
                  validatecontact(value);
                  // _contact.unfocus();
                  // FocusScope.of(context).requestFocus(_email);
                  // }
                },
                onFieldSubmitted: (value) {
                  validatecontact(value);
                  // _contact.unfocus();
                  // FocusScope.of(context).requestFocus(_email);
                },
                cursorColor: black_color,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    width: 1.5,
                    color: _contactErr || _iscontactEmpty
                        ? Colors.red.shade800
                        : shadow_color,
                  )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1.5,
                          color: _contactErr || _iscontactEmpty
                              ? Colors.red.shade800
                              : shadow_color)),
                )),
          ),
        ],
      );
    } catch (e) {
     
      return Container();
    }
  }

/* Emailid widget */

  Widget getEmailId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.872,
          child: new TextFormField(
              controller: _emailId,
              autofocus: false,
              focusNode: _email,
              keyboardType: TextInputType.emailAddress,
              enableInteractiveSelection: false,
              cursorColor: black_color,
              // ignore: missing_return
              validator: (value) {
                bool emailregex = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value!);
                if (value.isEmpty ||
                    emailregex == false ||
                    EmailValidator.validate(value, true, true) == false) {
                  return 'Please enter valid email address';
                }
              },
              onChanged: (value) {
                validateEmail(value);
              },
              onFieldSubmitted: (value) {
                _email.unfocus();
                FocusScope.of(context).requestFocus(_fname);
              },
              decoration: InputDecoration(
                errorText: _isemailvalid == true
                    ? null
                    : 'Please enter valid email address',
                errorStyle:
                    TextStyle(color: Colors.red[800], fontFamily: "Poppins"),
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: shadow_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: shadow_color)),
              )),
        ),
      ],
    );
  }

/* guest title */
  Widget _customRadio(String txt, int index) {
    return new GestureDetector(
        onTap: () {
          changeIndex(index);
          setState(() {
            _guestTitle = txt;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 7,
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color:
                    _selectedIndex == index ? blue_color : Colors.grey.shade800,
              )),
          child: Center(
            child: TextWidget(
              text: '$txt.',
              size: 16,
              color: _selectedIndex == index ? blue_color : Colors.grey[800],
            ),
          ),
        ));
  }

/* first name , last name widget */
  Widget getName() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 6.0, 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new TextWidget(
                text: 'FIRST NAME',
                size: text_font_medium14_size,
                color: grey600_color,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0.0, 6.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.872,
                child: new TextFormField(
                    controller: _firstName,
                    autofocus: false,
                    focusNode: _fname,
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection: false,
                    cursorColor: black_color,
                    inputFormatters: [
                      new FilteringTextInputFormatter(
                          new RegExp('[a-zA-Z .,-_\']'),
                          allow: true),
                    ],
                    // ignore: missing_return
                    validator: (value) {
                      String pattern = '[a-zA-Z .,-_\']{3,}';
                      RegExp regex = new RegExp(pattern);
                      if (value!.isEmpty) {
                        return 'Please enter first name';
                      } else if (!regex.hasMatch(value)) {
                        return 'First name should have minimum 3 characters';
                      }
                    },
                    onChanged: (value) {
                      validateFirstname(value);
                    },
                    onFieldSubmitted: (value) {
                      _fname.unfocus();
                      FocusScope.of(context).requestFocus(_lname);
                    },
                    decoration: InputDecoration(
                      errorText: _isfirstnameempty == true
                          ? 'Please enter first name'
                          : _isfirstnamevalid == false
                              ? 'First name should have minimum 3 characters'
                              : null,
                      errorStyle: TextStyle(
                          color: Colors.red[800], fontFamily: "Poppins"),
                      counterText: "",
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: shadow_color,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: shadow_color)),
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.0, 6.0, 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                'LAST NAME',
                style: TextStyle(
                    fontSize: text_font_medium14_size, color: grey600_color),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0.0, 6.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.872,
                child: new TextFormField(
                    controller: _lastName,
                    autofocus: false,
                    focusNode: _lname,
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection: false,
                    cursorColor: black_color,
                    inputFormatters: [
                      new FilteringTextInputFormatter(
                          new RegExp('[a-zA-Z .,-_\']'),
                          allow: true),
                    ],
                    // ignore: missing_return
                    validator: (lastname) {
                      String pattern = '[a-zA-Z .,-_\']{3,}';
                      RegExp regex = new RegExp(pattern);
                      if (lastname!.isEmpty) {
                        return 'Please enter last name';
                      } else if (!regex.hasMatch(lastname)) {
                        return 'Last name should have minimum 3 characters';
                      }
                    },
                    onChanged: (value) {
                      validateLastname(value);
                    },
                    onFieldSubmitted: (value) {
                      _lname.unfocus();
                      FocusScope.of(context).requestFocus(specialreq);
                    },
                    decoration: InputDecoration(
                      errorText: _islastnameempty == true
                          ? 'Please enter last name'
                          : _islastnamevalid == false
                              ? 'Last name should have minimum 3 characters'
                              : null,
                      errorStyle: TextStyle(
                          color: Colors.red[800], fontFamily: "Poppins"),
                      counterText: "",
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: shadow_color,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: shadow_color)),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

/* special request widget */
  Widget getSpecialRequest() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.872,
          child: new TextFormField(
              controller: _request,
              autofocus: false,
              focusNode: specialreq,
              keyboardType: TextInputType.text,
              enableInteractiveSelection: false,
              cursorColor: black_color,
              onFieldSubmitted: (value) {
                specialreq.unfocus();
              },
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                hintText: '(Optional)',
                hintStyle: TextStyle(
                    color: grey600_color,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: shadow_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: shadow_color)),
              )),
        ),
      ],
    );
  }

/* Promo code widget */
  Widget getPromoCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: new TextFormField(
              controller: _promoCode,
              autofocus: true,
              keyboardType: TextInputType.text,
              enableInteractiveSelection: false,
              cursorColor: black_color,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                hintText: 'APPLY PROMO CODE',
                hintStyle: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: shadow_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: shadow_color)),
              )),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: shadow_color),
          )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 11),
            child: GestureDetector(
              child: new TextWidget(
                text: 'APPLY',
                color: blue_color,
                weight: FontWeight.w600,
                size: 17,
              ),
              onTap: () {},
            ),
          ),
        )
      ],
    );
  }

  Widget appBar() {
    return GradientAppBar(
      height: 80,
      centerTitle: true,
      title: 'Book Now',
      size: 19,
      weight: FontWeight.w600,
      onLeftTap: () async {
        Navigator.pop(context);
      },
    );
  }

/* hotel details */
  Widget tabcontent() {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      padding: const EdgeInsets.only(left: 20.0, bottom: 15, top: 40),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
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
                )),
                TextWidget(
                  text: "Book Now",
                  size: text_font_medium17_size,
                  weight: FontWeight.w600,
                  color: white_text_color,
                ),
                SizedBox(
                  width: 42,
                )
              ],
            ),
          ),
          new Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    new TextSpan(
                      text: this.widget.roomdata['hotelname'] + '\n',
                      style: new TextStyle(
                        color: white_text_color,
                        fontWeight: FontWeight.bold,
                        fontSize: text_font_medium18_size,
                      ),
                    ),
                    new WidgetSpan(
                        child: Container(
                      height: 8,
                    )),
                    new TextSpan(
                        text:
                            '${DateFormat("dd MMM, yyyy").format(this.widget.roomdata['checkindate']) + " - " + DateFormat("dd MMM, yyyy").format(this.widget.roomdata['checkoutdate'])} | ${this.widget.roomdata['roomtype']}',
                        style: TextStyle(
                            fontSize: text_font_medium14_size,
                            color: white_text_color)),
                    new WidgetSpan(
                        child: Container(
                      height: 8,
                    )),
                    new TextSpan(
                      text: '\nTotal Cost \t',
                      children: <TextSpan>[
                        new TextSpan(
                            text: this.widget.roomdata['mop'] == 'cash'
                                ? '\tAED ${pointsFormatter(totalcost)}'
                                : '\t${pointsFormatter(totalcost)} GEMS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: text_font_medium16_size,
                            )),
                      ],
                      style: TextStyle(
                          fontSize: text_font_medium15_size,
                          color: white_text_color),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return _fareBrkup();
                  });
            },
            child: Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.topLeft,
              child: TextWidget(
                  text: 'View Price Breakup',
                  decoration: TextDecoration.underline,
                  size: text_font_size_x_small,
                  color: white_text_color),
            ),
          )
        ],
      ),
    );
  }

/* Price breakup widget */
  Widget _fareBrkup() {
    return Container(
      height: Platform.isIOS
          ? (_bottomsheetheight * this.widget.roomdata['rooms'].length) + 5
          : (_bottomsheetheight * this.widget.roomdata['rooms'].length) + 1,
      color: white_text_color,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: TextWidget(
              text: "Price Breakup",
              size: text_font_medium17_size,
              color: black_color,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                  itemCount: this.widget.roomdata['rooms'].length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int pernight = this
                            .widget
                            .roomdata['rooms'][index]['pernight']
                            .toString()
                            .isNotEmpty
                        ? int.parse(this
                            .widget
                            .roomdata['rooms'][index]['pernight']
                            .toString())
                        : 0;
                    int noofnight = this
                            .widget
                            .roomdata['rooms'][index]['noofnight']
                            .toString()
                            .isNotEmpty
                        ? int.parse(this
                            .widget
                            .roomdata['rooms'][index]['noofnight']
                            .toString())
                        : 0;
                    int totalbaseprice = (pernight * noofnight);
                    int roomtax = this
                            .widget
                            .roomdata['rooms'][index]['roomtax']
                            .toString()
                            .isNotEmpty
                        ? int.parse(this
                            .widget
                            .roomdata['rooms'][index]['roomtax']
                            .toString())
                        : 0;
                    int totaltax = (roomtax * noofnight);
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextWidget(
                                text: "Base Price",
                                color: grey_gunsmoke_text_color,
                                size: text_font_medium14_size,
                              ),
                              TextWidget(
                                text: "AED ${pointsFormatter(totalbaseprice)}",
                                weight: FontWeight.bold,
                                color: black_color,
                                size: text_font_medium14_size,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextWidget(
                                text: "Taxes",
                                color: grey_gunsmoke_text_color,
                                size: text_font_medium14_size,
                              ),
                              TextWidget(
                                text: this.widget.roomdata['mop'] == 'cash'
                                    ? "AED ${this.widget.roomdata['rooms'][index]['roomtax'].toString().isNotEmpty ? pointsFormatter(int.parse(this.widget.roomdata['rooms'][index]['roomtax'].toString())) : ''}"
                                    : "AED ${pointsFormatter(totaltax)}",
                                weight: FontWeight.bold,
                                color: black_color,
                                size: text_font_medium14_size,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextWidget(
                                text: "Total",
                                color: grey_gunsmoke_text_color,
                                size: text_font_medium14_size,
                              ),
                              TextWidget(
                                text: this.widget.roomdata['mop'] == 'cash'
                                    ? "AED ${this.widget.roomdata['rooms'][index]['cost'].toString().isNotEmpty ? pointsFormatter(int.parse(this.widget.roomdata['rooms'][index]['cost'].toString())) : ''}"
                                    : "${this.widget.roomdata['rooms'][index]['cost'].toString().isNotEmpty ? pointsFormatter(int.parse(this.widget.roomdata['rooms'][index]['cost'].toString())) : ''} GEMS",
                                weight: FontWeight.bold,
                                color: black_color,
                                size: text_font_medium14_size,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          mandatoryfee.length > index
                              ? mandatoryfee[index] != null ||
                                      mandatoryfee[index] != []
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        TextWidget(
                                          text: "Pay at hotel",
                                          color:
                                              grey_color_300.withAlpha((0.6 * 255).toInt()),
                                          size: text_font_medium14_size,
                                        ),
                                        TextWidget(
                                          text: mandatoryfee != [] ||
                                                  mandatoryfee != null
                                              ? "AED ${pointsFormatter(double.tryParse(mandatoryfee[index])!.ceil())}"
                                              : "",
                                          weight: FontWeight.bold,
                                          color: black_color,
                                          size: text_font_medium14_size,
                                        ),
                                      ],
                                    )
                                  : new Container()
                              : new Container(),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          this.widget.roomdata['rooms'].length > 1
              ? Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          text: "Grand Total",
                          color: grey_color_300.withAlpha((0.6 * 255).toInt()),
                          size: text_font_medium14_size,
                          weight: FontWeight.bold,
                        ),
                        TextWidget(
                          text: this.widget.roomdata['mop'] == 'cash'
                              ? "AED ${pointsFormatter(totalcost)}"
                              : "${pointsFormatter(totalcost)} GEMS",
                          weight: FontWeight.bold,
                          color: black_color,
                          size: text_font_medium14_size,
                        ),
                      ],
                    ),
                    _totalmandatoryfee != 0
                        ? new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextWidget(
                                text: "Pay at hotel (Total)",
                                color: grey_color_300.withAlpha((0.6 * 255).toInt()),
                                size: text_font_medium14_size,
                                weight: FontWeight.bold,
                              ),
                              TextWidget(
                                text: _totalmandatoryfee != 0
                                    ? "AED ${pointsFormatter(_totalmandatoryfee)}"
                                    : "",
                                weight: FontWeight.bold,
                                color: black_color,
                                size: text_font_medium14_size,
                              ),
                            ],
                          )
                        : new Container(
                            height: 0.0,
                          ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                )
              : new Container(
                  height: 0.0,
                ),
        ],
      ),
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
                    text: "OK",
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

/* on button click validation */
  bool checkValidation() {
    if (_contactNo.text.length == _numberLength) {
      setState(() {
        _contactErr = false;
        _iscontactEmpty = false;
      });
    }

    if (_iscontactEmpty == true || _contactErr == true) {
      FocusScope.of(context).requestFocus(_contact);
      topcontroller.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else if (_isemailvalid == false || _emailId.text.isEmpty) {
      FocusScope.of(context).requestFocus(_email);
      topcontroller.animateTo(1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else if (_isfirstnameempty == true || _isfirstnamevalid == false) {
      FocusScope.of(context).requestFocus(_fname);
      topcontroller.animateTo(2,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else if (_islastnameempty == true || _islastnamevalid == false) {
      FocusScope.of(context).requestFocus(_lname);
    }
    if (_checkedValue != true) {
      _checkTerms = true;
      return false;
    } else {
      _checkTerms = false;
    }
    if (_iscontactEmpty == true ||
        _emailId.text.isEmpty ||
        _isfirstnameempty == true ||
        _islastnameempty == true) {
      showDialogMessage('Please fill guest details to continue your booking.');
    }
    if (_contactErr == false &&
        _iscontactEmpty == false &&
        _isemailvalid == true &&
        _isfirstnameempty == false &&
        _isfirstnamevalid == true &&
        _islastnamevalid == true &&
        _islastnameempty == false) {
      return true;
    } else {
      return false;
    }
  }
}
