import 'package:flutter/material.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class PlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageConstants.noimages,
      fit: BoxFit.contain,
      // color: Colors.grey.withOpacity(0.5),
    );
  }
}
