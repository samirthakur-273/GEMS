import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/tabbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/details_view.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/sellerwise_policy.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/details_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_delete_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/presenter/my_wishlist_delete_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/presenter/my_wishlist_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_delete_view.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_view.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/add_to_cart_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detail_presenter.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detail_view.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_success.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/product_detailPage_shimmer.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailNew extends StatefulWidget {
  final catName;
  final Function? apiCallTabPage;
  final String? burnRate;
  final pointsEarned;
  final String? minPointsReq;
  final String? productcode;
  final String? routeType;
  final ProductDetails? modelData;
  final String? productShipping;
  final String? productReturn;
  final Function()? addWishlist;
  final Function()? deleteWishlist;
  const ProductDetailNew(
      {Key? key,
      this.catName,
      required this.productcode,
      this.routeType,
      this.modelData,
      this.productShipping,
      this.productReturn,
      this.apiCallTabPage,
      this.addWishlist,
      this.deleteWishlist,
      this.burnRate,
      this.pointsEarned,
      this.minPointsReq})
      : super(key: key);
  @override
  _ProductDetailNewState createState() => _ProductDetailNewState();
}

class _ProductDetailNewState extends State<ProductDetailNew>
    implements
        ProductDetailsView,
        MyWishlistDeleteView,
        MyProfileViewContract,
        MyWishlistView,
        DetailsView {
  final _currentPageNotifier = ValueNotifier<int>(0);
  bool _isAddedToCart = false;
  int _currentPage = 0;
  PageController _pageControlller = PageController(
    initialPage: 0,
  );
  MyDetailsPresenter? detailsPresenter;
  MyWishlistDeletePresenter? _deletePresenter;
  var top = 0.0;
  bool isdetails = true;
  bool dettailsreadmore = false;
  bool overviewreadmore = false;
  bool infoandcarereadmore = false;
  bool shippingreadmore = false;
  bool productreturnreadmore = false;
  int qty = 1;
  int values = 0;
  bool isloadaing = false;
  bool productPurchaseLoader = false;
  bool responsefalse = false;
  bool issusscess = false;
  var puchasedSize;
  String? sizerror;
  bool sizeerror = false;
  bool qtyy = false;
  int? sizeindex;
  String sizevalue = "";
  List memoryList = ["128 GB", "256 GB", "512 GB"];
  var _noConnection;
  TextEditingController _emailController = new TextEditingController();
  List productImages = [
    "assets/shop_assets/product_detail/productimage1.jpeg",
    "assets/shop_assets/product_detail/productimage1.jpeg",
    "assets/shop_assets/product_detail/productimage1.jpeg"
  ];
  int sizeselected = 1;
  ProductDetails? response;
  late WishList addwishResponse;
  List<MediaGalleryImages> _selectedcolor = [];
  List<ColorConfigGalleryImages> images = [];
  String swatch = "";
  bool viewmore = false;
  var userIdCode;
  String? value;
  double percentageOff = 0.0;
  String? productId;
  var userEmail;
  var userName;
  bool isLoading = true;
  MyProfileModel? _model;
  int index = 0;
  var configdata;
  bool isEmailEditable = true;
  var new_config_options = [];
  var config_options;
  List colorvalue = [];
  bool _dropdown = false;
  bool tapdropdown = false;
  int sizeindexData = 0;
  int colorindexData = 0;
  List errorkey = [];
  var childId; //[];
  var _overviewLength = 0;
  Map requiredDict = {};

  makesenseAddtocartApiCall(response) {
    String keyName = GemsGLobals.eventEcomAddCart;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      'total_cart_value': response?.item?.price ?? "",
      "product_name": response?.item?.name ?? "",
      "sku": response?.item?.sku ?? "",
      "stock": response?.item?.stock ?? "",
      "Quantity": sizeselected,
      "category_type": response?.item?.categoryType ?? "",
      "sub_category": response?.item?.subCategory ?? "",
      "brand_name": response?.item?.additionalAttributes != null
          ? (response?.item?.additionalAttributes?["Brand"] ?? "")
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseAddtoWishlistApiCall(ProductDetails? response) {
    String keyName = GemsGLobals.eventEcomAddWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response?.item?.name ?? "",
      "sku": response?.item?.sku ?? "",
      "total_value": response?.item?.price ?? "",
      "stock": response?.item?.stock ?? "",
      "Quantity": sizeselected,
      "category_type": response?.item?.categoryType ?? "",
      "sub_category": response?.item?.subCategory ?? "",
      "brand_name": response?.item?.additionalAttributes != null
          ? (response?.item?.additionalAttributes?["Brand"] ?? "")
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseRemoveFromWishlistApiCall(ProductDetails? response) {
    String keyName = GemsGLobals.eventEcomRemoveWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response?.item?.name ?? "",
      "sku": response?.item?.sku ?? "",
      "total_value": response?.item?.price ?? "",
      "stock": response?.item?.stock ?? "",
      "Quantity": sizeselected,
      "category_type": response?.item?.categoryType ?? "",
      "sub_category": response?.item?.subCategory ?? "",
      "brand_name": response?.item?.additionalAttributes != null
          ? (response?.item?.additionalAttributes?["Brand"] ?? "")
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = GemsGLobals.useremail;
    if (widget.routeType == "plp" || widget.routeType == "home") {
      response = widget.modelData!;
      isloadaing = false;
      images = response?.item?.colorConfigGalleryImages ?? [];
      productId = response?.item?.id;
      var dictionary;
      if (response?.item?.configurableProductOptionsNew != null) {
        dictionary = response?.item?.configurableProductOptionsNew;
      } else {
        dictionary = response?.item?.configurableProductOptions;
      }
      makesenseEventProductDetailPageCall();
      if (response?.item?.configurableProductOptions != null) {
        config_options = dictionary["config_options"];
        var key = config_options?.entries.toList()[0].value;
        configdata = dictionary;
        createDict(dictionary);
      }
      images
          .where((element) => element.sku == response?.item?.sku)
          .forEach((element) {
        _selectedcolor.add(MediaGalleryImages(url: element.url));
      });
      swatch = response?.item?.sku ?? "";
      double data = double.tryParse(response!.item!.price!)! -
          double.tryParse(response!.item!.specialPrice!)!;
      percentageOff = data / double.tryParse(response!.item!.price!)! * 100;
      _deletePresenter = MyWishlistDeletePresenter(this);
      MyWishlistPresenter(this).loadMyWishlistData();
      ProductDetailsPresenter(this)
          .recommendedProduct(widget.productcode ?? " ");
    } else {
      value = widget.productcode == "" || widget.productcode == null
          ? "120_0454WY002_2_NAVY_BLUE"
          : widget.productcode;
      _deletePresenter = MyWishlistDeletePresenter(this);
      detailsPresenter = MyDetailsPresenter(this);
      detailsPresenter?.getMyDetailsData();
      isloadaing = true;
      internetCall(
          context, () => ProductDetailsPresenter(this).productdetails(value));
    }
  }

  makesenseEventProductDetailPageCall() {
    String keyName = GemsGLobals.eventProductDetailPage;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
      'product_name': response?.item?.name ?? "",
      'category_type': response?.item?.categoryType ?? "",
      'sub_category': response?.item?.subCategory ?? "",
      'brand_name': response?.item?.additionalAttributes!["Brand"] ?? "",
      'Stock': response?.item?.stock ?? "",
      'sku': response?.item?.sku ?? "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  arrUnique(arr) {
    var cleaned = [];
    var unique = false;

    arr.forEach((itm) => {
          unique = true,
          cleaned.forEach((itm2) => {
                if (itm["option_label"] == itm2["option_label"]) unique = false
              }),
          if (unique) cleaned.add(itm)
        });
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {   

    Widget _detailsAndInfoCare() {
      _overviewLength = response!.item!.customAttributes!.description!.length;
      return Container(
        color: white_text_color,
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      values = 0;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: values == 0
                                      ? blue_color
                                      : Colors.transparent))),
                      width: 80,
                      height: 35,
                      child: TextWidget(
                        text: "Overview",
                        color: values == 0 ? Colors.black : grey600_color,
                        size: text_font_medium16_size,
                        // weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                response?.item?.additionalAttributes == null
                    ? Container()
                    : Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              values = 1;
                            });
                          },
                          child: Container(
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2,
                                        color: values == 1
                                            ? blue_color
                                            : Colors.transparent))),
                            child: TextWidget(
                              text: "Specification",
                              color: values == 1 ? Colors.black : grey600_color,
                              size: text_font_medium16_size,
                              // weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            values == 0
                ? Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: overviewreadmore
                              ? null
                              : (response!.item!.customAttributes!.description!
                                          .length) >
                                      150
                                  ? 84
                                  : null,
                          child: Html(
                              data:
                                  response?.item!.customAttributes!.description,
                              style: {
                                "html": Style.fromTextStyle(TextStyle(
                                    fontSize: text_font_size_small,
                                    color: grey600_color)),
                              }),
                        ),
                        _overviewLength >= 200
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    overviewreadmore = !overviewreadmore;
                                    productreturnreadmore = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(left: 10, top: 0),
                                  child: TextWidget(
                                    text: overviewreadmore
                                        ? "Read less"
                                        : productreturnreadmore
                                            ? "Read less"
                                            : "Read more",
                                    color: theme_color,
                                    size: text_font_size_small,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                : values == 1
                    ? Column(
                        children: [
                          Container(
                            child: Table(
                              textDirection: TextDirection.ltr,
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                for (var i = 0;
                                    i <
                                        (shippingreadmore
                                            ? (response
                                                    ?.item
                                                    ?.additionalAttributes
                                                    ?.entries
                                                    .length ??
                                                0)
                                            : min(
                                                2,
                                                response
                                                        ?.item
                                                        ?.additionalAttributes
                                                        ?.entries
                                                        .length ??
                                                    0));
                                    i++)
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextWidget(
                                        text: response!.item
                                                ?.additionalAttributes?.entries
                                                .toList()[i]
                                                .key ??
                                            "",
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextWidget(
                                        text: response!
                                            .item?.additionalAttributes?.entries
                                            .toList()[i]
                                            .value,
                                        color: Colors.black,
                                        weight: FontWeight.w500,
                                      ),
                                    )
                                  ])
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {

                                if (values == 1) {
                                  shippingreadmore = !shippingreadmore;
                                  dettailsreadmore = false;
                                  setState(() {});
                                }

                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: TextWidget(
                                text: dettailsreadmore
                                    ? "Read less"
                                    : shippingreadmore
                                        ? "Read less"
                                        : "Read more",
                                color: theme_color,
                                size: text_font_size_small,
                                weight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
          ],
        ),
      );
    }

    List<Widget> _swatches() {
      List<Widget> _color = [];
      int length = (response?.item?.swatchGalleryImages?.length ?? 0);

      for (var i = 0;
          i < (response?.item?.swatchGalleryImages?.length ?? 0);
          i++) {
        _color.add(GestureDetector(
          onTap: () {
            swatch = response?.item?.swatchGalleryImages![i].sku ?? "";
            productId = response?.item?.swatchGalleryImages![i].entityId;
            _selectedcolor.clear();
            images
                .where((element) =>
                    element.sku == response?.item?.swatchGalleryImages![i].sku)
                .forEach((element) {
              _selectedcolor.add(MediaGalleryImages(url: element.url));
            });
            setState(() {});
          },
          child: Container(
              margin: EdgeInsets.only(top: 5, right: 10),
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: swatch == response?.item?.swatchGalleryImages![i].sku
                        ? theme_color
                        : Colors.grey.shade300,
                    width: swatch == response?.item?.swatchGalleryImages![i].sku
                        ? 2
                        : 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 50,
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl:
                          response?.item?.swatchGalleryImages![i].swatchurl ??
                              "",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ));
      }
      return _color;
    }

    List<Widget> dynamicarray(listdata, index) {
      List<Widget> _listArrayList = [];
      for (var i = 0; i < listdata.length; i++) {
        _listArrayList.add(GestureDetector(
          onTap: () {
            setState(() {
              tapdropdown = true;
              _dropdown = false;
              sizeindexData = i;
              for (var j = 0; j < listdata.length; j++) {
                new_config_options[index]["isSelected"][j] = "0";
              }
              setState(() {
                new_config_options[index]["isSelected"][i] = "1";
              });
              if (colorvalue[index]["key"] == index) {
                colorvalue[index]["value"] = listdata[i]['option_label'];
                colorvalue[index]["error"] = true;
              }
              for (int i = 0; i < new_config_options.length; i++) {
                if (colorvalue[i]["error"] == "false") {
                  errorkey[i] = "true";
                } else {
                  errorkey[i] = "false";
                }
              }

            });
            Navigator.pop(context);
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade300))),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                        height: 25,
                        width: 25,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: new_config_options[index]["isSelected"]
                                            [i] ==
                                        "1"
                                    ? theme_color
                                    : black_color)),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: new_config_options[index]["isSelected"]
                                          [i] ==
                                      "1"
                                  ? theme_color
                                  : white_text_color),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: listdata[i]['option_label'],
                      color: black_color,
                      size: text_font_medium_x_size,
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ));
      }

      return _listArrayList;
    }

    Widget _structureHorizontal(_info, index, context) {
      var listData = _info["value"];
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8, color: theme_color),
                    borderRadius: BorderRadius.circular(14)),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext bc) {
                          return Container(
                            height: listData.length > 3
                                ? MediaQuery.of(context).size.height * 0.40
                                : MediaQuery.of(context).size.height * 0.20,
                            decoration: new BoxDecoration(
                              color: white_color,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 46,
                                  color: grey_color_300,
                                  child: Center(
                                    child: TextWidget(
                                      text: "Select",
                                      color: black_color,
                                      size: text_font_medium_size,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: dynamicarray(listData, index),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new SizedBox(
                        width: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(),
                        child: TextWidget(
                          // text: colorvalue == null ? "Select" : colorvalue,
                          text: colorvalue[index]["value"] != ""
                              ? colorvalue[index]["value"]
                              : listData[0]['option_label'],
                          color: theme_color,
                        ),
                      ),
                      new SizedBox(
                        width: 0,
                      ),
                      Container(
                          child: Icon(
                        Icons.keyboard_arrow_down,
                        color: theme_color,
                      ))
                    ],
                  ),
                ),
              ),

              // )
            ]),
            new_config_options.length > 0 && errorkey.length > 0
                ? errorkey[index] == "true"
                    ? Row(
                        children: [
                          TextWidget(
                              text: "Please choose an option",
                              color: Colors.red,
                              size: 12),
                        ],
                      )
                    : Container(height: 0)
                : Container(height: 0),
          ],
        ),
      );
    }

    List<Widget> _structureVertical(_info, context) {
      List<Widget> _catList = [];

      for (var i = 0; i < _info.length; i++) {
        _catList.add(Container(
          margin: EdgeInsets.only(left: 22, right: 22, top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width / 4.4,
                  // margin: EdgeInsets.only(left: 22, right: 22),
                  child: TextWidget(
                    text: _info[i]["value"][0]["label"] != null
                        ? _info[i]["value"][0]["label"]
                                    .toString()
                                    .contains('color') ==
                                true
                            ? 'Color'
                            : _info[i]["value"][0]["label"]
                        : "",
                    size: text_font_medium_size,
                    // weight: FontWeight.bold,
                    color: black_color,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 22),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        _structureHorizontal(_info[i], i, context)
                      ],
                    ),
                  ),
                ),
              ]),
        ));
      }

      return _catList;
    }

    Widget _productdata() {
      return Container(
        color: white_text_color,
        padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: TextWidget(
                softwrap: true,
                text: response?.item?.additionalAttributes != null
                    ? response?.item?.additionalAttributes!["Brand"] ?? ""
                    : "",
                size: text_font_size_small,
                color: theme_color,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: TextWidget(
                softwrap: true,
                text: response?.item?.name ?? "",
                size: text_font_medium18_size,
                color: black_color,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            response?.item?.specialPrice == "0.00"
                ? Container()
                : TextWidget(
                    text:
                        "${response?.item?.currencySymbol}${Constants.priceFormatter(double.tryParse(response?.item?.price ?? "0.0"))}",
                    decoration: TextDecoration.lineThrough,
                    size: 12,
                    color: grey600_color,
                    weight: FontWeight.w600,
                  ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      text: "${response?.item?.currencySymbol}",
                      size: text_font_medium16_size,
                      color: black_color,
                    ),
                    TextWidget(
                      text: response?.item?.specialPrice == null ||
                              response?.item?.specialPrice == "0.00"
                          ? "${Constants.priceFormatter(double.tryParse(response?.item?.price ?? "0.0"))}"
                          : "${Constants.priceFormatter(double.tryParse(response?.item?.specialPrice ?? "0.0"))}",
                      size: text_font_medium18_size,
                      color: black_color,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                response?.item?.specialPrice == "0.00"
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: offersubcat_color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextWidget(
                          text: "Save ${percentageOff.ceil()}%",
                          color: white_color,
                          size: text_font_size_xx_small,
                          weight: FontWeight.bold,
                        ),
                      ),
                Spacer(),
                TextWidget(
                  text: "(Inclusive of VAT)",
                  size: text_font_size_x_small,
                  color: grey600_color,
                  weight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerWisePolicyPage(
                              )),
                    );
                  },
                  child: TextWidget(
                    text: "Click here",
                    size: text_font_x_small,
                    color: blue_color,
                    weight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextWidget(
                  softwrap: true,
                  text: " to Check Product Policy",
                  size: text_font_x_small,
                  color: black_color,
                  weight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  text: "Earn Upto",
                  size: text_font_x_small,
                  color: blue_color,
                ),
                SizedBox(
                  width: 5,
                ),
                TextWidget(
                  text: GlobalValue.paymentType == "collectbounz"
                      ? Constants.pricePointsFormatter(int.parse(
                          widget.pointsEarned == "" ||
                                  response?.item?.pointEarned == ""
                              ? "0"
                              : widget.pointsEarned ??
                                  response?.item?.pointEarned))
                      : Constants.burnPoints(
                          (response?.item!.specialPrice == "0.00"
                              ? response?.item!.price
                              : response?.item!.specialPrice)!,
                          (widget.burnRate ?? response?.item!.burnrate)!,
                          1),
                  size: text_font_medium15_size,
                  color: blue_color,
                  weight: FontWeight.bold,
                ),
                TextWidget(
                  softwrap: true,
                  text: " GEMS Points",
                  size: text_font_medium15_size,
                  color: blue_color,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                    GemsGLobals.referralRelationType != GemsGLobals.childValue)
                  ? widget.burnRate.toString() == "" ||
                    widget.burnRate.toString() == "0"
                ? Container(
                    height: 0,
                  )
                : Container(
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 0.5,
                          color: grey_color,
                        ),
                        TextWidget(
                          text: ' OR ',
                          weight: FontWeight.w500,
                        ),
                        Container(
                          width: 80,
                          height: 0.5,
                          color: grey_color,
                        ),
                      ],
                    ),
                  ):Container(
                              height: 0,
                            ),
             (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                    GemsGLobals.referralRelationType != GemsGLobals.childValue)
 ? widget.burnRate.toString() == "" ||
                    widget.burnRate.toString() == "0"
                ? Container(
                    height: 0,
                  )
                : Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        text: "Redeem  ",
                        size: text_font_x_small,
                        color: needGemsColor,
                      ),
                      TextWidget(
                        text:
                            "${Constants.pricePointsFormatter(needGemsPointsCal(double.tryParse(response!.item!.specialPrice.toString() == "0.00" ? response!.item!.price.toString() : response!.item!.specialPrice.toString()), double.parse(widget.burnRate.toString())))}",
                        size: text_font_medium15_size,
                        color: needGemsColor,
                        weight: FontWeight.bold,
                      ),
                      TextWidget(
                        softwrap: true,
                        text: " GEMS Points",
                        size: text_font_medium15_size,
                        color: needGemsColor,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ):Container(
                              height: 0,
                            ),
            SizedBox(
              height: 5,
            ),
            response?.item?.soldby != null || response?.item?.soldby == ""
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        text: "Sold by: ",
                        size: text_font_size_x_small,
                        color: black_color,
                      ),
                      TextWidget(
                        softwrap: true,
                        text: response?.item?.soldby != null
                            ? response?.item?.soldby?.contains('Gems') == true
                                ? response!.item!.soldby!.toUpperCase()
                                : response!.item!.soldby!
                            : "",
                        size: text_font_small,
                        color: black_color,
                        weight: FontWeight.bold,
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      );
    }

    List<Widget> sizeSelection() {
      List<Widget> _diffSizes = [];
      for (var i = 0; i < memoryList.length; i++) {
        _diffSizes.add(GestureDetector(
          onTap: () {
            setState(() {
              sizeindex = i;
              sizevalue = memoryList[i];
              sizeerror = false;
            });
          },
          child: Container(
              margin: EdgeInsets.only(right: 8),
              height: 30,
              width: 70,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          sizeindex == i ? white_color : Colors.grey.shade400,
                      width: 1),
                  gradient: LinearGradient(
                      colors: sizeindex == i
                          ? new_gradient_color
                          : [white_color, white_color]),
                  shape: BoxShape.rectangle),
              child: TextWidget(
                text: memoryList[i],
                color: sizeindex == i ? white_color : black_color,
              )),
        ));
      }
      return _diffSizes;
    }

    Widget _buildPageView() {
      if (_selectedcolor.length == 0)
        _selectedcolor = response?.item?.mediaGalleryImages ?? [];
      return PageView.builder(
          itemCount: _selectedcolor.length,
          controller: _pageControlller,
          itemBuilder: (BuildContext context, int index) {
            final _index = index % _selectedcolor.length;
            return Container(
                margin: EdgeInsets.all(35),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: _selectedcolor[index].url ?? "",
                  placeholder: (context, url) => Image.asset(
                    ImageConstants.noimages,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ));
          },
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
              _currentPageNotifier.value = index;
            });
          });
    }

    Widget _buildIndicator() {
      return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 13.0,
        child: Center(
          child: SmoothPageIndicator(
            controller: _pageControlller,
            count: _selectedcolor.length,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey.shade200,
              spacing: 15.0,
              radius: 4.0,
              dotWidth: 9.0,
              dotHeight: 4.0,
              activeDotColor: blue_color,
            ),
          ),
        ),
      );
    }

    Positioned _favButton() {
      return Positioned(
        top: 8,
        right: 8,
        child: Container(
          height: 30,
          width: 30,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: white_color,
              shape: BoxShape.circle,
              border: Border.all(width: 0.3, color: Colors.grey)),
          child: GestureDetector(
              onTap: () async {
                if (response?.item!.iswishlist == false) {
                  setState(() {
                    if (GemsGLobals.membershipNo == null ||
                        GemsGLobals.membershipNo == '') {
                      DialogAlert.showLoginAlert(context);
                      setState(() {});
                    } else {
                      makesenseAddtoWishlistApiCall(response);

                      setState(() {
                        response?.item!.iswishlist = true;
                        ProductDetailsPresenter(this).addWishList(
                            productId ?? "", GemsGLobals.custEncryptedId, "");
                      });
                    }
                  });
                } else {
                  setState(() {
                    response?.item!.iswishlist = false;
                    var body = {
                      "email": GemsGLobals.useremail,
                      "shopuserid": GemsGLobals.custEncryptedId,
                      "productId": response?.item?.id
                    };
                    makesenseRemoveFromWishlistApiCall(response);
                    internetCall(
                        context,
                        () => _deletePresenter?.deleteMyWishlistData(
                            body, response?.item?.id));
                  });
                }
              },
              child: response?.item?.iswishlist == true
                  ? Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white_color,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: theme_color,
                        size: 15,
                      ),
                    )
                  : Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white_color,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: theme_color,
                        size: 15,
                      ),
                    )),
        ),
      );
    }

    Widget _productImage() {
      return Container(
        decoration: BoxDecoration(
            color: white_color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 0.3, color: Colors.grey)
            ),
        margin: EdgeInsets.fromLTRB(22, 15, 22, 10),
        height: 270,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[_buildPageView(), _buildIndicator(), _favButton()],
        ),
      );
    }

    List<Widget> productTypes() {
      List<Widget> _color = [];
      int length =
          (response?.item?.configurableProductOptions?.configDataList?.length ??
              0);

      for (var i = 0; i < length; i++) {
        _color.add(GestureDetector(
          onTap: () {
            index = i;
            configdata =
                response?.item?.configurableProductOptions?.configDataList?[i];
            setState(() {});
          },
          child: Container(
              margin: EdgeInsets.only(top: 5, right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        index == i ? theme_color : Colors.grey.shade300,
                    width: 2),
              ),
              height: 35,
              width: 35,
              child: TextWidget(
                color: Colors.black,
                text: response?.item?.configurableProductOptions
                        ?.configDataList?[i].optionLabel ??
                    "",
                size: text_font_medium_x_size,
              )),
        ));
      }
      return _color;
    }

    Widget _body() {
      return Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productImage(),
                    _productdata(),
                    new_config_options.length > 0
                        ? Column(
                            children:
                                _structureVertical(new_config_options, context),
                          )
                        : Container(
                            height: 0,
                          ),
                    response?.item?.customAttributes?.description != null &&
                            response!
                                .item!.customAttributes!.description!.isNotEmpty
                        ? response?.item?.type == "virtual"
                            ? Container()
                            : _detailsAndInfoCare()
                        : Container(),
                    response?.item?.edvproduct == true
                        ? Container()
                        : Card(
                            elevation: 0,
                            margin: EdgeInsets.only(left: 22, right: 22),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    response?.item?.type == "virtual"
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: "Quantity",
                                    color: black_color,
                                    size: text_font_medium14_size,
                                    weight: FontWeight.bold,
                                  ),
                                  response?.item?.type == "virtual"
                                      ? Container()
                                      : SizedBox(
                                          width: 10,
                                        ),
                                  Container(child: CounterView(
                                    counterCallback: (int? counterValue) {
                                      sizeselected = counterValue ?? 0;
                                    },
                                  ))
                                ],
                              ),
                            ),
                          ),
                    response?.item?.type == "virtual"
                        ? Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                            decoration: BoxDecoration(
                              color: white_color,
                              border: Border(
                                  top: BorderSide(
                                      color: response?.item?.edvproduct == true
                                          ? Colors.grey.shade300
                                          : Colors.transparent,
                                      width: 1),
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300, width: 1)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        isEmailEditable = !isEmailEditable;
                                        setState(() {});
                                      },
                                      child: isEmailEditable
                                          ? SvgPicture.asset(
                                              ImageConstants.editicon,
                                              height: 10,
                                            )
                                          : SvgPicture.asset(
                                              ImageConstants.editicon,
                                              height: 10,
                                            ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 29,
                                    width: MediaQuery.of(context).size.width,
                                    child: TextFormField(
                                      controller: _emailController,
                                      readOnly: isEmailEditable,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: "example@mail.com",
                                        hintStyle: TextStyle(
                                            color: black_color,
                                            fontSize: text_font_medium16_size,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      autofocus: false,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          color: black_color,
                                          fontSize: text_font_medium16_size,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (text) {},
                                    )),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                  alignment: Alignment.center,
                  child: (GemsGLobals.membershipNo == null ||
                          GemsGLobals.membershipNo == '')
                      ? Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 22),
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5.0)
                                ],
                                borderRadius: BorderRadius.circular(8)),
                            child: MaterialButton(
                              child: TextWidget(
                                text: "Add to Cart",
                                color: white_color,
                                weight: FontWeight.bold,
                                size: text_font_medium16_size,
                              ),
                              onPressed: () {
                                makesenseRemoveFromWishlistApiCall(response);
                                DialogAlert.showLoginAlert(context);
                              },
                            ),
                          ),
                        )
                      : Material(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 22),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5.0)
                                ],
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(8)),
                            child: MaterialButton(
                              child: TextWidget(
                                text: "Add to Cart",
                                size: text_font_medium16_size,
                                color: white_color,
                                weight: FontWeight.bold,
                              ),
                              onPressed:    
                                  () {
                                          setState(() {
                                            for (var i = 0;
                                                i < new_config_options.length;
                                                i++) {
                                              var key = new_config_options[i]
                                                      ["key"]
                                                  .toString();
                                              var value = "";
                                              for (var j = 0;
                                                  j <
                                                      new_config_options[i]
                                                              ["isSelected"]
                                                          .length;
                                                  j++) {
                                                if (new_config_options[i]
                                                        ["isSelected"][j] ==
                                                    "1") {
                                                  value = new_config_options[i]
                                                              ["value"][j]
                                                          ["option_value"]
                                                      .toString();
                                                  childId =
                                                      new_config_options[i]
                                                                  ["value"][j]
                                                              ["child_id"]
                                                          .toString();
                                                }
                                                var dict = {'$key': value};
                                                requiredDict.addAll(dict);
                                              }
                                            }
                                           
                                          });
                                          var body = {
                                            "emailid": GemsGLobals.useremail,
                                            "shopuserid":
                                                GemsGLobals.custEncryptedId,
                                            "firstname":
                                                GemsGLobals.userFirstName,
                                            "lastname":
                                                GemsGLobals.userLastName,
                                            "password": "",
                                            "gift_email":
                                                response?.item?.type ==
                                                        "virtual"
                                                    ? _emailController.text
                                                    : "",
                                            "sku": widget.productcode,
                                            "qty": sizeselected.toString(),
                                            "product_id": response?.item?.id,
                                            "child_id": response?.item?.type ==
                                                        "simple" ||
                                                    response?.item?.type ==
                                                        "virtual"
                                                ? ""
                                                : childId ?? "",
                                            "options": response?.item?.type ==
                                                        "simple" ||
                                                    response?.item?.type ==
                                                        "virtual"
                                                ? {}
                                                : requiredDict
                                          };
                                          makesenseAddtocartApiCall(response);
                                          GemsGLobals.lastVisitPageName = GemsGLobals.eventProductDetailPage;
                                          productPurchaseLoader = true;
                                          setState(() {
                                            internetCall(context, () {                                   
                                              
                                              ProductDetailsPresenter(this)
                                                  .addToCart(body, "");
                                            });
                                          });
                                          //}
                                        },
                            ),
                          ),
                        )),
            )
          ],
        ),
      );
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: "",
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        backgroundColor: Colors.white,
        body: isloadaing
            ? SingleChildScrollView(child: ProductDetailPageShimmer())
            : Stack(
                children: [
                  Opacity(
                    opacity: 1,
                    child: Column(
                      children: [
                        _body(),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: productPurchaseLoader ? 0.8 : 0,
                    child: productPurchaseLoader
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
        bottomNavigationBar:
            isloadaing ? SizedBox() :  Container(child: TabbarWidget(0)),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                    "assets/shop_assets/product_detail/6.svg",
                                    height: 70,
                                    color: Colors.green,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              TextWidget(
                                text: "Product added to cart",
                                color: black_color,
                                weight: FontWeight.bold,
                                size: text_font_medium_size,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            var returnData = [
                              _isAddedToCart,
                              productId,
                              sizeselected
                            ];
                            Navigator.pop(context);
                            Navigator.pop(context, returnData);
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5.0)
                                ],
                                gradient: LinearGradient(
                                    colors: new_gradient_color,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.only(right: 15, left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget(
                              text: "continue_shoppping_normal",
                              color: white_color,
                              size: text_font_medium_size,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopTabBarPage(
                                        index: 2,
                                      )),
                            );
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: black_color, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.only(right: 15, left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget(
                              text: "View Cart",
                              color: black_color,
                              size: text_font_small,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]))
            ],
          );
        });
  }

  void createDict(dict) {
    setState(() {
      new_config_options.clear();

      config_options = dict["config_options"];
      errorkey.clear();
      for (var i = 0; i < (config_options?.length ?? 0); i++) {
        errorkey.add("false");
      }
      for (var i = 0; i < (config_options?.length ?? 0); i++) {
        colorvalue.add({"key": i, "value": "", "error": errorkey[i]});
        var key = config_options?.entries.toList()[i].value;

        var isSelct = [];

        var optionsList = dict["$key"];

        var newOptionsList = [];
        var newOptionsListTrunkate = [];

        for (var j = 0; j < (optionsList?.length ?? 0); j++) {
          var vv = optionsList[j];
          Map map = vv;
          newOptionsList.add(map);
        }

        newOptionsListTrunkate = arrUnique(newOptionsList);
        for (var a = 0; a < newOptionsListTrunkate.length; a++) {
          if (a == 0) {
            isSelct.add("1");
          } else {
            isSelct.add("0");
          }
        }

        var data = {
          "key": key,
          "value": newOptionsListTrunkate,
          "isSelected": isSelct
        };
        new_config_options.add(data);
      }
    });
  }

  @override
  void responseFailure(response) {
    isloadaing = false;
    productPurchaseLoader = false;
    responsefalse = true;
    setState(() {});

    }

  @override
  void productaddWishListResponse(
      List<WishList> addWishlist, String productId, String quoteItemId) {
    if (addWishlist[0].success == "true") {
      setState(() {
        addwishResponse = addWishlist[0];
        if (response?.item?.id == productId) {
          response?.item!.iswishlist = true;
          if (widget.addWishlist != null) widget.addWishlist!();
          MyWishListDBHelper().truncateWishlistData();
          MyWishlistPresenter(this).loadMyWishlistData();
        }
      });
    } else {}
    setState(() {});
  }

  static var dbHelperProfile = MyProfileDBHelper();
  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbHelperProfile.getMyProfileData();
    return data;
  }

  @override
  void addToCartResponse(
      List<AddToCartModel> addToCartModel, String productId) {
    setState(() {
      isloadaing = false;
      productPurchaseLoader = false;
    });

    if (addToCartModel[0].success == "true") {
      _isAddedToCart = true;
      CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
      ShippingDetailsDBHelper().truncateShippingDetailsData();

      issusscess = true;
      puchasedSize = sizeselected;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ProductSuccess(
                    isAddedToCart: _isAddedToCart,
                    productId: productId,
                    sizeselected: sizeselected,
                  )));
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: addToCartModel[0].message ?? "",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
      setState(() {
        isloadaing = false;
        productPurchaseLoader = false;
      });
    }
  }

  @override
  void myWishlistDeleteError(error) {}

  @override
  void myWishlistDeleteResponse(
      List<MyWishlistDeleteModel> myWishlistDeleteModel, String productId) {
    setState(() {
      if (myWishlistDeleteModel[0].success == "true") {
        setState(() {
          response?.item!.iswishlist = false;
          if (widget.deleteWishlist != null) widget.deleteWishlist!();
          MyWishListDBHelper().truncateWishlistData();
          MyWishlistPresenter(this).loadMyWishlistData();
        });
      } else {
        Fluttertoast.showToast(
            msg: myWishlistDeleteModel[0].message ?? "",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            gravity: ToastGravity.CENTER);
      }
    });
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      ProductDetailsPresenter(this).productdetails(value))));
  }

  @override
  void recommendedProductResponse(List<YouMaLikeModel> youmaylike) {
    if (youmaylike[0].success == "true") {
      response?.item?.recommendedProducts =
          youmaylike[0].item?.recommendedProductss ?? [];
      setState(() {});
    } else {
      response?.item?.recommendedProducts = [];
      setState(() {});
    }
  }

  userLoginCheck() async {
    var prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString("Useremail");
    userName = prefs.getString("Username");
  }

  @override
  void onMyProfileViewError(error) {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void onMyProfileViewSuccess(MyProfileModel response) {
    if (response.success == 'true') {
      _model = response;
      isLoading = false;
      if (response.orderList != null) {
        getProfileDataFromDb().then((value) async {
          if (value.length < 1) {
            var prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'profileapiresponsetime', DateTime.now().toString());
            // if no data Insert profile data into database //
            return await dbHelperProfile
                .save(MyProfileDataModel(null, json.encode(_model!.toJson())));
          }
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: response.message.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void onProfileTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyProfilePresenter(this).getMyProfileData())));
  }

  @override
  void myWishlistError(error) {}

  @override
  void myWishlistResponse(MyWishlistModel myWishlistModel) {
    for (var i = 0; i < (myWishlistModel.viewWishlist?.length ?? 0); i++) {
      if (response?.item?.sku == myWishlistModel.viewWishlist![i].sku) {
        setState(() {
          response?.item?.iswishlist = true;
        });
        break;
      } else {
        setState(() {
          response?.item?.iswishlist = false;
        });
      }
    }
    setState(() {});
  }

  @override
  void productdeatilsResponse(List<ProductDetails> productDetails) {

    if (productDetails[0].success == "true") {
      response = productDetails[0];
      isloadaing = false;
      images = response?.item?.colorConfigGalleryImages ?? [];
      productId = response?.item?.id;
      makesenseEventProductDetailPageCall();
      MyWishlistPresenter(this).loadMyWishlistData();
      if (response?.item?.configurableProductOptions != null) {
        var dictionary = response?.item?.configurableProductOptions;
        config_options = dictionary["config_options"];
        configdata = response?.item?.configurableProductOptions;
        createDict(response?.item?.configurableProductOptions);
      }
      images
          .where((element) => element.sku == response?.item?.sku)
          .forEach((element) {
        _selectedcolor.add(MediaGalleryImages(url: element.url));
      });
      if (_selectedcolor.length == 0) {
        _selectedcolor = response?.item?.mediaGalleryImages ?? [];
      }
      swatch = response?.item?.sku ?? "";
      double data = double.tryParse(response!.item!.price!)! -
          double.tryParse(response!.item!.specialPrice!)!;
      percentageOff = data / double.tryParse(response!.item!.price!)! * 100;
      setState(() {});
    } else {
      isloadaing = false;
      responsefalse = true;
      setState(() {});
    }
  }

  @override
  void onDetailsViewError(error) {
  }

  @override
  void onDetailsViewSuccess(DetailsModel response) {
    setState(() {
      
    });
  }
}

