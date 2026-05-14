import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/confirmationpage.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/Presenter/guest_checkout_controller.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/apply_coupon_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/payment_card_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/presenter/apply_coupon_presenter.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/shopwebviewPage.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/view/apply_coupon_view.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/checkout_view.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/model/checkout_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentForm extends StatefulWidget {
  AddressSave? addressSave;
  Address? customerSelectedOldaddress;
  bool? usernewaddress;
  String? cartId;
  String? shippingtype;
  String? appliedCoupon;
  final String? ordertotal;
  final String? burnRate;
  final pointsEarned;
  final String? minPointsReq;
  final String? totalPoinstBurned;
  final bool? virtualRequest;
  CartDetailsModel? cartDetailsModel;
  void Function(Paymentmethod paymentmethod, Paymentmethod storevalue)?
      onchanged;

  void Function(bool coupounUsed)? callCartApi;

  PaymentForm(
      {Key? key,
      this.addressSave,
      this.customerSelectedOldaddress,
      this.usernewaddress,
      this.cartId,
      this.shippingtype,
      this.onchanged,
      this.callCartApi,
      this.appliedCoupon,
      this.ordertotal,
      this.burnRate,
      this.pointsEarned,
      this.minPointsReq,
      this.totalPoinstBurned,
      this.cartDetailsModel,
      this.virtualRequest})
      : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm>
    implements GuestCheckoutVieww, ApplyCouponView {
  ApplyCouponPresenter? _presenter;
  bool applyCoupon = false;
  bool coupounapplied = false;
  var _couponCodeController = TextEditingController();
  List _payment = [];
  String? payments;
  String? _value;
  String? rewardPoints;
  Paymentmethod? cardorcash;
  Paymentmethod? store;
  bool isguestcheckout = false;
  PaymentMethodModel? paymentMethodresponse;
  String? paymentType;
  bool isloading = true;
  AddressSave? addressSave;
  List<CheckoutModel>? checkoutmodel;
  StoreCreditModel? storecreditmodelresponse;
  String? storeIsUsed;
  String? orderid;
  bool checkBoxValue = false;
  bool selectPayment = false;
  var burnpoints;
  var prefs;
  var lang;
  var cardNumber;
  var cvcError;
  var expirationError;
  bool hideOtherPayments = false;
  static var dbHelper = MyProfileDBHelper();
  OrderRequest orderRequest = new OrderRequest();
  CartDetailsModel? cartDetailsModel;
  int? shippingPoint;
  @override
  void initState() {
    super.initState();

    addressSave = widget.addressSave;
    if (widget.appliedCoupon != "") {
      _couponCodeController.text = widget.appliedCoupon!;
      coupounapplied = true;
    }
    cartDetailsModel = widget.cartDetailsModel;

    var body = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId
    };
    internetCall(
        context, () => GuestCheckoutPresenter().paymentMethod(this, body));
    _presenter = ApplyCouponPresenter(this);
    burnpoints = double.parse(
            widget.ordertotal!.replaceAll("AED ", "").replaceAll(",", "")) /
        double.tryParse(widget.burnRate!)!;
    if (burnpoints >= GemsGLobals.userGEMSpoints) hideOtherPayments = true;
    storeRelated();
    initLang();
    if (GlobalValue.paymentType == "usebounz") {
      itemPointSpecificPointConversion(widget.cartDetailsModel!);
    } else {
      collectPointConversion(widget.cartDetailsModel!);
    }
  }

  void storeRelated() async {
    var prefs = await SharedPreferences.getInstance();
    storeIsUsed = prefs.getString("Store");
    setState(() {});
  }

  void collectPointConversion(CartDetailsModel cartDetailsModel) {
    orderRequest.pointData = [];
    String subTotal =
        cartDetailsModel.subTotal!.replaceAll("AED ", "").replaceAll(",", "");
    cartDetailsModel.items!.forEach((element) {
      orderRequest.pointData!.add(new PointDatum(
          sku: element.sku!,
          burnrate: "0",
          burnpoint: "0",
          burnamount: "0",
          cashamount: "0",
          earnpoint: element.pointEarned!,
          earnamount: subTotal,
          earnrate: element.earnrate!));
    });
  }

  void itemPointSpecificPointConversion(CartDetailsModel cartDetailsModel) {
    double priceValueAsPerPoint = GemsGLobals.userGEMSpoints.toDouble();
    int pointTotal = GemsGLobals.userGEMSpoints;
    orderRequest.pointData = [];
    cartDetailsModel.items!.forEach((element) {
      priceValueAsPerPoint = (pointTotal * double.tryParse(element.burnrate!)!);
      // if (priceValueAsPerPoint > 0) {
      int point = (double.tryParse(element.specialPrice == "0.00"
                  ? element.price!
                  : element.specialPrice!)! /
              double.tryParse(element.burnrate!)!)
          .round();
      if (pointTotal > point) {
        // if total point is more than item point
        int point = (double.tryParse(element.specialPrice == "0.00"
                    ? element.price!
                    : element.specialPrice!)! /
                double.tryParse(element.burnrate!)!)
            .round();
        orderRequest.pointData!.add(new PointDatum(
            sku: element.sku!,
            burnrate: element.burnrate!,
            burnpoint: point.toString(),
            burnamount: element.specialPrice == "0.00"
                ? element.price
                : element.specialPrice,
            cashamount: "0",
            earnpoint: "0",
            earnamount: "0",
            earnrate: "0"));
        pointTotal = pointTotal - point;
      } else {
        double burnAmount = priceValueAsPerPoint;
        double earnAmount =
            (burnAmount - double.tryParse(element.excltaxprice!)!);
        if (burnAmount > 0) {
          orderRequest.pointData!.add(new PointDatum(
              sku: element.sku!,
              burnrate: element.burnrate!,
              burnpoint: (burnAmount / double.tryParse(element.burnrate!)!)
                  .round()
                  .toString(),
              burnamount: (burnAmount.toStringAsFixed(2)).toString(),
              earnpoint: (earnAmount / double.tryParse(element.earnrate!)!)
                  .round()
                  .abs()
                  .toString(),
              earnamount: earnAmount.abs().toStringAsFixed(2).toString(),
              earnrate: element.earnrate!));
          pointTotal = pointTotal - point;
        } else {
          orderRequest.pointData!.add(new PointDatum(
              sku: element.sku!,
              burnrate: element.burnrate!,
              burnpoint: "0",
              burnamount: "0",
              earnpoint:
                  /*(double.tryParse(element.specialPrice == "0.00"
                          ? element.price
                          : element.specialPrice) /
                      double.tryParse(element.earnrate))
                  .round()
                  .toString()*/
                  element.pointEarned!,
              earnamount:
                  /*element.specialPrice == "0.00"
                  ? element.price
                  : element.specialPrice*/
                  element.excltaxprice!,
              earnrate: element.earnrate!));
          pointTotal = pointTotal - point;
        }
      }
      priceValueAsPerPoint = priceValueAsPerPoint -
          double.tryParse(element.specialPrice == "0.00"
              ? element.price!
              : element.specialPrice!)!;
    });
    if (cartDetailsModel.shippingAmount != null &&
        cartDetailsModel.shippingAmount != "AED 0.00") {
      String shippingAmount = cartDetailsModel.shippingAmount!
          .replaceAll("AED ", "")
          .replaceAll(",", "");
      int shippingPoint = (double.tryParse(shippingAmount)! /
              double.tryParse(cartDetailsModel.shippingBurnrate!)!)
          .round();
      if (pointTotal > shippingPoint) {
        orderRequest.pointData!.add(new PointDatum(
            sku: "shipping_changes",
            burnrate: cartDetailsModel.shippingBurnrate,
            burnpoint: shippingPoint.toString(),
            burnamount: shippingAmount,
            cashamount: "0",
            earnpoint: "0",
            earnamount: "0",
            earnrate: "0"));
      } else {
        double burnAmount = priceValueAsPerPoint;
        double earnAmount = (burnAmount - double.tryParse(shippingAmount)!);
        if (burnAmount > 0) {
          orderRequest.pointData!.add(new PointDatum(
              sku: "shipping_changes",
              burnrate: cartDetailsModel.shippingBurnrate,
              burnpoint: (burnAmount /
                      double.tryParse(cartDetailsModel.shippingBurnrate!)!)
                  .round()
                  .toString(),
              burnamount: (burnAmount.toStringAsFixed(2)).toString(),
              earnpoint: "0",
              earnamount: earnAmount.abs().toStringAsFixed(2).toString(),
              earnrate: "0"));
          // pointTotal = pointTotal - point;
        } else {
          orderRequest.pointData!.add(new PointDatum(
              sku: "shipping_changes",
              burnrate: cartDetailsModel.shippingBurnrate,
              burnpoint: "0",
              burnamount: shippingAmount,
              earnpoint: "0",
              earnamount: "0",
              earnrate: "0"));
        }
      }
    }
  }

  int totalBurnPoint = 0;
  int totalEarnPoint = 0;
  double totalBurnPrice = 0.0;
  double totalEarnPrice = 0.0;
  void totalPriceOrPoint() {
    totalBurnPoint = 0;
    totalEarnPoint = 0;
    totalBurnPrice = 0.0;
    totalEarnPrice = 0.0;
    orderRequest.pointData!.forEach((element) {
      totalBurnPrice = totalBurnPrice + double.tryParse(element.burnamount!)!;
      totalEarnPrice = totalEarnPrice + double.tryParse(element.earnamount!)!;
      totalBurnPoint = totalBurnPoint + int.tryParse(element.burnpoint!)!;
      totalEarnPoint = totalEarnPoint + int.tryParse(element.earnpoint!)!;
    });
  }

  void initLang() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      setState(() {
        lang = "en";
      });
    } else if (prefs.getString('language_code') == 'ar') {
      setState(() {
        lang = "ar";
      });
    } else {
      setState(() {
        lang = "en";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            height: 40,
            child: Loader(),
          )
        : _paymentSection();
  }

  List<Widget> _paymenttypes() {
    List<Widget> _paymethodmethd = [];
    int len = paymentMethodresponse?.shippingmethods?.length ?? 0;

    _value ??=
        GlobalValue.paymentType == "usebounz" && hideOtherPayments == false
            ? null
            : paymentMethodresponse?.shippingmethods
                    ?.firstWhere(
                      (element) => element.code == "ngeniusonline",
                    )
                    .code ??
                "";

    if (GlobalValue.paymentType == "usebounz" && hideOtherPayments == true) {
      checkBoxValue = true;
      rewardPoints = paymentMethodresponse?.shippingmethods
              ?.firstWhere(
                (element) => element.code == "banktransfer",
              )
              .code ??
          "";
    }
    setState(() {});

    for (var i = 0; i < len; i++) {
      _paymethodmethd.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalValue.paymentType == "collectbounz"
              ? paymentMethodresponse?.shippingmethods![i].code ==
                      "banktransfer"
                  ? Container()
                  : ListTile(
                      onTap: () {
                        setState(() {
                          _value =
                              paymentMethodresponse!.shippingmethods![i].code;
                          store = null;
                          selectPayment = false;
                          cardorcash =
                              paymentMethodresponse?.shippingmethods![i];
                          //   widget.onchanged(cardorcash, store);
                        });
                      },
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      title: TextWidget(
                        text:
                            paymentMethodresponse?.shippingmethods![i].title ??
                                "",
                      ),
                      leading: Radio<dynamic>(
                        value: paymentMethodresponse?.shippingmethods![i].code,
                        groupValue: _value,
                        activeColor: theme_color,
                        onChanged: (value) {
                          setState(() {
                            _value = value.toString();
                            store = null;
                            selectPayment = false;
                            cardorcash =
                                paymentMethodresponse?.shippingmethods![i];
                            // widget.onchanged(cardorcash, store);
                          });
                        },
                      ),
                    )
              : paymentMethodresponse?.shippingmethods![i].code ==
                      "banktransfer"
                  ? GemsGLobals.userGEMSpoints != 0
                      ? ListTile(
                          onTap: () {
                            setState(() {
                              checkBoxValue = !checkBoxValue;
                              rewardPoints = checkBoxValue
                                  ? paymentMethodresponse
                                      ?.shippingmethods![0].code
                                  : null;
                              selectPayment = false;
                              cardorcash =
                                  paymentMethodresponse?.shippingmethods![i];
                              //   widget.onchanged(cardorcash, store);
                            });
                          },
                          dense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          title: TextWidget(
                            text: paymentMethodresponse
                                    ?.shippingmethods![i].title ??
                                "",
                          ),
                          leading: Checkbox(
                              value: checkBoxValue,
                              activeColor: theme_color,
                              checkColor: white_color,
                              onChanged: (bool? value) {
                                checkBoxValue = value!;
                                selectPayment = false;
                                rewardPoints = paymentMethodresponse
                                    ?.shippingmethods![i].code;
                                setState(() {});
                              }),
                        )
                      : AbsorbPointer(
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            title: TextWidget(
                              text: paymentMethodresponse
                                      ?.shippingmethods![i].title ??
                                  "",
                              color: Colors.grey[300],
                            ),
                            leading: Checkbox(
                                value: checkBoxValue,
                                activeColor: theme_color,
                                checkColor: white_color,
                                onChanged: (bool? value) {
                                  checkBoxValue = value!;
                                  _value = paymentMethodresponse
                                      ?.shippingmethods![i].code;
                                  setState(() {});
                                }),
                          ),
                        )
                  : hideOtherPayments
                      ? ListTile(
                          onTap: () {
                            setState(() {
                              _value = paymentMethodresponse
                                  ?.shippingmethods![i].code;
                              store = null;
                              selectPayment = false;
                              cardorcash =
                                  paymentMethodresponse?.shippingmethods![i];
                              //   widget.onchanged(cardorcash, store);
                            });
                          },
                          dense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          title: TextWidget(
                            text: paymentMethodresponse
                                    ?.shippingmethods![i].title ??
                                "",
                          ),
                          leading: Radio<dynamic>(
                            value:
                                paymentMethodresponse?.shippingmethods![i].code,
                            groupValue: _value,
                            activeColor: theme_color,
                            onChanged: (value) {
                              setState(() {
                                _value = value.toString();
                                store = null;
                                selectPayment = false;
                                cardorcash =
                                    paymentMethodresponse?.shippingmethods![i];
                                // widget.onchanged(cardorcash, store);
                              });
                            },
                          ),
                        )
                      : Container(),
          if (paymentMethodresponse?.shippingmethods![i].code ==
                  "banktransfer" &&
              GlobalValue.paymentType == "usebounz")
            _rewarspoints(),
        ],
      ));
    }
    return _paymethodmethd;
  }

  Widget _rewarspoints() {
    return Container(
      margin: EdgeInsets.only(left: 65),
      child: TextWidget(
        text: "You have ${GemsGLobals.userGEMSpoints} Gems Points",
        weight: FontWeight.bold,
        size: text_font_small,
        color: GemsGLobals.userGEMSpoints == 0 ? Colors.grey[350] : black_color,
      ),
    );
  }

  _paymentSection() {
    return Container(
      //margin: EdgeInsets.only(left: 10, right: 10),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._paymenttypes(),
          // Container(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(12.0),
          //         child: TextWidget(
          //           text: 'Delivery Instruction',
          //           size: 14,
          //           weight: FontWeight.bold,
          //           maxLines: 2,
          //         ),
          //       ),
          //       Container(
          //         margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          //         child: TextField(
          //           maxLines: 3,
          //           controller: _deliveryInstController,
          //           decoration: InputDecoration(
          //             border: const OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //               borderSide:
          //                   const BorderSide(color: Colors.grey, width: 1.0),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          selectPayment
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          selectPayment
              ? Align(
                  alignment: Alignment.center,
                  child: TextWidget(
                    text: "Please select payment type",
                    color: Colors.red,
                    size: text_font_small,
                  ),
                )
              : Container(),
          isguestcheckout
              ? Container(
                  height: 40,
                  child: Loader(),
                )
              : _submitBtn()
        ],
      ),
    );
  }

  void checkoutApi() {
    setState(() {
      _payment.clear();
      if (_value != null) {
        _payment.add(_value);
      }
      if (rewardPoints != null) _payment.add(rewardPoints);

      payments = _payment.join(",");

      if (widget.virtualRequest!) {
        var body = {
          "brandcode": Constants.brandCode,
          "country_code": "main_website_store",
          "lang_code": Constants.langCode,
          "address_id": "",
          "firstname": addressSave?.firstname ?? GemsGLobals.userFirstName,
          "lastname": addressSave?.lastName ?? GemsGLobals.userLastName,
          "email": addressSave?.email ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "street": "-",
          "region": "-",
          "city": "-",
          "telephone":
              "${addressSave?.countryCode ?? GemsGLobals.countryCode}${addressSave?.number ?? GemsGLobals.mobilenumber}",
          "country_id": "AE",
          "save_in_address_book": '0',
          "shippingmethod": widget.shippingtype,
          "paymentmethod": payments,
          "burn_points": totalBurnPoint,
          "burn_amount": totalBurnPrice,
          "earnpoint": totalEarnPoint,
        };
        internetCall(context,
            () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
      } else if (widget.usernewaddress!) {
        var body = {
          "brandcode": Constants.brandCode,
          "country_code": "main_website_store",
          "lang_code": Constants.langCode,
          "address_id": "",
          "firstname": addressSave?.firstname,
          "lastname": addressSave?.lastName,
          "email": GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "street": addressSave?.streetAddress,
          "region": addressSave?.city,
          "city": addressSave?.area,
          "telephone": "${addressSave!.countryCode}${addressSave!.number}",
          "country_id": "AE",
          "save_in_address_book": addressSave?.savedefault.toString(),
          "shippingmethod": widget.shippingtype,
          "paymentmethod": payments,
          // "burn_points": _payment.contains("banktransfer")
          //     ? widget?.totalPoinstBurned
          //     : "",
          "burn_points": totalBurnPoint,
          // "burn_amount": _payment.contains("banktransfer")
          //     ? widget?.ordertotal?.replaceAll("AED ", "")?.replaceAll(",", "")
          //     : "",
          "burn_amount": totalBurnPrice,
          // "earnpoint": GlobalValue.paymentType == "collectbounz"
          //     ? widget.pointsEarned
          //     : "",
          "earnpoint": totalEarnPoint,
        };

        internetCall(context,
            () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
      } else {
        var body = {
          "brandcode": Constants.brandCode,
          "country_code": "main_website_store",
          "lang_code": Constants.langCode,
          "address_id": widget.customerSelectedOldaddress!.addressId,
          "email": GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "shippingmethod": widget.shippingtype,
          "paymentmethod": payments,
          // "burn_points": _payment.contains("banktransfer")
          //     ? widget?.totalPoinstBurned
          //     : "",
          "burn_points": totalBurnPoint,
          // "burn_amount": _payment.contains("banktransfer")
          //     ? widget?.ordertotal?.replaceAll("AED ", "")?.replaceAll(",", "")
          //     : "",
          "burn_amount": totalBurnPrice,
          // "earnpoint": GlobalValue.paymentType == "collectbounz"
          //     ? widget.pointsEarned
          //     : "",
          "earnpoint": totalEarnPoint,
        };

        internetCall(context,
            () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
      }
    });
  }

  Widget _submitBtn() {
    return Container(
      // width: MediaQuery.of(context).size.width / 1.1,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: new_gradient_color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.only(top: 15),
      child: MaterialButton(
        elevation: 5,
        highlightColor: Colors.grey[400],
        child: TextWidget(
          text: 'Place Order',
          color: white_text_color,
          size: text_font_medium_size,
          weight: FontWeight.bold,
        ),
        onPressed: () {
          setState(() {
            if (GlobalValue.paymentType == "usebounz" && !hideOtherPayments) {
              if (checkBoxValue == true) {
                isguestcheckout = true;
                totalPriceOrPoint();
                checkoutApi();
              } else {
                selectPayment = true;
              }
            } else if (_value == null && rewardPoints == null) {
              selectPayment = true;
            } else {
              totalPriceOrPoint();
              isguestcheckout = true;
              checkoutApi();
            }
          });
        },
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

  @override
  void checkoutResponse(List<CheckoutModel> checkoutmodel) async {
    if (checkoutmodel[0].success == "true") {
      this.checkoutmodel = checkoutmodel;
      if (_value == "ngeniusonline") {
        if (Constants.customerId == null ||
            Constants.customerId == "" ||
            Constants.customerId == "0") {
          Constants.guestId = null.toString();
          guestid();
        }
        GlobalValue.isstoreaapplied = false;
        isguestcheckout = false;
        setState(() {});

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopWebViewPage(
                    email: addressSave?.email ?? GemsGLobals.useremail,
                    webUrl: checkoutmodel[0].url,
                    orderId: checkoutmodel[0].orderId,
                    paymentMedthod: payments,
                    orderNumber: checkoutmodel[0].orderIncrementid,
                    orderRefence: checkoutmodel[0].reference,
                    ordertotal: widget.ordertotal!,
                    pointsEarned: widget.pointsEarned,
                    orderRequest: orderRequest,
                    totalBurnPoint: totalBurnPoint,
                    totalEarnPoint: totalEarnPoint,
                    totalBurnPrice: totalBurnPrice,
                    totalEarnPrice: totalEarnPrice,
                  )),
        );
      } else {
        setState(() {
          orderid = checkoutmodel[0].orderIncrementid;
          var body = {
            "email": addressSave?.email ?? GemsGLobals.useremail,
            "shopuserid": GemsGLobals.custEncryptedId,
            "orderid": checkoutmodel[0].orderId,
            "status": "processing",
            // "reference": checkoutmodel[0]?.reference,
            "customer_id": GemsGLobals.userId,
            // "burn_points": _payment.contains("banktransfer")
            //     ? widget?.totalPoinstBurned
            //     : "",
            "burn_points": totalBurnPoint,
            // "burn_amount": _payment.contains("banktransfer")
            //     ? widget?.ordertotal?.replaceAll("AED ", "")
            //     : "",
            "burn_amount": totalBurnPrice,
            "type": "staff",
            "description": checkoutmodel[0].orderId,
            "activity": "ESR",
            // "earnpoint": GlobalValue.paymentType == "collectbounz"
            //     ? widget.pointsEarned
            //     : "",
            "earnpoint": totalEarnPoint,
            "payment_method": payments,
            "point_data": (orderRequest.pointData),
          };
          internetCall(context, () {
            GuestCheckoutPresenter().orderStatusUpdate(this, body);
          });
        });
      }
    } else {
      isguestcheckout = false;
      Fluttertoast.showToast(
          msg: checkoutmodel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("Store", null.toString());
      MyProfileDBHelper().truncateMyProfileData();
      setState(() {});
    }
  }

  @override
  void responseFailure(response) {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": GemsGLobals.useremail,
          "shopxrid": GemsGLobals.membershipNo
        };
        internetCall(
            context, () => GuestCheckoutPresenter().paymentMethod(this, body));
      }
    });
  }

  @override
  void paymentMethodResponse(List<PaymentMethodModel> paymentMethod) {
    if (paymentMethod[0].success == "true") {
      isloading = false;
      isguestcheckout = false;
      paymentMethodresponse = paymentMethod[0];
      setState(() {});
    }
  }

  @override
  void applyCouponError(error) {}

  @override
  void applyCouponResponse(ApplyCouponModel response) {
    setState(() {
      if (response.success == "true") {
        coupounapplied = true;

        widget.callCartApi!(true);
        setState(() {});
      } else {
        coupounapplied = false;
        setState(() {});
        Fluttertoast.showToast(
            msg: response.message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  @override
  void paymentGatewayCreateToken(TokenModel? tokenModel) {
    if (tokenModel?.token != null && checkoutmodel != null) {
      var body;

      internetCall(
          context, () => GuestCheckoutPresenter().paymentCard(this, body));
    } else {
      isguestcheckout = false;
      Fluttertoast.showToast(
          msg: tokenModel?.errorCodes?[0].toString() ?? '',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {});
    }
  }

  @override
  void paymentByCard(PaymentCardModel paymentCardModel) {
    setState(() {
      isguestcheckout = false;
      if (paymentCardModel.success != null && paymentCardModel.success!) {
        /* truncate profile table */
        dbHelper.truncateMyProfileData();
        /*----------------------- */

        CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
        ShippingDetailsDBHelper().truncateShippingDetailsData();
        GlobalValue.isstoreaapplied = false;
        if (Constants.customerId == null ||
            Constants.customerId == "" ||
            Constants.customerId == "0") {
          Constants.guestId = null.toString();
          guestid();
        }
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    orderId: checkoutmodel![0].reference == null ||
                            checkoutmodel![0].reference == ""
                        ? paymentCardModel.orderId
                        : checkoutmodel![0].reference,
                  )),
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "${paymentCardModel.errorMessage![0].toString()} \n ${paymentCardModel.errorMessage![1].toString()}",
            gravity: ToastGravity.CENTER,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  guestid() async {
    var prefs = await SharedPreferences.getInstance();
  }

  @override
  void applystorecreditResponse(List<StoreCreditModel> storecreditmodel) async {
    if (storecreditmodel[0].success == "true") {}
  }

  @override
  void statusCheck(List<OrderStatusModel> orderstatus) {
    if (orderstatus[0].success == "true") {
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();
      // _makesensePurchaseSuccessApiCall(orderstatus[0].message!);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    orderId: orderid,
                    orderstatus: "success",
                  )));
    } else {
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();
      // _makesensePurchaseFailureApiCall();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    orderId: orderid,
                    orderstatus: "false",
                  )));
    }
  }

  @override
  void checkoutTimeOut() {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        checkoutApi();
      }
    });
  }

  @override
  void paymentTimeOut() {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId
        };
        internetCall(
            context, () => GuestCheckoutPresenter().paymentMethod(this, body));
      }
    });
  }

  @override
  void statusCheckTimeout() {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": addressSave?.email ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": checkoutmodel![0].orderId,
          "status": "processing",
          // "reference": checkoutmodel[0]?.reference,
          "customer_id": GemsGLobals.userId,
          "burn_points": totalBurnPoint,
          // "burn_amount": _payment.contains("banktransfer")
          //     ? widget?.ordertotal?.replaceAll("AED ", "")?.replaceAll(",", "")
          //     : "",
          "burn_amount": totalBurnPrice,
          // "earnpoint": GlobalValue.paymentType == "collectbounz"
          //     ? widget.pointsEarned
          //     : "",
          "earnpoint": totalEarnPoint,
          "type": "staff",
          "description": checkoutmodel![0].orderId,
          "activity": "ESR",

          "payment_method": payments,
          "point_data": (orderRequest.pointData),
        };

        internetCall(context, () {
          GuestCheckoutPresenter().orderStatusUpdate(this, body);
        });
      }
    });
  }

  @override
  void checkoutResponseFailure(error) {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        checkoutApi();
      }
    });
  }

  @override
  void statusUpadetaResponseFailure(error) {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": addressSave?.email ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": checkoutmodel![0].orderId,
          "status": "processing",
          // "reference": checkoutmodel[0]?.reference,
          "customer_id": GemsGLobals.userId,
          "burn_points": totalBurnPoint,
          // "burn_amount": _payment.contains("banktransfer")
          //     ? widget?.ordertotal?.replaceAll("AED ", "")?.replaceAll(",", "")
          //     : "",
          "burn_amount": totalBurnPrice,
          // "earnpoint": GlobalValue.paymentType == "collectbounz"
          //     ? widget.pointsEarned
          //     : "",
          "earnpoint": totalEarnPoint,
          "type": "staff",
          "description": checkoutmodel![0].orderId,
          "activity": "ESR",

          "payment_method": payments,
          "point_data": (orderRequest.pointData),
        };

        internetCall(context, () {
          GuestCheckoutPresenter().orderStatusUpdate(this, body);
        });
      }
    });
  }

  @override
  void paymentMethodresponseFailure(error) {
    // TODO: implement paymentMethodresponseFailure
  }
}

