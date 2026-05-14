import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/address/address_model.dart';
import 'package:gems_revamp/eshop_module_new/address/address_presenter.dart';
import 'package:gems_revamp/eshop_module_new/address/address_view.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
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

class NewAddress extends StatefulWidget {
  final address;
  final streestaddress;
  final city;
  final area;
  final countyCode;
  final title;
  final String type;
  final AddressSave? editaddress;
  final CartDetailsModel? cartDetailsModel;
  final route;
  NewAddress(
      {Key? key,
      this.address,
      this.streestaddress,
      this.city,
      this.area,
      this.countyCode,
      this.cartDetailsModel,
      this.editaddress,
      this.route,
      this.title,
      required this.type})
      : super(key: key);
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress>
    implements ShppingAddressView, CustomerAddressView {
  late List<DropdownMenuItem<CarrierCode>> _carrieDropDown;
  late CarrierCode _selectedCarrier;
  List<CarrierCode> _carrierItems = [];

  late CityModel cityresponse;
  late AreaModel? arearesponse;
  String cityvalue = "";
  String areavalue = "";
  int defaultShippingAddress = 0;
  int defaultBillingAddress = 0;
  AddressSave? editaddress;
  bool isloading = false;
  bool arealoader = false;
  bool isloader = false;
  bool _isCountryCodeErr = false;
  List _cityList = [];
  List _areaList = [];
  bool _autovalidate = false;
  late CustomerAddressModel _response;
  bool readOnly = false;
  bool isdefault = false;
  void initState() {
    super.initState();
    editaddress = (widget.editaddress);
    _firstnameController.text = editaddress?.firstname ?? "";
    _lastnameController.text = editaddress?.lastName ?? "";
    _areaController.text = editaddress?.city ?? "";
    _cityController.text = editaddress?.area ?? "";
    _addressController.text = editaddress?.address ?? "";
    _streetaddressController.text = editaddress?.streetAddress ?? "";
    _housenoController.text = editaddress?.houseNo ?? "";
    _countryController.text = editaddress?.countryCode ?? "";
    _mobileController.text = editaddress?.number ?? "";
    _cityList = cityAreaList.keys.toList();
    isdefault = editaddress?.isdefault ?? false;

    if (_cityController.text.isNotEmpty) {
      if (cityAreaList.containsKey(_cityController.text)) {
        _areaList = cityAreaList[_cityController.text]!;
      }
    }
    if (_cityController.text.isNotEmpty) cityvalue = _cityController.text;
    if (_areaController.text.isNotEmpty) areavalue = _areaController.text;

    addListners();
    userLoginCheck();
  }

  void editAddress() {
    if (widget.type == "new") {
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
        "set_default": defaultShippingAddress.toString()
      };
      internetCall(context,
          () => CustomerAddressPresenter(this).addAddressResponse(request));
    } else {
      var request = {
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
        "address_id": editaddress?.addressId ?? "",
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "address1": _addressController.text,
        "address2": _streetaddressController.text,
        "city": _cityController.text,
        "area": _areaController.text,
        "countrycode": "",
        "carrier_code": "",
        "mobile": _mobileController.text,
        "set_default": defaultShippingAddress.toString()
      };
      internetCall(
          context,
          () =>
              CustomerAddressPresenter(this).customeraddressResponse(request));
    }

    isloading = true;
  }

  userLoginCheck() async {
    var prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString("Useremail") ?? "";
  }

  addListners() {
    if (_autovalidate) {
      _lastnameController.addListener(() => _lastName(refresh: true));
      _firstnameController.addListener(() => _firstName(refresh: true));
      // _emailController.addListener(() => _email(refresh: true));
      _addressController.addListener(() => _address(refresh: true));
      _streetaddressController.addListener(() => _streetaddrss(refresh: true));
      //_housenoController.addListener(() => _houseno(refresh: true));
      _mobileController.addListener(() => _mobileno(refresh: true));
      _cityController.addListener(() => _city(refresh: true));
      _areaController.addListener(() => _area(refresh: true));
      _countryController.addListener(() => _countryCode(refresh: true));
    }
  }

