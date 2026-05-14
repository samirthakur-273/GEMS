import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/confirmationpage.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/Presenter/guest_checkout_controller.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/payment_card_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/payment_form.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/checkout_view.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/model/checkout_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../errorpage.dart';

class ShopWebViewPage extends StatefulWidget {
  final email;
  final webUrl;
  final orderId;
  final orderNumber;
  final burnPoints;
  final burnAmount;
  final paymentMedthod;
  final orderRefence;
  final String? burnRate;
  final pointsEarned;
  final String? minPointsReq;
  final String? ordertotal;
  final String? totalPoinstBurned;
  final OrderRequest? orderRequest;
  final totalBurnPoint;
  final totalEarnPoint;
  final totalBurnPrice;
  final totalEarnPrice;
  final String? userFirstName;
  final String? userLastName;
  final AddressSave? addressSave;
  final Address? defaultaddress;
  final bool? showAddress;
  final CartDetailsModel? cartDetailsModel;
  final paymentmethod;

  const ShopWebViewPage(
      {Key? key,
      required this.webUrl,
      this.orderId,
      this.orderNumber,
      this.burnPoints,
      this.burnAmount,
      this.paymentMedthod,
      this.orderRefence,
      this.burnRate,
      this.pointsEarned,
      this.minPointsReq,
      this.ordertotal,
      this.totalPoinstBurned,
      this.orderRequest,
      this.totalBurnPoint,
      this.totalEarnPoint,
      this.totalBurnPrice,
      this.totalEarnPrice,
      this.email,
      this.addressSave,
      this.userFirstName,
      this.userLastName,
      this.defaultaddress,
      this.showAddress,
      this.cartDetailsModel,
      this.paymentmethod})
      : super(key: key);

  @override
  _ShopWebViewPageState createState() => _ShopWebViewPageState();
}