OrderRequest orderRequestFromJson(String str) =>
    OrderRequest.fromJson(json.decode(str));

String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  OrderRequest({
    this.pointData,
  });

  List<PointDatum>? pointData;

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        pointData: json["point_data"] == null
            ? null
            : List<PointDatum>.from(
                json["point_data"].map((x) => PointDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "point_data": pointData == null
            ? null
            : List<dynamic>.from(pointData!.map((x) => x.toJson())),
      };
}

class PointDatum {
  PointDatum({
    this.sku,
    this.burnrate,
    this.burnpoint,
    this.burnamount,
    this.earnrate,
    this.earnpoint,
    this.earnamount,
    this.cashamount,
  });

  String? sku;
  String? burnrate;
  String? burnpoint;
  String? burnamount;
  String? earnrate;
  String? earnpoint;
  String? earnamount;
  String? cashamount;

  factory PointDatum.fromJson(Map<String, dynamic> json) => PointDatum(
        sku: json["sku"] == null ? null : json["sku"],
        burnrate: json["burnrate"] == null ? null : json["burnrate"],
        burnpoint: json["burnpoint"] == null ? null : json["burnpoint"],
        burnamount: json["burnamount"] == null ? null : json["burnamount"],
        earnrate: json["earnrate"] == null ? null : json["earnrate"],
        earnpoint: json["earnpoint"] == null ? null : json["earnpoint"],
        earnamount: json["earnamount"] == null ? null : json["earnamount"],
        cashamount: json["cashamount"] == null ? null : json["cashamount"],
      );

  Map<String, dynamic> toJson() => {
        "sku": sku == null ? null : sku,
        "burnrate": burnrate == null ? null : burnrate,
        "burnpoint": burnpoint == null ? null : burnpoint,
        "burnamount": burnamount == null ? null : burnamount,
        "earnrate": earnrate == null ? null : earnrate,
        "earnpoint": earnpoint == null ? null : earnpoint,
        "earnamount": earnamount == null ? null : earnamount,
        "cashamount": cashamount == null ? null : cashamount,
      };
}