  void _countryCode({required bool refresh}) {
    if (_countryController.text.isEmpty) {
      _isCountryCodeErr = true;
      _countryErrMsg = "Please Enter Country Code";
    } else {
      _isCountryCodeErr = false;
      _countryErrMsg = "";
    }
    if (refresh) {
      setState(() {});
    }
  }

  void _firstName({required bool refresh}) {
    if (_firstnameController.text.isEmpty) {
      _isfirstnameErr = true;
      _firstNameErrmsg = "Please enter first name";
    } else if (_firstnameController.text.length <= 1) {
      _isfirstnameErr = true;
      _firstNameErrmsg = "Please enter valid first name";
    } else {
      Pattern _number = r'^(?=.*[0-9])';
      Pattern _symbols = r"^(?=.*[$&+,:;=?@#|'<>.^*()%!-])";
      if (RegExp(_number.toString()).hasMatch(_firstnameController.text) ||
          RegExp(_symbols.toString()).hasMatch(_firstnameController.text)) {
        _isfirstnameErr = true;
        _firstNameErrmsg = 'Please enter valid first name';
      } else {
        _isfirstnameErr = false;
        _firstNameErrmsg = "";
      }
    }
    if (refresh) {
      setState(() {});
    }
  }

  void _lastName({required bool refresh}) {
    if (_lastnameController.text.isEmpty) {
      _islastnameErr = true;
      _lastNameErrmsg = "Please enter last name";
    } else if (_lastnameController.text.length <= 1) {
      _islastnameErr = true;
      _lastNameErrmsg = "Please enter valid last name";
    } else {
      Pattern _number = r'^(?=.*[0-9])';
      Pattern _symbols = r"^(?=.*[$&+,:;=?@#|'<>.^*()%!-])";
      if (RegExp(_number.toString()).hasMatch(_lastnameController.text) ||
          RegExp(_symbols.toString()).hasMatch(_lastnameController.text)) {
        setState(() {
          _islastnameErr = true;
          _lastNameErrmsg = 'Please enter valid last name';
        });
      } else {
        _islastnameErr = false;
        _lastNameErrmsg = "";
      }
    }
    if (refresh) {
      setState(() {});
    }
  }

  // void _email({bool refresh}) {
  // if (_emailController.text.isEmpty) {
  // _isEmailErr = true;
  // _emailErrmsg = "email_blank";
  // } else if (_emailController.text.length < 2 ||
  // _emailController.text.length > 50) {
  // _isEmailErr = true;
  // _emailErrmsg = "email_valid";
  // } else {
  // bool emailValid = RegExp(
  // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  // .hasMatch(_emailController.text);
  // if (emailValid == true) {
  // _isEmailErr = false;
  // _emailErrmsg = "";
  // } else {
  // _isEmailErr = true;
  // _emailErrmsg = "email_valid";
  // }
  // }
  // if (refresh ?? false) {
  // setState(() {});
  // }
  // }

  void _address({required bool refresh}) {
    if (_addressController.text.isEmpty) {
      _isAddressErr = true;
      _addressErrmsg = "Please enter an address";
    } else if (_addressController.text.length <= 1) {
      _isAddressErr = true;
      _addressErrmsg = "Please enter valid address";
    } else {
      _isAddressErr = false;
      _addressErrmsg = "";
    }
    if (refresh) {
      setState(() {});
    }
  }

  void _city({required bool refresh}) {
    if (_cityController.text.isEmpty) {
      _isCityErr = true;
      _cityErrmsg = "Please select city";
    } else {
      _isCityErr = false;
      _cityErrmsg = "";
    }
    if (refresh) {
      setState(() {});
    }
  }

