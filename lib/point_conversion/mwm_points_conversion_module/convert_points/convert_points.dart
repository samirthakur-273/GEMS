

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../utils/constants_files/color_constants.dart';
import '../../../../utils/constants_files/imageconstants.dart';
import '../../../../utils/constants_files/styles_constants.dart';
import '../../../../utils/constants_files/text_constants.dart';
import '../../../account/profile/user_profile_model.dart';
import '../../../account/profile/user_profile_presenter.dart';
import '../../../account/profile/user_profile_view.dart';
import '../../../utilities/auth_utils.dart';
import '../../../utils/connectivity.dart';
import '../../../utils/gemsGlobals.dart';
import '../delink/delink_model.dart';
import '../delink/delink_presenter.dart';
import '../delink/delink_request_model.dart';
import '../delink/delink_view.dart';
import '../get_membership_list/get_membership_list_model.dart';
import '../partner_details/partner_details_model.dart';
import '../point_conversion_successful/conversion_successful.dart';
import '../transaction_capping/transaction_capping_model.dart';
import '../transaction_capping/transaction_capping_presenter.dart';
import '../transaction_capping/transaction_capping_request_model.dart';
import '../transaction_capping/transaction_capping_view.dart';
import 'submit_transaction/submit_transaction_model.dart';
import 'submit_transaction/submit_transaction_presenter.dart';
import 'submit_transaction/submit_transaction_request_model.dart' as request;
import 'submit_transaction/submit_transaction_view.dart';

class ConvertPointsScreen extends StatefulWidget {
  final MembershipListInfo? values;

  late String? partnerCurrencyCode;
  PartnerDetailsModel? partnerDetailsModel;
  bool isSwap;

  ConvertPointsScreen({
    super.key,
    this.values,
    required this.partnerCurrencyCode,
    required this.partnerDetailsModel,
    required this.isSwap,
  });

  @override
  State<ConvertPointsScreen> createState() => _ConvertPointsScreenState();
}

