import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants_files/color_constants.dart';
import '../../../../utils/constants_files/imageconstants.dart';
import '../../../../utils/constants_files/styles_constants.dart';
import '../../../../utils/constants_files/text_constants.dart';
import '../convert_points/submit_transaction/submit_transaction_model.dart';
import '../partner_details/partner_details_model.dart';

class ConversionSuccessfulScreen extends StatefulWidget {
  final int pointsConverted;
  final int pointsTransferred;
  final SubmitTransactionModel? submitTransactionModel;
  final bool isSwap;
  final PartnerDetailsModel? partnerDetailsModel;

  ConversionSuccessfulScreen({
    required this.pointsConverted,
    required this.partnerDetailsModel,
    required this.submitTransactionModel,
    required this.pointsTransferred,
    required this.isSwap,
  });

  @override
  State<ConversionSuccessfulScreen> createState() =>
      _ConversionSuccessfulScreenState();
}

class _ConversionSuccessfulScreenState
    extends State<ConversionSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    final displayName =
        widget.partnerDetailsModel?.values?.first.displayName ?? '';

    final swappedPointsTransferredMsg =
        '${AppTexts.yourText} ${widget.pointsTransferred} $displayName ${AppTexts.convertedToText} ${widget.pointsConverted} ${AppTexts.gemsPointsText} ${AppTexts.convertedTimeText}.';
    final unSwappedPointsTransferredMsg =
        '${AppTexts.yourText} ${widget.pointsTransferred} ${AppTexts.gemsPointsText} ${AppTexts.convertedToText} ${widget.pointsConverted} $displayName ${AppTexts.convertedTimeText}.';
    final transactionStatus =
        widget.submitTransactionModel?.values?.first.transactionStatus ?? '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
    
        Navigator.pop(context, AppTexts.isFromConversionSuccessfulText);
      

        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteShade,
         extendBodyBehindAppBar: false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75.0),
            child: AppBar(
              backgroundColor: AppColors.whiteShade,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Image.asset(
                  ImageConstants.backArrow,
                  fit: BoxFit.contain,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.pop(context, AppTexts.isFromConversionSuccessfulText);  
                },
              ),
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(
                      ImageConstants.tickCircle,
                    ),
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppTexts.conversionText}\n $transactionStatus!',
                    style: AppTheme.interBlack36SemiBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.isSwap
                                ? swappedPointsTransferredMsg
                                : unSwappedPointsTransferredMsg,
                            textAlign: TextAlign.center,
                            style: AppTheme.interBlack16Regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppTexts.transactionDetailsText,
                            style: AppTheme.interBlackShade16Bold,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.submitTransactionModel?.values?.first
                                        .referenceId ??
                                    '',
                                style: AppTheme.interBlack12Medium,
                              ),
                              Text(
                                formatApiDate(
                                        '${widget.submitTransactionModel?.values?.first.createdAt ?? ''}')
                                    .toString(),
                                style: AppTheme.interBlack12Medium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                AppTexts.from,
                                style: AppTheme.interDarkGrey12Medium,
                              ),
                              const Text(
                                AppTexts.to,
                                style: AppTheme.interDarkGrey12Medium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.isSwap
                                    ? displayName
                                    : AppTexts.gemsPointsText,
                                style: AppTheme.interBlack12Medium,
                              ),
                              Text(
                                widget.isSwap
                                    ? AppTexts.gemsPointsText
                                    : displayName,
                                style: AppTheme.interBlack12Medium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppTexts.needHelpText,
                            style: AppTheme.interBlackShade24Medium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            AppTexts.conversionSupportOptionsText,
                            style: AppTheme.interDarkGrey14Medium,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () async {
                              const String phoneNumber =
                                  AppTexts.supportContactNumber;
                              final Uri whatsappUrl = Uri.parse(
                                  "${AppTexts.whatsappBaseUrl}$phoneNumber");

                              if (await canLaunchUrl(whatsappUrl)) {
                                await launchUrl(whatsappUrl,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  ImageConstants.whatsapp,
                                  height: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  AppTexts.supportContactNumber,
                                  style: AppTheme.interBlack16Regular,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              const String email = AppTexts.supportEmail;
                              const String subject =
                                  AppTexts.supportEmailSubject;
                              const String body = AppTexts.supportEmailBody;
                              final Uri emailUri = Uri.parse(
                                "${AppTexts.mailTo}$email?${AppTexts.subjectPrefix}${Uri.encodeComponent(subject)}&${AppTexts.bodyPrefix}${Uri.encodeComponent(body)}",
                              );

                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  ImageConstants.email,
                                  height: 20,
                                  color: AppColors.greyShade900,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  AppTexts.supportEmail,
                                  style: AppTheme.interBlack16Regular,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatApiDate(String apiDate) {
    final parsedDate = DateTime.parse(apiDate);
    return DateFormat(AppTexts.dateFormat).format(parsedDate);
  }
}
