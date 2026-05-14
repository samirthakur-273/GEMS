// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gems_revamp/eshop_module_new/payment_gateway/input_formatters.dart';
// import 'package:gems_revamp/eshop_module_new/payment_gateway/payment_card.dart';
// import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';

// class PaymentGateWayPage extends StatefulWidget {
//   @override
//   _PaymentGateWayPageState createState() => _PaymentGateWayPageState();
// }

// class _PaymentGateWayPageState extends State<PaymentGateWayPage> {
//   TokenModel _token;

//   var _scaffoldKey = new GlobalKey<ScaffoldState>();
//   var _formKey = new GlobalKey<FormState>();
//   var numberController = new TextEditingController();
//   var _paymentCard = PaymentCard();
//   var _autoValidate = false;

//   var _card = new PaymentCard();
//   @override
//   void initState() {
//     super.initState();
//     _paymentCard.type = CardType.Others;
//     numberController.addListener(_getCardTypeFrmNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         key: _scaffoldKey,
//         appBar: new AppBar(
//           title: new Text(""),
//         ),
//         body: new Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: new Form(
//               key: _formKey,
//               autovalidateMode: _autoValidate
//                   ? AutovalidateMode.onUserInteraction
//                   : AutovalidateMode.disabled,
//               child: new ListView(
//                 children: <Widget>[
//                   new SizedBox(
//                     height: 20.0,
//                   ),
//                   new TextFormField(
//                     decoration: const InputDecoration(
//                       border: const UnderlineInputBorder(),
//                       filled: true,
//                       icon: const Icon(
//                         Icons.person,
//                         size: 40.0,
//                       ),
//                       labelText: 'Cardholder Name',
//                     ),
//                     onSaved: (String value) {
//                       _card.name = value;
//                     },
//                     keyboardType: TextInputType.text,
//                     validator: (String value) =>
//                         value.isEmpty ? PaymentCard.fieldReq : null,
//                   ),
//                   new SizedBox(
//                     height: 30.0,
//                   ),
//                   new TextFormField(
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       new LengthLimitingTextInputFormatter(19),
//                       new CardNumberInputFormatter()
//                     ],
//                     controller: numberController,
//                     decoration: new InputDecoration(
//                       border: const UnderlineInputBorder(),
//                       filled: true,
//                       icon: CardUtils.getCardIcon(_paymentCard.type),
//                       hintText: '•••• •••• •••• ••••',
//                       labelText: 'Number',
//                     ),
//                     onSaved: (String value) {
//                       _paymentCard.number = CardUtils.getCleanedNumber(value);
//                     },
//                     validator: CardUtils.validateCardNum,
//                   ),
//                   new SizedBox(
//                     height: 30.0,
//                   ),
//                   new TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       new LengthLimitingTextInputFormatter(4),
//                     ],
//                     decoration: new InputDecoration(
//                       border: const UnderlineInputBorder(),
//                       filled: true,
//                       icon: new Image.asset(
//                         'assets/shop_assets/card_cvv.png',
//                         width: 40.0,
//                         color: Colors.grey[600],
//                       ),
//                       hintText: '•••',
//                       labelText: 'CVV',
//                     ),
//                     validator: CardUtils.validateCVV,
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) {
//                       _paymentCard.cvv = int.parse(value);
//                     },
//                   ),
//                   new SizedBox(
//                     height: 30.0,
//                   ),
//                   new TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       new LengthLimitingTextInputFormatter(4),
//                       new CardMonthInputFormatter()
//                     ],
//                     decoration: new InputDecoration(
//                       border: const UnderlineInputBorder(),
//                       filled: true,
//                       icon: new Image.asset(
//                         'assets/shop_assets/calendar.png',
//                         width: 40.0,
//                         color: Colors.grey[600],
//                       ),
//                       hintText: 'MM/YY',
//                       labelText: 'Expiry Date',
//                     ),
//                     validator: CardUtils.validateDate,
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) {
//                       List<int> expiryDate = CardUtils.getExpiryDate(value);
//                       _paymentCard.month = expiryDate[0];
//                       _paymentCard.year = expiryDate[1];
//                     },
//                   ),
//                   new SizedBox(
//                     height: 50.0,
//                   ),
//                   new Container(
//                     alignment: Alignment.center,
//                     child: _getPayButton(),
//                   ),
//                   SizedBox(
//                     height: 32,
//                   ),
//                   _token == null ? Container() : Text("Token: ${_token.token}"),
//                 ],
//               )),
//         ));
//   }

//   Future<TokenModel> createToken(String cardNumber, String cardExpiryMonth,
//       String cardExpiryYear, String cardCvv) async {
//     final String apiUrl = "https://api.sandbox.checkout.com/tokens";
//     final String publicKey = "pk_test_a674ab6a-e287-4495-9551-a980a1f75444";

//     var body = {
//       "type": "card",
//       "number": cardNumber,
//       "expiry_month": cardExpiryMonth,
//       "expiry_year": cardExpiryYear,
//       "cvv": cardCvv
//     };
//     var jsonBody = jsonEncode(body);
//     var head = {
//       HttpHeaders.authorizationHeader: publicKey,
//       HttpHeaders.contentTypeHeader: "application/json"
//     };
//     final response =
//         await http.post(Uri.parse(apiUrl), headers: head, body: jsonBody);

//     if (response.statusCode == 201) {
//       final String responseString = response.body;

//       return tokenModelFromJson(responseString);
//     } else {
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is removed from the Widget tree
//     numberController.removeListener(_getCardTypeFrmNumber);
//     numberController.dispose();
//     super.dispose();
//   }

//   void _getCardTypeFrmNumber() {
//     String input = CardUtils.getCleanedNumber(numberController.text);
//     CardType cardType = CardUtils.getCardTypeFrmNumber(input);
//     setState(() {
//       this._paymentCard.type = cardType;
//     });
//   }

//   void _validateInputs() async {
//     final FormState form = _formKey.currentState;
//     if (!form.validate()) {
//       setState(() {
//         _autoValidate = true; // Start validating on every change.
//       });
//       _showInSnackBar('Please fix the errors in red before submitting.');
//     } else {
//       form.save();
//       _showInSnackBar('Token created successfully!');

//       // Exchange card details for Checkout.com token
//       final String cardNumber = _paymentCard.number.toString();
//       final String cardExpiryMonth = _paymentCard.month.toString();
//       final String cardExpiryYear = _paymentCard.year.toString();
//       final String cardCvv = _paymentCard.cvv.toString();

//       final TokenModel token = await createToken(
//           cardNumber, cardExpiryMonth, cardExpiryYear, cardCvv);

//       setState(() {
//         _token = token;
//       });

//       // Reset payment form
//       _formKey.currentState.reset();
//       numberController.text = "";
//     }
//   }

//   Widget _getPayButton() {
//     // if (.isIOS) {
//     //   return new CupertinoButton(
//     //     onPressed: _validateInputs,
//     //     color: CupertinoColors.activeBlue,
//     //     child: const Text(
//     //       Strings.pay,
//     //       style: const TextStyle(fontSize: 17.0),
//     //     ),
//     //   );
//     // } else {
//     return new RaisedButton(
//       onPressed: _validateInputs,
//       color: Colors.blueAccent,
//       splashColor: Colors.blue,
//       shape: RoundedRectangleBorder(
//         borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
//       textColor: Colors.white,
//       child: new Text(
//         PaymentCard.pay.toUpperCase(),
//         style: const TextStyle(fontSize: 17.0),
//       ),
//     );
//   }

//   void _showInSnackBar(String value) {
//     _scaffoldKey.currentState.showSnackBar(new SnackBar(
//       content: new Text(value),
//       duration: new Duration(seconds: 3),
//     ));
//   }
// }
