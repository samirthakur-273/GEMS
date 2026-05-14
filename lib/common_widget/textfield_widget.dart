/* Author : Ruchita Manve
 Date created : 04-July-2019
 Discription : Common Wideget for TextField */
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
final TextEditingController? controller;
final bool? isPassword;
final String? labeltxt;
final bool? isValid;
final String? validationMessage;
final TextInputType? textInputType;
final String? hinttext;
final bool? obscureText;
final int? maxLines;
final double? size;
TextFieldWidget({
Key? key,
this.isPassword,
this.controller,
this.labeltxt,
this.isValid,
this.validationMessage,
this.textInputType,
this.hinttext,
this.obscureText,
this.maxLines,
this.size

}) : super(key: key);

@override
Widget build(BuildContext context) {
return TextFormField(
controller: controller,
// validator: (String Values) {
keyboardType: this.textInputType,
textAlign: TextAlign.left,
decoration: InputDecoration.collapsed(
  
hintStyle: TextStyle(fontSize: this.size,),
hintText: this.hinttext,
border: InputBorder.none,
),
obscureText: false,
maxLines: this.maxLines,

// }
);
}
}