class _ConvertPointsScreenState extends State<ConvertPointsScreen>
    implements
        DelinkView,
        SubmitTransactionView,
        TransactionCappingView,
        UserProfileView {
  late DelinkPresenter delinkPresenter;
  late SubmitTransactionPresenter submitTransactionPresenter;
  late TransactionCappingPresenter transactionCappingPresenter;
  bool isApiLoading = true;
  bool isConvertPointsLoading = false;
  DelinkModel? delinkModel;
  SubmitTransactionModel? submitTransactionModel;
  TransactionCappingModel? transactionCappingModel;
  double _currentSliderValue = 0.0;
  int? minTransferValue = 0;
  final double defaultRedemptionRatio = 0.0;
  int defaultIncrementalValue = 1000;
  late UserProfilePresenter? userProfilePresenter;

  @override
  void initState() {
    super.initState();
    delinkPresenter = DelinkPresenter(this);
    submitTransactionPresenter = SubmitTransactionPresenter(this);
    transactionCappingPresenter = TransactionCappingPresenter(this);
    userProfilePresenter = UserProfilePresenter(this);
    transactionCappingApi();
  }

  Widget pointTransfer(pointsToBeTransferred) {
    final incrementalValue =
        transactionCappingModel?.values?.first.incrementalValue ??
            defaultIncrementalValue;

    final int? maxTransfer =
        transactionCappingModel?.values?.first.maxTransfer?.toInt();
    final userBalance =
        transactionCappingModel?.values?.first.pointBalance?.toInt() ??
            GemsGLobals.pointbalance.toInt();

    var maxValue = 0;

    if (widget.isSwap) {
      maxValue =
          (maxTransfer != null && maxTransfer > 0) ? maxTransfer : userBalance;
    } else {
      if (maxTransfer != null && maxTransfer > 0) {
        maxValue = userBalance > maxTransfer ? maxTransfer : userBalance;
      } else {
        maxValue = userBalance;
      }
    }
    final minValue =
        transactionCappingModel?.values?.first.minTransfer?.toInt() ?? 0;

    final calculatedDivisions = (maxValue - minValue) ~/ incrementalValue;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(
              color: AppColors.greyShade,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppTexts.selectPointsToConvertText,
                  style: AppTheme.interDarkGreyShade10Medium,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_currentSliderValue.toInt()}',
                        style: AppTheme.interBlack40Regular,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.isSwap
                            ? widget.partnerDetailsModel?.values?.first
                                    .displayName ??
                                ''
                            : AppTexts.gemsPointsText,
                        style: AppTheme.interDarkGreyShade14Medium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.black,
            inactiveTrackColor: AppColors.grey,
            trackHeight: 4.0,
            thumbColor: AppColors.blue,
            thumbShape: const CustomSliderThumb(thumbRadius: 25.0),
          ),
          child: Slider(
            value: _currentSliderValue,
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: calculatedDivisions > 0 ? calculatedDivisions : null,
            onChanged: (value) {
              if (!isConvertPointsLoading) {
                setState(() {
                  _currentSliderValue =
                      (value ~/ incrementalValue * incrementalValue).toDouble();

                  if (_currentSliderValue > maxValue) {
                    _currentSliderValue = maxValue.toDouble();
                  }
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minTransferValue.toString(),
                style: AppTheme.interLightBlack12Medium,
              ),
              Text(
                widget.isSwap
                    ? transactionCappingModel?.values?.first.pointBalance
                            ?.toString() ??
                        ''
                    : GemsGLobals.pointbalance.toString(),
                style: AppTheme.interLightBlack12Medium,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 75,
        ),
        if (maxTransfer != null && userBalance > maxTransfer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: GemsGLobals.noteText,
                      style: AppTheme.blackBoldColorStyle14),
                  const TextSpan(
                      text: AppTexts.maximumTransactionsText,
                      style: AppTheme.blackNormalColorStyle14),
                  TextSpan(
                      text: gemsPointsFormatter(maxTransfer),
                      style: AppTheme.blackNormalColorStyle14),
                  const TextSpan(
                      text: AppTexts.pointText,
                      style: AppTheme.blackNormalColorStyle14),
                ],
              ),
            ),
          ),
        const SizedBox(
          height: 75,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              flex: 3,
              child: Text(
                AppTexts.pointsToBeCreditedText,
                textAlign: TextAlign.center,
                style: AppTheme.interBlack14Regular,
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                pointsToBeConverted(),
                style: AppTheme.interBlack14Regular,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            getConversionRateText(),
            style: AppTheme.interBlack12Medium,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isConvertPointsLoading
                ? null
                : () {
                    isConvertPointsLoading = true;
                    final requestBody = request.SubmitTransactionRequestModel(
                      transactionFrom: widget.isSwap
                          ? widget.partnerCurrencyCode ?? ''
                          : widget.values?.clientDetails?.clientId ?? '',
                      transactionTo: widget.isSwap
                          ? widget.values?.clientDetails?.clientId ?? ''
                          : widget.partnerCurrencyCode ?? '',
                      clientMemberId: GemsGLobals.membershipNo ?? '',
                      clientDetails: request.ClientDetails(
                        linkMemberId: widget.values?.linkBookingRefNo ?? '',
                        pointsTransferred: widget.isSwap
                            ? pointsToBeTransferred
                            : _currentSliderValue.toInt(),
                      ),
                      partnerDetails: request.PartnerDetails(
                        partnerMemberId:
                            widget.values?.partnerDetails?.partnerMemberId ??
                                '',
                        pointsToBeTransferred: widget.isSwap
                            ? _currentSliderValue.toInt()
                            : pointsToBeTransferred,
                      ),
                      clientTierCode: AppTexts.tierCode,
                      partnerTierCode: widget.partnerDetailsModel?.values?.first
                              .partnerTier?.first.code ??
                          '',
                    );
                    setState(() {});

                    submitTransactionPresenter
                        .submitTransactionApiCall(requestBody)
                        .then(
                      (value) {
                        if (submitTransactionModel?.status ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversionSuccessfulScreen(
                                isSwap: widget.isSwap,
                                submitTransactionModel: submitTransactionModel,
                                pointsTransferred: _currentSliderValue.toInt(),
                                pointsConverted: pointsToBeTransferred,
                                partnerDetailsModel: widget.partnerDetailsModel,
                              ),
                            ),
                          ).then((value) {
                            isConvertPointsLoading = false;
                            setState(() {});
                            if (value.toString() ==
                                AppTexts.isFromConversionSuccessfulText) {
                              Navigator.pop(context, value);
                            }
                          });
                        } else {
                          isConvertPointsLoading = false;
                          setState(() {});
                        }
                      },
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenShade,
              disabledBackgroundColor: AppColors.greenShade,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Visibility(
              visible: isConvertPointsLoading,
              replacement: const Text(
                AppTexts.convertPointsText,
                style: AppTheme.interBlack17Medium,
              ),
              child: const CircularProgressIndicator(
                color: AppColors.blue,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final redemptionRatio = double.tryParse(
            transactionCappingModel?.values?.first.redemptionRatio ??
                defaultRedemptionRatio.toString()) ??
        defaultRedemptionRatio;
    final pointsToBeTransferred =
        (_currentSliderValue * redemptionRatio).toInt();

    final customerDetails = widget.values?.customerDetails;
    final partnerDetails = widget.values?.partnerDetails;

    final firstName = customerDetails?.firstName ?? '';
    final lastName = customerDetails?.lastName ?? '';
    final fullName = '$firstName $lastName';
    final email = customerDetails?.email ?? '';
    final partnerMemberId = partnerDetails?.partnerMemberId ?? '';
    final linkBookingRefNo = widget.values?.linkBookingRefNo ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          AppTexts.convertPointsText,
          style: AppTheme.appBarTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteShade,
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
      ),
      body: isApiLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: widget.isSwap ? 90 : 50,
                                  width: widget.isSwap ? 90 : 50,
                                  child: widget.isSwap
                                      ? CachedNetworkImage(
                                          imageUrl: widget
                                                  .values
                                                  ?.partnerDetails
                                                  ?.partnerLogo ??
                                              '',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : Image.asset(
                                          ImageConstants.gemsNewLogo,
                                          fit: BoxFit.cover,
                                        )),
                              const SizedBox(width: 8),
                              Image.asset(
                                ImageConstants.horizontalDottelLine,
                                width: MediaQuery.of(context).size.width * 0.25,
                              ),
                              if (widget.isSwap) const SizedBox(width: 8),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: widget.isSwap ? 50 : 90,
                                width: widget.isSwap ? 50 : 90,
                                child: widget.isSwap
                                    ? Image.asset(
                                        ImageConstants.gemsNewLogo,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: widget.values?.partnerDetails
                                                ?.partnerLogo ??
                                            '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: AppTheme.interDarkGreyShade16Medium,
                                  ),
                                  const SizedBox(height: 4),
                                  if (email.isNotEmpty)
                                    Text(
                                      email,
                                      style:
                                          AppTheme.interDarkGreyShade10Medium,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    partnerMemberId,
                                    style: AppTheme.interDarkGreyShade10Medium,
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final requestBody = DelinkRequestModel(
                                    mode: AppTexts.wrongeMemberIdMode,
                                    clientMemberId:
                                        GemsGLobals.membershipNo ?? '',
                                    linkBookingRefNo: linkBookingRefNo,
                                  );
                                  await delinkPresenter
                                      .delinkApiCall(requestBody)
                                      .then((value) {});
                                },
                                style: AppTheme.delinkButtonStyle,
                                child: const Text(
                                  AppTexts.deLinkText,
                                  style: AppTheme.interDeepBlackShade13Medium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          (minTransferValue != null &&
                                  minTransferValue! >
                                      (widget.isSwap
                                          ? (transactionCappingModel?.values
                                                  ?.first.pointBalance ??
                                              0)
                                          : GemsGLobals.pointbalance))
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: AppTexts.minimumText,
                                        style: AppTheme.interRed14Regular,
                                        children: [
                                          TextSpan(
                                            text: ' $minTransferValue ',
                                            style: AppTheme.interRed14Regular,
                                          ),
                                          const TextSpan(
                                            text: AppTexts.pointsText,
                                            style: AppTheme.interRed14Regular,
                                          ),
                                          const TextSpan(
                                            text: AppTexts.initiatedText,
                                            style: AppTheme.interRed14Regular,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : pointTransfer(pointsToBeTransferred),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void onDelinkError(String error) {
    setState(() {
      isApiLoading = false;
    });
  }

  @override
  void onDelinkSuccess(DelinkModel response) {
    setState(() {
      delinkModel = response;
      isApiLoading = false;
      if (response.status ?? false) {
        Fluttertoast.showToast(
          msg: delinkModel?.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        ).then((value) => Navigator.pop(context));
      } else {
        Fluttertoast.showToast(
          msg: delinkModel?.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  void onSubmitTransactionError(String error) {
    setState(() {
      isApiLoading = false;
    });
  }

  void onSubmitTransactionSuccess(SubmitTransactionModel response) {
    setState(
      () {
        submitTransactionModel = response;
        isApiLoading = false;
        if (!(submitTransactionModel?.status ?? false)) {
          Fluttertoast.showToast(
            msg: submitTransactionModel?.message?.toLowerCase() ==
                    GemsGLobals.timeOutText
                ? GemsGLobals.tryAgainErrorMessage
                : submitTransactionModel?.message ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: AppColors.black,
            fontSize: 16.0,
          );
        } else {
          userProfileApi(GemsGLobals.membershipNo);
        }
      },
    );
  }

  @override
  void onTransactionCappingError(String error) {
    setState(() {
      isApiLoading = false;
    });
  }

  @override
  void onTransactionCappingSuccess(TransactionCappingModel response) {
    setState(() {
      transactionCappingModel = response;
      isApiLoading = false;
      final minTransfer = response.values?.first.minTransfer?.toDouble();
      if (minTransfer != null) {
        _currentSliderValue = minTransfer;
        minTransferValue =
            transactionCappingModel?.values?.first.minTransfer?.toInt() ?? 0;
      }
      if (!(response.status ?? false)) {
        Fluttertoast.showToast(
          msg: response.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
      }
    });
  }

  void transactionCappingApi() {
    final transactionFrom = widget.isSwap
        ? widget.partnerCurrencyCode ?? ''
        : widget.values?.clientDetails?.clientId ?? '';
    final transactionTo = widget.isSwap
        ? widget.values?.clientDetails?.clientId ?? ''
        : widget.partnerCurrencyCode ?? '';
    final partnerMemberId =
        widget.values?.partnerDetails?.partnerMemberId ?? '';

    final requestBody = TransactionCappingRequestModel(
      clientTierCode: AppTexts.tierCode,
      partnerTierCode:
          widget.partnerDetailsModel?.values?.first.partnerTier?.first.code ??
              '',
      transactionFrom: transactionFrom,
      transactionTo: transactionTo,
      clientMemberId: GemsGLobals.membershipNo ?? '',
      partnerMemberId: widget.isSwap ? partnerMemberId : '',
    );
    transactionCappingPresenter.transactionCappingLimitApi(requestBody);
  }

  int calculateRedemptionValue() {
    final redemptionRatio = double.tryParse(
            transactionCappingModel?.values?.first.redemptionRatio ??
                defaultRedemptionRatio.toString()) ??
        defaultRedemptionRatio;
    return (_currentSliderValue * redemptionRatio).floor();
  }

  String getConversionRateText() {
    final conversionRate =
        transactionCappingModel?.values?.first.redemptionRatio ?? '';
    final partnerName = widget.partnerDetailsModel?.values?.first
            .partnerCurrency?.first.partnerCurrencyName ??
        '';

    if (widget.isSwap) {
      return '${AppTexts.conversionRateText} ${AppTexts.onePartnerPoint} $partnerName ${AppTexts.equalToSign} $conversionRate ${AppTexts.gemsPointsText}';
    } else {
      return '${AppTexts.conversionRateText} ${AppTexts.gemText} $conversionRate $partnerName';
    }
  }

  pointsToBeConverted() {
    if (widget.isSwap) {
      return '${calculateRedemptionValue()} ${AppTexts.gemsPointsText}';
    } else {
      return '${calculateRedemptionValue()} ${widget.partnerDetailsModel?.values?.first.partnerCurrency?.first.partnerCurrencyName ?? ''}';
    }
  }

  void userProfileApi(membershipNo) {
    Internetconnectivity().isConnected().then((connected) async {
      if (connected) {
        userProfilePresenter?.userProfileResonse(membershipNo);
      }
    });
  }

  @override
  void networkError(err) {}

  @override
  void userProfileErrorRespone(Error error) {
    setState(() {
      isApiLoading = false;
    });
  }

  @override
  void userProfileSuceessRespone(UserProfileModel userProfileModel) {
    userProfileModel = userProfileModel;
    if (userProfileModel.status ?? false) {
      setState(() {
        GemsGLobals.pointbalance = userProfileModel.values!.pointBalance!;

        AuthUtils.setStringValue(AppTexts.pointBalanceText,
            gemsPointsFormatter(userProfileModel.values!.pointBalance!));
      });
    }
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;

  const CustomSliderThumb({this.thumbRadius = 20.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? AppColors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, paint);

    final linePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const lineSpacing = 6;
    for (var i = -1; i <= 1; i++) {
      final lineOffset = i * lineSpacing;
      canvas.drawLine(
        Offset(center.dx + lineOffset, center.dy - thumbRadius / 2),
        Offset(center.dx + lineOffset, center.dy + thumbRadius / 2),
        linePaint,
      );
    }
  }
}
