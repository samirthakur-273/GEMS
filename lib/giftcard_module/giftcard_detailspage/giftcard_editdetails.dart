/*Author:Jyoti Gite
Description:edit vocher delivery details

date:28 apr 2022
*/
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/utils/country_list/country_code_list.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:string_validator/string_validator.dart';

class EditGiftcardReciverDetails extends StatefulWidget {
  final editDetails;
  EditGiftcardReciverDetails({
    this.editDetails,
    Key? key,
  }) : super(key: key);
  @override
  _EditGiftcardReciverDetailsState createState() =>
      _EditGiftcardReciverDetailsState();
}

class _EditGiftcardReciverDetailsState
    extends State<EditGiftcardReciverDetails> {
  var _firstnameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _emailController = TextEditingController();
  var _mobileNumController = TextEditingController();

  FocusNode fname = FocusNode();
  FocusNode lname = FocusNode();
  FocusNode ename = FocusNode();
  FocusNode mNumber = FocusNode();

  bool _isfirstnameErr = false;
  bool _islastnameErr = false;
  bool _isEmailErr = false;
  bool _isMobileErr = false;

  var _firstNameErrmsg;
  var _lastNameErrmsg;
  var _emailErrmsg;

  String? firstname;
  String? lastname;
  String? email;
  String? _mobileNumber;
  CountryList defaultCountryData = CountryList(
      id: 2,
      name: 'United Arab Emirates',
      code: 'AE',
      countryCode: '971',
      mobileNumberLength: 9,
      image: 'http://44.199.170.200:8082/uploads/images/countries/AE.jpg');
  int? numberLength;
  var countryid = 0, countrycode = '';
  String countryImage = '';
  MasterListModel? _masterListModel;
  List<CountryList>? countryCodeData = [];
  @override
  void initState() {
    fetchMasterListData();

    if (widget.editDetails != null) {
      numberLength = widget.editDetails['numberlength'];

      countryImage = widget.editDetails['flagimage'];

      countryid = widget.editDetails["countryId"];

      countrycode = widget.editDetails["countryCode"];

      _firstnameController =
          TextEditingController(text: widget.editDetails["firstname"]);

      _lastnameController =
          TextEditingController(text: widget.editDetails["lastname"]);

      _emailController =
          TextEditingController(text: widget.editDetails["email"]);
      _mobileNumController =
          TextEditingController(text: widget.editDetails["contactnumber"]);
    } else {
      numberLength = GemsGLobals.mobilenumberlength ??
          defaultCountryData.mobileNumberLength;
      countryImage = GemsGLobals.countryImage ?? defaultCountryData.image;
      countryid = GemsGLobals.countryid ?? defaultCountryData.id;
      countrycode = GemsGLobals.countryCode ?? defaultCountryData.countryCode;
      _firstnameController =
          TextEditingController(text: GemsGLobals.userFirstName);

      _lastnameController =
          TextEditingController(text: GemsGLobals.userLastName);

      _emailController = TextEditingController(text: GemsGLobals.useremail);
      _mobileNumController =
          TextEditingController(text: GemsGLobals.mobilenumber);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(widget.editDetails);
        }
      },
      child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              appBar: PreferredSize(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: GradientAppBar(
                    height: Platform.isIOS ? 100 : 90,
                    onLeftTap: () async {
                      Navigator.of(context).pop(this.widget.editDetails);
                    },
                    title: "Edit Details",
                    size: text_font_medium17_size,
                    weight: FontWeight.w500,
                    color: white_text_color,
                    centerTitle: true,
                  ),
                ),
                preferredSize: Size.fromHeight(55.0),
              ),
              body: _body(),
              // bottomNavigationBar: _saveCancelBtn(),
            ),
          )),
    );
  }

  Widget _body() {
    try {
      return SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 1.1,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          // shrinkWrap: true,
          children: <Widget>[
            _addForm(),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 45,
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: gradient_theme_color,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: blue_color.withOpacity(0.4),
                  //       offset: Offset(0, 7.0),
                  //       blurRadius: 7.0,
                  //       spreadRadius: 0.0),
                  // ],
                ),
                child: TextWidget(
                  text: 'Save',
                  color: white_text_color,
                  size: text_font_medium_size,
                  weight: FontWeight.w500,
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                _firstName(refresh: true);
                _lastName(refresh: true);
                _email(refresh: true);
                validatecontact(refresh: true);

                _saveeditedDetails();
              },
            ),
          ],
        ),
      ));
    } catch (e) {
      return Container();
    }
  }

  /*  All Text fields */

  Widget _addForm() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _textLabel("First Name*"),
          _firstnameTextfiled(),
          _textLabel("Last Name*"),
          _lastnameTextfiled(),
          _textLabel("Email*"),
          _emailTextfiled(),
          SizedBox(
            height: 15,
          ),
          Container(
            child: TextWidget(
              text: "All fields marked in asterisk are mandatory",
              color: text_color,
              size: text_font_small,
            ),
          ),
          // _textLabel(
          //   'Mobile Number',
          // ),
          SizedBox(
            height: 20,
          ),
          _selectCountryPhone(),

          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

