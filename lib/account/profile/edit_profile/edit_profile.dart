import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/account/profile/edit_profile/edit_profile_model.dart';
import 'package:gems_revamp/account/profile/edit_profile/edit_profile_view_presenter.dart';
import 'package:gems_revamp/account/profile/edit_profile/update_reqest_model.dart';
import 'package:gems_revamp/account/profile/edit_profile/visitor_update/visitor_model.dart';
import 'package:gems_revamp/account/profile/edit_profile/visitor_update/visitor_presenter.dart';
import 'package:gems_revamp/account/profile/edit_profile/visitor_update/visitor_request_model.dart';
import 'package:gems_revamp/account/profile/emirate/emirate_model.dart';
import 'package:gems_revamp/account/profile/emirate/emirate_presenter_view.dart';
import 'package:gems_revamp/account/profile/profile.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/family_and_friends/nationality_list.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';
import '../../../common_widget/appbar_widget.dart';
import '../../../common_widget/colors_widget.dart';
import '../../../common_widget/font_size.dart';
import '../../../common_widget/text_widget.dart';
import '../../../eshop_module_new/utils/connectivity.dart';
import '../../../family_and_friends/family_friends_master_list/master_list_model.dart';
import '../../../family_and_friends/master_list_db/master_list_db_helper.dart';
import '../../../utilities/auth_utils.dart';
import '../../../utils/constants_files/imageconstants.dart';
import '../../../utils/no_internet.dart';
import '../../interest/interest.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final email;
  final source;
  final headingtitle;
  final isDomainWhiteListed;
  final UserProfileModel? usermodel;
  final int? corporateId;
  final String? corporateCode;
  EditProfile(
      {Key? key,
      this.email,
      this.source,
      this.headingtitle,
      this.isDomainWhiteListed,
      this.usermodel,
      this.corporateId, this.corporateCode})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    implements UpdateRegisterView, EmirateView, UpdateVisitorView {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController corporateCodeController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emiratesController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  bool showError = true;
  bool? validateNationality = false;
  bool? validateEmirates = false;
  bool isLoading = false;
  bool enableList = false;
  List<dynamic>? nationalityList;
  int? mobilenumberlength = 9;
  dynamic nationality;
  List<dynamic> emirateList = [];
  String? selectedEmirate = GemsGLobals.selectEmiratesText;
  String? emirate = "";
  String? nationalityLocal = GemsGLobals.selectNationalityText;
  String nationalityId = "";
  String? countryImage;
  String? selectedCountryCode = GemsGLobals.defaultCountryCode;
  String genderValue = GemsGLobals.maleValue;
  String radioVal = GemsGLobals.maleText;
  MasterListModel? _masterListModel;
  List<dynamic>? countryCodeList;
  List<PartnerMasterList>? partnerMasterList;

  int radioSelected = 1;
  UserProfileModel? usermodel;
  List? intrestListData;
  late UpdateRegisterPresenter updateRegisterPresenter;
  late UpdateVisitorPresenter updateVisitorPresenter;
  late EmiratePresenter emiratePresenter;
  dynamic noConnection;
  String? membershipNo;
  int? emirateId;
  bool emirateLoading = false;
  String corporateCode = "";
  String corporateName = '';
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final mobileNumberFocus = FocusNode();

  @override
  void initState() {
    fetchMasterListData();
    fetchUserProfileDatafromDb();
    usermodel = widget.usermodel;
    if (widget.headingtitle == GemsGLobals.editProfileTitle) {
      emirateId = usermodel!.values!.emirateId;
      selectedEmirate = usermodel!.values!.emirateName ?? '';
      nationalityLocal = GemsGLobals.nationality ?? '';
      nationalityId = usermodel!.values!.nationalityId ?? '';
      firstNameController =
          TextEditingController(text: '${usermodel?.values?.firstName ?? ''}');
      lastNameController =
          TextEditingController(text: '${usermodel?.values?.lastName ?? ''}');
      mobileController = TextEditingController(text: GemsGLobals.mobilenumber);
      countryCodeController =
          TextEditingController(text: usermodel?.values?.countryCode ?? '');
      corporateCodeController = TextEditingController(text: usermodel?.values?.corporateCode ?? '');
      setState(() {
        if (usermodel!.values!.gender == GemsGLobals.maleText) {
          genderValue = GemsGLobals.maleValue;
          radioVal = GemsGLobals.maleText;
          radioSelected = 1;
        } else {
          genderValue = GemsGLobals.femaleValue;
          radioVal = GemsGLobals.femaleText;
          radioSelected = 2;
        }
      });
    } else {
      emirateId = 0;
      selectedEmirate = "";
      nationalityLocal = "";
      firstNameController.text = "";
      lastNameController.text = "";
      nationalityId = "";
    }

    updateRegisterPresenter = UpdateRegisterPresenter(this);
    updateVisitorPresenter = UpdateVisitorPresenter(this);
    emiratePresenter = EmiratePresenter(this);
    emiratePresenter.emirateResonse();

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    mobileNumberFocus.dispose();
    super.dispose();
  }

  void updateApiCall() {    
    var request = UpdateRequestModal(
        type: GemsGLobals.updateText,
        customerId: GemsGLobals.userId.toString(),
        transactionId: GemsGLobals.transactionId,
        customerType: GemsGLobals.userType,
        email: widget.email,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        midName: '',
        schoolCode: GemsGLobals.schoolcode,
        countryCode: int.parse(selectedCountryCode ?? ''),
        productCode: GemsGLobals.premiumText,
        isStaff: GemsGLobals.userType == GemsGLobals.defaultSource.toLowerCase()
            ? GemsGLobals.isStaffNo
            : GemsGLobals.isStaffYes,
        mobileNo: widget.isDomainWhiteListed == 0
            ? GemsGLobals.mobilenumber
            : mobileController.text,
        gender: genderValue,
        staffId: GemsGLobals.staffId,
        nationalityId: int.parse(nationalityId),
        dateOfBirth: (widget.headingtitle == GemsGLobals.registerFormTitle)
            ? ""
            : DateFormat(GemsGLobals.dateFormatYearMonthDay).format(
                DateFormat(GemsGLobals.dateFormatDayMonthYear)
                    .parse(usermodel!.values!.dob ?? '')),
        emirateId: emirateId,
        emirateName: selectedEmirate,
        corporateCode: widget.isDomainWhiteListed != 0
            ? widget.corporateCode
            : corporateCodeController.text);

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        updateRegisterPresenter.userProfileResonse(request);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          updateApiCall();
        }
      }
    });
  }

  void visitorApiCall() {
    final request = VisitorUpdateRequestModal(
      email: widget.email,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      countryCode: selectedCountryCode,
      phone: mobileController.text,
      country: "",
      status: GemsGLobals.activeText,
      membershipNo: GemsGLobals.membershipNo,
    );

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        updateVisitorPresenter.visitorUpdateResponse(request);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          visitorApiCall();
        }
      }
    });
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventRegistration;
    Map<String, dynamic> segmentReq = {
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName,
      "email": widget.email,
      "phone_number": mobileController.text,
      "username": firstNameController.text + " " + lastNameController.text,
      "gender": genderValue,
      "nationality": nationalityLocal,
      "created_on":
          DateFormat(GemsGLobals.dateFormatYearMonthDay).format(DateTime.now()),
      "country": "",
      "city": ""
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  fetchUserProfileDatafromDb() {
    UserProfileDbHelper().fetchUserProfileData().then((value) {
      setState(() {
        usermodel = userModelFromJson(value.first.userprofiledata);
        intrestListData = usermodel!.values!.interestList;
      });
    });
  }

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);
      nationalityList = _masterListModel!.values!.nationality;
      countryCodeList = _masterListModel!.values!.countryList;
      partnerMasterList = _masterListModel!.values!.partnerMasterList;
      for (var partner in partnerMasterList ?? []) {
        if (partner.id.toString() == widget.corporateId.toString()) {
          corporateCode = partner.code ?? "";
          break;
        }
      }
    });
  }

  String? validateMobile(String? data) {
    String value = data ?? '';
    if (value.isEmpty) {
      return GemsGLobals.mobileErrorText;
    } else if (value.length != mobilenumberlength!) {
      return '${GemsGLobals.mobileDigitText}';
    } else {
      return null;
    }
  }

  String? validateCorporateCode(String? data) {
    String value = data?.trim() ?? '';

    if (value.isEmpty) {
      corporateName = "";
      return GemsGLobals.errorText;
    }

    for (var partner in partnerMasterList ?? []) {
      if (partner.code.toString().toUpperCase() == value.toUpperCase()) {
        corporateCode = partner.code ?? "";
        corporateCodeController.text = corporateCode;
        corporateName = partner.partner ?? "";

        return null;
      }
    }
    corporateName = "";
    return GemsGLobals.invalidCodeErrorText;
  }

  String? validateName(String? data) {
    String value = data ?? '';
    String pattern = GemsGLobals.namePattern;
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return GemsGLobals.errorText;
    } else if (!regex.hasMatch(value) ||
        value.startsWith(" ") ||
        value.endsWith(" ")) {
      return GemsGLobals.invalidCharacterErrorText;
    } else {
      return null;
    }
  }

  void userProfileApi() {
    Internetconnectivity().isConnected().then((connected) async {
      if (connected) {
        UserApiConfig.userProfileApiCall(
                http.Client(), GemsGLobals.membershipNo)
            .then((value) {
          usermodel = value;

          if (usermodel!.status == true) {
            UserProfileDbHelper()
                .insertUserProfileData(
                    UserProfileDbModel(null, json.encode(usermodel!.toJson())))
                .whenComplete(() {
              setState(() {
                isLoading = false;
              });

              editPopup(GemsGLobals.editProfileTitle);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: white_text_color,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: GradientAppBar(
              title: widget.headingtitle,
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 100,
            )),
        body: _body(),
      ),
    );
  }

  InputDecoration _textFormStyle(String? suffix, String? hintText) {
    return InputDecoration(
      fillColor: white_text_color,
      filled: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 7.0),
      hintText: hintText,
      alignLabelWithHint: true,
      errorStyle: TextStyle(color: Colors.red),
      errorBorder: showError == false
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

  Widget textFieldWidget(
      FocusNode focusFields,
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
                      text: GemsGLobals.asteriskText,
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
              focusNode: focusFields,
              controller: _controller,
              onTap: () {
                showError = false;
              },
              readOnly: readOnly,
              decoration: _textFormStyle(suffix, hintText),
              maxLength: _controller == mobileController ? 9 : 20,
              textCapitalization: _controller == firstNameController ||
                      _controller == lastNameController
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              inputFormatters: _controller == firstNameController ||
                          _controller == lastNameController
                      ? [
                          NameInputFormatter(),
                        ]
                      : null,
              keyboardType: keyboardType,
              validator: validator)
        ],
      ),
    );
  }

  _validateInputs() {
    if (_formKey.currentState!.validate() == true) {
      setState(() {
        _formKey.currentState?.save();
        isLoading = true;
        updateApiCall();
      });
    } else {
      setState(() {
        if (nationality == null || nationality == '') {
          setState(() {
            validateNationality = true;
          });
        } else {
          setState(() {
            validateNationality = false;
          });
        }
        if (selectedEmirate == null || selectedEmirate == '') {
          setState(() {
            validateEmirates = true;
          });
        } else {
          setState(() {
            validateEmirates = false;
          });
        }

        showError = true;
        autoValidate = AutovalidateMode.always;
      });
    }
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
        child: isLoading == false
            ? TextWidget(
                text: GemsGLobals.submitText,
                color: Colors.white,
                size: text_font_medium17_size,
              )
            : SpinKitCircle(
                color: theme_color,
              ),
        onPressed: () {
          setState(() {
            _validateInputs();
          });
        },
      ),
    );
  }

  Widget emiratesOptions() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              firstNameFocus.unfocus();
              lastNameFocus.unfocus();
              mobileNumberFocus.unfocus(); 
              FocusScope.of(context).unfocus();
            });
            emirateLoading == true
                ? CircularProgressIndicator()
                : emirate = await showModalBottomSheet(
                    backgroundColor: white_text_color,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: emirateList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pop(
                                            context, emirateList[index].name);
                                        emirateId = emirateList[index].id;
                                        GemsGLobals.emirate =
                                            emirateList[index].name;
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 20,
                                          bottom: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                child: TextWidget(
                                              text:
                                                  emirateList[index].name == ''
                                                      ? usermodel!
                                                          .values!.emirateName
                                                      : emirateList[index].name,
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
                    });
            setState(() {
              if (emirate != null) {
                setState(() {
                  selectedEmirate = emirate ?? '';
                });
              }
              if (emirate == null && selectedEmirate != null) {
                setState(() {
                  emirate = selectedEmirate ?? '';
                });
              }

              enableList = !enableList;
              validateEmirates = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: white_text_color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: grey_background)),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: TextWidget(
                  text: selectedEmirate == '' ||
                          selectedEmirate == GemsGLobals.selectEmiratesText
                      ? GemsGLobals.selectEmiratesText
                      : selectedEmirate,
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

  Widget corporateCodeFieldWidget() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: GemsGLobals.corporateCodeLabel,
                color: grey600_color,
              ),
              TextWidget(
                text: GemsGLobals.asteriskText,
                color: red_color,
              ),
            ],
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: corporateCodeController,
            maxLength: 20,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  GemsGLobals.corporateCodePattern),
            ],
            decoration: _textFormStyle(null, null),
            validator: (value) => validateCorporateCode(value),
            onChanged: (value) {
              validateCorporateCode(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _addForm() {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              widget.isDomainWhiteListed != 0
                  ? SizedBox()
                  : corporateCodeFieldWidget(),
              SizedBox(
                height: 20,
              ),
              widget.isDomainWhiteListed != 0
                  ? SizedBox()
                  : enterDetails(GemsGLobals.corporateNameLabel, corporateName),
              textFieldWidget(firstNameFocus, GemsGLobals.firstNameText,
                  firstNameController, (String? arg) {
                return validateName(arg);
              }, null, TextInputType.text, null, false),
              SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  lastNameFocus, GemsGLobals.lastNameText, lastNameController,
                  (String? arg) {
                return validateName(arg);
              }, null, TextInputType.text, null, false),
              SizedBox(
                height: 20,
              ),
              widget.isDomainWhiteListed == 0
                  ? enterDetails(GemsGLobals.mobileNoText,
                      "+$selectedCountryCode " + GemsGLobals.mobilenumber)
                  : Row(
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
                                    text: GemsGLobals.mobileNoText,
                                    color: grey600_color,
                                  ),
                                  TextWidget(
                                    text: GemsGLobals.asteriskText,
                                    color: red_color,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: white_text_color,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: countryImage == null ||
                                                    countryImage == ""
                                                ? NetworkImage(ImageConstants
                                                    .countryDefaultImage)
                                                : NetworkImage('$countryImage'),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    TextWidget(
                                      text: "+$selectedCountryCode",
                                      color: grey_color,
                                      size: text_font_medium15_size,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: textFieldWidget(
                            mobileNumberFocus,
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
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 20,
              ),
              enterDetails(GemsGLobals.emailIdText, widget.email),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: GemsGLobals.genderText,
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: GemsGLobals.asteriskText,
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
                            border: Border.all(color: grey_background)),
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: radioSelected,
                              activeColor: green_color,
                              onChanged: (value) {
                                setState(() {
                                  if (_formKey.currentState?.validate() ==
                                      false) {
                                    FocusScope.of(context).unfocus();
                                    autoValidate = AutovalidateMode.always;
                                  }
                                  radioSelected = value as int;
                                  radioVal = GemsGLobals.maleText;
                                  genderValue = GemsGLobals.maleValue;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    radioSelected = 1;
                                    radioVal = GemsGLobals.maleText;
                                    genderValue = GemsGLobals.maleValue;
                                  });
                                },
                                child: Text(GemsGLobals.maleText)),
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
                            border: Border.all(color: grey_background)),
                        child: Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: radioSelected,
                              activeColor: green_color,
                              onChanged: (value) {
                                setState(() {
                                  if (_formKey.currentState?.validate() ==
                                      false) {
                                    FocusScope.of(context).unfocus();
                                    autoValidate = AutovalidateMode.always;
                                  }
                                  radioSelected = value as int;
                                  radioVal = GemsGLobals.femaleText;
                                  genderValue = GemsGLobals.femaleValue;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    radioSelected = 2;
                                    radioVal = GemsGLobals.femaleText;
                                    genderValue = GemsGLobals.femaleValue;
                                  });
                                },
                                child: Text(GemsGLobals.femaleText))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              enterDetails(
                  GemsGLobals.userTypeText,
                  (GemsGLobals.userType)[0].toUpperCase() +
                      GemsGLobals.userType.substring(1)),
              enterDetails(GemsGLobals.sourceText,
                  widget.source ?? GemsGLobals.defaultSource),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: GemsGLobals.emirateText,
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: GemsGLobals.asteriskText,
                        color: red_color,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  emiratesOptions(),
                  validateEmirates == true
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 7, top: 5, bottom: 5),
                          child: TextWidget(
                            text: GemsGLobals.selectEmirateErrorText,
                            color: Colors.red,
                            size: text_font_size_small,
                          ),
                        )
                      : Container(height: 0),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              widget.headingtitle == GemsGLobals.editProfileTitle
                  ? enterDetails(GemsGLobals.nationalityText,
                      nationalityLocal ?? GemsGLobals.nationality)
                  : Column(
                      children: [
                        Row(
                          children: [
                            TextWidget(
                              text: GemsGLobals.nationalityText,
                              color: grey600_color,
                            ),
                            TextWidget(
                              text: GemsGLobals.asteriskText,
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
                              firstNameFocus.unfocus();
                              lastNameFocus.unfocus();
                              mobileNumberFocus.unfocus();
                              FocusScope.of(context).unfocus();
                              validateNationality = false;
                            });

                            nationality = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Nationality(
                                          nationalityData: nationalityList,
                                        )));

                            if (nationality != null) {
                              setState(() {
                                nationalityLocal = nationality!.name ?? '';
                                nationalityId = nationality!.code ?? '';
                              });
                            }
                            if (nationality == null &&
                                nationalityLocal != null) {
                              setState(() {
                                nationality = nationalityLocal ?? '';
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
                                border: Border.all(color: grey_background)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: nationalityLocal == '' ||
                                            nationalityLocal ==
                                                GemsGLobals
                                                    .selectNationalityText
                                        ? GemsGLobals.selectNationalityText
                                        : nationalityLocal,
                                    color: black_color,
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
                                  text: GemsGLobals.nationalityErrorText,
                                  color: Colors.red,
                                  size: text_font_size_small,
                                ),
                              )
                            : Container(height: 0),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
              widget.headingtitle == GemsGLobals.editProfileTitle
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InterestPage(
                                    membershipId: GemsGLobals.membershipNo,
                                    intrestList: intrestListData,
                                  )),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: white_text_color,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400)),
                        width: MediaQuery.of(context).size.width / 1,
                        child: Row(
                          children: [
                            TextWidget(
                              text: GemsGLobals.myInterestTitle,
                              weight: FontWeight.w600,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pink,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: 10,
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

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.1,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                _addForm(),
                SizedBox(
                  height: 30,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget enterDetails(label, info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label ?? '',
            color: grey600_color,
            weight: FontWeight.w400,
          ),
          SizedBox(
            height: 10,
          ),
          TextWidget(
            text: info == null || info == "" ? '' : info,
            weight: FontWeight.w500,
            size: text_font_medium16_size,
            color: grey600_color,
          ),
          Divider(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget gender(label, info) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.4,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: label,
            color: grey600_color,
            weight: FontWeight.w400,
          ),
          SizedBox(
            height: 10,
          ),
          TextWidget(
            text: info,
            weight: FontWeight.w500,
            size: text_font_medium16_size,
            color:
                label == GemsGLobals.genderText ? black_color : grey_color_300,
          ),
          Divider(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  editPopup(headingTitle) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 0, right: 0, bottom: 20),
            alignment: Alignment.center,
            width: 80,
            height: 80,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text: widget.headingtitle == GemsGLobals.registerFormTitle
                        ? GemsGLobals.successfullyRegisterMsg
                        : GemsGLobals.profileDetailUpdateSuccessMsg,
                    size: 12,
                    weight: FontWeight.bold,
                    color: Colors.grey[700]!,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              text: GemsGLobals.ok,
                              alignment: TextAlign.center,
                              size: 12,
                              weight: FontWeight.bold),
                          onPressed: () {
                            if (headingTitle == GemsGLobals.registerFormTitle) {
                              visitorApiCall();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TabsScreen(
                                      initialIndex: 0,
                                    ),
                                  ));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfile()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void updateRegisterError(Error error) {}

  @override
  void updateRegisterSuceess(UpdateRegistrationModal updateRegistrationModal) {
    setState(() async {
      if (updateRegistrationModal.status == true) {
        GemsGLobals.membershipNo =
            updateRegistrationModal.values!.membershipNo.toString();
        AuthUtils.setuserType(GemsGLobals.corporateUserTypeValue);

        AuthUtils.setStringValue(
            GemsGLobals.membershipText, GemsGLobals.membershipNo ?? '');
        GemsGLobals.membershipNo =
            await AuthUtils.getStringValue(GemsGLobals.membershipText);

        GemsGLobals.useremail = widget.email ?? '';
        GemsGLobals.userId = updateRegistrationModal.values!.customerId;
        GemsGLobals.schoolcode =
            updateRegistrationModal.values!.schoolCode ?? '';
        GemsGLobals.alumniStatus = false;
        GemsGLobals.mobilenumber = mobileController.text;
        GemsGLobals.countryCode = selectedCountryCode;
        GemsGLobals.userFirstName = firstNameController.text.split(' ').first;
        GemsGLobals.userLastName = firstNameController.text.split(' ').last;
        GemsGLobals.nationality = nationalityLocal;
        GemsGLobals.nationalityId = nationalityId;
        GemsGLobals.emirate = selectedEmirate;
        GemsGLobals.gender = radioVal;
        makesenseEventCall();
        if (widget.headingtitle == GemsGLobals.registerFormTitle) {
          setState(() {
            isLoading = false;
          });
          editPopup(GemsGLobals.registerFormTitle);
          GemsGLobals.lastVisitPageName = GemsGLobals.registerFormTitle;
        } else {
          userProfileApi();
          GemsGLobals.lastVisitPageName = GemsGLobals.editProfileTitle;
        }
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: blue_color,
              content: Text(updateRegistrationModal.message.toString())));
        });
      }
    });
  }

  @override
  void emirateError(Error error) {}

  @override
  void emirateSuceess(EmirateModal emirateModal) {
    setState(() {
      emirateLoading = false;
    });
    for (int i = 0; i < emirateModal.values!.length; i++) {
      emirateList.add(emirateModal.values![i]);
    }
  }

  @override
  void visitorError(Error error) {}

  @override
  void visitorSuceess(VisitorUpdateModal visitorUpdateModal) {}
}

class NameInputFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r"^[a-zA-Z' ]*$");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (!_regExp.hasMatch(text)) {
      return oldValue;
    }

    String cleaned = text.replaceAll(RegExp(r'\s+'), ' ');

    if (cleaned.startsWith(' ')) {
      cleaned = cleaned.trimLeft();
    }

    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}
