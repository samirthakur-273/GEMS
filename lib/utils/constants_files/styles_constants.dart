import 'package:flutter/material.dart';
import 'color_constants.dart';
import 'text_constants.dart';

class AppTheme {
  static const TextStyle appBarTextStyle = TextStyle(
    color: AppColors.deepBlack,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle manropeBlack14Normal = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle dmDisplayLightYellow28Regular = TextStyle(
    fontSize: 24,
    fontFamily: AppTexts.inter,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static const TextStyle interSmallTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interSmall500TextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interMediumTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interMedium400TextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interMediumBlueTextStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interMediumGreyTextStyle = TextStyle(
    color: Colors.grey,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interMedium500TextStyle = TextStyle(
    fontSize: 18,
    color: Colors.blue,
    fontWeight: FontWeight.w600,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interTextSize18Style = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle interSmallBlueTextStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontFamily: AppTexts.inter,
      fontSize: 14);
  static const TextStyle letterSpacingStyle = TextStyle(
    fontSize: 18,
    letterSpacing: 8.0,
  );

  static const TextStyle interBlack36SemiBold = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interBlack24SemiBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interBlack16Regular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interBlackShade16Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.blackShade,
    fontFamily: AppTexts.inter,
  );

  static TextStyle interLightBlack12Medium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
    color: AppColors.black.withAlpha(127),
  );
  static TextStyle interBlack12Medium = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interBlack17Medium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interBlack14Regular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );
  static const TextStyle interRed14Regular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interBlackShade24Medium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.blackShade,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interDarkGrey12Medium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGrey,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interDarkGrey14Medium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGrey,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interDarkGreyShade16Medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGreyShade,
    fontFamily: AppTexts.inter,
  );

  static TextStyle interDarkGreyShade10Medium = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
    color: AppColors.darkGreyShade.withAlpha(127),
  );

  static const TextStyle interBlack40Regular = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interDarkGreyShade14Medium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGreyShade,
    fontFamily: AppTexts.inter,
  );

  static const TextStyle interDeepBlackShade13Medium = TextStyle(
    color: AppColors.deepBlackShade,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: AppTexts.inter,
  );

  static ButtonStyle delinkButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightGrey,
    elevation: 0,
  );

  static const TextStyle black15Medium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueGrey,
  );
  static const TextStyle blackColorStyle = TextStyle(
    color: Colors.black,
  );
  static const TextStyle blackColorStyle14 = TextStyle(
    color: AppColors.black,
    fontStyle: FontStyle.italic,
    fontSize: 14,
  );
  static const TextStyle blackBoldColorStyle14 = TextStyle(
    color: AppColors.black,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  static const TextStyle blackNormalColorStyle14 = TextStyle(
    color: AppColors.black,
    fontStyle: FontStyle.italic,
    fontSize: 14,
  );
}