class _ShopWebViewPageState extends State<ShopWebViewPage>
    implements GuestCheckoutVieww {
  bool isLoading = true;
  String? status;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventPaymentPage;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.webUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            var string = request.url;
            if (string.contains('pg/success') ||
                string.contains("pg_loader.gif")) {
              status = "processing";
              var body = {
                "email": GemsGLobals.useremail,
                "shopuserid": GemsGLobals.custEncryptedId,
                "orderid": widget.orderId,
                "status": "processing",
                "reference": widget.orderRefence,
                "customer_id": GemsGLobals.userId,
                "burn_points": widget.totalBurnPoint,
                "burn_amount": widget.totalBurnPrice,
                "type": "staff",
                "description": widget.orderId,
                "activity": "ESR",
                "earnpoint": widget.totalEarnPoint,
                "payment_method": widget.paymentMedthod,
                "point_data": (widget.orderRequest!.pointData),
              };

              internetCall(context, () {
                GuestCheckoutPresenter().orderStatusUpdate(this, body);
                setState(() {
                  isLoading = true;
                });
              });
            } else if (string.contains('/pg/erro') ||
                string.contains("pg_failed.gif") ||
                string.contains('checkout/onepage/failure/') ||
                string.contains("stripe/payment/failure/") ||
                string.contains('checkout/onepage/failed/')) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ErrorPage()));
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventPaymentPage;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: new_gradient_color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: PreferredSize(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: new_gradient_color,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  height: 90,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Platform.isIOS
                            ? GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                          builder: (context) => new AlertDialog(
                                                content: new Text(
                                                    'Are you sure do you want to leave this page?'),
                                                actions: <Widget>[
                                                  new MaterialButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);

                                                      // flutterWeb.show();
                                                    },
                                                    child: new Text('No'),
                                                  ),
                                                  new MaterialButton(
                                                      child: new Text('Yes'),
                                                      onPressed: () {
                                                        CartDetailsDBHelper()
                                                            .truncateCartDetailsData()
                                                            .then(
                                                                (value) => {});
                                                        ShippingDetailsDBHelper()
                                                            .truncateShippingDetailsData();
                                                        MyProfileDBHelper()
                                                            .truncateMyProfileData();
                                                        Navigator.pop(context);
                                                        isLoading = true;
                                                        status = "pending";
                                                        var body = {
                                                          "email": widget
                                                                  .email ??
                                                              GemsGLobals
                                                                  .useremail,
                                                          "shopuserid": GemsGLobals
                                                              .custEncryptedId,
                                                          "orderid":
                                                              widget.orderId,
                                                          "status": "pending",
                                                          "reference": widget
                                                              .orderRefence,
                                                          "customer_id":
                                                              GemsGLobals
                                                                  .userId,
                                                          // "burn_points": widget.paymentMedthod.contains("banktransfer")
                                                          //     ? widget?.totalPoinstBurned
                                                          //     : "",
                                                          "burn_points": widget
                                                              .totalBurnPoint,
                                                          // "burn_amount": widget.paymentMedthod.contains("banktransfer")
                                                          //     ? widget?.ordertotal?.replaceAll("AED ", "")?.replaceAll(",", "")
                                                          //     : "",
                                                          "burn_amount": widget
                                                              .totalBurnPrice,
                                                          "type": "staff",
                                                          "description":
                                                              widget.orderId,
                                                          "activity": "ESR",
                                                          // "earnpoint": GlobalValue.paymentType == "collectbounz"
                                                          //     ? widget.pointsEarned
                                                          //     : "",
                                                          "earnpoint": widget
                                                              .totalEarnPoint,
                                                          "payment_method": widget
                                                              .paymentMedthod,
                                                          "point_data": (widget
                                                              .orderRequest!
                                                              .pointData),
                                                        };

                                                        internetCall(context,
                                                            () {
                                                          GuestCheckoutPresenter()
                                                              .orderStatusUpdate(
                                                                  this, body);
                                                        });
                                                        setState(() {});
                                                      })
                                                ],
                                              ),
                                          context: context) ??
                                      false;
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: EdgeInsets.fromLTRB(10, 36, 0, 10),
                                  padding: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: white_color,
                                    size: 22,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 40,
                              ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: 36, bottom: 10),
                          child: TextWidget(
                            text: "GEMS Rewards",
                            weight: FontWeight.w600,
                            size: text_size_18,
                            color: white_color,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 40,
                        )
                      ]),
                ),
                preferredSize: Size.fromHeight(60)),
            body: PopScope(
                canPop: false,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                                child: WebViewWidget(
                                    controller: webViewController)),
                            isLoading == true
                                ? Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height - 45,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onPopInvoked: (canPop) async {
                  _onWillPop();
                }),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
            builder: (context) => new AlertDialog(
                  content: new Text(
                    'Are you sure do you want to leave this page?',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: new MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: new Text(
                              'No',
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: new MaterialButton(
                              child: new Text(
                                'Yes',
                                textAlign: TextAlign.center,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onPressed: () {
                                CartDetailsDBHelper()
                                    .truncateCartDetailsData()
                                    .then((value) => {});
                                ShippingDetailsDBHelper()
                                    .truncateShippingDetailsData();
                                MyProfileDBHelper().truncateMyProfileData();
                                Navigator.pop(context);
                                isLoading = true;
                                status = "pending";
                                var body = {
                                  "email":
                                      widget.email ?? GemsGLobals.useremail,
                                  "shopuserid": GemsGLobals.custEncryptedId,
                                  "orderid": widget.orderId,
                                  "status": "pending",
                                  "reference": widget.orderRefence,
                                  "customer_id": GemsGLobals.userId,
                                  "burn_points": widget.totalBurnPoint,
                                  "burn_amount": widget.totalBurnPrice,
                                  "type": "staff",
                                  "description": widget.orderId,
                                  "activity": "ESR",
                                  "earnpoint": widget.totalEarnPoint,
                                  "payment_method": widget.paymentMedthod,
                                  "point_data":
                                      (widget.orderRequest!.pointData),
                                };

                                internetCall(context, () {
                                  GuestCheckoutPresenter()
                                      .orderStatusUpdate(this, body);
                                });
                                setState(() {});
                              }),
                        )
                      ],
                    )
                  ],
                ),
            context: context) ??
        false;
  }

  @override
  void applystorecreditResponse(List<StoreCreditModel> storecreditmodel) {}

  @override
  void checkoutResponse(List<CheckoutModel> checkoutmodel) {}

  @override
  void paymentByCard(PaymentCardModel tokenModel) {}

  @override
  void paymentGatewayCreateToken(TokenModel? tokenModel) {}

  @override
  void paymentMethodResponse(List<PaymentMethodModel> paymentMethod) {}

  @override
  void responseFailure(error) {
    setState(() {
      isLoading = false;
    });
    if (status == "pending") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 0,
                    tabIndex: 0,
                  )));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ErrorPage()));
    }
  }

  @override
  void statusCheck(List<OrderStatusModel> orderstatus) {
    print(orderstatus[0].toJson());
    if (orderstatus[0].success == "true") {
      setState(() {
        isLoading = false;
      });
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    showAddress: widget.showAddress,
                    orderId: widget.orderNumber,
                    orderstatus: "success",
                    pointsEarned: widget.pointsEarned,
                    userFirstName: widget.userFirstName,
                    userLastName: widget.userLastName,
                    addressSave: widget.addressSave,
                    defaultaddress: widget.defaultaddress,
                    cartDetailsModel: widget.cartDetailsModel,
                    paymentmethod: widget.paymentmethod.toString(),
                  )));
    } else {
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();
      // _makesensePurchaseFailureApiCall();
      if (status == "pending") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ShopTabBarPage(
                      index: 0,
                      tabIndex: 0,
                    )));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ErrorPage()));
      }
    }
  }

  @override
  void checkoutTimeOut() {}

  @override
  void paymentTimeOut() {}

  @override
  void statusCheckTimeout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (cxt) => TimeOut())).then((value) {
      if (value != null) {
        var body = {
          "email": widget.email ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": widget.orderId,
          "status": status == "processing" ? "processing" : "pending",
          "reference": widget.orderRefence,
          "customer_id": GemsGLobals.userId,
          "burn_points": widget.totalBurnPoint,
          "burn_amount": widget.totalBurnPrice,
          "type": "staff",
          "description": widget.orderId,
          "activity": "ESR",
          "earnpoint": widget.totalEarnPoint,
          "payment_method": widget.paymentMedthod,
          "point_data": (widget.orderRequest!.pointData),
        };

        internetCall(context, () {
          GuestCheckoutPresenter().orderStatusUpdate(this, body);
        });
      }
    });
  }

  @override
  void checkoutResponseFailure(error) {}

  @override
  void statusUpadetaResponseFailure(error) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (cxt) => TimeOut())).then((value) {
      if (value != null) {
        var body = {
          "email": widget.email ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": widget.orderId,
          "status": status == "processing" ? "processing" : "pending",
          "reference": widget.orderRefence,
          "customer_id": GemsGLobals.userId,
          "burn_points": widget.totalBurnPoint,
          "burn_amount": widget.totalBurnPrice,
          "type": "staff",
          "description": widget.orderId,
          "activity": "ESR",
          "earnpoint": widget.totalEarnPoint,
          "payment_method": widget.paymentMedthod,
          "point_data": json.encode((widget.orderRequest!.pointData)),
        };

        internetCall(context, () {
          GuestCheckoutPresenter().orderStatusUpdate(this, body);
        });
      }
    });
  }

  @override
  void paymentMethodresponseFailure(error) {}
}