  void _area({required bool refresh}) {
    if (_areaController.text.isEmpty) {
      _areaErr = true;
      _areaErrmsg = "Please select area";
    } else {
      _areaErr = false;
      _areaErrmsg = "";
    }
    if (refresh) {
      setState(() {});
    }
  }

  void _streetaddrss({required bool refresh}) {
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
    if (refresh) {
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

  void _mobileno({required bool refresh}) {
    int len = 12;
    // _countryController.text.length == 2
    //     ? 10
    //     : _countryController.text.length == 3
    //         ? 9
    //         : _countryController.text.length == 1
    //             ? 11
    //             : 12;
    if (_mobileController.text.isEmpty) {
      _isNumberErr = true;
      _mobileErrmsg = "Please enter mobile number";
    } else if (_mobileController.text.length < len) {
      _isNumberErr = true;
      _mobileErrmsg = "Max length is $len";
    } 
    else if (_mobileController.text.substring(0,3) != "971") {
      _isNumberErr = true;
      _mobileErrmsg = "Please enter valid mobile number";
    }
    else {
      _isNumberErr = false;
      _mobileErrmsg = "";
    }
    if (refresh) {
      setState(() {});
    }
  }

  bool _isfirstnameErr = false;
  bool _islastnameErr = false;
  bool _isEmailErr = false;
  bool _isstreetaddressErr = false;
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
    List<DropdownMenuItem<CarrierCode>> items = [];
    for (CarrierCode listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.code!),
          value: listItem,
        ),
      );
    }
    return items;
  }

  bool switches = true;
  late String switchvalue;
  @override
  Widget build(BuildContext context) {
    Widget _commonHeader(String title) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          children: [
            TextWidget(
              text: title,
              color: dark_grey,
              size: text_font_medium_x_size,
              weight: FontWeight.w500,
            ),
            // SizedBox(
            //   width: 5,
            // ),
            // TextWidget(
            //   text: "*",
            //   color: Colors.red,
            //   size: text_font_small,
            // ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: new_gradient_color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: SafeArea(
        bottom: false,
        top: false,
        child: PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
            Navigator.pop(context, false);
            return Future.value(true);
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: GradientAppBar(
                title: "My Address",
                color: white_text_color,
                size: 19,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 90,
              ),
            ),
            backgroundColor: white_color,
            body: isloader
                ? Center(
                    child: Loader(),
                  )
                : SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                _commonHeader("First Name"),
                                Container(
                                    child: TextFormField(
                                  readOnly: readOnly,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  textAlign: TextAlign.start,
                                  controller: _firstnameController,
                                  keyboardType: TextInputType.text,
                                  autofocus: true,
                                  style: TextStyle(
                                      color: black_color,
                                      fontSize: text_font_medium_x_size,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: 'Enter First Name',
                                    hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                )),
                                _isfirstnameErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
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
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Last Name',
                                    hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                )),
                                _islastnameErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: TextWidget(
                                            text: _lastNameErrmsg ?? "",
                                            color: Colors.red,
                                            size: 13,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 15,
                                ),
                                TextWidget(
                                  text: "Address",
                                  color: black_color,
                                  size: text_size_18,
                                  weight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 15,
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
                                                        builder: (context) =>
                                                            CityOrArea(
                                                                title: "City",
                                                                cityvalues:
                                                                    _cityList,
                                                                selectedvalue:
                                                                    cityvalue)))
                                                .then((value) {
                                              if (value != null) {
                                                _cityController.text = value;
                                                cityvalue = value;
                                                if (cityAreaList
                                                    .containsKey(value))
                                                  _areaList =
                                                      cityAreaList[value]!;

                                                setState(() {});
                                              }
                                            });
                                          },
                                    child: AbsorbPointer(
                                      child: Container(
                                          child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        textAlign: TextAlign.start,
                                        controller: _cityController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            color: black_color,
                                            fontSize: text_font_medium_x_size,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          hintText: 'Enter City',
                                          hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                            isDense: true,
                                            border: UnderlineInputBorder(),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400]!)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400]!)),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10)),
                                      )),
                                    )),
                                _isCityErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
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
                                                  builder: (context) =>
                                                      CityOrArea(
                                                          title: "Area",
                                                          cityvalues: [],
                                                          areavalues: _areaList,
                                                          selectedvalue:
                                                              areavalue))).then(
                                              (value) {
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
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      textAlign: TextAlign.start,
                                      controller: _areaController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          color: black_color,
                                          fontSize: text_font_medium_x_size,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Area',
                                        hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                          isDense: true,
                                          border: UnderlineInputBorder(),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400]!)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400]!)),
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                    )),
                                  ),
                                ),
                                _areaErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
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
                                  style: TextStyle(
                                      color: black_color,
                                      fontSize: text_font_medium_x_size,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Address',
                                    hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                )),
                                _isAddressErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
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
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: 'Enter House No.',
                                    hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[400]!)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                )),
                                _isstreetaddressErr
                                    ? Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    // _commonHeader("countrycode"),
                                    // SizedBox(
                                    // width: 25,
                                    // ),
                                    Expanded(child: _commonHeader("Phone No.")),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            //margin: EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                          readOnly: readOnly,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          textAlign: TextAlign.start,
                                          controller: _mobileController,
                                          maxLength: 12,
                                              // _countryController.text.length ==
                                              //         2
                                              //     ? 10
                                              //     : _countryController
                                              //                 .text.length ==
                                              //             3
                                              //         ? 9
                                              //         : _countryController.text
                                              //                     .length ==
                                              //                 1
                                              //             ? 11
                                              //             : 12,
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                              color: black_color,
                                              fontSize: text_font_medium_x_size,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                            hintText: 'Enter Phone No.',
                                            hintStyle: TextStyle(fontFamily: "Poppins", color: grey_color_pin_text),
                                              counterText: "",
                                              isDense: true,
                                              border: UnderlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.grey[
                                                                  400]!)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey[400]!)),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10)),
                                        )),
                                        _isNumberErr
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
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
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextWidget(
                                    text: "(For eg: 971501234567)",
                                    color: Colors.grey,
                                    size: text_font_small,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (defaultShippingAddress == 0) {
                                              defaultShippingAddress = 1;
                                              isdefault = true;
                                            } else {
                                              defaultShippingAddress = 0;
                                              isdefault = false;
                                            }
                                          });
                                        },
                                        child: defaultShippingAddress == 1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: blue_color)),
                                                child: Icon(Icons.check,
                                                    size: 20,
                                                    color: theme_color),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: blue_color),
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 20,
                                                    color: transColor),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: "Set as default address",
                                        size: text_font_medium_x_size,
                                        weight: FontWeight.w600,
                                        color: grey_gunsmoke_text_color,
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                // height: 10,
                                // ),
                                // Container(
                                // child: Row(
                                // children: [
                                // InkWell(
                                // onTap: () {
                                // setState(() {
                                // if (defaultBillingAddress == 0) {
                                // defaultBillingAddress = 1;
                                // } else {
                                // defaultBillingAddress = 0;
                                // }
                                // });
                                // },
                                // child: Icon(
                                // defaultBillingAddress == 1
                                // ? Icons.check_box
                                // : Icons.check_box_outline_blank,
                                // color: theme_color,
                                // ),
                                // ),
                                // SizedBox(
                                // width: 10,
                                // ),
                                // TextWidget(
                                // text: "defaultbilling",
                                // size: text_font_medium_x_size,
                                // weight: FontWeight.w600,
                                // )
                                // ],
                                // ),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                isloading
                                    ? Container(
                                        height: 40,
                                        child: Loader(),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _autovalidate = true;
                                                  addListners();
                                                  _firstName(refresh: false);
                                                  _lastName(refresh: false);
                                                  //_email();
                                                  _address(refresh: false);
                                                  _streetaddrss(refresh: false);
                                                  //_houseno();
                                                  _mobileno(refresh: false);
                                                  _area(refresh: false);
                                                  _city(refresh: false);
                                                });
                                                if (_isfirstnameErr == false &&
                                                    _islastnameErr == false &&
                                                    _isEmailErr == false &&
                                                    _isAddressErr == false &&
                                                    _isstreetaddressErr ==
                                                        false &&
                                                    //_isHouseNoErr == false &&
                                                    _isNumberErr == false &&
                                                    _areaErr == false &&
                                                    _isCityErr == false) {
                                                  editAddress();
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                height: 50,
                                                // width: MediaQuery.of(context)
                                                //         .size
                                                //         .width /
                                                //     2,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        gradient_theme_color,
                                                    
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
border: Border.all(color:Colors.grey,width:0.3),
                                                ),
                                                height: 50,
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
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void responseFailure(response) {}

  @override
  void shippingAddressAreaRespone(List<AreaModel> areamodel) {
    if (areamodel[0].success == "true") {
      arearesponse = areamodel[0];
      arealoader = false;
      isloader = false;
      setState(() {});
    } else {
      arearesponse = null;
      arealoader = false;
      isloader = false;
      setState(() {});
    }
  }

  @override
  void shippingAddressCityRespone(List<CityModel> citymodel) {
    if (citymodel[0].success == "true") {
      cityresponse = citymodel[0];
      _carrierItems = cityresponse.carrierCode!;
      _carrieDropDown = buildDropDownMenuItems(_carrierItems);
      if (editaddress!.carrierCode == _carrierItems[0].id) {
        _selectedCarrier = _carrierItems[0];
      }
      _selectedCarrier = _carrierItems[0];
      // ignore: unnecessary_null_comparison
      switchvalue = (cityresponse.customAddressType![0].id != null ||
              cityresponse.customAddressType![0].id != ""
          ? cityresponse.customAddressType![0].id
          : "")!;
      for (var i = 0; i < (citymodel[0].carrierCode!.length); i++) {
        if (editaddress!.carrierCode == citymodel[0].carrierCode![i].code)
          _selectedCarrier = citymodel[0].carrierCode![i];
      }
      _countryController.text = cityresponse.countryCode![0].code!;
      isloader = false;
      setState(() {});
    }
  }

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
  void onAddressTimeout() {
    if (widget.type == "new") {
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
        "set_default": defaultShippingAddress.toString()
      };
      internetCall(context,
          () => CustomerAddressPresenter(this).addAddressResponse(request));
    } else {
      var request = {
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
        "address_id": editaddress?.addressId ?? "",
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "address1": _addressController.text,
        "address2": _streetaddressController.text,
        "city": _cityController.text,
        "area": _areaController.text,
        "countrycode": "",
        "carrier_code": "",
        "mobile": _mobileController.text,
        "set_default": defaultShippingAddress.toString()
      };
      internetCall(
          context,
          () =>
              CustomerAddressPresenter(this).customeraddressResponse(request));
    }
  }

  @override
  void editAddressResponse(List<CustomerAddressModel> modelresponse) {
    if (modelresponse[0].success == "true") {
      _response = modelresponse[0];
      isloading = false;
      Navigator.pop(context, true);
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: modelresponse[0].message.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
      isloading = false;
      setState(() {});
    }
  }

  @override
  void deleteaddressResponse(List<DeleteAddressModel> modelresponse) {}

  @override
  void addAddressResponse(List<AddAddressModel> modelresponse) {
    if (modelresponse[0].success == "true") {
      isloading = false;
      Navigator.pop(context, true);
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: modelresponse[0].message.toString(),
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      isloading = false;
      setState(() {});
    }
  }
}