class SizeList extends StatefulWidget {
  final int? values;
  final int? selectedvalue;
  final Function(dynamic)? onchanged;
  SizeList({
    Key? key,
    this.values,
    this.selectedvalue,
    this.onchanged,
  }) : super(key: key);
  @override
  _SizeListState createState() => _SizeListState();
}

int value = 1;

class _SizeListState extends State<SizeList> {
  @override
  void initState() {
    super.initState();
    value = widget.selectedvalue!;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sizelist() {
      List<Widget> products = [];
      for (var i = 1; i <= 5; i++) {
        products.add(GestureDetector(
          onTap: () {
            value = i;
            widget.onchanged!(value);
            setState(() {});
          },
          child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: value == i ? theme_color : Colors.grey.shade300)),
              margin: EdgeInsets.only(right: 10, top: 0),
              child: TextWidget(
                text: i.toString(),
                color: grey200_color,
                size: text_font_medium_x_size,
              )),
        ));
      }
      return products;
    }

    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 5),
                  alignment: Alignment.center,
                  child: TextWidget(
                    text: "Quantity",
                    color: black_color,
                    size: text_font_medium_x_size,
                    weight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: black_color,
                    ),
                    onPressed: () {
                      if (value != null) {
                        widget.onchanged!(value);
                      } else {
                        widget.onchanged!(null);
                      }
                    }),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sizelist(),
            ),
          )
        ],
      ),
    );
  }
}

