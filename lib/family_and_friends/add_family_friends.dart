import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/bottombar1.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/family_and_friends/nationality_list.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../common_widget/bottombar.dart';
import '../utils/constants_files/text_constants.dart';

class AddFamilyAndFriends extends StatefulWidget {
  @override
  State<AddFamilyAndFriends> createState() => _AddFamilyAndFriendsState();
}

class _AddFamilyAndFriendsState extends State<AddFamilyAndFriends> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController isdController = TextEditingController();
  TextEditingController nationalController = TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  bool _showError = true;
  FocusNode? focusNode;
  int _radioSelected = 1;
  String _radioVal = 'Male';

  String _genderValue = 'M';
  bool enableList = false;
  int? _selectedIndex;

  String? selectedCountryCode = "971";
  String? selectedRelationship = "Relationship";
  String? selectedRelationshipName;
  String? dobcheckRelation;

  var dropdownValue;
  MasterListModel? _masterListModel;
  List<Emirate>? fnfRelationshipList;
  String? _relation;
  List<dynamic>? nationalityList;
  var nationalityLocal;
  bool? validateNationality = false;
  bool? validateRelation = false;
  bool? validatedob = false;
  int? mobilenumberlength = 9;
  String? _countryFlag;
  String? _format = 'dd MMMM yyyy';
  DateTime? _dateTime;
  var dateTimedate = DateTime.parse("2020-06-21 18:28:04");
  String? _dob;
  var currentdobDate;
  var _dobError;

  var dateFormate;
  String? countryImage;

  List dummyList = [];
  var _nationality;
  String? nation = "Nationality";
  bool? isLoadinAddRef = false;
  List<dynamic>? countryCodeList;
  /* Email Validation*/
  String? validateEmail(String? data) {
    String value = data ?? '';
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter an email id';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email id';
    } else {
      return null;
    }
  }

  /* Mobile Validation*/
  String? validateMobile(String? data) {
    String value = data ?? '';
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (value.length != mobilenumberlength!) {
      return 'Please enter $mobilenumberlength digit mobile number';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    fetchMasterListData();
    super.initState();
  }

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);

      fnfRelationshipList = _masterListModel!.values!.fnfRelationship;
      nationalityList = _masterListModel!.values!.nationality;
      countryCodeList = _masterListModel!.values!.countryList;
    });
  }

  Widget _relationshipoption() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            var data = await showModalBottomSheet(
                backgroundColor: white_text_color,
                context: context,
                builder: (context) {
                  return relationshipBottomSheet(fnfRelationshipList);
                });
            setState(() {
              enableList = !enableList;
              selectedRelationship = data.code;
              selectedRelationshipName = data.name;

              validateRelation = false;

              var spiltdata = selectedRelationship.toString().split(" ");

              dobcheckRelation = spiltdata[0];
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: white_text_color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade400)),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: TextWidget(
                  text: selectedRelationship,
                  size: text_font_medium_x_size,
                  color: black_color,
                  weight: FontWeight.normal,
                  softwrap: false,
                )),
                
                Icon(
                  Icons.expand_more,
                  size: 24.0,
                )
              
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BottomBar(
        initialIndex: 2,
        tabvalue: "myaccount",
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
        backgroundColor: grey100_color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: AppTexts.addFamilyAndFriendsText,
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            _addForm(),
          ],
        )),
        bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }

  void showDatePicker(BuildContext context, _date) {
    var myFormat = DateFormat('dd/MM/yyyy', 'en_us');

    DatePicker.showDatePicker(context,
        pickerTheme: DateTimePickerTheme(
          showTitle: true,
          confirm: Text(
            "Done",
            style: TextStyle(
                color: blue_color, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        initialDateTime: DateTime.now(),
        minDateTime: new DateTime.now().subtract(
            selectedRelationshipName == GemsGLobals.selectedRelationship
                ? new Duration(days: (365.242189 * 20).floor())
                : new Duration(days: (365.242189 * 15).floor())),
        maxDateTime: new DateTime.now().subtract(
            selectedRelationshipName == GemsGLobals.selectedRelationship
                ? new Duration(days: (365.242189 * 16).floor())
                : new Duration(days: (365.242189 * 5).floor())),
        locale: DateTimePickerLocale.en_us,
        onMonthChangeStartWithFirstDate: false,
        pickerMode: DateTimePickerMode.date,
        dateFormat: _format, onConfirm: (dateTime, List<int> index) {
      _dateTime = dateTime;
      dateFormate =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(_dateTime.toString()));
      dateTimedate = _dateTime!;
      _date.value =
          TextEditingValue(text: myFormat.format(dateTime).toString());
    });
  }

  Widget _addForm() {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              textFieldWidget('First Name', fnameController, (String? arg) {
                if ((arg ?? '').isEmpty) {
                  return "Please enter first name";
                } else {
                  return null;
                }
              }, null, TextInputType.text, null, false),
              SizedBox(
                height: 10,
              ),
              textFieldWidget('Last Name', lnameController, (String? arg) {
                if ((arg ?? '').isEmpty) {
                  return "Please enter last name";
                } else {
                  return null;
                }
              }, null, TextInputType.text, null, false),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: 'Gender',
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: "*",
                        color: red_color,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: white_text_color,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400)),
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _radioSelected,
                              activeColor: green_color,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as int;
                                  _radioVal = 'Male';
                                  _genderValue = 'M';
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _radioSelected = 1;
                                    _radioVal = 'Male';
                                    _genderValue = 'M';
                                  });
                                },
                                child: Text('Male')),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.4,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: white_text_color,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400)),
                        child: Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: _radioSelected,
                              activeColor: green_color,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as int;
                                  _radioVal = 'Female';
                                  _genderValue = 'F';
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _radioSelected = 2;
                                    _radioVal = 'Female';
                                    _genderValue = 'F';
                                  });
                                },
                                child: Text('Female'))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              textFieldWidget('Email', emailController, (String? arg) {
                return validateEmail(arg);
              }, null, TextInputType.emailAddress, null, false),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TextWidget(
                              text: 'Mobile No',
                              color: grey600_color,
                            ),
                            TextWidget(
                              text: "*",
                              color: red_color,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var data = await showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                backgroundColor: white_text_color,
                                context: context,
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      countryBottomSheet(countryCodeList)
                                    ],
                                  );
                                });

                            setState(() {
                              selectedCountryCode = data.countryCode;
                              mobilenumberlength = data.mobileNumberLength;

                              countryImage = data.image;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: white_text_color,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_down_rounded),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: countryImage == null ||
                                                countryImage == ""
                                            ? NetworkImage(
                                                'http://44.199.170.200:8082/uploads/images/countries/AE.jpg')
                                            : NetworkImage('$countryImage'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                TextWidget(
                                  text: "+$selectedCountryCode",
                                  color: flight_text_black_color,
                                  size: text_font_medium15_size,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 7),
                        child: textFieldWidget(
                          '',
                          mobileController,
                          (String? arg) {
                            return validateMobile(arg);
                          },
                          null,
                          TextInputType.numberWithOptions(
                              signed: true, decimal: false),
                          null,
                          false,
                        )),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Relationship',
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: "*",
                        color: red_color,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _relationshipoption(),
                  validateRelation == true
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: TextWidget(
                            text: "Please select Relationship",
                            color: Colors.red,
                            size: text_font_size_small,
                          ),
                        )
                      : Container(height: 0),
                ],
              ),
              dobcheckRelation.toString().toLowerCase() == "child" ||
                      dobcheckRelation.toString().toLowerCase() == "junior"
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: 'DOB',
                              color: grey600_color,
                            ),
                            TextWidget(
                              text: "*",
                              color: red_color,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDatePicker(context, _dobController);
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width / 1,
                            decoration: BoxDecoration(
                                color: white_text_color,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: AbsorbPointer(
                              child: TextFormField(
                                style: TextStyle(
                                    color: black_color,
                                    fontWeight: FontWeight.normal),
                                validator: (String? arg) {
                                  Duration dur =
                                      DateTime.now().difference(dateTimedate);
                                  String differenceInYears =
                                      (dur.inDays / 365).floor().toString();

                                  currentdobDate = new DateFormat("yyyy-MM-dd")
                                      .format(dateTimedate);

                                  return null;
                                },
                                onSaved: (String? val) {
                                  _dob = val;
                                },
                                onChanged: (String? val) {
                                  validatedob = false;
                                },
                                controller: _dobController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    hintText: "",
                                    labelStyle: TextStyle(
                                        fontSize: text_font_medium_size,
                                        color: black_color,
                                        fontWeight: FontWeight.normal),
                                    contentPadding:
                                        new EdgeInsets.only(top: 0, bottom: 5),
                                    
                                    hintStyle: TextStyle(
                                        fontSize: text_font_medium_size,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    counterText: "",
                                    errorMaxLines: 2,
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        validatedob == true
                            ? Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 7, top: 5),
                                child: TextWidget(
                                  text: "Please enter date of birth",
                                  color: Colors.red,
                                  size: text_font_size_small,
                                ),
                              )
                            : Container(height: 0),
                      ],
                    )
                  : Container(height: 0),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Nationality',
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: "*",
                        color: red_color,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        validateNationality = false;
                      });

                      _nationality = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Nationality(
                                    nationalityData: nationalityList,
                                  )));

                      if (_nationality != null) {
                        setState(() {
                          nationalityLocal = _nationality!.name;
                        });
                      }
                      if (_nationality == null && nationalityLocal != null) {
                        setState(() {
                          _nationality = nationalityLocal;
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                          color: white_text_color,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextWidget(
                              text: _nationality == null
                                  ? (nationalityLocal == null
                                      ? nation
                                      : nationalityLocal)
                                  : _nationality!.name,
                              color: nationalityLocal == null
                                  ? black_color
                                  : black_color,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                  validateNationality == true
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 7, top: 5),
                          child: TextWidget(
                            text: "Please select Nationality",
                            color: Colors.red,
                            size: text_font_size_small,
                          ),
                        )
                      : Container(height: 0),
                ],
              ),
              _submitBtn(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget countryBottomSheet(countryCodeList) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: countryCodeList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, countryCodeList[index]);
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                  bottom: 5,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 55,
                          child: TextWidget(
                            text: '+${countryCodeList[index].countryCode}',
                            color: purchase_text_color,
                            size: text_font_medium15_size,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        countryCodeList[index].image != null ||
                                countryCodeList[index].image != ""
                            ? Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                         
                                          NetworkImage(
                                              '${countryCodeList[index].image}'),
                                      
                                      fit: BoxFit.fill),
                                ),
                              )
                            : Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          AssetImage(ImageConstants.noimages),
                                      fit: BoxFit.fill),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                       
                        Expanded(
                          child: TextWidget(
                            text: countryCodeList[index].name,
                            color: purchase_text_color,
                            size: text_font_medium15_size,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget relationshipBottomSheet(countryCodeList) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: countryCodeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, fnfRelationshipList![index]);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: TextWidget(
                            text: fnfRelationshipList![index].code,
                            size: text_font_medium16_size,
                            color: black_color,
                            weight: FontWeight.normal,
                            softwrap: false,
                          )),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget textFieldWidget(
      String? label,
      TextEditingController _controller,
      String? Function(String?) validator,
      String? suffix,
      TextInputType? keyboardType,
      String? hintText,
      bool readOnly,
      [List<TextInputFormatter>? inputFormatters]) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: label,
                color: grey600_color,
              ),
              _controller != mobileController
                  ? TextWidget(
                      text: "*",
                      color: red_color,
                    )
                  : Container(
                      width: 0,
                    )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
              controller: _controller,
              onTap: () {
                _showError = false;
              },
              readOnly: readOnly,
              decoration: _textFormStyle(suffix, hintText),
              maxLength: label == '' ? mobilenumberlength : 50,
              textCapitalization: _controller == fnameController ||
                      _controller == lnameController
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              inputFormatters: _controller == mobileController
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : (_controller == fnameController ||
                          _controller == lnameController
                      ? [
                          FilteringTextInputFormatter.deny(new RegExp(
                              '[0-9π!@#\$%^&*(()" "\'_=+-\:;.,<>?/|~{}£¢€¥^°π√|¶∆÷×✓™®©`•|₹\\[\\]\\\\]'))
                        ]
                      : null),
              keyboardType: keyboardType,
              validator: validator),
        ],
      ),
    );
  }

  Widget _submitBtn() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0XFF4CD080),
      ),
      margin: EdgeInsets.only(top: 15),
      child: MaterialButton(
        child: isLoadinAddRef == false
            ? TextWidget(
                text: "Submit",
                color: Colors.white,
                size: text_font_medium17_size,
              )
            : SpinKitCircle(
                color: Colors.white,
              ),
        onPressed: () {
          setState(() {
            _validateInputs();
          });
        },
      ),
    );
  }

  void addReferralApiCall() {
    var refferalDataReq = {
      "first_name": fnameController.value.text,
      "last_name": lnameController.value.text,
      'gender': _genderValue.toString(),
      'phone': mobileController.value.text,
      'email': emailController.value.text,
      'membership_no': GemsGLobals.membershipNo.toString(),
      'ncode': _nationality.code.toString(),
      'fnf_relationship_code': selectedRelationship.toString(),
      'dob': dateFormate ?? "",
      'country_code': selectedCountryCode.toString()
    };

    Internetconnectivity().isConnected().then((isConnected) {
      if (isConnected) {
        UserApiConfig()
            .addRefrralApiCall(http.Client(), refferalDataReq)
            .then((value) {
          if (value['status'] == true) {
            isLoadinAddRef = false;
            Navigator.pop(context, true);
          } else {
            setState(() {
              isLoadinAddRef = false;
              showAlert(context, value['message']);
            });
          }
        });
      }
    });
  }

  _validateInputs() {
    if (_formKey.currentState!.validate() == true) {
      setState(() {
        _formKey.currentState?.save();

        isLoadinAddRef = true;

        addReferralApiCall();
        
      });
    } else {
      setState(() {
        if (_nationality == null) {
          setState(() {
            validateNationality = true;
          });
        } else {
          setState(() {
            validateNationality = false;
          });
        }
        if (selectedRelationship == '' ||
            selectedRelationship == null ||
            selectedRelationship == "Relationship") {
          setState(() {
            validateRelation = true;
          });
        } else {
          setState(() {
            validateRelation = false;
          });
        }

        if (dobcheckRelation.toString().toLowerCase() == "child" ||
            dobcheckRelation.toString().toLowerCase() == "junior") {
          if (_dobController.text.length == 0) {
            setState(() {
              validatedob = true;
              _dobError = "Please enter date of birth";
            });
          } else {
            setState(() {
              validatedob = false;
            });
          }
        }
        _showError = true;
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  /* TextField Style */
  InputDecoration _textFormStyle(String? suffix, String? hintText) {
    return InputDecoration(
      fillColor: white_text_color,
      filled: true,

      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 7.0),
      hintText: hintText,
      alignLabelWithHint: true,
      errorStyle: TextStyle(color: Colors.red),
      errorBorder: _showError == false
          ? OutlineInputBorder(
              borderSide:
                  BorderSide(color: grey_gunsmoke_text_color, width: 1.0),
            )
          : const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      counterText: "",
      errorMaxLines: 2,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade100, width: 1.0),
      ),
    );
  }

  static void showAlert(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
            child: TextWidget(
              text: message,
              alignment: TextAlign.center,
            ),
          ),
          actions: [
            MaterialButton(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextWidget(
                  text: "OK",
                  alignment: TextAlign.center,
                  size: 15,
                  weight: FontWeight.bold,
                  color: blue_color,
                ),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
