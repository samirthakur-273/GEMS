import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/eshop_module_new/address_map.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/cart_details_presenter.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/cart_details_view.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/tabbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/Presenter/guest_checkout_controller.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/apply_coupon_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/payment_card_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/payment_form.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/shopwebviewPage.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/checkout_view.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/model/checkout_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_presenter.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_view.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../confirmationpage.dart';
import '../errorpage.dart';

class ReviewPage extends StatefulWidget {
  final CartDetailsModel? cartDetailsModel;
  final AddressSave? addressSave;
  final String? shippingcode;

  ReviewPage({
    Key? key,
    this.cartDetailsModel,
    this.addressSave,
    this.shippingcode,
  }) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    implements ReviewPageView, GuestCheckoutVieww, CartDetailsView {
  int selected = 1;
  bool autovalidate = false;
  int? selectAddress;
  bool guestaddress = false;
  GoogleMapController? mapController;

  var countryData;

  //ShippingAddress shippingaddressResponse;
  ShippingMethodModel? shippingmodelResponse;
  StoreCreditModel? storecreditmodelResponse;
  int? selectedIndex;
  CartDetailsModel? cartDetailsModel;
  AddressSave? addressSave;
  Address? userselectedaddress;
  bool newaddress = false;
  bool addressnotselected = false;
  bool isloading = false;
  bool addressLoader = true;
  Paymentmethod? returnedValue;
  Paymentmethod? cashondelivery;
  PaymentMethodModel? paymentMethodresponse;
  bool oncashtrue = false;
  List<Address> _addressList = [];
  List<CheckoutModel>? checkoutmodel;
  Address? defaultaddress;
  bool storeapplied = false;
  bool showViewAllButton = false;
  bool showViewAllButtonTap = false;
  bool newaddressadded = false;
  bool updateCart = false;
  String? forStoreUse;
  double totalOfEarnPoints = 0.0;
  double totalOfBurnPoints = 0.0;
  bool allVirtualCheck = false;
  bool allSimpleCheck = false;
  bool isEmailEditable = true;
  bool sendViaAddress = true;
  bool sendViaEmail = false;
  bool _isEmailErr = false;
  var _emailErrmsg;
  OrderRequest orderRequest = new OrderRequest();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _countryController = TextEditingController();
  final _pointsController = TextEditingController();
  bool _autovalidate = false;
  static var dbHelper = MyProfileDBHelper();
  List _payment = [];
  String? payments;
  String? _value;
  List? rewardPoints = [];
  String? orderid;
  bool isPointsPaymentSelected = false;
  String? paymentTypeSelected;
  bool placeOrderLoader = false;
  bool _placeOrderLoad = false;
  bool _viewMore = false;
  FocusNode _emailFoucs = new FocusNode();
  bool _pointsEditable = true;
  bool noAddressSelected = false;
  bool _invaldPoints = false;
  var config_options;
  bool pointsController = false;
  bool showAddress = false;
  bool _payWithPoint = true;
  var _pointwithController = TextEditingController();
  var firsttimevalue;
  bool errormessage = false;
  bool enteramount = false;
  List<Itemss> remainingItems = [];
  double finalEarnRate = 0.0;

  void initState() {
    super.initState();
    addressSave = widget.addressSave;
    remainingItems = widget.cartDetailsModel!.items!;
    if (GemsGLobals.membershipNo != null) {
      var body = {
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId
      };
      internetCall(
          context, () => ReviewPagePresenter(this).shippingaddress(body));
      cartDetailsModel = widget.cartDetailsModel;
      allVirtualCheck =
          cartDetailsModel!.items!.any((element) => element.type == "virtual");          
      allSimpleCheck = cartDetailsModel!.items!.any((element) =>
          element.type == "simple" || element.type == 'configurable');
      if (allSimpleCheck) {
        showAddress = true;
      }
    }
    var body = {
      "email": GemsGLobals.useremail,
      "shopxrid": GemsGLobals.custEncryptedId
    };
    internetCall(
        context, () => GuestCheckoutPresenter().paymentMethod(this, body));
    placeOrderLoader = true;
    if (GemsGLobals.userFirstName != null)
      _firstnameController.text = GemsGLobals.userFirstName ?? "";
    if (GemsGLobals.userLastName != null)
      _lastnameController.text = GemsGLobals.userLastName ?? "";
    if (GemsGLobals.countryCode != null)
      _countryController.text = GemsGLobals.countryCode ?? "";
    if (GemsGLobals.mobilenumber != null)
      _mobileController.text = GemsGLobals.mobilenumber ?? "";
    if (GemsGLobals.useremail != null)
      _emailController.text =
          cartDetailsModel?.giftEmail ?? GemsGLobals.useremail;
    for (var i = 0; i < (cartDetailsModel?.items?.length ?? 0); i++) {
      totalOfEarnPoints += double.tryParse(
          cartDetailsModel?.items?[i].pointEarned != ''
              ? (cartDetailsModel?.items?[i].pointEarned ?? '0')
              : '0')!;
    }
    totalOfBurnPoints = 0.0;

    for (var i = 0; i < (cartDetailsModel?.items?.length ?? 0); i++) {
      totalOfBurnPoints += (double.tryParse(
              (cartDetailsModel!.items![i].specialPrice == "0.00"
                  ? cartDetailsModel?.items![i].price!
                  : cartDetailsModel?.items![i].specialPrice!)!)! /
          double.tryParse(cartDetailsModel!.items![i].burnrate ?? '0')!);
    }
    if (cartDetailsModel?.shippingAmount != null &&
        cartDetailsModel?.shippingBurnrate != null) {
      int? shippingPoint = (double.parse(cartDetailsModel!.shippingAmount!
                  .replaceAll("AED ", "")
                  .replaceAll(",", "")) /
              double.tryParse(cartDetailsModel!.shippingBurnrate!)!)
          .round();
      totalOfBurnPoints = totalOfBurnPoints + shippingPoint;
    }

    storeReleated();
    if (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
        GemsGLobals.referralRelationType != GemsGLobals.childValue) {
      redeemPoints();
    }
    _pointwithController.text = GemsGLobals.pointbalance > _redeemPoints()
        ? _redeemPoints().toString()
        : GemsGLobals.pointbalance.toString();
  }

  
  makesenseCheckoutApiCall(checkoutClick) {
    CartDetailsModel cartDetailsModel = widget.cartDetailsModel!;
   
    String keyName = GemsGLobals.eventCheckOutPage;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      'total_cart_value': cartDetailsModel.grandTotal ?? "",
      'add_address': defaultaddress != null || addressSave != null
          ? GemsGLobals.yesText
          : GemsGLobals.noText,
      'items': [
        for (final item in (cartDetailsModel.items ?? []))
          {
            'Quantity': item.qty ?? "",
            'product_name': item.name,
            'category_type': item.categoryType,
            'sub_category': item.subCategory,
            'brand_name': item.brandName,
            'Stock': item.isAvailable == 0
                ? GemsGLobals.productOutOfStock
                : GemsGLobals.productInStock,
            'sku': item.sku.toString(),
          }
      ],
      "checkout_click": checkoutClick,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void checkoutApi(String? paymentScenario) {
    if (noAddressSelected) {
    } else {
      setState(() {
        _payment.clear();

        if (paymentScenario == "points+cash") {
          _payment.add(paymentMethodresponse?.shippingmethods
              ?.firstWhere((element) => element.code == "banktransfer")
              .code);

          if (paymentMethodresponse!.shippingmethods!
              .any((element) => element.code == "ngeniusonline")) {
            _payment.add(paymentMethodresponse?.shippingmethods!
                .firstWhere((element) => element.code == "ngeniusonline")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "ngeniusonline")
                .code;
          } else if (paymentMethodresponse!.shippingmethods!
              .any((element) => element.code == "vernost_gateway")) {
            _payment.add(paymentMethodresponse?.shippingmethods!
                .firstWhere((element) => element.code == "vernost_gateway")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "vernost_gateway")
                .code;
          } else {
            _payment.add(paymentMethodresponse!.shippingmethods
                ?.firstWhere((element) => element.code == "stripe")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "stripe")
                .code;
          }
        } else if (paymentScenario == "points") {
          _payment.add(paymentMethodresponse?.shippingmethods
              ?.firstWhere((element) => element.code == "banktransfer")
              .code);
        } else {
          if (paymentMethodresponse!.shippingmethods!
              .any((element) => element.code == "ngeniusonline")) {
            _payment.add(paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "ngeniusonline")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "ngeniusonline")
                .code;
          } else if (paymentMethodresponse!.shippingmethods!
              .any((element) => element.code == "vernost_gateway")) {
            _payment.add(paymentMethodresponse?.shippingmethods!
                .firstWhere((element) => element.code == "vernost_gateway")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "vernost_gateway")
                .code;
          } else {
            _payment.add(paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "stripe")
                .code);
            _value = paymentMethodresponse?.shippingmethods
                ?.firstWhere((element) => element.code == "stripe")
                .code;
          }
        }

        payments = _payment.join(",");

        if (allVirtualCheck == true && allSimpleCheck != true) {
          var body = {
            "brandcode": Constants.brandCode,
            "country_code": "main_website_store",
            "lang_code": Constants.langCode,
            "address_id": "",
            "firstname": addressSave?.firstname ?? GemsGLobals.userFirstName,
            "lastname": addressSave?.lastName ?? GemsGLobals.userLastName,
            "email": cartDetailsModel?.giftEmail ?? GemsGLobals.useremail,
            "shopuserid": GemsGLobals.custEncryptedId,
            "street": "-",
            "region": "-",
            "city": "-",
            "telephone":
                "${addressSave?.countryCode ?? GemsGLobals.countryCode}${addressSave?.number ?? GemsGLobals.mobilenumber}",
            "country_id": "AE",
            "save_in_address_book": '0',
            "shippingmethod": widget.shippingcode,
            "paymentmethod": payments,
            "burn_points": totalBurnPoint,
            "burn_amount": totalBurnPrice,
            "earnpoint": totalEarnPoint,
          };
          internetCall(context,
              () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
        } else if (newaddressadded) {
          var body = {
            "brandcode": Constants.brandCode,
            "country_code": "main_website_store",
            "lang_code": Constants.langCode,
            "address_id": "",
            "firstname": addressSave?.firstname ?? GemsGLobals.userFirstName,
            "lastname": addressSave?.lastName ?? GemsGLobals.userLastName,
            "emailid": GemsGLobals.useremail,
            "email": GemsGLobals.useremail,
            "shopuserid": GemsGLobals.custEncryptedId,
            "street": addressSave?.streetAddress,
            "region": addressSave?.city,
            "city": addressSave?.area,
            "telephone": '${addressSave?.countryCode} ${addressSave?.number}',
            "country_id": "AE",
            "save_in_address_book": addressSave?.savedefault.toString(),
            "shippingmethod": widget.shippingcode,
            "paymentmethod": payments,
            "burn_points": totalBurnPoint,
            "burn_amount": totalBurnPrice,
            "earnpoint": totalEarnPoint,
          };

          internetCall(context,
              () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
        } else {
          var body = {
            "brandcode": Constants.brandCode,
            "country_code": "main_website_store",
            "lang_code": Constants.langCode,
            "customerId": GemsGLobals.userId,
            "address_id":
                userselectedaddress?.addressId ?? defaultaddress?.addressId,
            "firstname": userselectedaddress?.firstname ??
                defaultaddress?.firstname ??
                GemsGLobals.userFirstName,
            "lastname": userselectedaddress?.lastname ??
                defaultaddress?.lastname ??
                GemsGLobals.userLastName,
            "emailid": GemsGLobals.useremail,
            "email": GemsGLobals.useremail,
            "shopuserid": GemsGLobals.custEncryptedId,
            "street": userselectedaddress?.address ?? defaultaddress?.address,
            "region": userselectedaddress?.city ?? defaultaddress?.city,
            "city": userselectedaddress?.area,
            "telephone": '${userselectedaddress?.telephone}',
            "country_id": "AE",
            "save_in_address_book": userselectedaddress?.isdefault.toString(),
            "shippingmethod": widget.shippingcode,
            "paymentmethod": payments,
            "burn_points": totalBurnPoint.toString(),
            "burn_amount": totalBurnPrice.toString(),
            "earnpoint": totalEarnPoint.toString(),
          };

          internetCall(context,
              () => GuestCheckoutPresenter().guestcheckoutresp(this, body));
        }
      });
    }
  }

  addListners() {
    if (_autovalidate) {
      _emailController.addListener(() => _email(refresh: true));
    }
  }

  void collectPointConversion(CartDetailsModel? cartDetailsModel) {
    orderRequest.pointData = [];
    String? subTotal =
        cartDetailsModel?.subTotal?.replaceAll("AED ", "").replaceAll(",", "");
    cartDetailsModel?.items?.forEach((element) {
      orderRequest.pointData?.add(new PointDatum(
          sku: element.sku,
          burnrate: "0",
          burnpoint: "0",
          burnamount: "0",
          cashamount: "0",
          earnpoint: element.pointEarned,
          earnamount: subTotal,
          earnrate: element.earnrate));
    });
  }

  void redeemPoints() {
    if ((double.tryParse(GemsGLobals.pointbalance.toString()) ?? 0) >=
        totalOfBurnPoints) {
      _pointsController.text = totalOfBurnPoints.round().toString();
    } else {
      _pointsController.text = GemsGLobals.pointbalance.toString();
    }
  }

  fifoLogicCalculation() {
    remainingItems = cartDetailsModel!.items!;
    var toAedValue = int.parse(_pointwithController.text) / 10;
    double aed = double.parse(toAedValue.toString());
    double tax = 0.0;
    double withoutTax = 0.0;
    double earnRate = 0.0;
    double checkValue = 0.0;
    double productPriceWithShippingAmt = 0.0;
    var deductedAmt;

    List<String> shippingCharges =
        widget.cartDetailsModel!.shippingAmount!.split(" ");
    List<String> taxCharges = widget.cartDetailsModel!.tax!.split(" ");
    double _splitShippingCharges =
        double.parse(double.parse(shippingCharges[1]).toStringAsFixed(2));
    double _splitTaxCharges = double.parse(taxCharges[1].toString());
    double? shippingAmount =
        _splitShippingCharges / cartDetailsModel!.items!.length;
    double calculateEarnPointForSingleProduct;
    if (cartDetailsModel!.items!.length == 1) {
      int payableAmt = _pointConv();
      double amt = payableAmt - shippingAmount - _splitTaxCharges;
      calculateEarnPointForSingleProduct =
          amt / double.parse(cartDetailsModel!.items![0].earnrate.toString());
      finalEarnRate = calculateEarnPointForSingleProduct;
      return;
    }

    for (var i = 0; i < cartDetailsModel!.items!.length; i++) {
      productPriceWithShippingAmt = double.parse(
              widget.cartDetailsModel!.items![i].specialPrice.toString()) +
          shippingAmount;
      checkValue = aed - productPriceWithShippingAmt;
      if (checkValue > 0) {
        remainingItems.removeAt(i);
        for (var j = 0; j < remainingItems.length; j++) {
          tax = double.parse(remainingItems[j].specialPrice.toString()) * 0.05;
          withoutTax =
              double.parse(remainingItems[j].specialPrice.toString()) - tax;
          earnRate = withoutTax - checkValue;
          finalEarnRate = finalEarnRate +
              earnRate / double.parse(remainingItems[j].earnrate.toString());
        }
      } else {
        productPriceWithShippingAmt = double.parse(
                widget.cartDetailsModel!.items![i].specialPrice.toString()) +
            double.parse(shippingAmount.toString());
        checkValue = productPriceWithShippingAmt - toAedValue;
        tax = double.parse(remainingItems[i].specialPrice.toString()) * 0.05;
        deductedAmt =
            (checkValue - tax - double.parse(shippingAmount.toString())) /
                double.parse(
                    widget.cartDetailsModel!.items![i].earnrate.toString());
        finalEarnRate = deductedAmt +
            double.parse(
                widget.cartDetailsModel!.items![i + 1].pointEarned.toString());
        if (i + 1 == cartDetailsModel!.items!.length - 1) break;
      }
    }
  }

  void itemPointSpecificPointConversion(
      CartDetailsModel cartDetailsModel, int userEditedPoints) {
    double priceValueAsPerPoint = userEditedPoints.toDouble();

    int pointTotal = userEditedPoints;
    orderRequest.pointData = [];
    String? length = cartDetailsModel.items?.length.toString();
    for (var i = 0; i < int.parse(length!); i++) {
      priceValueAsPerPoint = (pointTotal *
          (double.tryParse(cartDetailsModel.items![i].burnrate != ''
              ? cartDetailsModel.items![i].burnrate!
              : '0')!));

      // if (priceValueAsPerPoint > 0) {

      int point = (double.tryParse(
                  cartDetailsModel.items![i].specialPrice == "0.00"
                      ? cartDetailsModel.items![i].price!
                      : cartDetailsModel.items![i].specialPrice!)! /
              double.tryParse(cartDetailsModel.items![i].burnrate != ''
                  ? cartDetailsModel.items![i].burnrate!
                  : '0')!)
          .round();
      int data;
      if (_pointwithController.text != "null" &&
          _pointwithController.text != "") {
        data = int.parse(_pointwithController.text);
      } else {
        data = GemsGLobals.pointbalance;
      }
      double burnAmount = priceValueAsPerPoint;
      var value = (double.parse(_pointwithController.text) / 10) -
          double.parse(cartDetailsModel.subTotal
              .toString()
              .split(" ")[1]
              .replaceAll(",", ""));
      if (!value.isNegative) {
        
        int point = (double.tryParse(
                    cartDetailsModel.items![i].specialPrice == "0.00"
                        ? cartDetailsModel.items![i].price!
                        : cartDetailsModel.items![i].specialPrice!)! /
                double.tryParse(cartDetailsModel.items![i].burnrate != ''
                    ? cartDetailsModel.items![i].burnrate!
                    : '0')!)
            .round();

        orderRequest.pointData?.add(new PointDatum(
            sku: cartDetailsModel.items![i].sku,
            burnrate: cartDetailsModel.items![i].burnrate,
            burnpoint: (burnAmount /
                    double.tryParse(cartDetailsModel.items![i].burnrate != ''
                        ? cartDetailsModel.items![i].burnrate!
                        : '0')!)
                .round()
                .toString(),
            burnamount: (burnAmount.toStringAsFixed(2)).toString(),
            cashamount: "0",
            earnpoint: "0",
            earnamount: "0",
            earnrate: "0"));
        pointTotal = pointTotal - point;
      } else {
        double earnAmount;
        earnAmount = (burnAmount -
            double.tryParse(cartDetailsModel.items![i].excltaxprice!)!);
        if (earnAmount < 0) {
          earnAmount = 0;
        }

        if (burnAmount > 0) {
          orderRequest.pointData?.add(new PointDatum(
              sku: cartDetailsModel.items![i].sku,
              burnrate: cartDetailsModel.items![i].burnrate,
              burnpoint: (burnAmount /
                      double.tryParse(cartDetailsModel.items![i].burnrate != ''
                          ? cartDetailsModel.items![i].burnrate!
                          : '0')!)
                  .round()
                  .toString(),
              burnamount: (burnAmount.toStringAsFixed(2)).toString(),
              earnpoint:
                  finalEarnRate.isNegative ? '0' : finalEarnRate.toString(),
              earnamount: earnAmount.abs().toStringAsFixed(2).toString(),
              earnrate: cartDetailsModel.items![i].earnrate));

          totalOfEarnPoints = (earnAmount /
                  double.tryParse(cartDetailsModel.items![i].earnrate!)!)
              .abs()
              .roundToDouble();

          pointTotal = pointTotal - point;
        } else {
          orderRequest.pointData?.add(new PointDatum(
              sku: cartDetailsModel.items![i].sku,
              burnrate: cartDetailsModel.items![i].burnrate,
              burnpoint: "0",
              burnamount: "0",
              earnpoint: cartDetailsModel.items![i].pointEarned,
              earnamount: cartDetailsModel.items![i].excltaxprice,
              earnrate: cartDetailsModel.items![i].earnrate));
          pointTotal = pointTotal - point;
        }
      }
      priceValueAsPerPoint = priceValueAsPerPoint -
          double.tryParse(cartDetailsModel.items![i].specialPrice == "0.00"
              ? cartDetailsModel.items![i].price!
              : cartDetailsModel.items![i].specialPrice!)!;
    }

    if (cartDetailsModel.shippingAmount != null &&
        cartDetailsModel.shippingAmount != "AED 0.00") {
      String shippingAmount = cartDetailsModel.shippingAmount!
          .replaceAll("AED ", "")
          .replaceAll(",", "");
      int shippingPoint = (double.tryParse(shippingAmount)! /
              double.tryParse(cartDetailsModel.shippingBurnrate!)!)
          .round();

      // print("shippingPoint");
      if (pointTotal > shippingPoint) {
        // print("user has point");
        orderRequest.pointData?.add(new PointDatum(
            sku: "shipping_changes",
            burnrate: cartDetailsModel.shippingBurnrate,
            burnpoint: shippingPoint.toString(),
            burnamount: shippingAmount,
            cashamount: "0",
            earnpoint: "0",
            earnamount: "0",
            earnrate: "0"));
      } else {
        // print('iii');
        double burnAmount = priceValueAsPerPoint;
        double earnAmount = (burnAmount - double.tryParse(shippingAmount)!);
        if (burnAmount > 0) {
          // print('kkk');
          orderRequest.pointData?.add(new PointDatum(
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
          // print('www');
          orderRequest.pointData?.add(new PointDatum(
              sku: "shipping_changes",
              burnrate: cartDetailsModel.shippingBurnrate,
              burnpoint: "0",
              burnamount: "0",
              earnpoint: "0",
              earnamount: "0",
              earnrate: "0"));
        }
      }
    }
  }

  double totalBurnPoint = 0;
  double totalEarnPoint = 0;
  double totalBurnPrice = 0.0;
  double totalEarnPrice = 0.0;

  void totalPriceOrPoint() {
    totalBurnPoint = 0;
    totalEarnPoint = 0;
    totalBurnPrice = 0.0;
    totalEarnPrice = 0.0;
    var burnPoint = double.parse(_pointwithController.text);
    var burnAmt = (double.parse(_pointwithController.text) / 10);
    orderRequest.pointData?.forEach((element) {
      totalBurnPrice = !isPointsPaymentSelected
          ? totalBurnPrice +
              double.tryParse(
                  element.burnamount != '' ? (element.burnamount ?? '0') : '0')!
          : burnAmt;
      totalEarnPrice = totalEarnPrice +
          double.tryParse(
              element.earnamount != null ? (element.earnamount ?? '0') : '0')!;
      // totalBurnPoint = burnPoint;
      totalBurnPoint = !isPointsPaymentSelected
          ? totalBurnPoint +
              double.parse(
                  element.burnpoint != '' ? (element.burnpoint ?? '0') : '0')
          : burnPoint;
      totalEarnPoint = finalEarnRate.isNegative ? 0.0 : finalEarnRate;
    });
  }

  void _email({bool? refresh}) {
    if (_emailController.text.isEmpty) {
      _isEmailErr = true;
      _emailErrmsg = "email_blank";
    } else if (_emailController.text.length < 2 ||
        _emailController.text.length > 50) {
      _isEmailErr = true;
      _emailErrmsg = "email_valid";
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailController.text);
      if (emailValid == true) {
        _isEmailErr = false;
        _emailErrmsg = "";
      } else {
        _isEmailErr = true;
        _emailErrmsg = "email_valid";
      }
    }
    if (refresh ?? false) {
      setState(() {});
    }
  }

  void storeReleated() async {
    var prefs = await SharedPreferences.getInstance();

    forStoreUse = prefs.getString("Store");
  }

  _pointConv() {
    var _redpoints = _redeemPoints();

    var convAmount;
    if (_pointwithController.text == "null" ||
        _pointwithController.text == "") {
      convAmount = _redpoints - 0;
    } else {
      convAmount = _redpoints - int.parse(_pointwithController.text);
    }

    var redeemrate;
    if (cartDetailsModel?.items?[0].burnrate != null &&
        cartDetailsModel?.items?[0].burnrate != "") {
      redeemrate = cartDetailsModel?.items?[0].burnrate;
    } else {
      redeemrate = 0.1;
    }
    var paybleAmount = (convAmount * double.parse(redeemrate)).ceil();

    return paybleAmount;
  }

  _redeemPoints() {
    var aedAmount = cartDetailsModel!.grandTotal
        .toString()
        .replaceAll("AED ", "")
        .replaceAll(",", "");

    // print(aedAmount);
    var redeemrate;
    if (cartDetailsModel?.items?[0].burnrate != null &&
        cartDetailsModel?.items?[0].burnrate != "") {
      redeemrate = cartDetailsModel?.items?[0].burnrate;
    } else {
      redeemrate = 0.1;
    }

    var redeem = double.parse(aedAmount) / double.parse(redeemrate);

    return redeem.ceil();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> configoption(dict) {
      var optionsList;
      config_options = dict["config_options"];
      List<Widget> products = [];
      for (var i = 0; i < (config_options?.length ?? 0); i++) {
        var key = config_options?.entries.toList()[i].value;
        optionsList = dict["$key"];
        for (var j = 0; j < (optionsList?.length ?? 0); j++) {
          var vv = optionsList[j];
          Map map = vv;
          products.add(Container(
            margin: EdgeInsets.only(left: 0, right: 6, top: 0),
            child: TextWidget(
                text: "${map["label"]} : ${map["option_label"]}",
                size: text_font_small,
                weight: FontWeight.w500),
          ));
        }
      }
      return products;
    }

    Widget _paybycashandpoints() {
      return Container(
        margin: EdgeInsets.only(left: 0, right: 5),
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "Redeemable Points",
                  ),
                  TextWidget(
                      // text: "${GemsGLobals.pointbalance} GEMS points",
                      text: '${_redeemPoints()} GEMS Points')
                ],
              ),
            ),
            new SizedBox(
              height: 10,
            ),
            if (pointsFormatter(_pointConv()) != "0" &&
                !errormessage &&
                !_invaldPoints &&
                _pointwithController.text.isNotEmpty &&
                _pointwithController.text.length >= 1)
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: "Payable Amount",
                    ),
                    TextWidget(
                      text: "AED ${pointsFormatter(_pointConv())}",
                      // text: '${_payableAmount()}',
                    )
                  ],
                ),
              ),
            Container(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _payWithPoint = !_payWithPoint;
                        _pointwithController.text =
                            GemsGLobals.pointbalance > _redeemPoints()
                                ? _redeemPoints().toString()
                                : GemsGLobals.pointbalance.toString();
                        if (_payWithPoint) {
                          if (_pointwithController.text != "null" &&
                              _pointwithController.text != "") {
                            if (int.parse(_pointwithController.text) >
                                _redeemPoints()) {
                              errormessage = true;
                            } else if (int.parse(_pointwithController.text) >
                                GemsGLobals.pointbalance) {
                              _invaldPoints = true;
                            } else {
                              errormessage = false;
                              _invaldPoints = false;
                            }
                          }
                        }
                      });
                    },
                    child: Container(
                        height: 23,
                        width: 23,
                        child: _payWithPoint
                            ? SvgPicture.asset(
                                ImageConstants.select,
                              )
                            : SvgPicture.asset(
                                ImageConstants.unselect,
                              )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 7),
                    child: TextWidget(
                      text: 'Pay with ',
                      color: _payWithPoint
                          ? black_color.withOpacity(0.7)
                          : shadow_color,
                      size: text_font_medium15_size,
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                            color: _payWithPoint
                                ? grey600_color.withOpacity(0.5)
                                : shadow_color,
                            width: 0.8)),
                    child: _payWithPoint
                        ? TextFormField(
                            controller: _pointwithController,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp('[0-9]'),
                                  allow: true)
                            ],
                            cursorColor: deepdark_orange_color,
                            textAlign: TextAlign.center,
                            cursorWidth: 1.0,
                            maxLength: 15,
                            style: TextStyle(
                                color: black_color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            onChanged: (text) {
                              setState(() {
                                if (_pointwithController.text.isNotEmpty &&
                                    _pointwithController.text.length >= 1) {
                                  enteramount = false;
                                  if (int.parse(_pointwithController.text) >
                                      GemsGLobals.pointbalance) {
                                    _invaldPoints = true;
                                  } else {
                                    _invaldPoints = false;
                                  }
                                  if (int.parse(_pointwithController.text) >
                                      _redeemPoints()) {
                                    errormessage = true;
                                  } else {
                                    errormessage = false;
                                  }
                                } else {}
                                remainingItems = cartDetailsModel!.items!;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              alignLabelWithHint: true,
                              counterText: '',
                              errorMaxLines: 2,
                              border: InputBorder.none,
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextWidget(
                              text: _pointwithController.text,
                              color: shadow_color,
                              weight: FontWeight.bold,
                              size: text_font_medium15_size,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextWidget(
                      text: 'GEMS',
                      color: _payWithPoint
                          ? black_color.withOpacity(0.7)
                          : shadow_color,
                      // weight: FontWeight.bold,
                      size: text_font_medium15_size,
                    ),
                  ),
                ],
              ),
            ),
            if (errormessage && !_invaldPoints && _payWithPoint)
              Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50, right: 20),
                child: TextWidget(
                  text: "Please select GEMS points equal to or less than " +
                      '${_redeemPoints()}',
                  color: red_color,
                  size: 13,
                  softwrap: true,
                  maxLines: 4,
                  weight: FontWeight.w600,
                ),
              ),
            if (enteramount && _payWithPoint)
              Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50, right: 20),
                child: TextWidget(
                  text: "Please enter amount",
                  color: red_color,
                  size: 13,
                  softwrap: true,
                  maxLines: 4,
                  weight: FontWeight.w600,
                ),
              )
          ],
        ),
      );
    }


    List<Widget> _cartList() {
      List<Widget> _data = [];
      List<Itemss> items = cartDetailsModel!.items!;
      for (var i = 0; i < (items.length); i++) {
        _data.add(Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            color: white_text_color.withOpacity(0.5),
            margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: " ",
                            size: text_font_small,
                            softwrap: true,
                            color: blue_color,
                            weight: FontWeight.w600,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 0),
                            child: TextWidget(
                              text: items[i].name ?? '',
                              size: text_font_small,
                              softwrap: true,
                              color: flight_text_black_color,
                              weight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          items[i].isAvailable != 1
                              ? Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 6, right: 6, top: 5),
                                      child: TextWidget(
                                        text: "Out of stock",
                                        size: text_font_size_xxx_small,
                                        color: red_color,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 0,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 0, top: 0),
                                child: TextWidget(
                                  text:
                                      "${items[i].currencySymbol}${Constants.priceFormatter(double.tryParse(items[i].price ?? '0.0'))}",
                                  decoration: items[i].specialPrice == "0.00" ||
                                          items[i].specialPrice == null
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                  size: text_font_size_x_small,
                                  color: items[i].specialPrice == "0.00" ||
                                          items[i].specialPrice == null
                                      ? Colors.black
                                      : Colors.grey[400],
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          items[i].specialPrice == "0.00" ||
                                  items[i].specialPrice == null
                              ? Container()
                              : SizedBox(
                                  width: 10,
                                ),
                          items[i].specialPrice == "0.00" ||
                                  items[i].specialPrice == null
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(
                                      left: 0, top: 5, right: 10),
                                  child: TextWidget(
                                    text:
                                        "${items[i].currencySymbol}${Constants.priceFormatter(double.tryParse(items[i].specialPrice ?? '0.0'))}",
                                    size: text_font_medium_x_size,
                                    color: Colors.black,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                          SizedBox(height: 5.0),
                          items[i].configurableProductOptions != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: configoption(
                                      items[i].configurableProductOptions))
                              : Container(),
                        ],
                      )),
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                        create: (context) =>
                                            WishListCartCount(),
                                        child: ProductDetailNew(
                                          productcode: items[i].sku,
                                          burnRate: items[i].burnrate,
                                          minPointsReq:
                                              items[i].minipointrequired,
                                          pointsEarned: items[i].pointEarned,
                                        ),
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: CachedNetworkImage(
                            fit: BoxFit.contain,
                            imageUrl: items[i].image ?? "",
                            placeholder: (context, url) => Image.asset(
                              ImageConstants.noimages,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ImageConstants.noimages,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      child: TextWidget(
                        softwrap: true,
                        text: "Earn upto",
                        weight: FontWeight.w600,
                        color: blue_color,
                        size: text_font_x_small,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: TextWidget(
                        softwrap: true,
                        text:
                            '${(Constants.pricePointsFormatter(int.parse(items[i].pointEarned != '' ? (items[i].pointEarned ?? '0') : '0')))} GEMS Points',
                        color: blue_color,
                        weight: FontWeight.w500,
                        size: text_font_medium15_size,
                      ),
                    ),
                  ],
                ),
                (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                        GemsGLobals.referralRelationType !=
                            GemsGLobals.childValue)
                    ? items[i].burnrate!.toString() == "0" ||
                            items[i].burnrate!.toString() == ""
                        ? Container(
                            height: 0,
                          )
                        : Container(
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 0.5,
                                  color: grey_color,
                                ),
                                TextWidget(
                                  text: ' OR ',
                                  weight: FontWeight.w500,
                                ),
                                Container(
                                  width: 70,
                                  height: 0.5,
                                  color: grey_color,
                                ),
                              ],
                            ),
                          )
                    : Container(
                        height: 0,
                      ),
                (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                        GemsGLobals.referralRelationType !=
                            GemsGLobals.childValue)
                    ? items[i].burnrate!.toString() == "0" ||
                            items[i].burnrate!.toString() == ""
                        ? Container(
                            height: 0,
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 2),
                                child: TextWidget(
                                  softwrap: true,
                                  text: "Redeem  ",
                                  weight: FontWeight.w500,
                                  color: needGemsColor,
                                  size: text_font_x_small,
                                ),
                              ),
                              Container(
                                child: TextWidget(
                                  softwrap: true,
                                  text:
                                      '${needGemsPointsCal(double.tryParse(items[i].specialPrice == "0.00" ? items[i].price.toString() : items[i].specialPrice.toString()), double.parse(items[i].burnrate!.toString()))} GEMS Points',
                                  color: needGemsColor,
                                  weight: FontWeight.w500,
                                  size: text_font_medium15_size,
                                ),
                              ),
                            ],
                          )
                    : Container(
                        height: 0,
                      ),
                _viewMore && selectedIndex == i
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 0, top: 5),
                        child: TextWidget(
                          //overflow: TextOverflow.ellipsis,
                          text: "Sold By: ${items[i].soldBy}",
                          size: text_font_size_small,
                          color: black_color,
                          softwrap: true,
                          weight: FontWeight.w600,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    selectedIndex = i;
                    _viewMore = !_viewMore;

                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 0, top: 0),
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 1,
                              spreadRadius: 1)
                        ],
                        color: grey100_color,
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: TextWidget(
                        text: _viewMore && selectedIndex == i
                            ? "View less"
                            : "View more",
                        color: grey_text_color,
                        size: text_font_size_small),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
      return _data;
    }

    Widget bottombody() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GemsGLobals.pointbalance != 0
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cartDetailsModel?.freeShippingApply == 1
                            ? TextWidget(
                                alignment: TextAlign.center,
                                text:
                                    cartDetailsModel?.freeShippingMessage ?? '',
                                color: grey600_color,
                                size: text_font_medium_size,
                                weight: FontWeight.bold,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            (GemsGLobals.referralRelationType !=
                                        GemsGLobals.spouseValue &&
                                    GemsGLobals.referralRelationType !=
                                        GemsGLobals.childValue)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          isPointsPaymentSelected =
                                              !isPointsPaymentSelected;
                                          if (isPointsPaymentSelected) {
                                            GlobalValue.paymentType =
                                                "usebounz";
                                            _pointsEditable = false;
                                          }
                                          enteramount = false;
                                          if (_pointwithController.text !=
                                                  "null" &&
                                              _pointwithController.text != "") {
                                            if (int.parse(
                                                    _pointwithController.text) >
                                                _redeemPoints()) {
                                              errormessage = true;
                                            } else if (int.parse(
                                                    _pointwithController.text) >
                                                GemsGLobals.pointbalance) {
                                              _invaldPoints = true;
                                            } else {
                                              errormessage = false;
                                              _invaldPoints = false;
                                            }
                                          }

                                          setState(() {});
                                        },
                                        child: isPointsPaymentSelected
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            country_select_color_border),
                                                    shape: BoxShape.rectangle,
                                                    color: white_color),
                                                child: Icon(Icons.check,
                                                    size: 25,
                                                    color: theme_color),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            country_select_color_border),
                                                    shape: BoxShape.rectangle),
                                                child: Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 25,
                                                    color: transColor),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: "Reward Points",
                                        color: _pointsEditable
                                            ? Colors.grey.shade400
                                            : black_color,
                                        size: text_font_medium16_size,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: (GemsGLobals.referralRelationType !=
                                                GemsGLobals.spouseValue &&
                                            GemsGLobals.referralRelationType !=
                                                GemsGLobals.childValue)
                                        ? () {
                                            isPointsPaymentSelected =
                                                !isPointsPaymentSelected;
                                            if (!isPointsPaymentSelected) {
                                              GlobalValue.paymentType =
                                                  "collectbounz";
                                              _pointsEditable = true;
                                            }
                                            setState(() {
                                              errormessage = false;
                                              _invaldPoints = false;
                                            });

                                            setState(() {});
                                          }
                                        : () {},
                                    child: !isPointsPaymentSelected
                                        ? Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        country_select_color_border),
                                                shape: BoxShape.rectangle,
                                                color: white_color),
                                            child: Icon(Icons.check,
                                                size: 25, color: theme_color),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        country_select_color_border),
                                                shape: BoxShape.rectangle),
                                            child: Icon(
                                                Icons.check_box_outline_blank,
                                                size: 25,
                                                color: transColor),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextWidget(
                                    text: "Online Payment",
                                    color: !_pointsEditable
                                        ? Colors.grey.shade400
                                        : black_color,
                                    size: text_font_medium16_size,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            isPointsPaymentSelected
                                ? _paybycashandpoints()
                                : Container(
                                    height: 0,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            !isPointsPaymentSelected
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: 'Online Payment: ',
                                        color: black_color,
                                        size: text_font_medium16_size,
                                      ),
                                      TextWidget(
                                        text:
                                            cartDetailsModel?.grandTotal ?? '',
                                        color: black_color,
                                        size: text_font_medium16_size,
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            _invaldPoints && _payWithPoint
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: TextWidget(
                        text:
                            "The entered GEMS must be within your available GEMS balance and required total amount",
                        size: 13,
                        color: red_color,
                        weight: FontWeight.w600,
                        alignment: TextAlign.center,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  ),
            noAddressSelected || defaultaddress == null
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: TextWidget(
                        text: "Please select or add address",
                        size: text_font_medium_x_size,
                        color: red_color,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  ),
            placeOrderLoader
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey.shade200)
                        ],
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.all(20),
                    ),
                  )
                : (_invaldPoints || errormessage) && _payWithPoint
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 2,
                                color: Colors.grey.shade200)
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: TextWidget(
                          text: 'Place Order',
                          color: white_text_color,
                          size: text_font_medium16_size,
                          weight: FontWeight.w500,
                        ))
                    : _placeOrderLoad == true
                        ? SpinKitCircle(
                            color: blue_color,
                          )
                        : InkWell(
                            onTap: () async {
                              if (isPointsPaymentSelected &&
                                  (_pointwithController.text.isEmpty ||
                                      _pointwithController.text.length <= 0)) {
                                setState(() {
                                  enteramount = true;
                                });
                              } else {
                                setState(() {
                                  enteramount = false;
                                  _placeOrderLoad = true;
                                });
                                makesenseCheckoutApiCall("place order");
                                if (addressSave == null &&
                                    (defaultaddress == null &&
                                        allSimpleCheck != false)) {
                                  noAddressSelected = true;
                                  placeOrderLoader = false;
                                  setState(() {});
                                } else if (allVirtualCheck) {
                                  _autovalidate = true;
                                  addListners();

                                  _email();

                                }
                                if (

                                    _isEmailErr == false
                                    
                                    ) {
                                  if (addressSave != null) {
                                    addressSave = addressSave?.copyWith(
                                     
                                      email: _emailController.text,

                                    );
                                  } else {
                                    addressSave = AddressSave(
                                        "",
                                        _firstnameController.text,
                                        _lastnameController.text,
                                        _emailController.text,
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        _countryController.text,
                                        "",
                                        _mobileController.text,
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        true);
                                  }

                                  if (GlobalValue.paymentType == "usebounz") {
                                    
                                    await fifoLogicCalculation();
                                    itemPointSpecificPointConversion(
                                        widget.cartDetailsModel!,
                                        
                                        _pointwithController.text.isNotEmpty &&
                                                int.parse(_pointwithController
                                                        .text) >
                                                    0
                                            ? int.parse(
                                                _pointwithController.text)
                                            : GemsGLobals.pointbalance);
                                  } else {
                                    collectPointConversion(
                                        widget.cartDetailsModel);
                                  }

                                  setState(() {
                                    if (isPointsPaymentSelected &&
                                        _pointwithController.text != "0" &&
                                        _redeemPoints() ==
                                            double.tryParse(
                                                _pointwithController.text)) {
                                      totalPriceOrPoint();
                                      checkoutApi("points");
                                      paymentTypeSelected = "points";
                                     
                                    } else if (isPointsPaymentSelected &&
                                        ((totalOfBurnPoints >=
                                                        (double.tryParse(GemsGLobals
                                                                .pointbalance
                                                                .toString()) ??
                                                            0) ||
                                                    double.tryParse(
                                                            _pointsController
                                                                .text)! <=
                                                        (double.tryParse(GemsGLobals
                                                                .pointbalance
                                                                .toString()) ??
                                                            0)) &&
                                                _pointsController.text != "0" ||
                                            (_pointwithController
                                                    .text.isNotEmpty &&
                                                int.parse(_pointwithController
                                                        .text) >
                                                    0))) {
                                      totalPriceOrPoint();
                                      checkoutApi("points+cash");
                                      paymentTypeSelected = "points+cash";
                                    } else {
                                      totalPriceOrPoint();
                                      checkoutApi("cash");
                                      paymentTypeSelected = "cash";                                      
                                    }
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      color: Colors.grey.shade200)
                                ],
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 15),
                              child: TextWidget(
                                text: 'Place Order',
                                color: white_text_color,
                                size: text_font_medium16_size,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
          ],
        ),
      );
    }

    Widget _pricebrekup() {
      return Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "Price Breakup",
                            color: flight_text_black_color,
                            // weight: FontWeight.bold,
                            size: text_font_medium15_size,
                            weight: FontWeight.w500,
                          ),
                        ])),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text:
                            "Subtotal ${cartDetailsModel?.totalItems ?? 0} Item",
                        color: flight_text_black_color,
                        size: text_font_medium14_size,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: "${cartDetailsModel?.subTotal}",
                            color: black_color,
                            weight: FontWeight.bold,
                            size: text_font_medium14_size,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                cartDetailsModel?.tax == null ||
                        cartDetailsModel!.tax!.isEmpty ||
                        cartDetailsModel!.tax!.contains(" 0.00") ||
                        cartDetailsModel!.tax!.contains(" 0٫00")
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                cartDetailsModel?.tax == null ||
                        cartDetailsModel!.tax!.isEmpty ||
                        cartDetailsModel!.tax!.contains(" 0.00") ||
                        cartDetailsModel!.tax!.contains(" 0٫00")
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            TextWidget(
                              text: "Tax",
                              color: flight_text_black_color,
                              // weight: FontWeight.bold,
                              size: text_font_medium14_size,
                            ),
                            Spacer(),
                            TextWidget(
                              text: "${cartDetailsModel?.tax ?? ''}",
                              size: text_font_medium14_size,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                cartDetailsModel?.discount == null ||
                        cartDetailsModel!.discount!.isEmpty ||
                        cartDetailsModel!.discount!.contains(" 0.00") ||
                        cartDetailsModel!.discount!.contains(" 0٫00")
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                cartDetailsModel?.discount == null ||
                        cartDetailsModel!.discount!.isEmpty ||
                        cartDetailsModel!.discount!.contains(" 0.00") ||
                        cartDetailsModel!.discount!.contains(" 0٫00")
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            TextWidget(
                              text: "Discount",
                              color: flight_text_black_color,
                              // weight: FontWeight.bold,
                              size: text_font_medium14_size,
                            ),
                            Spacer(),
                            TextWidget(
                              text: "- ${cartDetailsModel?.discount}",
                              size: text_font_medium14_size,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "Shipping Charge",
                        color: flight_text_black_color,
                        // weight: FontWeight.bold,
                        size: text_font_medium14_size,
                      ),
                      TextWidget(
                        text: "${cartDetailsModel?.shippingAmount}",
                        color: black_color,
                        weight: FontWeight.bold,
                        size: text_font_medium14_size,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GlobalValue.isstoreaapplied
                    ? Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var body = {
                                  "brandcode": Constants.brandCode,
                                  "country_code": Constants.countryCode,
                                  "lang_code": Constants.langCode,
                                  "cart_id":
                                      cartDetailsModel?.items?[0].quoteId,
                                  "action": "unapply"
                                };

                                if (GlobalValue.isstoreaapplied)
                                  GlobalValue.isstoreaapplied = false;
                                internetCall(
                                    context,
                                    () => GuestCheckoutPresenter()
                                        .applystorecredit(this, body));
                                storeapplied = true;
                                returnedValue = null;
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.grey[400],
                                padding: EdgeInsets.all(5),
                                child: TextWidget(
                                  text: "REMOVE",
                                  color: black_color,
                                  weight: FontWeight.bold,
                                  size: text_font_x_small,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(
                              text:
                                  "${cartDetailsModel?.storeCredit} Store \nCredits",
                              color: black_color,
                              weight: FontWeight.bold,
                            ),
                            Spacer(),
                            TextWidget(
                              text: "- ${cartDetailsModel?.storeCredit}",
                              color: black_color,
                              weight: FontWeight.bold,
                              size: text_font_small,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: "Total",
                            color: black_color,
                            toUpperCase: true,
                            weight: FontWeight.w800,
                            size: text_font_small,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          TextWidget(
                            text: "(Inclusive of VAT)",
                            color: flight_text_black_color,
                            size: text_font_small,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: cashondelivery == null
                            ? "${cartDetailsModel?.grandTotal}"
                            : cartDetailsModel?.grandTotal == null ||
                                    cartDetailsModel!.grandTotal!.isEmpty ||
                                    cartDetailsModel!.grandTotal!
                                        .contains(" 0.00")
                                ? (cartDetailsModel?.grandTotal ?? '')
                                : "",
                        //"${cartDetailsModel?.items[0]?.currencySymbol} ${(double.tryParse(cartDetailsModel?.grandTotal?.substring(4)?.replaceAll(",", "") ?? "") ?? 0.00) + (double.tryParse(cashondelivery?.fee?.substring(4) ?? "") ?? 0.00)}",
                        color: black_color,
                        weight: FontWeight.bold,
                        size: text_font_medium_x_size,
                      ),
                    ],
                  ),
                ),
                bottombody()
              ],
            ),
          ),
        ),
      );
    }

    Widget _reviewOrder() {
      return Container(
        child: Column(
          children: [
            ..._cartList(),
            SizedBox(
              height: 10,
            ),
            _pricebrekup(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    

    PreferredSizeWidget _appbar() {
      double appbarheight = 140;
      setState(() {
        if (GemsGLobals.pointbalance == 0 || GemsGLobals.pointbalance == null) {
          appbarheight = Platform.isIOS ? 160 : 100;
        } else if (GemsGLobals.referralRelationType !=
                GemsGLobals.spouseValue &&
            GemsGLobals.referralRelationType != GemsGLobals.childValue) {
          appbarheight = Platform.isIOS ? 160 : 130;
        } else {
          appbarheight = Platform.isIOS ? 160 : 100;
        }
      });
      return PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: InkWell(
            onTap: () {
            },
            child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: appbarheight,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShopGradientAppBar(
                    title: "Order Review",
                    color: white_text_color,
                    size: 19,
                    weight: FontWeight.w600,
                    centerTitle: true,
                    height: 60,
                  ),
                  GemsGLobals.pointbalance == 0 ||
                          GemsGLobals.pointbalance == null
                      ? Container()
                      : (GemsGLobals.referralRelationType !=
                                  GemsGLobals.spouseValue &&
                              GemsGLobals.referralRelationType !=
                                  GemsGLobals.childValue)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(left: 30, top: 5, right: 20),
                              child: TextWidget(
                                text:
                                    "You can redeem upto ${gemsPointsFormatter(GemsGLobals.pointbalance)} GEMS Points",
                                color: white_text_color,
                                alignment: TextAlign.center,
                                size: text_font_size_x_small,
                              ),
                            )
                          : Container()
                ],
              ),
            ),
          ));
    }

    Widget _body() {
      return Container(
        padding: EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              allSimpleCheck == false
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 8, left: 2, right: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: grey_color_300),
                        color: white_color,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              spreadRadius: 3,
                              offset: Offset(2.0, 1.0),
                              color: grey_color_300)
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(
                                text: !allVirtualCheck
                                    ? "Deliver to"
                                    : "Deliver via Address",
                                color: grey600_color,
                                size: text_font_medium_x_size,
                                weight: FontWeight.bold,
                              ),
                              Container(
                                width: 200,
                                child: addressSave != null &&
                                        addressSave
                                                ?.streetAddress?.isNotEmpty ==
                                            true
                                    ? TextWidget(
                                        softwrap: true,
                                        color: Colors.black,
                                        size: 13,
                                        weight: FontWeight.normal,
                                        text:
                                            "${addressSave?.firstname} ${addressSave?.lastName} ${addressSave?.streetAddress}\n ${addressSave?.address}\n${addressSave?.area}, ${addressSave?.city}\nM:- ${addressSave?.countryCode}  ${addressSave?.number}",
                                      )
                                    : TextWidget(
                                        softwrap: true,
                                        color: defaultaddress == null
                                            ? grey_gunsmoke_text_color
                                            : Colors.black,
                                        size: 13,
                                        weight: FontWeight.normal,
                                        text: defaultaddress == null
                                            ? "No verified address"
                                            : "${defaultaddress?.firstname} ${defaultaddress?.lastname}\n${defaultaddress?.address} \n${defaultaddress?.city} ${defaultaddress?.area}\nM:- ${defaultaddress?.telephone}"),
                              ),
                            ],
                          ),
                          !allVirtualCheck
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddressMap(
                                                route:
                                                    GemsGLobals.membershipId !=
                                                            null
                                                        ? "customer"
                                                        : "",
                                                cartDetailsModel: null,
                                              )),
                                    ).then((value) {
                                      if (value != null) {
                                        // print("opopop");
                                        addressSave = value;
                                        newaddressadded = true;
                                        noAddressSelected = false;
                                        setState(() {});
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: white_color,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              color: Colors.grey.shade200)
                                        ]),
                                    child: TextWidget(
                                      text: "Add Address",
                                      color: theme_color,
                                      size: text_font_size_small,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Switch(
                                      value: sendViaAddress,
                                      onChanged: (value) {
                                        setState(() {
                                          sendViaAddress = value;
                                          if (value == false)
                                            _emailFoucs.unfocus();
                                        });
                                      },
                                      activeTrackColor:
                                          theme_color.withOpacity(0.6),
                                      activeColor: theme_color,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 2,
                                                spreadRadius: 2)
                                          ],
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: GestureDetector(
                                        onTap: !sendViaAddress
                                            ? () {}
                                            : () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressMap(
                                                            route: GemsGLobals
                                                                        .membershipId !=
                                                                    null
                                                                ? "customer"
                                                                : "",
                                                            cartDetailsModel:
                                                                null,
                                                          )),
                                                ).then((value) {
                                                  if (value != null) {
                                                    addressSave = value;
                                                    newaddressadded = true;
                                                    noAddressSelected = false;
                                                    setState(() {});
                                                  }
                                                });
                                              },
                                        child: TextWidget(
                                          text: "Change",
                                          color: !sendViaAddress
                                              ? Colors.grey
                                              : theme_color,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
              !allVirtualCheck
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: grey_color_300),
                        color: white_color,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              spreadRadius: 3,
                              offset: Offset(2.0, 1.0),
                              color: grey_color_300)
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: "Deliver via Email",
                                color: grey600_color,
                                size: text_font_medium_x_size,
                                weight: FontWeight.bold,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 200,
                                      color: Color.fromRGBO(255, 255, 255, 0.2),
                                      child: TextFormField(
                                        focusNode: _emailFoucs,
                                        controller: _emailController,
                                        readOnly: isEmailEditable,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: "example@mail.in",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        autofocus: false,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        onChanged: (text) {
                                          EasyDebounce.debounce('debouncer2',
                                              Duration(seconds: 5), () {
                                            var body = {
                                              "emailid": GemsGLobals.useremail,
                                              "shopuserid":
                                                  GemsGLobals.custEncryptedId,
                                              "qty": "",
                                              "action": "email",
                                              "gift_email":
                                                  _emailController.text,
                                              "product_id": "",
                                              "child_id": ""
                                            };
                                            isloading = true;
                                            internetCall(
                                                context,
                                                () => CartDetailsPresenter(this)
                                                    .editProductCart(body));
                                            CartDetailsDBHelper()
                                                .truncateCartDetailsData()
                                                .then((value) => {});
                                            ShippingDetailsDBHelper()
                                                .truncateShippingDetailsData();
                                            setState(() {});
                                          });
                                        },
                                        onEditingComplete: () {},
                                      )),
                                  _isEmailErr
                                      ? Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0.0),
                                            child: TextWidget(
                                              text: _emailErrmsg ?? "",
                                              color: Colors.red,
                                              size: 13,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Switch(
                                value: sendViaEmail,
                                onChanged: (value) {
                                  setState(() {
                                    sendViaEmail = value;
                                  });
                                },
                                activeTrackColor: theme_color.withOpacity(0.6),
                                activeColor: theme_color,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 2,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: GestureDetector(
                                  onTap: !sendViaEmail
                                      ? () {}
                                      : () {
                                          isEmailEditable = !isEmailEditable;
                                          _emailFoucs.requestFocus();
                                          setState(() {});
                                        },
                                  child: TextWidget(
                                    text: "Change",
                                    color: !sendViaEmail
                                        ? Colors.grey
                                        : theme_color,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              _reviewOrder(),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: new_gradient_color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: grey_color, blurRadius: 5)]),
      child: SafeArea(
        bottom: true,
        top: false,
        child: PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
            if (updateCart) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopTabBarPage(
                            index: 2,
                          )));
            } else {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _appbar(),
            backgroundColor: grey200_color,
            body: isloading
                ? Container(
                    child: Loader(),
                  )
                : Stack(
                    children: [
                      Opacity(
                        opacity: 1,
                        child: _body(),
                      ),
                      Opacity(
                        opacity: storeapplied ? 0.5 : 0,
                        child: storeapplied
                            ? AbsorbPointer(
                                child: SpinKitCircle(
                                  color: theme_color,
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                      ),
                    ],
                  ),
            bottomNavigationBar: isloading ? SizedBox() :  TabbarWidget(0),
          ),
        ),
      ),
    );
  }

  @override
  void reviewPageResponse(List<ShippingAddresss> shippingaddress) {
    if (shippingaddress[0].success == "true") {

      _addressList =
          shippingaddress[0].address?.where((e) => e.isdefault == 0).toList() ??
              [];
      defaultaddress = shippingaddress[0].address?.firstWhere(
            (e) => e.isdefault == 1,
          );
        makesenseCheckoutApiCall("");
      if (defaultaddress != null) userselectedaddress = defaultaddress;
      if (defaultaddress == null && _addressList.isNotEmpty) {
        selectAddress = 0;
        userselectedaddress = _addressList[0];
        addressnotselected = false;
      }
      addressLoader = false;
      guestaddress = false;
      addressnotselected = false;
      //internetCall(context, () => CartDetailsPresenter(this).cartDetails());
      setState(() {});
    } else {
      addressLoader = false;
      setState(() {});
    }
  }

  @override
  void getshippingmethodresponse(ShippingMethodModel shippingmodel) {
    if (shippingmodel.success == "true") {
      shippingmodelResponse = shippingmodel;

      internetCall(context, () => CartDetailsPresenter(this).cartDetails());

      setState(() {});
    }
  }

  @override
  void applystorecreditResponse(List<StoreCreditModel> storecreditmodel) {
    if (storecreditmodel[0].success == "true") {
      storecreditmodelResponse = storecreditmodel[0];
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();

      internetCall(context, () => CartDetailsPresenter(this).cartDetails());
      setState(() {});
    }
  }

  @override
  void cartDetailResponse(CartDetailsModel cartdetailsmodels) {
    if (cartdetailsmodels.success == "true") {
      cartDetailsModel = cartdetailsmodels;
      for (var i = 0; i < (cartDetailsModel?.items?.length ?? 0); i++) {
        totalOfEarnPoints += double.tryParse(
            cartDetailsModel?.items?[i].pointEarned != ''
                ? (cartDetailsModel?.items?[i].pointEarned ?? '0')
                : '0')!;
      }

      if (cartDetailsModel!.grandTotal!.contains(" 0.00")) {
        GlobalValue.amtAvailable = true;
        GlobalValue.isstoreaapplied = true;
        oncashtrue = false;
      } else {
        GlobalValue.amtAvailable = false;
      }
      isloading = false;
      storeapplied = false;
      setState(() {});
    } else {
      isloading = false;
      storeapplied = false;
      setState(() {});
    }
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => CartDetailsPresenter(this).cartDetails())));
  }

  @override
  void onReviewTimeout() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "customer_id": Constants.customerId
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      ReviewPagePresenter(this).shippingaddress(body))));
  }

  @override
  void checkoutResponse(List<CheckoutModel> checkoutmodel) async {
    GemsGLobals.lastVisitPageName = GemsGLobals.eShopOrderReviewPage;
    if (checkoutmodel[0].success == "true") {
      setState(() {
        _placeOrderLoad = false;
      });

      this.checkoutmodel = checkoutmodel;
      if (_value == "stripe" || _value == "ngeniusonline"|| _value == "vernost_gateway" ) {
        internetCall(context, () => CartDetailsPresenter(this).cartDetails());

        placeOrderLoader = false;
        setState(() {});

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopWebViewPage(
                    showAddress: showAddress,
                    defaultaddress: defaultaddress,
                    addressSave: addressSave,
                    userFirstName: addressSave != null
                        ? addressSave?.firstname
                        : GemsGLobals.userFirstName ?? '',
                    userLastName: addressSave != null
                        ? addressSave?.lastName
                        : GemsGLobals.userLastName ?? '',
                    email: cartDetailsModel?.giftEmail != '' ||
                            cartDetailsModel?.giftEmail != null
                        ? cartDetailsModel?.giftEmail
                        : GemsGLobals.useremail,
                    webUrl: checkoutmodel[0].url,
                    orderId: checkoutmodel[0].orderId,
                    paymentMedthod: payments,
                    orderNumber: checkoutmodel[0].orderIncrementid,
                    orderRefence: checkoutmodel[0].reference,
                    ordertotal: cartDetailsModel?.grandTotal,
                    pointsEarned: totalEarnPoint.toInt().toString(),
                    orderRequest: orderRequest,
                    totalBurnPoint: totalBurnPoint,
                    totalEarnPoint: totalEarnPoint,
                    totalBurnPrice: totalBurnPrice,
                    totalEarnPrice: totalEarnPrice,
                    cartDetailsModel: widget.cartDetailsModel,
                    paymentmethod: _payment.toString(),
                  )),
        );
      } else {
        setState(() {
          _placeOrderLoad = false;
          orderid = checkoutmodel[0].orderIncrementid;
          var body = {
            "email": cartDetailsModel?.giftEmail ?? GemsGLobals.useremail,
            "shopuserid": GemsGLobals.custEncryptedId,
            "orderid": checkoutmodel[0].orderId,
            "status": "processing",
            "customer_id": GemsGLobals.userId,
            "burn_points": totalBurnPoint,
            "burn_amount": totalBurnPrice,
            "type": GemsGLobals.userType,
            "description": checkoutmodel[0].orderId,
            "activity": "ESR",
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
      _placeOrderLoad = false;
      placeOrderLoader = false;
      // isguestcheckout = false;
      Fluttertoast.showToast(
          msg: checkoutmodel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("Store", '');
      MyProfileDBHelper().truncateMyProfileData();
      setState(() {});
    }
  }

  @override
  void responseFailure(response) {
    debugPrint("error ------- $response");
  }

  @override
  void paymentMethodResponse(List<PaymentMethodModel> paymentMethod) {
    if (paymentMethod[0].success == "true") {
      isloading = false;
      _placeOrderLoad = false;
      placeOrderLoader = false;
      paymentMethodresponse = paymentMethod[0];
      setState(() {});
    }
  }

  @override
  void paymentGatewayCreateToken(TokenModel? tokenModel) {
    if (tokenModel?.token != null && checkoutmodel != null) {
      var body;
      internetCall(
          context, () => GuestCheckoutPresenter().paymentCard(this, body));
    } else {
      _placeOrderLoad = false;
      placeOrderLoader = false;
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
      GemsGLobals.lastVisitPageName = GemsGLobals.eShopOrderReviewPage;
      placeOrderLoader = false;
      if (paymentCardModel.success != null && paymentCardModel.success!) {
        dbHelper.truncateMyProfileData();
        CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
        ShippingDetailsDBHelper().truncateShippingDetailsData();
        GlobalValue.isstoreaapplied = false;
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    orderId: checkoutmodel?[0].reference == null ||
                            checkoutmodel?[0].reference == ""
                        ? paymentCardModel.orderId
                        : checkoutmodel?[0].reference,
                    cartDetailsModel: widget.cartDetailsModel,
                    paymentmethod: _payment.toString(),
                  )),
        );
      } else {
        _placeOrderLoad = false;
        Fluttertoast.showToast(
            msg:
                "${paymentCardModel.errorMessage?[0].toString()} \n ${paymentCardModel.errorMessage?[1].toString()}",
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
  void statusCheck(List<OrderStatusModel> orderstatus) {
    GemsGLobals.lastVisitPageName = GemsGLobals.eShopOrderReviewPage;
    if (orderstatus[0].success == "true") {
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationPage(
                    pointsEarned: totalEarnPoint.toString(),
                    defaultaddress: defaultaddress,
                    addressSave: addressSave,
                    userFirstName: addressSave != null
                        ? addressSave?.firstname
                        : GemsGLobals.userFirstName,
                    userLastName: addressSave != null
                        ? addressSave?.lastName
                        : GemsGLobals.userLastName,
                    orderId: orderid,
                    orderstatus: "success",
                    showAddress: showAddress,
                    cartDetailsModel: widget.cartDetailsModel,
                    paymentmethod: _payment.toString(),
                  )));
    } else {
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();
      MyProfileDBHelper().truncateMyProfileData();
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ErrorPage()));
    }
  }

  @override
  void checkoutTimeOut() {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        checkoutApi(paymentTypeSelected);
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
          "email": cartDetailsModel?.giftEmail ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": checkoutmodel?[0].orderId,
          "status": "processing",
          "customer_id": GemsGLobals.userId,
          "burn_points": totalBurnPoint,
          "burn_amount": totalBurnPrice,
          "earnpoint": totalEarnPoint,
          "type": GemsGLobals.userType,
          "description": checkoutmodel?[0].orderId,
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
    setState(() {
      _placeOrderLoad = false;
      placeOrderLoader = false;
    });
    Fluttertoast.showToast(
        msg: "Some product quantity not available",
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xAA000000),
        textColor: white_text_color,
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  void statusUpadetaResponseFailure(error) {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": cartDetailsModel?.giftEmail ?? GemsGLobals.useremail,
          "shopuserid": GemsGLobals.custEncryptedId,
          "orderid": checkoutmodel?[0].orderId,
          "status": "processing",
          "customer_id": GemsGLobals.userId,
          "burn_points": totalBurnPoint,
          "burn_amount": totalBurnPrice,
          "earnpoint": totalEarnPoint,
          "type": GemsGLobals.userType,
          "description": checkoutmodel?[0].orderId,
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
  void deleteCartResponse(List<RemoveProductModel> removeProductModel) {}

  @override
  void editCartResponse(List<EditProductModel> editProductModel) {
    if (editProductModel[0].success == "true") {
      CartDetailsPresenter(this).shippingmethod();
      setState(() {});
    } else {
      isloading = false;
      setState(() {});
    }
  }

  @override
  void paymentMethodresponseFailure(error) {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      if (value != null) {
        var body = {
          "email": GemsGLobals.useremail,
          "shopxrid": GemsGLobals.membershipId
        };
        internetCall(
            context, () => GuestCheckoutPresenter().paymentMethod(this, body));
      }
    });
  }
}