class CounterView extends StatefulWidget {
  final int? initNumber;
  final Function(int)? counterCallback;
  final Function? increaseCallback;
  final Function? decreaseCallback;
  final int? minNumber;
  CounterView(
      {this.initNumber,
      this.counterCallback,
      this.increaseCallback,
      this.decreaseCallback,
      this.minNumber});
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int? _currentCount;
  Function? _counterCallback;
  Function? _increaseCallback;
  late Function _decreaseCallback;
  int? _minNumber;

  @override
  void initState() {
    _currentCount = widget.initNumber ?? 1;
    _counterCallback = widget.counterCallback ?? (int number) {};
    _increaseCallback = widget.increaseCallback ?? () {};
    _decreaseCallback = widget.decreaseCallback ?? () {};
    _minNumber = widget.minNumber ?? 1;
    super.initState();
  }

  int _maxLimit = 7;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createIncrementDicrementButton(Icons.remove, 'decrement'),
          TextWidget(
            text: _currentCount.toString(),
            size: text_font_medium_x_size,
          ),
          _createIncrementDicrementButton(Icons.add, 'increment'),
        ],
      ),
    );
  }

  _increment() {
    setState(() {
      if (_currentCount != _maxLimit) {
        _currentCount = _currentCount! + 1;
        _counterCallback!(_currentCount);
        _increaseCallback!();
      }
    });
  }

  _dicrement() {
    setState(() {

      if (_currentCount! >= _minNumber! && _currentCount != _minNumber) {
        _currentCount = _currentCount! - 1;

        _counterCallback!(_currentCount);
        _decreaseCallback();
      }
    });
  }

  Widget _createIncrementDicrementButton(IconData icon, String onPressed) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 50.0, minHeight: 32.0),
      onPressed: () async {
        if (onPressed == 'increment') {
          _increment();
        } else if (onPressed == 'decrement') {
          _dicrement();
        }
        // return await onPressed;
      },
      elevation: 0,
      fillColor: ((onPressed == 'increment') && _currentCount == _maxLimit) ||
              ((onPressed == 'decrement') && _currentCount == 1)
          ? grey_color_300
          : black_color,
      child: Icon(
        icon,
        color: white_color,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }
}
