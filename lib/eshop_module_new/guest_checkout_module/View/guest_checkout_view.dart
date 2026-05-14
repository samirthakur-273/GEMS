/*
Author-Nilisha
Description:- Ui Design Guest Checkout
*/

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/checkout_order_details.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/payment_form.dart';

class GuestCheckoutView extends StatefulWidget {
  GuestCheckoutView({Key? key}) : super(key: key);

  @override
  _GuestCheckoutViewState createState() => _GuestCheckoutViewState();
}

class _GuestCheckoutViewState extends State<GuestCheckoutView> {
  bool _isPaymentActive = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          reviewHeader(),
          SizedBox(
            height: 4,
          ),
          CheckoutCartDetails(),
          _shippingOrPayment(),
          SizedBox(
            height: 4,
          ),
          _paymentHeading('Shipping Address'),
          SizedBox(
            height: 2,
          ),
          _shippingAddress(),
          SizedBox(
            height: 4,
          ),
          _paymentHeading('Payment'),
          SizedBox(
            height: 2,
          ),
          PaymentForm()
        ],
      ),
    );
  }

  Widget reviewHeader() {
    return Container(
      height: 60,
      decoration: boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Reviewed your order',
              weight: FontWeight.bold,
              size: text_font_medium_x_size,
            ),
            TextWidget(
              text: 'Edit Cart',
              decoration: TextDecoration.underline,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            offset: Offset(
              0,
              10,
            ),
            blurRadius: 20,
            color: Color(0xFF4056C6).withOpacity(.15))
      ],
    );
  }

  _shippingOrPayment() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          height: 100,
          padding: EdgeInsets.all(8),
          decoration: boxDecoration(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isPaymentActive = false;
                    });
                  },
                  child: Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: _isPaymentActive == false
                                  ? theme_color
                                  : white_text_color,
                              border: Border.all(
                                  color: _isPaymentActive == false
                                      ? Colors.transparent
                                      : black_color)),
                          child: TextWidget(
                            text: "1",
                            color: _isPaymentActive == false
                                ? white_text_color
                                : theme_color,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextWidget(
                              text: 'Shipping',
                              toUpperCase: true,
                              weight: FontWeight.bold,
                              color: _isPaymentActive == false
                                  ? theme_color
                                  : black_color,
                            ),
                            const SizedBox(height: 5.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: TextWidget(
                                text: 'Please select or add your address',
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isPaymentActive = true;
                    });
                  },
                  child: Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: _isPaymentActive == true
                                  ? theme_color
                                  : white_text_color,
                              border: Border.all(
                                  color: _isPaymentActive == true
                                      ? Colors.transparent
                                      : Colors.grey)),
                          child: TextWidget(
                            text: "2",
                            color: _isPaymentActive == true
                                ? white_text_color
                                : black_color,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextWidget(
                              text: 'payment',
                              toUpperCase: true,
                              weight: FontWeight.bold,
                              color: _isPaymentActive == false
                                  ? black_color
                                  : theme_color,
                            ),
                            const SizedBox(height: 5.0),
                            SizedBox(
                              width: 120,
                              child: TextWidget(
                                text: 'Credit / Debit or Cash on Delivery',
                                color: Colors.grey,
                                size: 12,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ])),
    );
  }

  _paymentHeading(title) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: boxDecoration(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextWidget(
          text: title,
          toUpperCase: true,
          weight: FontWeight.bold,
          color: theme_color,
        ),
      ),
    );
  }

  _shippingAddress() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: boxDecoration(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Test Test 8971525',
              ),
              SizedBox(
                height: 12,
              ),
              TextWidget(
                text: 'Test, AI Aweer, Dubai, United Arab Emirates',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
