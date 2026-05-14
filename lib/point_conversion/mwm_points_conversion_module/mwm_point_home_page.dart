import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../utils/constants_files/color_constants.dart';
import '../../utils/constants_files/imageconstants.dart';
import '../../utils/constants_files/styles_constants.dart';
import '../../utils/constants_files/text_constants.dart';
import '../../utils/gemsGlobals.dart';
import 'convert_points/convert_points.dart';
import 'get_membership_list/get_membership_list_model.dart';
import 'get_membership_list/get_membership_list_presenter.dart';
import 'get_membership_list/get_membership_list_view.dart';
import 'partner_details/partner_details_model.dart';
import 'partner_details/partner_details_presenter.dart';
import 'partner_details/partner_details_view.dart';
import 'verify_member/resend_otp/resend_otp_model.dart';
import 'verify_member/resend_otp/resend_otp_presenter.dart';
import 'verify_member/resend_otp/resend_otp_view.dart';
import 'verify_member/validate_otp/encryption_otp.dart';
import 'verify_member/validate_otp/validate_otp_model.dart';
import 'verify_member/validate_otp/validate_otp_presenter.dart';
import 'verify_member/validate_otp/validate_otp_view.dart';
import 'verify_member/verify_member_model.dart';
import 'verify_member/verify_member_presenter.dart';
import 'verify_member/verify_member_view.dart';

class MwmPointsHomePage extends StatefulWidget {
  late String? partnerCurrencyCode;
  late String? partnerLogo;
  late String? trackId;
  late String? partnerType;

  MwmPointsHomePage(
      {this.partnerCurrencyCode,
      this.partnerLogo,
      this.trackId,
      this.partnerType});

  @override
  _MwmPointsHomePageState createState() => _MwmPointsHomePageState();
}