/* Common TextWidget */
  Widget _textLabel(label) {
    return Container(
      margin: EdgeInsets.only(left: 0, top: 15, bottom: 0),
      child: TextWidget(
        text: label,
        size: text_font_medium15_size,
        color: black_color,
      ),
    );
  }

/* First name textfield widget */
  Widget _firstnameTextfiled() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            height: 35,
            child: TextFormField(
              maxLength: 32,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: black_color,
                  fontSize: text_font_medium_size,
                  fontWeight: FontWeight.w400),
              autofocus: true,
              focusNode: fname,
              onChanged: (text) {
                setState(() {
                  _isfirstnameErr = false;
                });
              },
              onFieldSubmitted: (value) {
                fname.unfocus();
                FocusScope.of(context).requestFocus(lname);
                firstname = _firstnameController.text;
              },
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[\\ ]')),
              ],
              controller: _firstnameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                hintText: "Enter First Name",
                counterText: "",
                hintStyle: TextStyle(
                    color: hint_text_color,
                    fontSize: text_font_medium_size,
                    fontWeight: FontWeight.w400),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: shadow_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: shadow_color)),
              ),
            ),
          ),
          _isfirstnameErr
              ? Container(
                  height: 15,
                  margin: EdgeInsets.only(top: 3),
                  child: TextWidget(
                    text: _firstNameErrmsg ?? "",
                    color: red_color,
                    size: text_font_size_x_small,
                  ),
                )
              : Container(
                  height: 0,
                )
        ]));
  }

/* Last name textfield widget */
  Widget _lastnameTextfiled() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            height: 35,
            child: TextFormField(
              maxLength: 32,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: black_color,
                  fontSize: text_font_medium_size,
                  fontWeight: FontWeight.w400),
              autofocus: true,
              focusNode: lname,
              showCursor: true,
              onFieldSubmitted: (value) {
                lname.unfocus();
                FocusScope.of(context).requestFocus(ename);

                lastname = _lastnameController.text;
              },
              onChanged: (text) {
                setState(() {
                  _islastnameErr = false;
                });
              },
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[\\ ]')),
              ],
              controller: _lastnameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                hintText: "Enter Last Name",
                counterText: "",
                hintStyle: TextStyle(
                    color: hint_text_color,
                    fontSize: text_font_medium_size,
                    fontWeight: FontWeight.w400),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: shadow_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: shadow_color)),
              ),
            ),
          ),
          _islastnameErr
              ? Container(
                  height: 15,
                  margin: EdgeInsets.only(top: 3),
                  child: TextWidget(
                    text: _lastNameErrmsg ?? "",
                    color: red_color,
                    size: text_font_size_x_small,
                  ),
                )
              : Container(
                  height: 0,
                )
        ]));
  }

