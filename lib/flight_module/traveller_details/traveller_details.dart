// ignore_for_file: unnecessary_null_comparison, unnecessary_statements

/*
Auther Name: Jyoti Gite
Discription : This is the FLIGHT Travellers Details DART PAGE which takes the passenger information
Date: 19 may 2022
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_details/return_jr_details_modal.dart';
import 'package:gems_revamp/flight_module/flight_review_iternery/flight_revirew_iternery.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/country_list/country_code_list.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:intl/intl.dart';

import '../../family_and_friends/nationality_list.dart';
import '../../utils/constants_files/color_constants.dart';
import '../../utils/constants_files/text_constants.dart';

class TravellersDetails extends StatefulWidget {
  final DetailsFlightModel? flightDetailsModel;
  final ReturnJrnyDetailsFlightModel? returnJrnyDetailsFlightModel;
  final String tripTyp;
  final guestData;
  final FlightRequestHolder? flightRequestHolder;
  final String? tripSubTyp;
  final String paymentTyp;
  final bool iSDomestic;
  final int? timer;
  final totatPrice;
  final baseprice;
  final taxprice;
  // final pgConvFee;
  // final totalPayableAmount;
  // final commissionratio;
  const TravellersDetails(this.flightRequestHolder,
      {Key? key,
      required this.flightDetailsModel,
      required this.returnJrnyDetailsFlightModel,
      required this.tripTyp,
      required this.guestData,
      required this.paymentTyp,
      required this.iSDomestic,
      this.tripSubTyp,
      this.baseprice,
      this.taxprice,
      this.totatPrice,
      this.timer
      // ,this.pgConvFee,
      // this.totalPayableAmount,
      // this.commissionratio
      })
      : super(key: key);

  @override
  _TravellersDetailsState createState() => _TravellersDetailsState();
}

class _TravellersDetailsState extends State<TravellersDetails> {
  FlightRequestHolder? flightRequestHolder;
  String? tripType;
  var countrydata;
  var issueCountryData;
  String nationality = 'IN';
  int? numberLength;
  int _guestCount = 1;
  bool checkedValue = false,
      checkTerms = false,
      isstaying = true,
      _checkValidation = false;
  TextEditingController _contactNo = TextEditingController();
  TextEditingController _emailId = TextEditingController();
  FocusNode? _contactFocus, _emailIdFocus;
  List<String> _titleText = [];
  List<String> title = ['Mr.', 'Ms.', 'Mrs.'];
  List guestTitle = [];
  List selectedIndex = [];
  List<TextEditingController> _firstName = [];
  List<TextEditingController> _lastName = [];
  List<TextEditingController> _passportNo = [];
  List<TextEditingController> _dob = [];
  List<TextEditingController> _passportIssueDate = [];
  List<TextEditingController> _passportExpiryDate = [];
  List<TextEditingController> _passportIssueCountry = [];
  List<TextEditingController> nationalityControllers = [];

  List<FocusNode> _fnFocus = [];
  List<FocusNode> _lnFocus = [];
  List<FocusNode> _passportFocus = [];
  List<FocusNode> _dobFocus = [];
  List<FocusNode> _passportIssueFocus = [];
  List<FocusNode> _passportExpiryFocus = [];

  List<FocusNode> _passportIssueCountryFocus = [];
  List<FocusNode> _nationalityFocusNodes = [];

  List<String> nationalityLocalList = [];
  List<String> issueCountryList = [];

  List _dobList = [];
  List dobEmpty = [];
  List _validDOB = [];
  List _passPortIssueList = [];
  List _passPortExpiryList = [];
  List passportIssueCountryList = [];
  List nationalityOptions = [];
  DateTime? _dateTime;
  DateTime _min = DateTime(
      DateTime.now().year - 100, DateTime.now().month, DateTime.now().day);
  String _format = 'dd MMMM yyyy';
  bool contactEmpty = false;
  bool _emialVal = false;
  List _fnvalidate = [];
  List _lnValidate = [];
  List _passportValidate = [];
  ScrollController? scrollController;
  List _guestDataDel = [];
  List _adultInfo = [];
  List _childInfo = [];
  List _infantInfo = [];
  List _detail = [];
  bool errorPresent = false;
  List _fnErr = [];
  List _lnErr = [];
  List _ppErr = [];
  List<bool> isIssueDateValidList = [];
  List<bool> isExpiryDateValidList = [];
  List<bool> validateNationalityList = [];
  List<bool> validateIssueCountryList = [];

  MasterListModel? _masterListModel;

  List? countryCodeData = [];
  String? passportNoValidationMsg,
      passportExpiryDateValidationMsg,
      passportIssueDateValidationMsg;

  String selectedPassportExpiryDate = '';
  String selectedPassportIssueDate = '';
  String? selectedGenderType = AppTexts.male;
  String selectedDob = '';


  DateTime? passportIssueDate;
  DateTime? passportExpiryDate;

  void changeIndex(int index, j) {
    setState(() {
      selectedIndex.insert(j, index);
    });
  }

  String stringToDateAndDateToStringFormatter() {
    DateFormat journeyDateFormate = DateFormat("dd MMM");
    if (tripType == "1") {
      DateTime simpleSingleJourneyDate =
          DateTime.parse(flightRequestHolder!.departureDate);
      flightRequestHolder?.formattedDepartureDate =
          journeyDateFormate.format(simpleSingleJourneyDate);

      return "${flightRequestHolder?.formattedDepartureDate}";
    } else if (tripType == "2") {
      DateTime singleJourneyDate =
          DateTime.parse(flightRequestHolder!.departureDate);

      DateTime returnJourneyDate =
          DateTime.parse(flightRequestHolder!.returnDate);

      flightRequestHolder?.formattedDepartureDate =
          journeyDateFormate.format(singleJourneyDate);
      flightRequestHolder?.formattedReturnDate =
          journeyDateFormate.format(returnJourneyDate);

      return "${flightRequestHolder?.formattedDepartureDate} - ${flightRequestHolder?.formattedReturnDate}";
    }
    return "";
  }

  List<dynamic>? nationalityList;

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);
      nationalityList = _masterListModel?.values?.nationality;

      countryCodeData = _masterListModel?.values?.countryList;
    });
  }

  /* DatePicker for Date of Birth */
  void showDatePicker(BuildContext context, _date, _index) {
    var myFormat = DateFormat(AppTexts.bookingDateFormat, 'en_us');

    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          "Done",
          style: TextStyle(
              color: blue_color, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      maxDateTime: _dateTime,
      initialDateTime: _index != 0 ? _min : _dateTime,
      minDateTime: _min,
      dateFormat: _format,
      locale: DateTimePickerLocale.en_us,
      onMonthChangeStartWithFirstDate: false,
      pickerMode: DateTimePickerMode.date,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          _dobList[_index] = {AppTexts.dateText: _dateTime};

          var _datetime = myFormat.format(dateTime);

          _date.value = TextEditingValue(text: _datetime.toString());
          dobEmpty[_index] = false;
          errorPresent = false;
        });
      },
    );
  }

  void _titleAdultLoop(int count) {
    for (var i = 1; i <= count; i++) {
      _titleText.add("Adult $i");
    }
  }

  void _titleChildLoop(int count) {
    for (var i = 1; i <= count; i++) {
      _titleText.add("Child $i");
    }
  }

  void _titleInfLoop(int count) {
    for (var i = 1; i <= count; i++) {
      _titleText.add("Infant $i");
    }
  }

  void initialData(loopcount) {
    selectedIndex.clear();
    guestTitle.clear();
    _firstName.clear();
    _lastName.clear();
    _passportNo.clear();
    _dob.clear();
    _passportIssueDate.clear();
    _passportExpiryDate.clear();
    _passportIssueCountry.clear();
    nationalityControllers.clear();
    _fnFocus.clear();
    _lnFocus.clear();
    _passportFocus.clear();
    _dobFocus.clear();
    _dobList.clear();
    _passportIssueFocus.clear();
    _passportExpiryFocus.clear();
    _passportIssueCountryFocus.clear();
    _nationalityFocusNodes.clear();
    dobEmpty.clear();
    _fnErr.clear();
    _lnErr.clear();
    _ppErr.clear();

    isIssueDateValidList = List.generate(loopcount, (index) => true);
    isExpiryDateValidList = List.generate(loopcount, (index) => true);
    validateNationalityList = List.generate(loopcount, (index) => false);
    validateIssueCountryList = List.generate(loopcount, (index) => false);

    _passPortIssueList = List.generate(loopcount, (index) => {AppTexts.dateText: ""});
    _passPortExpiryList = List.generate(loopcount, (index) => {AppTexts.dateText: ""});
    passportIssueCountryList =
        List.generate(loopcount, (index) => {AppTexts.countryText: ""});
    nationalityOptions =
        List.generate(loopcount, (index) => {AppTexts.nationalityText: ""});

    for (int i = 0; i < loopcount; i++) {
      selectedIndex.add(0);
      guestTitle.add(title[0]);
      _firstName.add(TextEditingController());
      _lastName.add(TextEditingController());
      _passportNo.add(TextEditingController());
      _dob.add(TextEditingController());
      nationalityLocalList.add('');
      issueCountryList.add('');
      _passportIssueDate.add(TextEditingController());
      _passportExpiryDate.add(TextEditingController());
      _passportIssueCountry.add(TextEditingController());
      nationalityControllers.add(TextEditingController());

      _fnFocus.add(FocusNode());
      _lnFocus.add(FocusNode());
      _passportFocus.add(FocusNode());
      _dobFocus.add(FocusNode());
      _dobList.add({AppTexts.dateText: ""});
      _passportIssueFocus.add(FocusNode());

      _passportExpiryFocus.add(FocusNode());
      _passportIssueCountryFocus.add(FocusNode());
      _nationalityFocusNodes.add(FocusNode());
      dobEmpty.add('false');
      _fnErr.add(false);
      _lnErr.add(false);
      _ppErr.add(false);
    }
  }

  void _stayingData() {
    setState(() {
      _firstName[0].text = GemsGLobals.userFirstName != null
          ? "${GemsGLobals.userFirstName![0] + GemsGLobals.userFirstName!.substring(1)}"
          : "";
      _lastName[0].text = GemsGLobals.userLastName != null
          ? GemsGLobals.userLastName![0] +
              GemsGLobals.userLastName!.substring(1)
          : "";
      _emailId.text = GemsGLobals.useremail != null
          ? GemsGLobals.useremail
          : "abc@gmail.com";

      
      if (GemsGLobals.mobilenumber != 'undefined') {
        _contactNo.text = GemsGLobals.mobilenumber;
        // _extractMobileNo(GemsGLobals.mobilenumber, GemsGLobals.countryCode);
      } else {
        _contactNo.text = '';
      }

     });
  }

  bool isInternational = false;

  @override
  void initState() {
    fetchMasterListData();

    if (widget.flightDetailsModel?.values?.flightDetail?.first.flt == AppTexts.flightTypeInternational) {
      isInternational = true;
    }
    scrollController = ScrollController();
    tripType = widget.tripTyp;
    flightRequestHolder = widget.flightRequestHolder;

    numberLength = GemsGLobals.mobilenumberlength != null
        ? GemsGLobals.mobilenumberlength
        : GemsGLobals.mobilenumber.length;
    _contactFocus = FocusNode();
    _emailIdFocus = FocusNode();

    _guestCount = (widget.guestData.adultNumber ?? 0) +
        (widget.guestData.childNumber ?? 0) +
        (widget.guestData.infentNumber ?? 0);

    if (_guestCount < 1) _guestCount = 1;

    _titleAdultLoop(widget.guestData.adultNumber ?? 0);
    _titleChildLoop(widget.guestData.childNumber ?? 0);
    _titleInfLoop(widget.guestData.infentNumber ?? 0);

    initialData(_guestCount);

    if (isstaying) {
      _stayingData();
    }

    _dateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    super.initState();
  }

  String _mobileListner(contct) {
    if (contct.length == 0) {
      contactEmpty = true;
      return 'Please enter Mobile Number';
    } else if (contct.length != numberLength) {
      contactEmpty = true;
      return "please enter valid mobile number";
    } else {
      contactEmpty = false;
      return '';
    }
  }

  String _emaillistner(email) {
    bool emailregex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$:%&₹'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.isEmpty) {
      return 'Please enter Email-Id';
    } else if (emailregex == false) {
      return 'Please enter Valid Email-Id';
    } else {
      return '';
    }
  }

  void _emailValidator() {
    bool emailregex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&₹:'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailId.text);
    if (_emailId.text.length == 0) {
      _emialVal = true;
      setState(() {});
    } else if (emailregex == false) {
      _emialVal = true;
      setState(() {});
    } else {
      _emialVal = false;
      setState(() {});
    }
  }

  String _firstNamelistner(firstname, i) {
    String pattern = '[a-z A-Z 0-9]';
    RegExp regex = new RegExp(pattern);
    if (firstname.length == 0) {
      _fnErr[i] = true;
      return 'Please enter First Name';
    } else if (firstname.length < 2) {
      _fnErr[i] = true;
      return 'Please enter minimum 2 character';
    } else if (!regex.hasMatch(firstname)) {
      _fnErr[i] = true;
      return 'Invalid First Name';
    } else if (firstname.length >= 2 &&
        firstname.toString().trim().length == 0) {
      return 'Invalid First Name';
    } else {
      _fnErr[i] = false;
      errorPresent = false;
      return '';
    }
  }

  String _lstNamelistner(lastname, i) {
    String pattern = '[a-z A-Z 0-9]';
    RegExp regex = new RegExp(pattern);
    if (lastname.isEmpty) {
      _lnErr[i] = true;
      return 'Please enter Last Name';
    } else if (lastname.length < 2) {
      _lnErr[i] = true;
      return 'Please enter minimum 2 character';
    } else if (!regex.hasMatch(lastname)) {
      _lnErr[i] = true;
      return 'Invalid Last Name';
    } else if (lastname.length >= 2 && lastname.toString().trim().length == 0) {
      return 'Invalid Last Name';
    } else {
      _lnErr[i] = false;
      errorPresent = false;

      return '';
    }
  }

  String _passPortlistner(passPortNumber, i) {
    if (widget.iSDomestic == false) {
      final passportRegex = AppTexts.passportNumberRegExp;

      if (passPortNumber.isEmpty) {
        _ppErr[i] = true;
        return passportNoValidationMsg = AppTexts.passportNumberEmpty;
      } else if (!passportRegex.hasMatch(_passportNo[i].text)) {
        _ppErr[i] = true;
        return passportNoValidationMsg = AppTexts.passportNumberValidation;
      } else if (passPortNumber.length < AppTexts.passportNoMinLimit ||
          passPortNumber.length > AppTexts.passportNoMaxLimit) {
        return passportNoValidationMsg = AppTexts.passportNumberValidation;
      } else {
        _ppErr[i] = false;
        errorPresent = false;
        return '';
      }
    } else {
      if (widget.iSDomestic == true && passPortNumber.isEmpty) {
        _ppErr[i] = false;
        errorPresent = false;
        return '';
      } else {
        if (passPortNumber.isEmpty) {
          _ppErr[i] = true;
          return  AppTexts.passportNumberEmpty;
        } else if (passPortNumber.length < AppTexts.passportNoMinLimit) {
          _ppErr[i] = true;
          return  AppTexts.passportNumberValidation;
        } else {
          _ppErr[i] = false;
          errorPresent = false;
          return '';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _primaryData() {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: AppTexts.contactDetailsText,
                  size: text_font_medium16_size,
                  color: black_color,
                  weight: FontWeight.w700,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                  text: AppTexts.mobileNumberText,
                  size: text_font_medium16_size,
                  color: AppColors.greyShade800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 3.4,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: transColor,
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

                              numberLength = countrydata.mobileNumberLength;

                              GemsGLobals.mobilenumberlength = numberLength;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3.4,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      1, 0.0, 3.0, 1.0),
                                  child: SvgPicture.asset(
                                    ImageConstants.giftdownarrow,
                                    height: 6,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                countrydata != null ||
                                        GemsGLobals.countryImage != null
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
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
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: shadow_color),
                                      ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                    width: 60,
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
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 50,
                  child: new TextFormField(
                      controller: _contactNo,
                      focusNode: _contactFocus,
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      maxLength: numberLength ?? GemsGLobals.mobilenumberlength,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                        // WhitelistingTextInputFormatter(RegExp("[0-9]"))
                      ],
                      // readOnly: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                      cursorColor: black_color,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
            Container(
              color: transColor,
              margin: EdgeInsets.only(
                  top: 5, left: MediaQuery.of(context).size.width / 3),
              alignment: Alignment.centerLeft,
              child: new TextWidget(
                text: _mobileListner(_contactNo.text),
                alignment: TextAlign.start,
                color: AppColors.redShade800,
                size: 12,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                  text: 'E-MAIL ID',
                  size: text_font_medium16_size,
                  color: AppColors.greyShade800),
            ),
            SizedBox(
              height: 40,
              child: new TextFormField(
                  controller: _emailId,
                  autofocus: false,
                  focusNode: _emailIdFocus,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: black_color,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(50),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-z0-9./:;@₹?!|_,&#+=-]')),
                    FilteringTextInputFormatter.singleLineFormatter
                    // WhitelistingTextInputFormatter(
                    //     RegExp(r'[a-zA-z0-9./:;@₹?!|_,&#+=-]')),
                    // BlacklistingTextInputFormatter.singleLineFormatter,
                  ],
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: shadow_color,
                    )),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: shadow_color)),
                  )),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: _emaillistner(_emailId.text),
                color: AppColors.redShade800,
                size: 13,
              ),
            )
          ],
        ),
      );
    }

    Widget _customRadio(String txt, int index, int j) {
      return new GestureDetector(
          onTap: () {
            changeIndex(index, j);
            setState(() {
              guestTitle.insert(j, txt);
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: (selectedIndex[j] < 0 ? 0 : selectedIndex[j]) == index
                    ? gradient_theme_color
                    : gradient_white_color,
                border: Border.all(
                  color: (selectedIndex[j] < 0 ? 0 : selectedIndex[j]) == index
                      ? blue_color
                      : Colors.grey.shade800,
                )),
            child: Center(
              child: TextWidget(
                text: txt,
                size: 16,
                weight: (selectedIndex[j] < 0 ? 0 : selectedIndex[j]) == index
                    ? FontWeight.bold
                    : null,
                color: (selectedIndex[j] < 0 ? 0 : selectedIndex[j]) == index
                    ? white_text_color
                    : AppColors.greyShade800,
              ),
            ),
          ));
    }

    void showPassportDatePicker(
        {required BuildContext context,
        required TextEditingController controller,
        required bool isIssueDate,
        required DateTime? dobDate,
        required int? index}) {
      final now = DateTime.now();
      final myFormat = DateFormat(AppTexts.bookingDateFormat, AppTexts.dateInEnUsFormat);

      DateTime minDate = isIssueDate ? (dobDate ?? now) : now;
      DateTime maxDate =
          isIssueDate ? now : DateTime(now.year + 10, now.month, now.day);

      DatePicker.showDatePicker(
        context,
        pickerTheme: DateTimePickerTheme(
          showTitle: true,
          confirm: Text(
            AppTexts.doneText,
            style: TextStyle(
              color: blue_color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        minDateTime: minDate,
        maxDateTime: maxDate,
        initialDateTime: minDate,
        dateFormat: AppTexts.bookingDateFormat,
        locale: DateTimePickerLocale.en_us,
        onConfirm: (dateTime, _) {
          setState(() {
            controller.text = myFormat.format(dateTime);

            if (isIssueDate) {
              passportIssueDate = dateTime;
              _passPortIssueList[index ?? 0] = {AppTexts.dateText: passportIssueDate};

              if (passportExpiryDate != null &&
                  passportIssueDate!.isAfter(passportExpiryDate!)) {
                isIssueDateValidList[index ?? 0] = false;
              } else {
                isIssueDateValidList[index ?? 0] = true;
              }
            } else {
              passportExpiryDate = dateTime;
              _passPortExpiryList[index ?? 0] = {AppTexts.dateText: passportExpiryDate};

              final issueDate = _passPortIssueList[index ?? 0]?['date'];

              if (issueDate != null && dateTime.isBefore(issueDate)) {
                isExpiryDateValidList[index ?? 0] = false;
              } else {
                isExpiryDateValidList[index ?? 0] = true;
              }
            }
          });
        },

       
      );
    }

    Widget _guestData() {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _guestCount < 0 ? 0 : _guestCount,
          itemBuilder: (context, j) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                  text: "${_titleText[j]}",
                  size: text_font_medium16_size,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 10,
                ),
                TextWidget(
                    text: AppTexts.titleText,
                    size: text_font_medium16_size,
                    color: AppColors.greyShade800),
                SizedBox(
                  height: 10,
                ),
                _titleText[j].contains("Infant") ||
                        _titleText[j].contains("Child")
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _customRadio(title[0], 0, j),
                            SizedBox(
                              width: 15,
                            ),
                            _customRadio(title[1], 1, j),
                          ],
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _customRadio(title[0], 0, j),
                            _customRadio(title[1], 1, j),
                            _customRadio(title[2], 2, j),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                TextWidget(
                    text: AppTexts.firstNameText,
                    size: text_font_medium16_size,
                    color: AppColors.greyShade800),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                      controller: _firstName[j],
                      autofocus: false,
                      focusNode: _fnFocus[j],
                      keyboardType: TextInputType.text,
                      cursorColor: black_color,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                           AppTexts.inputRegexFirstName)
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: shadow_color,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: shadow_color)),
                      )),
                ),
                _checkValidation && _fnErr[j] == true
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: TextWidget(
                          text: _firstNamelistner(_firstName[j].text, j),
                          color: AppColors.redShade800,
                          size: text_font_size_x_small,
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(
                  height: 30,
                ),
                TextWidget(
                    text: AppTexts.lastNameText,
                    size: text_font_medium16_size,
                    color: AppColors.greyShade800),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                      controller: _lastName[j],
                      autofocus: false,
                      focusNode: _lnFocus[j],
                      keyboardType: TextInputType.text,
                      cursorColor: black_color,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                           AppTexts.inputRegexFirstName)
                       
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: shadow_color,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: shadow_color)),
                      )),
                ),
                _checkValidation && _lnErr[j] == true
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: TextWidget(
                          text: _lstNamelistner(_lastName[j].text, j),
                          color: AppColors.redShade800,
                          size: text_font_size_x_small,
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_titleText[j].contains("Infant")) {
                      _min = DateTime(DateTime.now().year - 2,
                          DateTime.now().month, DateTime.now().day+1);
                      _dateTime = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day - 1);
                      setState(() {});
                    } else if (_titleText[j].contains("Child")) {

                      _min = DateTime(DateTime.now().year - 12,
                          DateTime.now().month, DateTime.now().day+1);
                      _dateTime = DateTime(DateTime.now().year - 2,
                          DateTime.now().month, DateTime.now().day - 1);
                      setState(() {});
                    } else {
                      _min = DateTime(DateTime.now().year - 100,
                          DateTime.now().month, DateTime.now().day);
                      _dateTime = DateTime(DateTime.now().year - 13,
                          DateTime.now().month, DateTime.now().day - 1);
                      setState(() {});
                    }
                    showDatePicker(context, _dob[j], j);
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 6.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new TextWidget(
                                text: AppTexts.dateOfBirthText,
                                size: text_font_medium16_size,
                                color: AppColors.greyShade800),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: shadow_color),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: new TextFormField(
                                      controller: _dob[j],
                                      autofocus: false,
                                      focusNode: _dobFocus[j],
                                      keyboardType: TextInputType.datetime,
                                      cursorColor: black_color,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                dobEmpty[j] == 'true'
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        child: new TextWidget(
                            text: AppTexts.dateOfBirthEmpty,
                            size: text_font_size_x_small,
                            color: AppColors.redShade800),
                      )
                    : new SizedBox(),
                SizedBox(
                  height: 30,
                ),
               isInternational
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: AppTexts.passportNumber,
                              size: text_font_medium16_size,
                              color: AppColors.greyShade800),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                                controller: _passportNo[j],
                                autofocus: false,
                                focusNode: _passportFocus[j],
                                cursorColor: black_color,
                                maxLength: 30,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                  FilteringTextInputFormatter.allow(
                                      AppTexts.inputRegexPassportNumber),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    bool passPortValid = AppTexts
                                        .passportNumberRegExp
                                        .hasMatch(_passportNo[j].text);
                                    if (passPortValid == true) {
                                      setState(() {
                                        _ppErr[j] = false;
                                      });
                                    } else {
                                      setState(() {
                                        _ppErr[j] = true;
                                      });
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: shadow_color,
                                  )),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: shadow_color)),
                                )),
                          ),
                          _checkValidation && _ppErr[j] == true
                              ? Container(
                                  margin: EdgeInsets.only(top: 5),
                                  alignment: Alignment.centerLeft,
                                  child: TextWidget(
                                    text: _passPortlistner(
                                        _passportNo[j].text, j),
                                    color: AppColors.redShade800,
                                    size: text_font_size_x_small,
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextWidget(
                              text: AppTexts.passportIssueDate,
                              size: text_font_medium16_size,
                              color: AppColors.greyShade800),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: grey600_color),
                              ),
                              color: white_color,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showPassportDatePicker(
                                    context: context,
                                    controller: _passportIssueDate[j],
                                    isIssueDate: true,
                                    dobDate: _dateTime,
                                    index: j);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _passportIssueDate[j],
                                  autofocus: false,
                                  focusNode: _passportIssueFocus[j],
                                  keyboardType: TextInputType.datetime,
                                  cursorColor: black_color,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!isIssueDateValidList[j])
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: AppTexts.passportIssueDateValidation,
                                color: AppColors.redShade800,
                                size: text_font_size_x_small,
                              ),
                            ),
                          SizedBox(height: 20),
                          new TextWidget(
                              text: AppTexts.passportExpiryDate,
                              size: text_font_medium16_size,
                              color: AppColors.greyShade800),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: grey600_color),
                              ),
                              color: white_color,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showPassportDatePicker(
                                    context: context,
                                    controller: _passportExpiryDate[j],
                                    isIssueDate: false,
                                    dobDate: null,
                                    index: j);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _passportExpiryDate[j],
                                  autofocus: false,
                                  focusNode: _passportExpiryFocus[j],
                                  keyboardType: TextInputType.datetime,
                                  cursorColor: black_color,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!isExpiryDateValidList[j])
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: AppTexts.passportExpiryDateValidation,
                                color: AppColors.redShade800,
                                size: text_font_size_x_small,
                              ),
                            ),
                          SizedBox(height: 20),
                          TextWidget(
                              text: GemsGLobals.nationalityText.toUpperCase(),
                              size: text_font_medium16_size,
                              color: AppColors.greyShade800),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: grey600_color),
                              ),
                              color: white_color,
                            ),
                            child: TextFormField(
                              controller: nationalityControllers[j],
                              focusNode: _nationalityFocusNodes[j],
                              readOnly: true,
                              onTap: () async {
                                setState(() {
                                  validateNationalityList[j] = false;
                                });

                                final nationality = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Nationality(
                                      nationalityData: nationalityList,
                                    ),
                                  ),
                                );

                                if (nationality != null) {
                                  setState(() {
                                    nationalityLocalList[j] =
                                        nationality.name ?? '';
                                    nationalityControllers[j].text =
                                        nationalityLocalList[j] ?? '';
                                  });
                                }
                                if (nationality == null &&
                                    nationalityLocalList[j] != null) {
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 10, 0, 10),
                                hintText: nationalityLocalList[j] == '' ||
                                        nationalityLocalList[j] ==
                                            GemsGLobals.selectNationalityText
                                    ? GemsGLobals.selectNationalityText
                                    : nationalityLocalList[j],
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                              ),
                              style: TextStyle(color: black_color),
                            ),
                          ),
                          validateNationalityList[j] == true
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 0, top: 5),
                                  child: TextWidget(
                                    text: GemsGLobals.nationalityErrorText,
                                    color: AppColors.redShade800,
                                    size: text_font_size_small,
                                  ),
                                )
                              : Container(height: 0),
                          SizedBox(height: 20),
                          TextWidget(
                              text: AppTexts.passportIssueCountryText,
                              size: text_font_medium16_size,
                              color: AppColors.greyShade800),
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: grey600_color),
                                ),
                                color: white_color,
                              ),
                              child: GestureDetector(
                                  onTap: () async {
                                    var _countrydata = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (cxt) =>
                                                CountryCodeListPage(
                                                  countryListData:
                                                      countryCodeData,
                                                )));

                                    setState(() {
                                      issueCountryData = _countrydata;
                                      validateIssueCountryList[j] = false;

                                      issueCountryList[j] =
                                          issueCountryData.name ?? '';
                                    });
                                  },
                                  child: TextFormField(
                                    controller: _passportIssueCountry[j],
                                    focusNode: _passportIssueCountryFocus[j],
                                    readOnly: true,
                                    onTap: () async {
                                      var _countrydata = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (cxt) =>
                                                  CountryCodeListPage(
                                                    countryListData:
                                                        countryCodeData,
                                                  )));

                                      setState(() {
                                        issueCountryData = _countrydata;
                                        issueCountryList[j] =
                                            issueCountryData.name ?? '';
                                        _passportIssueCountry[j].text =
                                            issueCountryList[j];
                                        validateIssueCountryList[j] = false;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: "",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      hintText: issueCountryList[j] == ''
                                          ? AppTexts.selectCountryText
                                          : issueCountryList[j],
                                      suffixIcon: Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                    ),
                                    style: TextStyle(color: black_color),
                                  ))),
                          validateIssueCountryList[j] == true
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 0, top: 5),
                                  child: TextWidget(
                                    text: AppTexts.countryErrorText,
                                    color: AppColors.redShade800,
                                    size: text_font_size_small,
                                  ),
                                )
                              : Container(height: 0)
                        ],
                      )
                    : SizedBox()
              ],
            );
          },
        ),
      );
    }

    void _validations() {
      for (var l = 0; l < _guestCount; l++) {
        if (_dob[l].text.isEmpty) {
          dobEmpty[l] = 'true';
          _validDOB.add(true);
        } else {
          dobEmpty[l] = 'false';
        }
        if (_firstName[l].text.length < 2) {
          _fnErr[l] = true;
          _fnvalidate.add(true);
        }

        if (_firstName[l].text.trim().length == 0) {
          _fnErr[l] = true;
          _fnvalidate.add(true);
        }

        if (_lastName[l].text.length < 2) {
          _lnErr[l] = true;
          _lnValidate.add(true);
        }
        if (_lastName[l].text.trim().length == 0) {
          _lnErr[l] = true;
          _lnValidate.add(true);
        }
        if (isInternational) {
          if (_passportNo[l].text.length < 2) {
            if (widget.iSDomestic == true && _passportNo[l].text.isNotEmpty) {
              _passportValidate.add(true);
              _ppErr[l] = true;
            } else if (widget.iSDomestic == false) {
              final passportRegex = AppTexts.passportNumberRegExp;

              if (!passportRegex.hasMatch(_passportNo[l].text)) {
                _ppErr[l] = true;
                _passportValidate.add(true);
              } else {
                _ppErr[l] = true;
                _passportValidate.add(true);
              }
            }
          }
        }
      }
    }

    void _guestDetails() {
      setState(() {
        _checkValidation = false;
        _guestDataDel.clear();
        _adultInfo.clear();
        _childInfo.clear();
        _infantInfo.clear();

        for (int l = 0; l < _guestCount; l++) {
          if (_titleText[l].contains("Adult")) {
            _adultInfo.add({
              "title": guestTitle[l],
              "first_name": _firstName[l].text,
              "last_name": _lastName[l].text,
              "email_id": "",
              "dob": flightDobFrmt(_dobList[l][AppTexts.dateText]),
              "passport_no": isInternational ? _passportNo[l].text : '',
              "passport_exp_date": isInternational
                  ? flightPassportDateFormat(_passPortExpiryList[l][AppTexts.dateText])
                  : '',
              "passport_issue_date": isInternational
                  ? flightPassportDateFormat(_passPortIssueList[l][AppTexts.dateText])
                  : '',
              "nationality":
                  isInternational ? nationalityControllers[l].text : '',
              "passport_issue_country":
                  isInternational ? _passportIssueCountry[l].text : '',
            });
          } else if (_titleText[l].contains("Child")) {
            _childInfo.add({
              "title": guestTitle[l],
              "first_name": _firstName[l].text,
              "last_name": _lastName[l].text,
              "email_id": "",
              "dob": flightDobFrmt(_dobList[l][AppTexts.dateText]),
              "passport_no": isInternational ? _passportNo[l].text : '',
              "passport_exp_date": isInternational
                  ? flightPassportDateFormat(_passPortExpiryList[l][AppTexts.dateText])
                  : '',
              "passport_issue_date": isInternational
                  ? flightPassportDateFormat(_passPortIssueList[l][AppTexts.dateText])
                  : '',
              "nationality":
                  isInternational ? nationalityControllers[l].text : '',
              "passport_issue_country":
                  isInternational ? _passportIssueCountry[l].text : '',
            });
          } else if (_titleText[l].contains("Infant")) {
            _infantInfo.add({
              "title": guestTitle[l],
              "first_name": _firstName[l].text,
              "last_name": _lastName[l].text,
              "email_id": "",
              "dob": flightDobFrmt(_dobList[l][AppTexts.dateText]),
              "passport_no": isInternational ? _passportNo[l].text : '',
              "passport_exp_date": isInternational
                  ? flightPassportDateFormat(_passPortExpiryList[l][AppTexts.dateText])
                  : '',
              "passport_issue_date": isInternational
                  ? flightPassportDateFormat(_passPortIssueList[l][AppTexts.dateText])
                  : '',
              "nationality":
                  isInternational ? nationalityControllers[l].text : '',
              "passport_issue_country":
                  isInternational ? _passportIssueCountry[l].text : '',
            });
          }
          _guestDataDel.insert(l, {
            "title": guestTitle[l],
            "first_name": _firstName[l].text,
            "last_name": _lastName[l].text,
            "email_id": "",
            "dob": flightDobFrmt(_dobList[l][AppTexts.dateText]),
            "passport_no": isInternational ? _passportNo[l].text : '',
            "passport_exp_date": isInternational
                ? flightPassportDateFormat(_passPortExpiryList[l][AppTexts.dateText])
                : '',
            "passport_issue_date": isInternational
                ? flightPassportDateFormat(_passPortIssueList[l][AppTexts.dateText])
                : '',
            "nationality":
                isInternational ? nationalityControllers[l].text : '',
            "passport_issue_country":
                isInternational ? _passportIssueCountry[l].text : '',
          });
          print("---------->>>");
          print(_guestDataDel[l]);
        }

        _detail = [
          {
            "istravelling": isstaying,
            "contact_no": _contactNo.text,
            "country_code": countrydata != null
                ? "+${countrydata.countryCode}"
                : GemsGLobals.countryCode != null
                    ? "+${GemsGLobals.countryCode}"
                    : "",
            "email_id": _emailId.text,
            "details": _guestDataDel,
            "adult_list": _adultInfo,
            "child_list": _childInfo,
            "infant_list": _infantInfo,
          }
        ];
      });

      CheckInternet().apiCall().then((value) {
        if (value == true) {
          setState(() {});
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReviewItenirary(
                        flightDetailsModel: widget.flightDetailsModel,
                        returnJrnyDetailsFlightModel:
                            widget.returnJrnyDetailsFlightModel,
                        tripTyp: widget.tripTyp,
                        tripSubTyp: widget.tripSubTyp,
                        paymentTyp: widget.paymentTyp,
                        guestInfo: _detail,
                        flightRequestHolder: flightRequestHolder!,
                        guestData: widget.guestData,
                        baseprice: widget.baseprice,
                        taxprice: widget.taxprice,
                        totatPrice: widget.totatPrice,
                      
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NoInternet()));
        }
      });
    }

    Widget _continueBtn() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: white_text_color,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: GradientButtonWidget(
                  onTap: () {
                    setState(() {
                      _checkValidation = true;
                      _validDOB.clear();
                      _fnvalidate.clear();
                      _lnValidate.clear();
                      _passportValidate.clear();

                      _emailValidator();
                      _validations();

                      bool allFieldsValid = true;

                      if (_contactNo.text.isEmpty ||
                          _contactNo.text.length !=
                              (numberLength ??
                                  GemsGLobals.mobilenumberlength)) {
                        contactEmpty = true;
                        allFieldsValid = false;
                      } else {
                        contactEmpty = false;
                      }

                      if (_emailId.text.isEmpty ||
                          _emaillistner(_emailId.text).isNotEmpty) {
                        _emialVal = true;
                        allFieldsValid = false;
                      } else {
                        _emialVal = false;
                      }

                      for (int j = 0; j < _guestCount; j++) {
                        if (_firstName[j].text.isEmpty ||
                            _firstName[j].text.length < 2 ||
                            _firstNamelistner(_firstName[j].text, j)
                                .isNotEmpty) {
                          _fnErr[j] = true;
                          allFieldsValid = false;
                        }
                        if (_lastName[j].text.isEmpty ||
                            _lastName[j].text.length < 2 ||
                            _lstNamelistner(_lastName[j].text, j).isNotEmpty) {
                          _lnErr[j] = true;
                          allFieldsValid = false;
                        }
                        if (_dob[j].text.isEmpty) {
                          dobEmpty[j] = 'true';
                          allFieldsValid = false;
                        }

                        if (isInternational) {
                          if (_passPortlistner(_passportNo[j].text, j)
                              .isNotEmpty) {
                            _ppErr[j] = true;
                            allFieldsValid = false;
                          }
                          if (_passportIssueDate[j].text.isEmpty) {
                            isIssueDateValidList[j] = false;
                            allFieldsValid = false;
                          } else {
                            isIssueDateValidList[j] = true;
                          }
                          if (_passportExpiryDate[j].text.isEmpty) {
                            isExpiryDateValidList[j] = false;
                            allFieldsValid = false;
                          } else {
                            isExpiryDateValidList[j] = true;
                          }
                          if (_passportIssueDate[j].text.isNotEmpty &&
                              _passportExpiryDate[j].text.isNotEmpty) {
                            try {
                              DateTime issue = DateFormat(AppTexts.bookingDateFormat)
                                  .parse(_passportIssueDate[j].text);
                              DateTime expiry = DateFormat(AppTexts.bookingDateFormat)
                                  .parse(_passportExpiryDate[j].text);
                              if (!expiry.isAfter(issue)) {
                                isExpiryDateValidList[j] = false;
                                isIssueDateValidList[j] = false;
                                allFieldsValid = false;
                              }
                            } catch (_) {
                              isExpiryDateValidList[j] = false;
                              isIssueDateValidList[j] = false;
                              allFieldsValid = false;
                            }
                          }
                          if (nationalityControllers[j].text.isEmpty ||
                              nationalityControllers[j].text ==
                                  GemsGLobals.selectNationalityText) {
                            validateNationalityList[j] = true;
                            allFieldsValid = false;
                          } else {
                            validateNationalityList[j] = false;
                          }
                          if (_passportIssueCountry[j].text.isEmpty) {
                            validateIssueCountryList[j] = true;
                            allFieldsValid = false;
                          } else {
                            validateIssueCountryList[j] = false;
                          }
                        }
                      }

                      if (_fnvalidate.length == 0 &&
                          _lnValidate.length == 0 &&
                          _validDOB.length == 0 &&
                          _passportValidate.length == 0 &&
                          contactEmpty == false &&
                          _emialVal == false &&
                          allFieldsValid) {
                        if (!checkedValue) {
                          setState(() {
                            checkTerms = true;
                          });
                        } else {
                          scrollController?.animateTo(
                              scrollController!.position.maxScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {
                            errorPresent = false;
                            checkTerms = false;
                            _guestDetails();
                          });
                        }
                      } else {
                        setState(() {
                          errorPresent = true;
                        });
                        if (contactEmpty == true) {
                          FocusScope.of(context).requestFocus(_contactFocus);
                        } else if (_emialVal == true) {
                          FocusScope.of(context).requestFocus(_emailIdFocus);
                        } else {
                          for (int j = 0; j < _guestCount; j++) {
                            if (_fnvalidate.length > 0) {
                              if (_firstName[j].text.length < 2) {
                                FocusScope.of(context)
                                    .requestFocus(_fnFocus[j]);
                                break;
                              }
                            }
                            if (_lnValidate.length > 0) {
                              if (_lastName[j].text.length < 2) {
                                FocusScope.of(context)
                                    .requestFocus(_lnFocus[j]);
                                break;
                              }
                            }
                          }
                        }
                      }
                    });
                  },
                  color: star_yellow_color,
                  child: TextWidget(
                    text: 'Next',
                    size: text_font_medium17_size,
                    color: white_text_color,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _termsCondtn() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                checkedValue = !checkedValue;
                if (checkedValue) {
                  checkTerms = false;
                } else {
                  // checkTerms = true;
                }
              });
            },
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 1.0, 6.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    !checkedValue
                        ? Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: Color(0XFFA5A7AD),
                              ),
                            ))
                        : Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: Color(0XFFA5A7AD),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                ImageConstants.select,
                                height: 10,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: "I agree with the",
                      color: grey600_color,
                      size: text_font_size_x_small,
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForYouWeb(
                          appbarname: "Terms and Conditions",
                          weburl:
                              "https://www.gemsrewards.com/terms-and-conditions",
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 3.0),
              child: TextWidget(
                text: "terms and conditions",
                color: Color.fromRGBO(45, 76, 179, 1),
                decoration: TextDecoration.underline,
                size: text_font_size_x_small,
              ),
            ),
          )
        ],
      );
    }

    Widget _body() {
      try {
        return SingleChildScrollView(
          controller: scrollController,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              color: white_text_color,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(10, 5.0, 6.0, 5.0),
                    decoration: BoxDecoration(
                        color: bg_color,
                        borderRadius: BorderRadius.circular(30)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isstaying = !isstaying;

                          if (isstaying) {
                            _firstName[0].text = GemsGLobals.userFirstName !=
                                    null
                                ? "${GemsGLobals.userFirstName![0] + GemsGLobals.userFirstName!.substring(1)}"
                                : "";
                            _lastName[0].text = GemsGLobals.userLastName![0] +
                                GemsGLobals.userLastName!.substring(1);
                            _emailId.text = GemsGLobals.useremail;
                            _contactNo.text = GemsGLobals.mobilenumber;
                           
                          } else {
                            _firstName[0].clear();
                            _lastName[0].clear();
                            _emailId.clear();
                            _contactNo.clear();
                            _dob[0].clear();
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          isstaying == false
                              ? Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0XFFA5A7AD),
                                    ),
                                  ))
                              : Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0XFFA5A7AD),
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      ImageConstants.select,
                                      height: 10,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new TextWidget(
                              text: "I am travelling",
                              size: text_font_medium16_size,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: grey600_color,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Traveller Details',
                    size: text_font_medium16_size,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _guestData(),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _primaryData(),
                  SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: 'Booking details will be sent to mentioned Email ID.',
                    size: text_font_size_x_small,
                    color: Colors.grey[600],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _termsCondtn(),
                  checkTerms
                      ? Container(
                          child: new TextWidget(
                            text:
                                '* You must agree with the Terms and Condition',
                            size: text_font_size_x_small,
                            color: Colors.red[800],
                          ),
                        )
                      : new Container(),
                  _continueBtn(),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        );
      } catch (e) {
        return Container();
      }
    }

    PreferredSizeWidget _appbar() {
      return PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: Container(
                  margin: Platform.isIOS?EdgeInsets.only(left: 20) :EdgeInsets.only(left: 10),
                  height: Platform.isIOS? 50:40,
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
              Container(
                width: MediaQuery.of(context).size.width - 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextWidget(
                            text: widget.flightRequestHolder!.originCity ?? '',
                            weight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            size: text_font_medium17_size,
                            color: white_text_color,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          new Container(
                            child: LimitedBox(
                              child: widget.tripTyp == "1"
                                  ? Container(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Image.asset(
                                        ImageConstants.flt_single_arrow,
                                        height: 7,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : Image.asset(
                                      ImageConstants.flt_arrowswitch,
                                      height: 10,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: widget.flightRequestHolder!.destinationCity ??
                                '',
                            weight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            size: text_font_medium17_size,
                            color: white_text_color,
                          )
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: TextWidget(
                            text: "${stringToDateAndDateToStringFormatter()}",
                            color: white_text_color,
                            size: text_font_size_x_small,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        TextWidget(
                          text: "|",
                          size: text_font_size_x_small,
                          color: white_text_color,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        TextWidget(
                          text:
                              "${widget.guestData != null ? this.widget.guestData.adultNumber : 1}"
                              "${this.widget.guestData.adultNumber > 1 ? " Adults" : " Adult"} "
                              "${widget.guestData != null ? widget.guestData.childNumber > 0 ? widget.guestData.childNumber : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.childNumber > 1 ? " Children " : widget.guestData.childNumber == 1 ? " Child " : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.infentNumber > 0 ? widget.guestData.infentNumber : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.infentNumber > 1 ? " Infants " : widget.guestData.infentNumber == 1 ? " Infant " : "" : ""}"
                              "|"
                              " ${widget.guestData != null ? widget.guestData.cabinClassName : "Economy"}",
                          color: white_text_color,
                          size: text_font_size_x_small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ));
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: white_text_color,
            appBar: _appbar(),
            body: _body(),
          )),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