class _MwmPointsHomePageState extends State<MwmPointsHomePage>
    implements
        PartnerDetailsView,
        VerifyPartnerView,
        GetMembershipView,
        ValidateOTPView,
        ResendOtpView {
  final TextEditingController verificationController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  PartnerDetailsModel? partnerDetailsModel;
  PartnerDetailsPresenter? partnerDetailsPresenter;
  VerifyPartnerModel? verifyPartnerModel;
  VerifyPartnerPresenter? verifyPartnerPresenter;
  GetMembershipListModel? getMembershipListModel;
  GetMembershipListPresenter? getMembershipListPresenter;
  ValidateOtpPresenter? validateOtpPresenter;
  ValidateOtp? verifyOtpModel;
  ResendOtpPresenter? resendOtpPresenter;
  bool isApiLoading = true;
  bool isVerifyApiLoading = false;
  bool isValidateApiLoading = false;
  List<FieldColumn>? fieldColumns;
  bool isResendOtp = false;
  Timer? timer;
  int? waitTime = 0;
  int? remainingTime = 0;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormFieldState>> _fieldKeys = {};
  String? accountErrorText;
  bool isSwap = false;
  bool isOtpRequired = false;

  String regexPattern = '';
  int regexLength = 0;
  bool isGetMembershipApiLoading = false;
  int? resendOtpGapInMinutes = 0;
  int otpLengthValue = 5;
  int? otpExpireTimeInMinutes = 0;
  int? resendOtpCount = 0;
  Timer? _timer;
  int _remainingTime = 00;
  int _resendOtpAttempts = 0;
  bool _canResendOtp = false;
  int durationTime = 1;
  int secondValue = 60;
  String userVisibleOTP = '';
  int userEnteredOTP = 0;
  String finalEncryptedOTP = '';
  int defaultLength = 1;
  int padLeftValue = 2;
  String defaultPadValue = '0';

  @override
  void initState() {
    super.initState();

    partnerDetailsPresenter = PartnerDetailsPresenter(this);
    verifyPartnerPresenter = VerifyPartnerPresenter(this);
    getMembershipListPresenter = GetMembershipListPresenter(this);
    validateOtpPresenter = ValidateOtpPresenter(this);
    validateOtpPresenter = ValidateOtpPresenter(this);
    resendOtpPresenter = ResendOtpPresenter(this);
    partnerDetailsPresenter?.partnerDetailsResponse(
      widget.partnerCurrencyCode,
    );
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: durationTime), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          _canResendOtp = true;
        }
      });
    });
  }

  void resendOtp() {
    if (_resendOtpAttempts < resendOtpCount! && _canResendOtp) {
      setState(() {
        _resendOtpAttempts++;
        _canResendOtp = false;
        _remainingTime = resendOtpGapInMinutes! * secondValue;
      });
      startTimer();
      Timer(Duration(minutes: resendOtpGapInMinutes!), () {
        setState(() {
          _canResendOtp = true;
        });
      });
      resendOtpApiCall();
    } else {
      Fluttertoast.showToast(
        msg: AppTexts.maxAttemptsText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    verificationController.dispose();
    focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> resendOtpApiCall() async {
    isResendOtp = true;
    final request = ResendOtpRequest(
      linkMemberId: verifyPartnerModel?.values?.first.linkMemberId,
    );
    final requestBody = request.toJson();

    await resendOtpPresenter?.resendOtpResponse(requestBody);
  }

  String formatApiDate(String apiDate) {
    final parsedDate = DateTime.parse(apiDate);
    return DateFormat(AppTexts.dateFormat).format(parsedDate);
  }

  Widget buildVerificationField() => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppTexts.verificationCodeText,
                style: AppTheme.interSmallTextStyle),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: verificationController,
                    obscureText: true,
                    focusNode: focusNode,
                    maxLength: otpLengthValue,
                    keyboardType: TextInputType.number,
                    style: AppTheme.letterSpacingStyle,
                    decoration: InputDecoration(
                        hintText: '•••••',
                        errorText: errorText,
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        border: InputBorder.none),
                    onChanged: (value) {
                      if (value.length == otpLengthValue) {
                        focusNode.unfocus();
                        validateCode();
                      }
                    },
                    onEditingComplete: validateCode,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (verificationController.text.length == otpLengthValue) {
                      userEnteredOTP = int.parse(verificationController.text);

                      finalEncryptedOTP =
                          OtpEncryption.encryptOTP(userEnteredOTP);
                      final validateOtpRequest = ValidateOtpRequest(
                        linkMemberId:
                            verifyPartnerModel?.values?.first.linkMemberId,
                        otpToken: verifyPartnerModel?.values?.first.otpToken,
                        otp: finalEncryptedOTP,
                      );

                      final requestBody = validateOtpRequest.toJson();
                      validateOtpPresenter?.validateOtpResponse(requestBody);
                      setState(() {
                        isValidateApiLoading = true;
                      });
                    } else {
                      validateCode();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        visible: isValidateApiLoading,
                        child: const CircularProgressIndicator(),
                      ),
                      Visibility(
                        visible: !isValidateApiLoading,
                        child: const Text(
                          AppTexts.validateText,
                          style: AppTheme.interSmallBlueTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildDynamicInputField(FieldColumn field) {
    if (!_controllers.containsKey(field.fieldName)) {
      _controllers[field.fieldName] = TextEditingController();
    }

    if (!_fieldKeys.containsKey(field.fieldName)) {
      _fieldKeys[field.fieldName] = GlobalKey<FormFieldState<String>>();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.displayFieldName ?? '',
              style: AppTheme.interSmallTextStyle),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controllers[field.fieldName],
                  key: _fieldKeys[field.fieldName],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: field.displayFieldName,
                    filled: true,
                    hintStyle: AppTheme.interMediumTextStyle,
                    labelStyle: AppTheme.interMediumTextStyle,
                    fillColor: AppColors.white,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  onChanged: (values) {
                    setState(() {});
                    _fieldKeys[field.fieldName]?.currentState?.validate();
                  },
                  validator: (value) {
                    if (field.validations == AppTexts.mandatoryText &&
                        (value == null || value.isEmpty)) {
                      return ' ${AppTexts.pleaseEnterText} ${field.displayFieldName}';
                    }
                    if (field.pattern != null &&
                        !RegExp(field.pattern!).hasMatch(value!)) {
                      return '${AppTexts.invalidText} ${field.displayFieldName}';
                    }
                    if (field.patternLength != null &&
                        (value?.length ?? 0) > field.patternLength!) {
                      return '${field.displayFieldName} ${AppTexts.shouldNotExceedText} ${field.patternLength} ${AppTexts.charactersTexts}';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget userInforamtion() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fieldColumns?.length ?? 0,
                        itemBuilder: (context, index) {
                          final field = fieldColumns![index];
                          return Column(
                            children: [
                              buildDynamicInputField(field),
                              index != fieldColumns!.length - defaultLength
                                  ? const Divider(
                                      color: AppColors.black,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  const Divider(
                    color: AppColors.black,
                  ),
                  buildInputField(
                    label: AppTexts.accountNumberText,
                    value: AppTexts.accountNumberLabel,
                  ),
                  isOtpRequired
                      ? const Divider(
                          color: AppColors.black,
                        )
                      : const SizedBox(),
                  isOtpRequired ? buildVerificationField() : const SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              isOtpRequired
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (_canResendOtp) {
                            resendOtp();
                          }
                        },
                        child: RichText(
                          text: TextSpan(
                            text: AppTexts.didntReceiveOtpText,
                            style: AppTheme.interMedium400TextStyle,
                            children: [
                              TextSpan(
                                text: AppTexts.resendText,
                                style: _canResendOtp
                                    ? AppTheme.interMediumBlueTextStyle
                                    : AppTheme.interMediumGreyTextStyle,
                              ),
                              const TextSpan(
                                text: '\t${AppTexts.inText}',
                                style: AppTheme.interMedium400TextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              isOtpRequired
                  ? Text(
                      '${(_remainingTime ~/ secondValue).toString().padLeft(padLeftValue, defaultPadValue)}:${(_remainingTime % secondValue).toString().padLeft(padLeftValue, defaultPadValue)}',
                      style: AppTheme.interMedium500TextStyle,
                    )
                  : const SizedBox(),
            ],
          ),
          isOtpRequired
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RichText(
                      text: TextSpan(
                          text: AppTexts.resendAttemptText,
                          style: AppTheme.interMedium400TextStyle,
                          children: [
                        TextSpan(
                          text: '${resendOtpCount! - _resendOtpAttempts}',
                          style: AppTheme.interMedium400TextStyle,
                        ),
                      ])),
                )
              : const SizedBox(),
        ],
      );

  @override
  Widget build(BuildContext context) => Container(
      child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
            extendBody: true,
            backgroundColor: AppColors.greyShade200,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(75.0),
                child: AppBar(
                  backgroundColor: AppColors.greyShade200,
                  title: const Text(
                    AppTexts.convertPointsText,
                    style: AppTheme.appBarTextStyle,
                  ),
                  centerTitle: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: Image.asset(
                      ImageConstants.backArrow,
                      fit: BoxFit.contain,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )),
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                const Text(AppTexts.fromText,
                                    style: AppTheme.interSmallTextStyle),
                                const SizedBox(height: 5),
                                isSwap
                                    ? SizedBox(
                                        height: 90,
                                        width: 120,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.partnerLogo ?? '',
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 90,
                                        width: 120,
                                        child: Align(
                                          child: Image.asset(
                                            ImageConstants.gemsNewLogo,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 5),
                                Text(
                                    isSwap
                                        ? (partnerDetailsModel
                                                ?.values?.first.displayName ??
                                            '')
                                        : AppTexts.gemRewardText,
                                    style: AppTheme.interSmall500TextStyle),
                              ],
                            ),
                          ),
                          widget.partnerType == AppTexts.twoWayKey
                              ? Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 2,
                                        height: 200,
                                        color: AppColors.greyShade,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          isSwap = !isSwap;
                                          getMembershipListApi();
                                          setState(() {});
                                        },
                                        child: Center(
                                          child: Image.asset(
                                            ImageConstants.swapIcon,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.greyShade200,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                      color: AppColors.blueShade,
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                const Text(AppTexts.toText,
                                    style: AppTheme.interSmallTextStyle),
                                const SizedBox(height: 5),
                                isSwap
                                    ? SizedBox(
                                        height: 90,
                                        width: 120,
                                        child: Align(
                                          child: Image.asset(
                                            ImageConstants.gemsNewLogo,
                                            height: 50,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 90,
                                        width: 120,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.partnerLogo ?? '',
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                const SizedBox(height: 5),
                                Text(
                                  isSwap
                                      ? AppTexts.gemRewardText
                                      : partnerDetailsModel
                                              ?.values?.first.displayName ??
                                          '',
                                  style: AppTheme.interSmall500TextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0,
                      color: AppColors.greyShade,
                    ),
                    const SizedBox(height: 30),
                    isGetMembershipApiLoading
                        ? const SizedBox()
                        : (getMembershipListModel?.values?.isNotEmpty ?? true)
                            ? const SizedBox()
                            : Center(
                                child: Text(
                                    '${AppTexts.connectAccountText} ${partnerDetailsModel?.values?.first.displayName ?? ''}${AppTexts.accountStartedText}',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.interMediumTextStyle),
                              ),
                    const SizedBox(
                      height: 10,
                    ),
                    isApiLoading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : isGetMembershipApiLoading
                            ? const Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : ((getMembershipListModel?.values?.isEmpty ??
                                        true) ||
                                    partnerDetailsModel
                                            ?.values?.first.multiLink !=
                                        0)
                                ? userInforamtion()
                                : const SizedBox(),
                    const SizedBox(height: 20),
                    (getMembershipListModel?.values?.isNotEmpty ?? false)
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getMembershipListModel!.values!.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {},
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 0.5,
                                        color: AppColors.greyShade600,
                                      ),
                                      color: AppColors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      getMembershipListModel!
                                                              .values![index]
                                                              .partnerDetails
                                                              ?.partnerLogo ??
                                                          '',
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                                isSwap
                                                    ? '${getMembershipListModel!.values![index].partnerDetails?.partnerProgramName ?? ''} ${AppTexts.toLabel} ${getMembershipListModel!.values![index].clientDetails?.clientName ?? ''}'
                                                    : '${getMembershipListModel!.values![index].clientDetails?.clientName ?? ''} ${AppTexts.toLabel} ${getMembershipListModel!.values![index].partnerDetails?.partnerProgramName ?? ''}',
                                                style: AppTheme
                                                    .interMediumTextStyle),
                                            const Spacer(),
                                            GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConvertPointsScreen(
                                                        values:
                                                            getMembershipListModel!
                                                                .values![index],
                                                        isSwap: isSwap,
                                                        partnerCurrencyCode:
                                                            partnerDetailsModel
                                                                ?.values
                                                                ?.first
                                                                .partnerCurrencyCode,
                                                        partnerDetailsModel:
                                                            partnerDetailsModel,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    partnerDetailsPresenter
                                                        ?.partnerDetailsResponse(
                                                            widget
                                                                .partnerCurrencyCode);
                                                    verificationController
                                                        .clear();
                                                    accountController.clear();
                                                    timer?.cancel();
                                                    isOtpRequired = false;
                                                  });
                                                },
                                                child: const Text(
                                                  AppTexts.transferText,
                                                  style: AppTheme
                                                      .interMedium500TextStyle,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  AppTexts.linkedMemberIdText,
                                                  style: AppTheme
                                                      .interDarkGrey12Medium,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  getMembershipListModel!
                                                          .values![index]
                                                          .linkBookingRefNo ??
                                                      '',
                                                  style: AppTheme
                                                      .interBlack14Regular,
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const Text(
                                                  AppTexts.TimestampText,
                                                  style: AppTheme
                                                      .interDarkGrey12Medium,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  formatApiDate(
                                                      getMembershipListModel!
                                                          .values![index]
                                                          .creationTime
                                                          .toString()),
                                                  style: AppTheme
                                                      .interBlack14Regular,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )));

  void validateAccountNumber(String value) {
    if (!RegExp(regexPattern).hasMatch(value)) {
      setState(() {
        accountErrorText = AppTexts.accountNumberValidationText;
      });
    } else if (value.length != regexLength) {
      setState(() {
        accountErrorText =
            '${AppTexts.accountNumberMustText} $regexLength ${AppTexts.digitText}';
      });
    } else {
      setState(() {
        accountErrorText = null;
      });
    }
  }

  Map<String, dynamic> getMemberDetails() {
    final memberDetails = <String, dynamic>{
      AppTexts.partnerMemberIdKey: accountController.text,
    };

    _controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        memberDetails[key] = controller.text;
      }
    });

    return memberDetails;
  }

  Widget buildInputField({required String label, required String value}) =>
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.interSmallTextStyle),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: accountController,
                    decoration: InputDecoration(
                        hintText: value,
                        filled: true,
                        hintStyle: AppTheme.interMediumTextStyle,
                        labelStyle: AppTheme.interMediumTextStyle,
                        fillColor: AppColors.white,
                        contentPadding: EdgeInsets.zero,
                        errorText: accountErrorText,
                        border: InputBorder.none),
                    onChanged: validateAccountNumber,
                  ),
                ),
                if (label == AppTexts.accountNumberText)
                  GestureDetector(
                    onTap: () {
                      if (accountController.text.isEmpty) {
                        validateAccountNumber(value);
                      }

                      if (_fieldKeys.values.every((element) =>
                              element.currentState?.validate() ?? false) &&
                          accountErrorText == null) {
                        setState(() {
                          isVerifyApiLoading = true;

                          final request = VerifyLinkRequest(
                            transactionFrom: isSwap
                                ? (partnerDetailsModel
                                        ?.values?.first.partnerCurrencyCode ??
                                    '')
                                : AppTexts.transactionFromValue,
                            transactionTo: isSwap
                                ? AppTexts.transactionFromValue
                                : partnerDetailsModel
                                        ?.values?.first.partnerCurrencyCode ??
                                    '',
                            clientMemberId: GemsGLobals.membershipNo ?? '',
                            memberDetails: getMemberDetails(),
                          );

                          final requestBody = request.toJson();
                          verifyPartnerPresenter
                              ?.verifyPartnerResponse(requestBody);
                          focusNode.requestFocus();
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: isVerifyApiLoading,
                          child: const CircularProgressIndicator(),
                        ),
                        Visibility(
                          visible: !isVerifyApiLoading,
                          child: const Text(
                            AppTexts.verifyText,
                            style: AppTheme.interSmallBlueTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  String? errorText;

  void validateCode() {
    setState(() {
      if (verificationController.text.length != otpLengthValue) {
        errorText = AppTexts.verificationValidText;
      } else {
        errorText = null;
      }
    });
  }

  Future<void> getMembershipListApi() async {
    isGetMembershipApiLoading = true;
    final request = MemberListRequestBody(
      limit: AppTexts.numberOfTransactionsLimit,
      offset: AppTexts.initialOffsetValue,
      clientMemberId: GemsGLobals.membershipNo ?? '',
      transactionFrom: isSwap
          ? (partnerDetailsModel?.values?.first.partnerCurrencyCode ?? '')
          : AppTexts.transactionFromValue,
      transactionTo: isSwap
          ? AppTexts.transactionFromValue
          : partnerDetailsModel?.values?.first.partnerCurrencyCode ?? '',
    );
    final requestBody = request.toJson();

    await getMembershipListPresenter?.getMembershipResponse(requestBody);
  }

  @override
  void partnerDetailsErr(String error) {
    setState(() {
      isApiLoading = false;
    });
  }

  @override
  void partnerDetailsSuccess(PartnerDetailsModel partnerDetailsModel) {
    isApiLoading = false;

    setState(() {
      this.partnerDetailsModel = partnerDetailsModel;
      fieldColumns = partnerDetailsModel.values != null
          ? partnerDetailsModel.values?.first.fieldColumns
          : [];
      for (var field in fieldColumns!) {
        _controllers[field.fieldName] = TextEditingController();
        _fieldKeys[field.fieldName] = GlobalKey<FormFieldState>();
      }
      regexPattern = partnerDetailsModel.values?.first.regex ?? '';
      regexLength = partnerDetailsModel.values?.first.regexLength ?? 0;
      getMembershipListApi();
    });
  }

  @override
  void verifyPartnerErr(String error) {
    setState(() {
      isVerifyApiLoading = false;
    });
  }

  @override
  void verifyPartnerSuccess(VerifyPartnerModel verifyPartnerModel) {
    isVerifyApiLoading = false;

    if (verifyPartnerModel.status ?? false) {
      this.verifyPartnerModel = verifyPartnerModel;
      if (verifyPartnerModel.values?.first.isOtpRequired ?? false) {
        isOtpRequired = true;
        setState(() {
          otpExpireTimeInMinutes =
              verifyPartnerModel.values?.first.otpExpireTimeInMinutes;
          resendOtpCount = verifyPartnerModel.values?.first.resendOtpCount;
          resendOtpGapInMinutes =
              verifyPartnerModel.values?.first.resendOtpGapInMinutes;
          _remainingTime = resendOtpGapInMinutes! * secondValue;
          final apiEncryptedOTP = verifyPartnerModel.values?.first.otp ?? '';

          userVisibleOTP = OtpEncryption.decryptOTP(apiEncryptedOTP);
        });
        startTimer();
      }

      getMembershipListApi();
    }
    Fluttertoast.showToast(
      msg: verifyPartnerModel.message ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: AppColors.black,
      fontSize: 16.0,
    );
    setState(() {});
  }

  @override
  void getMembershipListErr(String error) {
    setState(() {
      isGetMembershipApiLoading = false;
    });
  }

  @override
  void getMembershipListSuccess(GetMembershipListModel getMembershipListModel) {
    isGetMembershipApiLoading = false;

    this.getMembershipListModel = getMembershipListModel;

    setState(() {});
  }

  @override
  void validateOtpErr(String err) {
    setState(() {
      isValidateApiLoading = false;
    });
  }

  @override
  void validateOtpSuccess(ValidateOtp validateOtp) {
    isValidateApiLoading = false;
    verifyOtpModel = validateOtp;

    if (validateOtp.status ?? false) {
      getMembershipListApi();
      Fluttertoast.showToast(
        msg: validateOtp.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: AppColors.black,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: validateOtp.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: AppColors.black,
        fontSize: 16.0,
      );
    }

    setState(() {});
  }

  @override
  void resendOtpErr(String err) {
    setState(() {
      isResendOtp = false;
    });
  }

  @override
  void resendOtpSuccess(ResendOtpModal resendOtpModal) {
    isResendOtp = false;
    if (resendOtpModal.status ?? false) {
      final apiEncryptedOTP = resendOtpModal.values?.first.otp ?? '';

      userVisibleOTP = OtpEncryption.decryptOTP(apiEncryptedOTP);

      Fluttertoast.showToast(
        msg: resendOtpModal.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: AppColors.black,
        fontSize: 16.0,
      );
    }
    setState(() {});
  }
}
