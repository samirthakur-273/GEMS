import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/address/address_model.dart';
import 'package:gems_revamp/eshop_module_new/address/address_presenter.dart';
import 'package:gems_revamp/eshop_module_new/address/address_view.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/cityAreaList.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/city_or_area.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_model.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_presenter.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_view.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress extends StatefulWidget {
  final String? address;
  final streestaddress;
  final city;
  final area;
  final countyCode;
  final ScrollController? controller;
  CartDetailsModel? cartDetailsModel;
  final route;
  ShippingAddress(
      {Key? key,
      this.address,
      this.streestaddress,
      this.city,
      this.area,
      this.countyCode,
      this.cartDetailsModel,
      this.route,
      this.controller})
      : super(key: key);
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress>
    implements ShppingAddressView, CustomerAddressView {
  List<DropdownMenuItem<CarrierCode>>? _carrieDropDown;
  CarrierCode? _selectedCarrier;
  List<CarrierCode> _carrierItems = [];

  CityModel? cityresponse;
  AreaModel? arearesponse;
  String cityvalue = "";
  String areavalue = "";
  int defaultaddress = 0;
  bool arealoader = false;
  bool _autovalidate = false;
  List _cityList = [];
  List? _areaList = [];
  var prefs;
  var lang;
  var countryData;
  bool readOnly = false;

  void initState() {
   

    super.initState();
    if (GemsGLobals.userFirstName != null)
      _firstnameController.text = GemsGLobals.userFirstName ?? "";
    if (GemsGLobals.userLastName != null)
      _lastnameController.text = GemsGLobals.userLastName ?? "";
    (GemsGLobals.countryCode != null)
        ? _countryController.text = ("+" + GemsGLobals.countryCode)
        : GemsGLobals.countryCode ?? "";
    if (GemsGLobals.mobilenumber != null)
      _mobileController.text = GemsGLobals.mobilenumber ?? "";
    if (GemsGLobals.useremail != null)
      _emailController.text = GemsGLobals.useremail;
    _cityList = cityAreaList.keys.toList();

    // _areaController.text = widget.area ?? "";
    // _cityController.text = widget.city ?? "";
    _addressController.text = widget.address!
        .replaceAll(RegExp("[\u0621-\u064A\u0660-\u0669\]"), "")
        .replaceAll("-", "")
        .replaceAll(",", "")
        .replaceAll("United Arab Emirates", "")
        .replaceAll("Dubai", "");
    addListners();
    userLoginCheck();
    initLang();
  }

  userLoginCheck() async {
    var prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString("Useremail") ?? '';
  }

  void initLang() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      setState(() {
        lang = "en";
      });
    } else if (prefs.getString('language_code') == 'ar') {
      setState(() {
        lang = "ar";
      });
    } else {
      setState(() {
        lang = "en";
      });
    }
  }

  addListners() {
    if (_autovalidate) {
      _lastnameController.addListener(() => _lastName(refresh: true));
      _firstnameController.addListener(() => _firstName(refresh: true));
      _emailController.addListener(() => _email(refresh: true));
      _addressController.addListener(() => _address(refresh: true));
      _streetaddressController.addListener(() => _streetaddrss(refresh: true));
      //_housenoController.addListener(() => _houseno(refresh: true));
      _mobileController.addListener(() => _mobileno(refresh: true));
      _cityController.addListener(() => _city(refresh: true));
      _areaController.addListener(() => _area(refresh: true));
      _countryController.addListener(() => _countryCode(refresh: true));
    }
  }

  void _firstName({bool? refresh}) {
    if (_firstnameController.text.isEmpty) {
      _isfirstnameErr = true;
      _firstNameErrmsg = "Please enter first name";
    } else if (_firstnameController.text.length <= 1) {
      _isfirstnameErr = true;
      _firstNameErrmsg = "firstname_min";
    } else {
      String _number = r'^(?=.*[0-9])';
      String _symbols = r"^(?=.*[$&+,:;=?@#|'<>.^*()%!-])";
      if (RegExp(_number).hasMatch(_firstnameController.text) ||
          RegExp(_symbols).hasMatch(_firstnameController.text)) {
        _isfirstnameErr = true;
        _firstNameErrmsg = 'Please enter valid first name';
      } else {
        _isfirstnameErr = false;
        _firstNameErrmsg = "";
      }
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _lastName({bool? refresh}) {
    if (_lastnameController.text.isEmpty) {
      _islastnameErr = true;
      _lastNameErrmsg = "Please enter last name";
    } else if (_lastnameController.text.length <= 1) {
      _islastnameErr = true;
      _lastNameErrmsg = "lastname_min";
    } else {
      String _number = r'^(?=.*[0-9])';
      String _symbols = r"^(?=.*[$&+,:;=?@#|'<>.^*()%!-])";
      if (RegExp(_number).hasMatch(_lastnameController.text) ||
          RegExp(_symbols).hasMatch(_lastnameController.text)) {
        setState(() {
          _islastnameErr = true;
          _lastNameErrmsg = 'Please enter valid last name';
        });
      } else {
        _islastnameErr = false;
        _lastNameErrmsg = "";
      }
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _email({bool? refresh}) {
    if (_emailController.text.isEmpty) {
      _isEmailErr = true;
      _emailErrmsg = "Please enter an email";
    } else if (_emailController.text.length < 2 ||
        _emailController.text.length > 50) {
      _isEmailErr = true;
      _emailErrmsg = "Please enter a valid email";
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailController.text);
      if (emailValid == true) {
        _isEmailErr = false;
        _emailErrmsg = "";
      } else {
        _isEmailErr = true;
        _emailErrmsg = "email_valid";
      }
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _address({bool? refresh}) {
    if (_addressController.text.isEmpty) {
      _isAddressErr = true;
      _addressErrmsg = "Please enter address";
    } else if (_addressController.text.length <= 1) {
      _isAddressErr = true;
      _addressErrmsg = "Please enter valid address";
    } else {
      _isAddressErr = false;
      _addressErrmsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _city({bool? refresh}) {
    if (_cityController.text.isEmpty) {
      _isCityErr = true;
      _cityErrmsg = "Please select city";
    } else {
      _isCityErr = false;
      _cityErrmsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _area({bool? refresh}) {
    if (_areaController.text.isEmpty) {
      _areaErr = true;
      _areaErrmsg = "Please select area";
    } else {
      _areaErr = false;
      _areaErrmsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _streetaddrss({bool? refresh}) {
    if (_streetaddressController.text.isEmpty) {
      _isstreetaddressErr = true;
      _streetAddressErrmsg = "Please enter house no.";
    } else if (_streetaddressController.text.length <= 1) {
      _isstreetaddressErr = true;
      _streetAddressErrmsg = "Please enter house no.";
    } else {
      _isstreetaddressErr = false;
      _streetAddressErrmsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  // void _houseno({bool refresh}) {
  //   if (_housenoController.text.isEmpty) {
  //     _isHouseNoErr = true;
  //     _houseErrmsg = "houseno_blank";
  //   } else if (_housenoController.text.length <= 1) {
  //     _isHouseNoErr = true;
  //     _houseErrmsg = "houseno_min";
  //   } else {
  //     _isHouseNoErr = false;
  //     _houseErrmsg = "";
  //   }
  //   if (refresh ?? false) {
  //     setState(() {});
  //   }
  // }

  void _mobileno({bool? refresh}) {
    int? len = 9;
    // countryData != null
    //     ? countryData?.mobileNumberLength
    //     : _countryController.text.length == 2
    //         ? 10
    //         : _countryController.text.length == 3
    //             ? 9
    //             : _countryController.text.length == 1
    //                 ? 11
    //                 : 12;
    if (_countryController.text.length != 0) {
      if (_mobileController.text.isEmpty) {
        _isNumberErr = true;
        _mobileErrmsg = "Please enter mobile number";
      } else if (_mobileController.text.length < (len) ||
          _mobileController.text.length > len) {
        _isNumberErr = true;
        _mobileErrmsg = "Max length is $len";
      } else {
        _isNumberErr = false;
        _mobileErrmsg = "";
      }
      setState(() {});
      if (refresh ?? false) {
        setState(() {});
      }
    }
  }

  void _countryCode({bool? refresh}) {
    if (_countryController.text.isEmpty) {
      _isCountryCodeErr = true;
      _countryErrMsg = "Please Enter Country Code";
    } else {
      _isCountryCodeErr = false;
      _countryErrMsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  bool _isfirstnameErr = false;
  bool _islastnameErr = false;
  bool _isEmailErr = false;
  bool _isstreetaddressErr = false;
  bool _isCountryCodeErr = false;
  bool _isAddressErr = false;
  bool _isHouseNoErr = false;
  bool _isNumberErr = false;
  bool _isCityErr = false;
  bool _areaErr = false;
  var _firstNameErrmsg;
  var _lastNameErrmsg;
  var _countryErrMsg;
  var _emailErrmsg;
  var _addressErrmsg;
  var _streetAddressErrmsg;
  var _houseErrmsg;
  var _mobileErrmsg;
  var _cityErrmsg;
  var _areaErrmsg;
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _streetaddressController = TextEditingController();
  final _housenoController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _countryController = TextEditingController();

  List<DropdownMenuItem<CarrierCode>> buildDropDownMenuItems(
      List<CarrierCode> listItems) {
    List<DropdownMenuItem<CarrierCode>> items =
        <DropdownMenuItem<CarrierCode>>[];
    for (CarrierCode listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.code ?? ''),
          value: listItem,
        ),
      );
    }
    return items;
  }

  bool switches = true;
  String? switchvalue;
  @override
  Widget build(BuildContext context) {
    Widget _commonHeader(String title) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          children: [
            TextWidget(
              text: title,
              color: grey_gunsmoke_text_color,
              size: text_font_small,
            ),
            SizedBox(
              width: 5,
            ),
            // TextWidget(
            //   text: "*",
            //   color: Colors.red,
            //   size: text_font_small,
            // ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: new_gradient_color,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 140,
                alignment: Alignment.center,
                child: TextWidget(
                  text: "My Address",
                  color: white_color,
                  size: text_size_18,
                  weight: FontWeight.w500,
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: white_color,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: TextWidget(
                                  text: "Contact Information",
                                  color: black_color,
                                  size: text_size_20,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       readOnly = !readOnly;
                          //       setState(() {});
                          //     },
                          //     child: Container(
                          //       height: 35,
                          //         width: 35,
                          //         margin: EdgeInsets.only(
                          //           right: 10,
                          //         ),
                          //         alignment: Alignment.centerRight,
                          //         child: readOnly
                          //             ? SvgPicture.asset(
                          //                 ImageConstants.eshop_edit)
                          //             : SvgPicture.asset(
                          //                 ImageConstants.eshop_edit, color: blue_color,)),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("First Name"),
                      Container(
                          child: TextFormField(
                        readOnly: readOnly,
                        autovalidateMode: AutovalidateMode.disabled,
                        textAlign: TextAlign.start,
                        controller: _firstnameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: black_color,
                            fontSize: text_font_medium_x_size,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      )),
                      _isfirstnameErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _firstNameErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("Last Name"),
                      Container(
                          child: TextFormField(
                        readOnly: readOnly,
                        autovalidateMode: AutovalidateMode.disabled,
                        textAlign: TextAlign.start,
                        controller: _lastnameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: black_color,
                            fontSize: text_font_medium_x_size,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      )),
                      _islastnameErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _lastNameErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // _commonHeader("email"),
                      // Container(
                      //     child: TextFormField(
                      //   autovalidateMode: AutovalidateMode.disabled,
                      //   textAlign: TextAlign.start,
                      //   controller: _emailController,
                      //   keyboardType: TextInputType.emailAddress,
                      //   style: TextStyle(
                      //       color: black_color,
                      //       fontSize: text_font_medium_x_size,
                      //       fontWeight: FontWeight.w600),
                      //   decoration: InputDecoration(
                      //       isDense: true,
                      //       border: UnderlineInputBorder(),
                      //       enabledBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Colors.grey[400])),
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Colors.grey[400])),
                      //       contentPadding:
                      //           EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      // )),
                      // _isEmailErr
                      //     ? Container(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(top: 5.0),
                      //           child: TextWidget(
                      //             text: _emailErrmsg ?? "",
                      //             color: Colors.red,
                      //             size: 13,
                      //           ),
                      //         ),
                      //       )
                      //     : Container(
                      //         height: 0,
                      //       ),
                      SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: "Address",
                        color: black_color,
                        size: text_size_20,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("City"),
                      GestureDetector(
                        onTap: readOnly
                            ? () {}
                            : () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CityOrArea(
                                                title: "City",
                                                cityvalues: _cityList,
                                                selectedvalue: cityvalue)))
                                    .then((value) {
                                  if (value != null) {
                                    _cityController.text = value;
                                    cityvalue = value;
                                    if (cityAreaList.containsKey(value))
                                      _areaList = cityAreaList[value];

                                    setState(() {});
                                  }
                                });
                              },
                        child: AbsorbPointer(
                          child: Container(
                              child: TextFormField(
                            autovalidateMode: AutovalidateMode.disabled,
                            textAlign: TextAlign.start,
                            controller: _cityController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: black_color,
                                fontSize: text_font_medium_x_size,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 10)),
                          )),
                        ),
                      ),
                      _isCityErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _cityErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("Area"),
                      GestureDetector(
                        onTap: readOnly
                            ? () {}
                            : () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CityOrArea(
                                                title: "Area",
                                                cityvalues: [],
                                                areavalues: _areaList,
                                                selectedvalue: areavalue)))
                                    .then((value) {
                                  if (value != null) {
                                    _areaController.text = value;
                                    arealoader = false;
                                    setState(() {});
                                    areavalue = value;
                                  }
                                });
                              },
                        child: AbsorbPointer(
                          child: Container(
                              child: TextFormField(
                            autovalidateMode: AutovalidateMode.disabled,
                            textAlign: TextAlign.start,
                            controller: _areaController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                color: black_color,
                                fontSize: text_font_medium_x_size,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 10)),
                          )),
                        ),
                      ),
                      _areaErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _areaErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("Address"),
                      Container(
                          child: TextFormField(
                        readOnly: readOnly,
                        autovalidateMode: AutovalidateMode.disabled,
                        textAlign: TextAlign.start,
                        controller: _addressController,
                        keyboardType: TextInputType.text,
                        //maxLines: _addressController.text == "" ? 1 : 2,
                        style: TextStyle(
                            color: black_color,
                            fontSize: text_font_medium_x_size,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      )),
                      _isAddressErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _addressErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      _commonHeader("House No."),
                      Container(
                          child: TextFormField(
                        readOnly: readOnly,
                        autovalidateMode: AutovalidateMode.disabled,
                        textAlign: TextAlign.start,
                        controller: _streetaddressController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: black_color,
                            fontSize: text_font_medium_x_size,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      )),
                      _isstreetaddressErr
                          ? Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextWidget(
                                  text: _streetAddressErrmsg ?? "",
                                  color: Colors.red,
                                  size: 13,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // _commonHeader("houseno"),
                      // Container(
                      //     child: TextFormField(
                      //   textAlign: TextAlign.start,
                      //   autovalidate: false,
                      //   controller: _housenoController,
                      //   keyboardType: TextInputType.text,
                      //   style: TextStyle(
                      //       color: black_color,
                      //       fontSize: text_font_medium_x_size,
                      //       fontWeight: FontWeight.w600),
                      //   decoration: InputDecoration(
                      //       isDense: true,
                      //       border: UnderlineInputBorder(),
                      //       enabledBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Colors.grey[400])),
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide:
                      //               BorderSide(color: Colors.grey[400])),
                      //       contentPadding:
                      //           EdgeInsets.fromLTRB(0, 0, 0, 10)),
                      // )),
                      // _isHouseNoErr
                      //     ? Container(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(top: 5.0),
                      //           child: TextWidget(
                      //             text: _houseErrmsg ?? "",
                      //             color: Colors.red,
                      //             size: 13,
                      //           ),
                      //         ),
                      //       )
                      //     : Container(
                      //         height: 0,
                      //       ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          _commonHeader("Country Code"),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(child: _commonHeader("Phone Number")),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              // GestureDetector(
                              // onTap: readOnly
                              //     ? () {}
                              //     : () async {
                              //         countryData =
                              //             await Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                     builder: (cxt) => CountryCodeListPage(
                              //                         countryListData:
                              //                             countryData
                              //                         // {
                              //                         //   "country_code":
                              //                         //       _countryController.text,
                              //                         //   "id": CityGLobals.countryid !=
                              //                         //           null
                              //                         //       ? CityGLobals.countryid
                              //                         //       : ""
                              //                         // },
                              //                         )));
                              //         _countryController.text =
                              //             countryData
                              //                     ?.countryCode ??
                              //                 "";
                              //       },
                              // child:
                              Container(
                                  width: 100,
                                  // margin: EdgeInsets.only(top: 20),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      readOnly: readOnly,
                                      textAlign: TextAlign.start,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      controller: _countryController,
                                      maxLength: 3,
                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                          color: black_color,
                                          fontSize: text_font_medium_x_size,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                          counterText: "",
                                          isDense: true,
                                          border: UnderlineInputBorder(),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400)),
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                    ),
                                  )),
                              // ),
                              _isCountryCodeErr
                                  ? Container(
                                      width: 100,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: TextWidget(
                                          text: _countryErrMsg ?? "",
                                          color: Colors.red,
                                          size: 13,
                                          softwrap: true,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                            ],
                          ),

                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   width: 100,
                          //   padding: const EdgeInsets.only(
                          //       left: 10.0, right: 10.0),
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //         bottom: BorderSide(
                          //             width: 1, color: Colors.grey[400])),
                          //   ),
                          //   child: DropdownButtonHideUnderline(
                          //     child: DropdownButton(
                          //         icon: Icon(Icons.keyboard_arrow_down),
                          //         value: _selectedCarrier,
                          //         items: _carrieDropDown,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             _selectedCarrier = value;
                          //           });
                          //         }),
                          //   ),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  // margin: EdgeInsets.only(top: 20),
                                  child: TextFormField(
                                readOnly: readOnly,
                                autovalidateMode: AutovalidateMode.disabled,
                                textAlign: TextAlign.start,
                                controller: _mobileController,
                                maxLength: countryData != null
                                    ? countryData?.mobileNumberLength
                                    : _countryController.text.length == 2
                                        ? 10
                                        : _countryController.text.length == 3
                                            ? 9
                                            : _countryController.text.length ==
                                                    1
                                                ? 11
                                                : 12,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    color: black_color,
                                    fontSize: text_font_medium_x_size,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                    counterText: "",
                                    isDense: true,
                                    border: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400)),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 10)),
                              )),
                              _isNumberErr
                                  ? Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: TextWidget(
                                        text: _mobileErrmsg ?? "",
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (widget.route == "customer" || widget.route == "popup")
                        Container(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (defaultaddress == 0) {
                                      defaultaddress = 1;
                                    } else {
                                      defaultaddress = 0;
                                    }
                                  });
                                },
                                child: defaultaddress == 1
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:
                                                    country_select_color_border)),
                                        child: Icon(Icons.check,
                                            size: 20, color: theme_color),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    country_select_color_border),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                            Icons.check_box_outline_blank,
                                            size: 20,
                                            color: transColor),
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextWidget(
                                text: "saveaddress",
                                size: text_font_medium_x_size,
                                weight: FontWeight.w600,
                              )
                            ],
                          ),
                        ),
                      if (widget.route == "customer" || widget.route == "popup")
                        SizedBox(
                          height: 20,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _autovalidate = true;
                                  addListners();
                                  _firstName();
                                  _lastName();
                                  _email();
                                  _address();
                                  _streetaddrss();
                                  //_houseno();
                                  _mobileno();
                                  // _countryCode();
                                  _area();
                                  _city();
                                });
                                if (_isfirstnameErr == false &&
                                    _islastnameErr == false &&
                                    //_isEmailErr == false &&
                                    _isAddressErr == false &&
                                    _isstreetaddressErr == false &&
                                    // _isHouseNoErr == false &&
                                    _isNumberErr == false &&
                                    _areaErr == false &&
                                    _isCityErr == false) {
                                  final _data = AddressSave(
                                      switchvalue,
                                      _firstnameController.text,
                                      _lastnameController.text,
                                      _emailController.text,
                                      _cityController.text,
                                      _areaController.text,
                                      _addressController.text,
                                      _streetaddressController.text,
                                      _housenoController.text,
                                      _countryController.text,
                                      "",
                                      _mobileController.text,
                                      "",
                                      defaultaddress.toString(),
                                      "",
                                      "",
                                      "",true);
                                  //////////////////
                                  var request = {
                                    "firstname": _firstnameController.text,
                                    "lastname": _lastnameController.text,
                                    "email": GemsGLobals.useremail,
                                    "shopuserid": GemsGLobals.custEncryptedId,
                                    "address1": _addressController.text,
                                    "address2": _streetaddressController.text,
                                    "city": _cityController.text,
                                    "area": _areaController.text,
                                    "countrycode": "",
                                    "carrier_code": "",
                                    "mobile": _mobileController.text,
                                    "set_default": 1
                                  };
                                  internetCall(
                                      context,
                                      () => CustomerAddressPresenter(this)
                                          .addAddressResponse(request));

                                  // if (widget.route == "customer") {
                                  Navigator.pop(context);
                                  Navigator.pop(context, _data);
                                  // } else {

                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ReviewPage(
                                  //               addressSave: _data,
                                  //             )),
                                  //   );
                                  // }
                                }
                              },
                              child: Container(
                                height: 40,
                                // width: MediaQuery.of(context)
                                //         .size
                                //         .width /
                                //     2,
                                decoration: BoxDecoration(
                                    gradient: gradient_theme_color,
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: TextWidget(
                                  text: "Save",
                                  color: white_color,
                                  weight: FontWeight.bold,
                                  size: text_font_medium_size,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: white_color,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.3),
                                ),
                                height: 40,
                                alignment: Alignment.center,
                                child: Center(
                                  child: TextWidget(
                                    text: "Cancel",
                                    color: blue_color,
                                    weight: FontWeight.w600,
                                    size: text_font_medium_size,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void responseFailure(response) {
    // TODO: implement responseFailure
  }

  @override
  void shippingAddressAreaRespone(List<AreaModel> areamodel) {
    // TODO: implement shippingAddressAreaRespone

    if (areamodel[0].success == "true") {
      arearesponse = areamodel[0];
      arealoader = false;
      setState(() {});
    }
  }

  @override
  void shippingAddressCityRespone(List<CityModel> citymodel) {
    // TODO: implement shippingAddressCityRespone

    if (citymodel[0].success == "true") {
      cityresponse = citymodel[0];
      _carrierItems = cityresponse!.carrierCode!;
      _carrieDropDown = buildDropDownMenuItems(_carrierItems);
      _selectedCarrier = _carrierItems[0];

      arealoader = false;
      switchvalue = cityresponse?.customAddressType?[0].id != null ||
              cityresponse?.customAddressType?[0].id != ""
          ? cityresponse?.customAddressType![0].id
          : "";
      setState(() {});
    }
  }

  @override
  void onAreaTimeout() {
    var bodyArea = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "city": _cityController.text
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      ShippingAddressPresenter(this).areaResponse(bodyArea))));
  }

  @override
  void onCityTimeout() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "city": ""
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      ShippingAddressPresenter(this).cityResponse(body))));
  }

  @override
  void addAddressResponse(List<AddAddressModel> modelresponse) {
    if (modelresponse[0].success == "true") {
      arealoader = false;
      //   Navigator.pop(context, true);
      //   setState(() {});
      // } else {
      //   Fluttertoast.showToast(
      //       msg: modelresponse[0].message.toString(),
      //       backgroundColor: Color(0xAA000000),
      //       textColor: white_text_color,
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.BOTTOM);
      //   isloading = false;
      //   setState(() {});
    }
  }

  @override
  void deleteaddressResponse(List<DeleteAddressModel> modelresponse) {
    // TODO: implement deleteaddressResponse
  }

  @override
  void editAddressResponse(List<CustomerAddressModel> modelresponse) {
    // TODO: implement editAddressResponse
  }

  @override
  void onAddressTimeout() {
    // TODO: implement onAddressTimeout
  }
}
