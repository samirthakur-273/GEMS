import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_db_model.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/presenter/apply_coupon_presenter.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/view/apply_coupon_view.dart';
import 'package:gems_revamp/eshop_module_new/localization/app_localization.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/presenter/my_wishlist_delete_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_delete_view.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detail_view.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/cart_detailspage_shimmer.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDetailsPage extends StatefulWidget {
  final Function? apiCallTabPage;
  final ShopTabBarPageState? tabBarPageState;

  CartDetailsPage({this.apiCallTabPage, this.tabBarPageState});

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage>
    with TickerProviderStateMixin
    implements
        CartDetailsView,
        ProductDetailsView,
        MyWishlistDeleteView,
        MyProfileViewContract,
        ApplyCouponView {
  late TextEditingController _controller;
  var isloadaing = true;
  var isTransloadaing = false;
  bool qtyLoading = false;
  late MyWishlistDeletePresenter _deletePresenter;
  late CartDetailsModel cartDetailsModel;
  List<Itemss>? listCart;
  late WishList addwishResponse;
  bool applyCoupon = true;
  late ApplyCouponPresenter _presenter;
  List<ScrollController> cont = [];
  late ShippingMethodModel shippingmodelResponse;
  TextEditingController _couponcontroller = TextEditingController();
  late String forStoreUse;
  double percentageOff = 0.0;
  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;
  Map<String, int> selected = {};
  List selectedItem = [];
  Map<String, bool> qtySelected = {};
  late String dropdownValue;
  late String selectedValue;
  late TabController _tabController;
  List<bool> _viewMore = [];
  double actualPrice = 0.0;
  Completer _completer = Completer();
  TextEditingController editingController = TextEditingController();
  List<CheckboxSelect> checkboxSelect = <CheckboxSelect>[
    CheckboxSelect(1, "Dubai"),
    CheckboxSelect(2, "Fujairah"),
    CheckboxSelect(3, "Ghantout"),
    CheckboxSelect(4, "Hatta"),
    CheckboxSelect(5, "Liwa"),
  ];
  List<String> duplicateItems = [
    "Dubai",
    "Fujairah",
    "Ghantout",
    "Hatta",
    "Liwa"
  ];
  var userEmail;
  var userName;
  late int cartIndex;
  bool itemOutOfStock = false;
  var items = <String>[];
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  late int countervalue = 0;
  late int selectedIndex = 0;
  var config_options;
  String lastPage = "";
  bool openCartListPage = false;

  @override
  void initState() {
    items.addAll(duplicateItems);
    CartDetailsPresenter(this).shippingmethod();
    _presenter = ApplyCouponPresenter(this);
    _deletePresenter = MyWishlistDeletePresenter(this);
    lastPage = GemsGLobals.lastVisitPageName;
    GemsGLobals.lastVisitPageName = GemsGLobals.eventCartPage;
    super.initState();
    _arrowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);
    _controller = new TextEditingController();
    _tabController = new TabController(length: 2, vsync: this);
  }

  makesenseEventCall(CartDetailsModel cartDetailsModel) {
    String keyName = GemsGLobals.eventCartPage;
    var segmentReq = {
      'int_source': lastPage,
      'total_cart_value': cartDetailsModel.grandTotal ?? "",
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
      ]
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventCartPage;
  }

  makesenseRemoveFromCartApiCall(Itemss itemss) {
    String keyName = GemsGLobals.eventEcomRemoveCart;
    var segmentReq = {
      "int_source": lastPage,
      'total_cart_value': cartDetailsModel.grandTotal ?? "",
      "product_name": itemss.name ?? "",
      "sku": itemss.sku ?? "",
      "stock": itemss.isAvailable == 0
          ? GemsGLobals.productOutOfStock
          : GemsGLobals.productInStock,
      "Quantity": itemss.qty ?? "",
      "category_type": itemss.categoryType ?? "",
      "sub_category": itemss.subCategory ?? "",
      "brand_name": itemss.brandName ?? "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventCartPage;
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  void _resetLoader() {
    _completer.complete();
    _completer = new Completer();
  }

  Future<void> cartDataUpdate() async {
    await ShippingDetailsDBHelper().truncateShippingDetailsData();
    await CartDetailsDBHelper().truncateCartDetailsData();
    internetCall(context, () => CartDetailsPresenter(this).shippingmethod());
  }

  @override
  void dispose() {
    cont.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  userLoginCheck() async {
    var prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString("Useremail");
    userName = prefs.getString("Username");
  }

  static var dbHelperProfile = MyProfileDBHelper();
  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbHelperProfile.getMyProfileData();
    return data;
  }

  void dataUpdate() {
    isloadaing = true;
    userLoginCheck();
    dbHelperProfile.truncateMyProfileData();
    MyProfilePresenter(this).getMyProfileData();
    widget.apiCallTabPage!();
    CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
    internetCall(context, () => CartDetailsPresenter(this).shippingmethod());
    ShippingDetailsDBHelper().truncateShippingDetailsData();
    MyWishListDBHelper().truncateWishlistData();
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
            margin: EdgeInsets.only(right: 6, top: 5),
            child: TextWidget(
                text: "${map["label"]} : ${map["option_label"]}",
                size: text_font_small,
                weight: FontWeight.w500),
          ));
        }
      }
      return products;
    }

    List<Widget> _cartList() {
      List<Widget> _data = [];
      for (var i = 0; i < (listCart?.length ?? 0); i++) {
        _viewMore.add(false);
        if (listCart?[i].isAvailable == 0) itemOutOfStock = true;

        _data.add(Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.3, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          shadowColor: grey_color_300,
          child: Container(
              color: white_text_color.withOpacity(0.5),
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                            Container(
                              width: 180,
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: listCart?[i].name ?? "",
                                size: text_font_small,
                                softwrap: true,
                                color: black_color,
                                weight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            listCart?[i].isAvailable != 1
                                ? Column(
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 0.0, top: 5),
                                        child: TextWidget(
                                          text: "Out of stock",
                                          size: text_font_medium_x_size,
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
                            Padding(
                              padding: EdgeInsets.only(right: 2, top: 13),
                              child: Row(
                                children: [
                                  TextWidget(
                                    text:
                                        '${listCart![i].currencySymbol}${Constants.priceFormatter(double.tryParse(listCart![i].price != '' ? (listCart![i].price ?? '0') : '0'))}',
                                    size: text_font_medium14_size,
                                    color: listCart?[i].specialPrice ==
                                                "0.00" ||
                                            listCart![i].specialPrice == null
                                        ? black_color
                                        : Colors.grey.shade400,
                                    weight: FontWeight.w500,
                                    decoration: listCart?[i].specialPrice ==
                                                "0.00" ||
                                            listCart?[i].specialPrice == null
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough,
                                  ),
                                  listCart![i].specialPrice == null ||
                                          listCart![i].specialPrice == "" ||
                                          listCart![i].specialPrice == "0.00"
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                              gradient: gradient_theme_color,
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20)),
                                          margin: EdgeInsets.only(left: 8),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: TextWidget(
                                              text: percentageCalculate(
                                                  listCart![i].price,
                                                  listCart![i].specialPrice),
                                              weight: FontWeight.bold,
                                              size: text_font_size_small,
                                              color: white_text_color,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            listCart![i].specialPrice == "0.00" ||
                                    listCart![i].specialPrice == null
                                ? Container()
                                : SizedBox(
                                    width: 10,
                                  ),
                            listCart![i].specialPrice == "0.00" ||
                                    listCart![i].specialPrice == null
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right: 1),
                                        child: TextWidget(
                                          text:
                                              "${listCart![i].currencySymbol}",
                                          size: text_font_medium14_size,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          weight: FontWeight.w400,
                                        ),
                                      ),
                                      TextWidget(
                                        text:
                                            '${Constants.priceFormatter(double.tryParse(listCart![i].specialPrice != '' ? (listCart![i].specialPrice ?? '0') : '0'))}',
                                        size: text_font_medium_size,
                                        color: Colors.black,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                            listCart![i].configurableProductOptions != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: configoption(listCart![i]
                                        .configurableProductOptions))
                                : Container(),
                            SizedBox(
                                height:
                                    listCart![i].configurableProductOptions !=
                                            null
                                        ? 10.0
                                        : 0),
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
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (context) =>
                                              WishListCartCount(),
                                          child: ProductDetailNew(
                                            productcode: listCart?[i].sku,
                                            burnRate: listCart?[i].burnrate,
                                            minPointsReq:
                                                listCart?[i].minipointrequired,
                                            pointsEarned:
                                                listCart?[i].pointEarned,
                                          ),
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: listCart?[i].image ?? "",
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
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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
                                margin: EdgeInsets.only(
                                  left: 4,
                                ),
                                child: TextWidget(
                                  softwrap: true,
                                  text: GlobalValue.paymentType ==
                                          "collectbounz"
                                      ? Constants.pricePointsFormatter(
                                          int.tryParse(
                                              listCart?[i].pointEarned != ''
                                                  ? (listCart?[i].pointEarned ??
                                                      '0')
                                                  : '0'))
                                      : Constants.burnPoints(
                                          (listCart![i].specialPrice == "0.00"
                                              ? listCart![i].price
                                              : listCart![i].specialPrice)!,
                                          listCart![i].burnrate!,
                                          listCart![i].qty),
                                  color: blue_color,
                                  weight: FontWeight.w500,
                                  size: text_font_medium15_size,
                                ),
                              ),
                              TextWidget(
                                softwrap: true,
                                text: " GEMS Points",
                                weight: FontWeight.w500,
                                color: theme_color,
                                size: text_font_medium_x_size,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            var data = {
                              "emailid": GemsGLobals.useremail,
                              "shopuserid": GemsGLobals.custEncryptedId,
                              "product_id": listCart![i].productId ?? "",
                              "child_id": listCart![i].childId ?? ""
                            };
                            isloadaing = true;
                            makesenseRemoveFromCartApiCall(listCart![i]);
                            internetCall(context, () {
                              CartDetailsPresenter(this)
                                  .removeProductCart(data);

                              CartDetailsDBHelper()
                                  .truncateCartDetailsData()
                                  .then((value) => {});
                            });
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 0.3, color: Colors.grey),
                              color: white_color,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                ImageConstants.delete,
                                color: blue_color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GemsGLobals.userType != "referral"
                      ? listCart![i].burnrate.toString() == "0" ||
                              listCart![i].burnrate.toString() == ""
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
                  (GemsGLobals.referralRelationType !=
                              GemsGLobals.spouseValue &&
                          GemsGLobals.referralRelationType !=
                              GemsGLobals.childValue)
                      ? listCart![i].burnrate.toString() == "0" ||
                              listCart![i].burnrate.toString() == ""
                          ? Container(
                              height: 0,
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: TextWidget(
                                    softwrap: true,
                                    text: "Redeem  ",
                                    weight: FontWeight.w600,
                                    color: needGemsColor,
                                    size: text_font_x_small,
                                  ),
                                ),
                                Container(
                                  child: TextWidget(
                                    softwrap: true,
                                    text:
                                        "${Constants.pricePointsFormatter(needGemsPointsCal(double.parse(listCart![i].specialPrice.toString() == "0.00" ? listCart![i].price.toString() : listCart![i].specialPrice.toString()), double.parse(listCart![i].burnrate.toString())))}",
                                    color: needGemsColor,
                                    weight: FontWeight.w500,
                                    size: text_font_medium15_size,
                                  ),
                                ),
                                TextWidget(
                                  softwrap: true,
                                  text: " GEMS Points",
                                  weight: FontWeight.w500,
                                  color: needGemsColor,
                                  size: text_font_medium_x_size,
                                ),
                              ],
                            )
                      : Container(
                          height: 0,
                        ),
                  _viewMore[i] == true
                      // && selectedIndex == i
                      ? Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10),
                          child: TextWidget(
                            //overflow: TextOverflow.ellipsis,
                            text: "Sold By: ${listCart![i].soldBy}",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedIndex = i;
                          _viewMore[i] = !_viewMore[i];

                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.center,
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: grey100_color,
                              border:
                                  Border.all(color: Colors.grey, width: 0.3)),
                          child: TextWidget(
                              text: _viewMore[i] && selectedIndex == i
                                  ? "View less"
                                  : "View more",
                              color: grey_text_color,
                              size: text_font_size_small),
                        ),
                      ),
                      listCart![i].edvoucher == true
                          ? Container()
                          : Container(
                              child: CounterView(
                              initNumber: listCart![i].qty,
                              counterCallback: (int counterValues) {
                                countervalue = counterValues;
                              },
                              increaseCallback: qtyLoading
                                  ? () {}
                                  : () {
                                      var body = {
                                        "emailid": GemsGLobals.useremail,
                                        "shopuserid":
                                            GemsGLobals.custEncryptedId,
                                        "qty": countervalue.toString(),
                                        "product_id": listCart![i].productId,
                                        "child_id": listCart![i].childId
                                      };

                                      qtyLoading = true;
                                      isTransloadaing = true;
                                      internetCall(
                                          context,
                                          () => CartDetailsPresenter(this)
                                              .editProductCart(body));
                                      setState(() {
                                        CartDetailsDBHelper()
                                            .truncateCartDetailsData()
                                            .then((value) => {});
                                      });
                                    },
                              decreaseCallback: qtyLoading
                                  ? () {}
                                  : () {
                                      var body = {
                                        "emailid": GemsGLobals.useremail,
                                        "shopuserid":
                                            GemsGLobals.custEncryptedId,
                                        "qty": countervalue,
                                        "product_id": listCart![i].productId,
                                        "child_id": listCart![i].childId
                                      };

                                      qtyLoading = true;
                                      isTransloadaing = true;
                                      internetCall(
                                          context,
                                          () => CartDetailsPresenter(this)
                                              .editProductCart(body));
                                      setState(() {
                                        CartDetailsDBHelper()
                                            .truncateCartDetailsData()
                                            .then((value) => {});
                                      });
                                    },
                            ))
                    ],
                  )
                ],
              )),
        ));
      }
      return _data;
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: white_color,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                top: 25,
              ),
              height: Platform.isIOS ? 100 : 90,
              child: Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 40),
                          child: TextWidget(
                            text: "My Cart",
                            size: 18,
                            weight: FontWeight.w500,
                            color: white_text_color,
                          )),
                    )
                  ],
                ),
              )),
        ),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              if (!isloadaing) {
                cartDataUpdate();
                return _completer.future;
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      isloadaing
                          ? CartDetailsPageShimmer()
                          : Opacity(
                              opacity: 1,
                              child: listCart == null
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 200,
                                            child: Image.asset(
                                                ImageConstants.empty_cart),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextWidget(
                                              text: 'Your cart is Empty',
                                              size: text_font_medium17_size,
                                              color: flight_text_black_color,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextWidget(
                                              text: "Your don't have any",
                                              size: text_font_medium14_size,
                                              color: hint_text_color,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          Container(
                                            child: TextWidget(
                                              text: "Product in your cart",
                                              size: text_font_medium14_size,
                                              color: hint_text_color,
                                              weight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (cxt) =>
                                                          ShopTabBarPage(
                                                            index: 0,
                                                            tabIndex: 0,
                                                          )));
                                            },
                                            child: Container(
                                              width: 140,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                gradient: gradient_theme_color,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: TextWidget(
                                                  text: "Start Shopping",
                                                  color: white_text_color,
                                                  size: text_font_medium14_size,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                color: grey200_color,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 170,
                                                          left: 10,
                                                          right: 10,
                                                          top: 10),
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                              children:
                                                                  _cartList()),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Column(
                                                            children: [
                                                              itemOutOfStock
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            TextWidget(
                                                                          text:
                                                                              "Some of your item is out of stock",
                                                                          size:
                                                                              text_font_medium_x_size,
                                                                          color:
                                                                              red_color,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                      Opacity(
                        opacity: isTransloadaing ? 1.0 : 0,
                        child: AbsorbPointer(
                            absorbing: isTransloadaing, child: Loader()),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: isloadaing || listCart == null
                            ? Container()
                            : Container(
                                padding: EdgeInsets.all(12),
                                color: white_color,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: qtyLoading
                                                ? () {}
                                                : itemOutOfStock
                                                    ? () {}
                                                    : () {
                                                        if (GemsGLobals
                                                                    .membershipNo ==
                                                                "" ||
                                                            GemsGLobals
                                                                    .membershipNo ==
                                                                null) {
                                                          internetCall(
                                                              context,
                                                              () => Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AddressMap(
                                                                              route: GemsGLobals.membershipNo != null ? "customer" : "",
                                                                              cartDetailsModel: null,
                                                                            )),
                                                                  ));
                                                        } else {
                                                          internetCall(
                                                              context,
                                                              () => Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => ChangeNotifierProvider(
                                                                          create: (context) =>
                                                                              WishListCartCount(),
                                                                          child: ReviewPage(
                                                                              cartDetailsModel: cartDetailsModel,
                                                                              shippingcode: shippingmodelResponse.shipping?[0].code)))));
                                                        }
                                                      },
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  gradient:
                                                      gradient_theme_color),
                                              child: Center(
                                                child: TextWidget(
                                                  text: "Review Order",
                                                  color: white_text_color,
                                                  size: text_font_medium14_size,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              widget.tabBarPageState!
                                                  .tabClick(0);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  color: grey100_color,
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Center(
                                                child: TextWidget(
                                                  text: "Continue Shopping",
                                                  color: black_color,
                                                  size: text_font_medium14_size,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<List<CartDetailsDbModel>> getCartDetailsFromDb() {
    var data = CartDetailsDBHelper().getCartDetailsData();
    return data;
  }

  @override
  void cartDetailResponse(CartDetailsModel cartDetailsModel) {
    this.cartDetailsModel = cartDetailsModel;
    if (openCartListPage == false) {
      makesenseEventCall(cartDetailsModel);
      openCartListPage = true;
    }
    if (widget.apiCallTabPage != null) {
      widget.apiCallTabPage!();
    }

    setState(() {
      isTransloadaing = false;
      if (cartDetailsModel.success == 'true' &&
          cartDetailsModel.updateResponse == true) {
        CartDetailsDBHelper().truncateCartDetailsData();
      }
      itemOutOfStock = false;
      getCartDetailsFromDb().then((value) async {
        if (value.length == 0) {
          var prefs = await SharedPreferences.getInstance();

          prefs.setString('cartapiresponsetime', DateTime.now().toString());
          /* if nodata in db cart details  data into database */
          return CartDetailsDBHelper().save(
              CartDetailsDbModel(null, json.encode(cartDetailsModel.toJson())));
        }
      });
      if (cartDetailsModel.success == "true") {
        isloadaing = false;
        _resetLoader();
        qtyLoading = false;
        setState(() {
          GlobalValue.totalCartCount = cartDetailsModel.totalQty ?? 0;
        });
        widget.tabBarPageState!.setState(() {});
        setState(() {});
        listCart = cartDetailsModel.items;
        for (final item in listCart!) {
          selected[item.quoteitemId ?? ""] = item.qty;
        }
        cont = List.generate(listCart!.length, (index) => ScrollController());
      } else {
        isloadaing = false;
        listCart = null;
        if (cartDetailsModel.message !=
            "You have no items in your shopping cart") {
          Fluttertoast.showToast(
              msg: cartDetailsModel.message.toString(),
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Color(0xAA000000),
              textColor: white_text_color,
              toastLength: Toast.LENGTH_LONG);
        }
      }
    });
  }

  @override
  void productaddWishListResponse(
      List<WishList> addWishlist, String productid, String quoteItemId) {
    // TODO: implement productaddWishListResponse
    if (addWishlist[0].success == "true") {
      if (widget.apiCallTabPage != null) {
        widget.apiCallTabPage!();
      }
      addwishResponse = addWishlist[0];
      var product = listCart!.firstWhere(
        (e) => e.productId == productid,
      );
      if (product != null) {
        product.iswishlist = true;
      }

      var data = {
        "emailid": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
        "product_id": productid,
        "child_id": quoteItemId
      };

      internetCall(context, () {
        CartDetailsPresenter(this).removeProductCart(data);
      });
      internetCall(context, () {
        CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
        ShippingDetailsDBHelper().truncateShippingDetailsData();
      });
      setState(() {});
    } else {
      isTransloadaing = false;
      Fluttertoast.showToast(
          msg: addWishlist[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
    }
    setState(() {});
  }

  @override
  void myWishlistDeleteError(error) {}

  @override
  void productdeatilsResponse(List<ProductDetails> productDetails) {}

  @override
  void applyCouponError(error) {}

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
  void recommendedProductResponse(List<YouMaLikeModel> youmaylike) {}

  @override
  void responseFailure(response) {
    isloadaing = false;
    isTransloadaing = false;
    setState(() {});
  }

  percentageCalculate(price, specialprice) {
    double data = double.tryParse(price)! - double.tryParse(specialprice)!;
    percentageOff = data / double.tryParse(price)! * 100;
    return "save ${percentageOff.ceil()}%";
  }

  void showMenuOfCities() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Colors.transparent,
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: 8.0, right: 8.0, bottom: 16.0),
                          child: SvgPicture.asset(
                            "assets/shop_assets/Group_10163.svg",
                            height: 45,
                            width: 45,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.only(left: 8.0, right: 8.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                        border: new Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        controller: editingController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.only(left: 18.0),
                          suffixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              selectedValue = items[index];
                            });
                            Navigator.pop(context);
                          },
                          title: TextWidget(
                            text: '${items[index]}',
                            size: 16.0,
                            weight: selectedValue == items[index]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          trailing: (selectedValue == items[index])
                              ? Container(
                                  child: SvgPicture.asset(
                                  "assets/shop_assets/select radiobtn.svg",
                                  height: 25,
                                  width: 25,
                                ))
                              : Container(
                                  child: SvgPicture.asset(
                                    "assets/shop_assets/unselect radiobtn.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void onMyProfileViewError(error) {
    // TODO: implement onMyProfileViewError
  }

  @override
  void onMyProfileViewSuccess(MyProfileModel response) {
    // TODO: implement onMyProfileViewSuccess
  }

  @override
  void onProfileTimeout() {
    // TODO: implement onProfileTimeout
  }

  @override
  void addToCartResponse(List addToCartModel, String productId) {
    // TODO: implement addToCartResponse
    if (addToCartModel[0].success == "true") {
      if (productId.isNotEmpty) {
        setState(() {
          qtySelected[productId] = false;
        });
      }
      CartDetailsPresenter(this).shippingmethod();
    } else {}
  }

  @override
  void myWishlistDeleteResponse(List myWishlistDeleteModel, String productId) {
    // TODO: implement myWishlistDeleteResponse
    setState(() {
      if (myWishlistDeleteModel[0]?.success == "true") {
        if (widget.apiCallTabPage != null) {
          widget.apiCallTabPage!();
        }
        CartDetailsPresenter(this).shippingmethod();
        var product = listCart!.firstWhere(
          (e) => e.productId == productId,
        );
        if (product != null) {
          product.iswishlist = false;
        }
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: myWishlistDeleteModel[0].message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
        setState(() {});
      }
    });
  }

  Future<List<ShippingMethodDbModel>> getShippingDetailsFromDb() {
    var data = ShippingDetailsDBHelper().getShippingDetailsData();
    return data;
  }

  @override
  void getshippingmethodresponse(ShippingMethodModel shippingmodel) {
    if ((shippingmodel.success == 'true') &&
        shippingmodel.updateResponse == true) {
      ShippingDetailsDBHelper().truncateShippingDetailsData();
    }

    getShippingDetailsFromDb().then((value) async {
      if (value.length < 1) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('shippingapiresponsetime', DateTime.now().toString());
        /* if nodata in db shipping details  data into database */
        return ShippingDetailsDBHelper().save(
            ShippingMethodDbModel(null, json.encode(shippingmodel.toJson())));
      }
    });

    if (shippingmodel.success == "true") {
      shippingmodelResponse = shippingmodel;
      CartDetailsPresenter(this).cartDetails();
      setState(() {});
    } else {
      isloadaing = false;
      listCart = null;
    }
    setState(() {});
  }

  @override
  void applyCouponResponse(applyCouponModel) {
    setState(() {
      if (applyCouponModel.success == "true") {
        applyCoupon = true;
        Fluttertoast.showToast(
            msg: applyCouponModel.message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: applyCouponModel.message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);

        setState(() {});
      }
    });
  }

  @override
  void deleteCartResponse(List<RemoveProductModel> removeProductModel) {
    if (removeProductModel[0].success == "true") {
      CartDetailsPresenter(this).shippingmethod();
      setState(() {});
    } else {
      isloadaing = false;
      Fluttertoast.showToast(
          msg: removeProductModel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {});
    }
  }

  @override
  void editCartResponse(List<EditProductModel> editProductModel) {
    if (editProductModel[0].success == "true") {
      CartDetailsPresenter(this).shippingmethod();
      setState(() {});
    } else {
      isTransloadaing = false;
      Fluttertoast.showToast(
          msg: editProductModel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {});
    }
  }
}

class CheckboxSelect {
  final int id;
  final String option;
  bool selected = false;

  CheckboxSelect(this.id, this.option);
}