/* Email name textfield widget */
  Widget _emailTextfiled() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            height: 35,
            child: TextFormField(
              maxLength: 50,
              textAlign: TextAlign.left,
              autofocus: false,
              inputFormatters: [
                new FilteringTextInputFormatter.deny(new RegExp('[\\ ]')),
              ],
              style: TextStyle(
                  color: black_color,
                  fontSize: text_font_medium_size,
                  fontWeight: FontWeight.w400),
              controller: _emailController,
              enabled: true,
              keyboardType: TextInputType.emailAddress,
              focusNode: ename,
              showCursor: true,
              onFieldSubmitted: (value) {
                ename.unfocus();
                FocusScope.of(context).requestFocus(mNumber);

                email = _emailController.text;
              },
              onChanged: (text) {
                setState(() {
                  _isEmailErr = false;
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                hintText: "Enter Email",
                counterText: "",
                hintStyle: TextStyle(
                    color: hint_text_color,
                    fontSize: text_font_medium_size,
                    fontWeight: FontWeight.w400),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: grey_color,
                )),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: grey_color)),
              ),
            ),
          ),
          _isEmailErr
              ? Container(
                  height: 15,
                  margin: EdgeInsets.only(top: 3),
                  child: TextWidget(
                    text: _emailErrmsg ?? "",
                    color: red_color,
                    size: text_font_size_x_small,
                  ),
                )
              : Container(
                  height: 0,
                )
        ]));
  }

  void _saveeditedDetails() {
    if (_isfirstnameErr == false &&
        _islastnameErr == false &&
        _isEmailErr == false &&
        _isMobileErr == false) {
      var _details = {
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "email": _emailController.text,
        "countryCode": countrycode,
        "contactnumber": _mobileNumController.text,
        "countryId": countryid,
        "numberlength": numberLength,
        "flagimage": countryImage
      };

      Navigator.of(context).pop(_details);
    }
  }

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);

      countryCodeData = _masterListModel!.values!.countryList;

     });
  }

  Widget _selectCountryPhone() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              color: white_text_color,
              borderRadius: new BorderRadius.circular(30.0),
              gradient: gradient_white_color,
              border:
                  Border.all(width: 1.0, color: grey_color.withOpacity(0.5)),
            ),
            width: MediaQuery.of(context).size.width,
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
                        countryImage = _countrydata.image;
                        countrycode = _countrydata.countryCode;
                        countryid = _countrydata.id;
                        numberLength = int.tryParse(
                            _countrydata.mobileNumberLength.toString());
                        validatecontact(refresh: true);
                      });
                    },
                    child: Container(
                      width: 110,
                      height: 53,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0, top: 5),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 25,
                              color: grey_gunsmoke_text_color,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            child: ClipOval(
                                child: CachedNetworkImage(
                                    alignment: Alignment.center,
                                    imageUrl: "$countryImage",
                                    width: 22,
                                    height: 22,
                                    placeholder: (context, url) => Container(
                                          margin: EdgeInsets.all(2),
                                          child: Container(),
                                        ),
                                    fit: BoxFit.fill)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                              width: 40,
                              child: TextWidget(
                                text: countrycode != '' ? '+$countrycode' : '',
                                color: black_color,
                                size: text_font_medium15_size,
                                weight: FontWeight.normal,
                              ))
                        ],
                      ),
                    )),
                Container(
                  width: 1,
                  height: 30,
                  color: deepdark_orange_color,
                ),
                Flexible(
                  child: TextFormField(
                      controller: _mobileNumController,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: numberLength,
                      inputFormatters: [
                        // WhitelistingTextInputFormatter(RegExp("[0-9]"))
                        FilteringTextInputFormatter(RegExp("[0-9]"),
                            allow: true)
                      ],
                      cursorColor: deepdark_orange_color,
                      cursorWidth: 1.0,
                      style: TextStyle(
                          color: black_color,
                          fontSize: text_font_medium15_size,
                          fontWeight: FontWeight.normal),
                      onFieldSubmitted: (value) {
                        mNumber.unfocus();
                        FocusScope.of(context).unfocus();

                        _mobileNumber = _mobileNumController.text;
                      },
                      onChanged: (text) {
                        setState(() {
                          _isMobileErr = false;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        alignLabelWithHint: true,
                        counterText: "",
                        errorMaxLines: 2,
                        border: InputBorder.none,
                        hintText: "Enter Mobile Number",
                        hintStyle: TextStyle(
                            color: black_color,
                            fontSize: text_font_medium15_size,
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ],
            ),
          ),
          _isMobileErr == true
              ? new Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5, right: 0),
                  child: new TextWidget(
                    text: _isMobileErr
                        ? '\tPlease enter $numberLength digit Mobile\n Number'
                        : '\tPlease enter $numberLength digit Mobile\n Number',
                    alignment: TextAlign.left,
                    size: text_font_size_x_small,
                    color: red_color,
                  ),
                )
              : new Container(),
        ],
      ),
    );
  }

  void _firstName({bool? refresh}) {
    if (_firstnameController.text.isEmpty) {
      setState(() {
        _isfirstnameErr = true;
        _firstNameErrmsg = "Please enter the First Name";
      });
    } else if (_firstnameController.text.length <= 1) {
      setState(() {
        _isfirstnameErr = true;
        _firstNameErrmsg = "First name should consist of minimum 2 characters";
      });
    } else {
      setState(() {
        _isfirstnameErr = false;
        _firstNameErrmsg = "";
      });
    }

    if (refresh ?? false) {
      setState(() {});
    }
  }

  void validatecontact({bool? refresh}) {
    if (_mobileNumController.text.isEmpty) {
      setState(() {
        _isMobileErr = true;
      });
    } else if (_mobileNumController.text.length < numberLength! ||
        _mobileNumController.text.length > numberLength!) {
      setState(() {
        _isMobileErr = true;
      });
    } else {
      setState(() {
        _isMobileErr = false;
      });
    }
  }

  void _lastName({bool? refresh}) {
    if (_lastnameController.text.isEmpty) {
      _islastnameErr = true;
      _lastNameErrmsg = "Please enter the Last Name";
    } else if (_lastnameController.text.length <= 1) {
      _islastnameErr = true;
      _lastNameErrmsg = "Last name should consist of minimum 2 characters";
    } else {
      _islastnameErr = false;
      _lastNameErrmsg = "";
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void _email({bool? refresh}) {
    if (_emailController.text.isEmpty) {
      _isEmailErr = true;
      _emailErrmsg = "Please enter your Email ID";
    } else if (_emailController.text.length < 2 ||
        _emailController.text.length > 50) {
      _isEmailErr = true;
      _emailErrmsg = "Please enter a valid Email ID";
    } else {
      bool emailValid = isEmail(_emailController.text);

      if (emailValid == true) {
        _isEmailErr = false;
        _emailErrmsg = "";
      } else {
        _isEmailErr = true;
        _emailErrmsg = "Please enter a valid Email ID";
      }
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }
}
