import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/cart_details_page.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/loading_list.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_db_model.dart';
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
import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/splashscreen.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:gems_revamp/eshop_module_new/sign_in_up/SignInUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/back_to_gems.dart';

class MyWishlist extends StatefulWidget {
  Function? apiCallTabPage;
  ShopTabBarPageState? tabBarPageState;

  MyWishlist({this.apiCallTabPage, this.tabBarPageState});

  @override
  _MyWishlistState createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist>
    implements
        MyWishlistView,
        MyWishlistDeleteView,
        ProductDetailsView,
        MyProfileViewContract {
  List<MyWishlistModel>? myWishlistModel;
  MyWishlistModel? myWishlistModelData;
  List<ViewWishlist>? data;
  MyProfileModel? _model;
  late MyWishlistPresenter _presenter;
  late MyWishlistDeletePresenter _deletePresenter;
  bool isLoading = true;
  CongifData? sizeselected;
  Completer _completer = Completer();
  bool showSizeData = false;
  String message = "";
  var userEmail;
  var userName;
  List<ScrollController> cont = [];
  bool delete = false;
  bool qty = false;
  List<CongifData> sizeList = [];
  String productId = "";
  String configOptionSelected = "";
  int listType = 1;
  String lastPage = "";
  @override
  void initState() {
    _presenter = MyWishlistPresenter(this);
    _deletePresenter = MyWishlistDeletePresenter(this);
    lastPage = GemsGLobals.lastVisitPageName;
    GemsGLobals.lastVisitPageName = GemsGLobals.eventEcomWishlistPage;
    apiCall();
    widget.apiCallTabPage!();
    super.initState();
  }

  void _resetLoader() {
    _completer.complete();
    _completer = new Completer();
  }

  Future<void> myWishlishtUpdate() async {
    await MyWishListDBHelper().truncateWishlistData();
    internetCall(context, () => _presenter.loadMyWishlistData());
  }

  makesenseWishlistApiCall() {    
    String keyName = GemsGLobals.eventEcomWishlistPage;
    var segmentReq = {
      "int_source": lastPage,
        "total_value":  myWishlistModelData?.totalValue ?? "",
        "Quantity": myWishlistModelData?.totalCount ?? 0,
 
        'items': [
          
        for (final item in (data ?? []))
          {
            'product_name': item?.productName,
            'category_type': item.categoryType,
            'sub_category': item.subCategory,
            'brand_name': item.brandName,
           
            'stock': item.stock == 'In stock'
                ? GemsGLobals.productInStock
                : GemsGLobals.productOutOfStock,
            'sku': item.sku.toString(),
          }
      ]
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventEcomWishlistPage;
  }

  makesenseRemoveFromWishlistApiCall(ViewWishlist viewWishlist) {
    String keyName = GemsGLobals.eventEcomRemoveWishlist;
    var segmentReq = {
      "int_source": lastPage,
      "product_name": viewWishlist.productName ?? "",
      "Quantity": viewWishlist.qty ?? "",
      "sku": viewWishlist.sku ?? "",
      "total_value": viewWishlist.price ?? "",
      "stock": viewWishlist.stock ?? "",
      "category_type": viewWishlist.categoryType ?? "",
      "sub_category": viewWishlist.subCategory ?? "",
      "brand_name": viewWishlist.brandName ?? "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventEcomWishlistPage;
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

  void dataUpdate() {
    isLoading = true;
    userLoginCheck();
    dbHelperProfile.truncateMyProfileData();
    MyProfilePresenter(this).getMyProfileData();

    widget.apiCallTabPage!();
    CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
    ShippingDetailsDBHelper().truncateShippingDetailsData();
    MyWishListDBHelper().truncateWishlistData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _wishList() {
      return Container(
        margin: EdgeInsets.only(top: 10, right: 15, left: 15),
        child: listType == 1
            ? ListView.builder(
                itemCount: data?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                    create: (context) => WishListCartCount(),
                                    child: ProductDetailNew(
                                      productcode: data?[index]
                                          .sku, //sku data from api//
                                      burnRate: data![index].burnrate! ?? "",
                                    ),
                                  )));
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: EdgeInsets.only(bottom: 15, left: 0, right: 0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                  imageUrl: data?[index].productImage ?? '',
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      )),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: TextWidget(
                                      softwrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      text: data?[index].productName ?? "",
                                      color: black_color,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextWidget(
                                              text: "AED",
                                              weight: FontWeight.w500,
                                              size: 14,
                                              color: blackish,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TextWidget(
                                                text: data![index]
                                                            .specialPrice ==
                                                        "AED 0.00"
                                                    ? data![index]
                                                        .price
                                                        .toString()
                                                        .replaceAll("AED", '')
                                                    : data![index]
                                                        .specialPrice
                                                        .toString()
                                                        .replaceAll("AED", ''),
                                                weight: FontWeight.w500,
                                                size: text_size_16,
                                                color: blackish,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(bottom: 2),
                                        child: TextWidget(
                                          softwrap: true,
                                          text: "Earn upto",
                                          weight: FontWeight.w400,
                                          color: theme_color,
                                          size: 10,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 2,
                                        ),
                                        child: TextWidget(
                                          softwrap: true,
                                          text: GlobalValue.paymentType ==
                                                  "collectbounz"
                                              ? Constants.pricePointsFormatter(
                                                  int.tryParse(data?[index]
                                                              .pointEarned !=
                                                          ''
                                                      ? (data?[index]
                                                              .pointEarned ??
                                                          '0')
                                                      : '0'))
                                              : Constants.burnPoints(
                                                  (data?[index].specialPrice ==
                                                          "0.00"
                                                      ? data![index].price
                                                      : data![index]
                                                          .specialPrice)!,
                                                  data![index].burnrate!,
                                                  data![index].qty),
                                          color: theme_color,
                                          weight: FontWeight.w600,
                                          size: 11,
                                        ),
                                      ),
                                      TextWidget(
                                        // softwrap: true,
                                        text: " GEMS Points",
                                        weight: FontWeight.w400,
                                        color: theme_color,
                                        size: 11,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              // padding: EdgeInsets.only(right: 20),
                              child: Column(children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          var body = {
                                            "productId": data?[index].productid,
                                            "email": GemsGLobals.useremail,
                                            "shopuserid":
                                                GemsGLobals.custEncryptedId,
                                          };
                                          setState(() {
                                            isLoading = true;
                                            makesenseRemoveFromWishlistApiCall(
                                                data![index]);
                                            internetCall(context, () {
                                              _deletePresenter
                                                  .deleteMyWishlistData(body,
                                                      data?[index].productid);
                                              data?.removeAt(index);
                                              setState(() {});
                                              MyWishListDBHelper()
                                                  .truncateWishlistData();
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 0.3, color: Colors.grey),
                                            color: white_color,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: theme_color,
                                            size: 15,
                                          ),
                                        )                                        
                                        ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        var body = {
                                          "productId": data?[index].productid,
                                          "email": GemsGLobals.useremail,
                                          "shopuserid":
                                              GemsGLobals.custEncryptedId,
                                        };
                                        setState(() {
                                          isLoading = true;
                                          makesenseRemoveFromWishlistApiCall(
                                              data![index]);
                                          internetCall(context, () {
                                            _deletePresenter
                                                .deleteMyWishlistData(body,
                                                    data![index].productid);
                                            data!.removeAt(index);
                                            setState(() {});
                                            MyWishListDBHelper()
                                                .truncateWishlistData();
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        // margin:
                                        //     EdgeInsets.only(right: 8.0, top: 8.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 0.3, color: Colors.grey),
                                          color: white_color,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SvgPicture.asset(
                                            ImageConstants.delete,
                                            color: blue_color,
                                            height: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                                  create: (context) =>
                                                      WishListCartCount(),
                                                  child: ProductDetailNew(
                                                      productcode: data?[index]
                                                          .sku, //sku data from api//
                                                      burnRate: data![index]
                                                              .burnrate! ??
                                                          ""),
                                                )));
                                  },
                                  child: AbsorbPointer(
                                      child: Container(
                                    // height: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFf4f4f4),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            width: 0.8,
                                            color:
                                                black_color.withOpacity(0.2))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, bottom: 6, right: 5, left: 5),
                                      child: Center(
                                        child: TextWidget(
                                          text: 'View Details',
                                          size: 11.7,
                                          // color: _resetData ? grey_background : text_color,
                                          color: grey_background,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )),
                                )
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : GridView.builder(
                itemCount: data!.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => WishListCartCount(),
                                      child: ProductDetailNew(
                                        productcode: data![index]
                                            .sku, //sku data from api//
                                        burnRate: data![index].burnrate! ?? "",
                                      ),
                                    )));
                      },
                      child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(clipBehavior: Clip.none, children: <
                                Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CachedNetworkImage(
                                      imageUrl: data?[index].productImage ?? '',
                                      height: 130,
                                      width: 170,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            ImageConstants.noimages,
                                            fit: BoxFit.fill,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            ImageConstants.noimages,
                                            fit: BoxFit.fill,
                                          )),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: TextWidget(
                                        softwrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        text: data?[index].productName ?? "",
                                        color: black_color,
                                        size: text_font_small,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),
                                  Container(
                                    child: Row(
                                      // mainAxisAlignment:
                                      // MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextWidget(
                                              text: "AED",
                                              weight: FontWeight.w500,
                                              size: 14,
                                              color: blackish,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TextWidget(
                                                text: data![index]
                                                            .specialPrice ==
                                                        "AED 0.00"
                                                    ? data![index]
                                                        .price
                                                        .toString()
                                                        .replaceAll("AED", '')
                                                    : data![index]
                                                        .specialPrice
                                                        .toString()
                                                        .replaceAll("AED", ''),
                                                weight: FontWeight.w500,
                                                size: text_size_16,
                                                color: blackish,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: TextWidget(
                                          softwrap: true,
                                          text: "Earn upto",
                                          weight: FontWeight.bold,
                                          color: blue_color,
                                          size: text_size_9,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 1,
                                        ),
                                        child: TextWidget(
                                          softwrap: true,
                                          text: GlobalValue.paymentType ==
                                                  "collectbounz"
                                              ? Constants.pricePointsFormatter(
                                                  int.tryParse(data?[index]
                                                              .pointEarned !=
                                                          ''
                                                      ? (data?[index]
                                                              .pointEarned ??
                                                          '0')
                                                      : '0'))
                                              : Constants.burnPoints(
                                                  (data?[index].specialPrice ==
                                                          "0.00"
                                                      ? data![index].price
                                                      : data![index]
                                                          .specialPrice)!,
                                                  data![index].burnrate!,
                                                  data![index].qty),
                                          color: theme_color,
                                          weight: FontWeight.w600,
                                          size: text_size_9,
                                        ),
                                      ),
                                      TextWidget(
                                        // softwrap: true,
                                        text: " GEMS Points",
                                        weight: FontWeight.bold,
                                        color: theme_color,
                                        size: text_size_9,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // sizeselected = value;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChangeNotifierProvider(
                                                          create: (context) =>
                                                              WishListCartCount(),
                                                          child:
                                                              ProductDetailNew(
                                                            productcode: data?[
                                                                    index]
                                                                .sku, //sku data from api//
                                                            burnRate: data![
                                                                        index]
                                                                    .burnrate! ??
                                                                "",
                                                          ),
                                                        )));
                                          },
                                          child: AbsorbPointer(
                                            child: Container(
                                              // height: 50,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFf4f4f4),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      width: 0.8,
                                                      color: black_color
                                                          .withOpacity(0.2))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0,
                                                    right: 6,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Center(
                                                  child: TextWidget(
                                                    text: 'View Details',
                                                    size:
                                                        text_font_size_x_small,
                                                    // color: _resetData ? grey_background : text_color,
                                                    color: grey_background,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          child: GestureDetector(
                                            onTap: () {
                                              var body = {
                                                "productId":
                                                    data![index].productid,
                                                "email": GemsGLobals.useremail,
                                                "shopuserid":
                                                    GemsGLobals.custEncryptedId,
                                              };
                                              setState(() {
                                                isLoading = true;
                                                makesenseRemoveFromWishlistApiCall(
                                                    data![index]);
                                                internetCall(context, () {
                                                  _deletePresenter
                                                      .deleteMyWishlistData(
                                                          body,
                                                          data![index]
                                                              .productid);
                                                  data!.removeAt(index);
                                                  setState(() {});
                                                  MyWishListDBHelper()
                                                      .truncateWishlistData();
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: white_text_color,
                                                    border: Border.all(
                                                        width: 0.3,
                                                        color: Colors.grey)
                                                    ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    ImageConstants.delete,
                                                    color: blue_color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                right: -7,
                                top: 4,
                                child: InkWell(
                                    onTap: () {
                                      var body = {
                                        "productId": data![index].productid,
                                        "email": GemsGLobals.useremail,
                                        "shopuserid":
                                            GemsGLobals.custEncryptedId,
                                      };
                                      setState(() {
                                        isLoading = true;
                                        makesenseRemoveFromWishlistApiCall(
                                            data![index]);
                                        internetCall(context, () {
                                          _deletePresenter.deleteMyWishlistData(
                                              body, data![index].productid);
                                          data!.removeAt(index);
                                          setState(() {});
                                          MyWishListDBHelper()
                                              .truncateWishlistData();
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      margin:
                                          EdgeInsets.only(right: 3.0, top: 3.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 0.3, color: Colors.grey),
                                        color: white_color,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color: theme_color,
                                        size: 15,
                                      ),
                                    )),
                              ),
                            ]),
                          )));
                }),
      );
    }

    Widget _body() {
      return Column(
        children: [
          GemsGLobals.membershipNo == "" || GemsGLobals.membershipNo == null
              ? Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/shop_assets/product_detail/wishlist.svg",
                        height: 65,
                        width: 65,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          TextWidget(
                            textAlign: TextAlign.center,
                            text: "If you have saved any item in wishlist,",
                            size: text_font_medium_size,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          TextWidget(
                            textAlign: TextAlign.center,
                            text: "you will see them here after you login",
                            size: text_font_medium_size,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: new_gradient_color,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          child: TextWidget(
                            text: "signin",
                            color: white_color,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: data == null || data!.isEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          color: white_text_color,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  child: Image.asset(
                                      ImageConstants.empty_Wishlist),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: TextWidget(
                                    text: "Your wishlist is empty",
                                    color: Colors.black,
                                    size: text_size_18,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text:
                                      "Save items that you like in your wishlist",
                                  color: Colors.black,
                                  size: text_font_medium_x_size,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (cxt) => ShopTabBarPage(
                                                  index: 0,
                                                  tabIndex: 0,
                                                )));
                                  },
                                  child: Container(
                                    width: 140,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      gradient: gradient_theme_color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: TextWidget(
                                        text: "SHOP NOW",
                                        color: white_text_color,
                                        size: text_font_medium_x_size,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ]),
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      listType = 1;

                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: listType == 1
                                                  ? new_gradient_color
                                                  : [
                                                      Colors.white,
                                                      Colors.white
                                                    ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: listType == 1 ? 1 : 0,
                                              color: listType == 1
                                                  ? Colors.transparent
                                                  : black_color)),
                                      child: Icon(
                                        Icons.list_sharp,
                                        color: listType == 1
                                            ? white_color
                                            : Color(0XFF81817F),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      listType = 2;

                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: listType == 2
                                                  ? new_gradient_color
                                                  : [
                                                      Colors.white,
                                                      Colors.white
                                                    ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: listType == 2 ? 1 : 0,
                                              color: listType == 2
                                                  ? Colors.transparent
                                                  : black_color)),
                                      child: Icon(
                                        Icons.grid_view_sharp,
                                        size: 20,
                                        color: listType == 2
                                            ? white_color
                                            : Color(0XFF81817F),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _wishList()),
                          ],
                        ),
                )
        ],
      );
    }

    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          bottomNavigationBar: showSizeData
              ?  Container(
                  height: 100,
                  decoration: BoxDecoration(color: white_color, boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 4.0)
                  ]),
                  child: SizeList(
                    values: 1,
                    onchanged: (value) {
                      if (value == null) {
                        showSizeData = false;
                        setState(() {});
                      } else {
                        sizeselected = value;
                        var body = {
                          "brandcode": Constants.brandCode,
                          "country_code": Constants.countryCode,
                          "lang_code": Constants.langCode,
                          "customerid": Constants.customerId, 
                          "action": "add",
                          "qty": "1",
                          "product_id": productId,
                          "child_id": sizeselected?.childId,
                          "options": {
                            configOptionSelected: sizeselected?.optionValue
                          }
                        };
              
                        showSizeData = false;
                        internetCall(context, () {
                          isLoading = true;
                          new ProductDetailsPresenter(this)
                              .addToCart(body, productId);
                          setState(() {});
                        });
                      }
                    },
                  ),
                )
              : Container(
                  height: 0,
                ),
          backgroundColor: Color(0XFFF3F3F2),
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
                              text: "My Wishlist",
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
            onRefresh: () async {
              if (!isLoading) {
                myWishlishtUpdate();
                return _completer.future;
              }
            },
            child: isLoading
                ? Container(
                    // height: MediaQuery.of(context).size.height / 1.2,
                    child: LoadingListPage())
                : Stack(
                    children: [
                      _body(),
                      Positioned(
                          bottom: 150,
                          right: 0,
                          child: Container(child: BackToGems())),
                    ],
                  ),
          ),
        ));
  }

  @override
  void myWishlistError(error) {
    setState(() {
      isLoading = false;
    });
  }

  Future<List<MyWishListDbModel>> getWishListDataFromDb() {
    var data = MyWishListDBHelper().getMyWishListData();
    return data;
  }

  static var dbHelperProfile = MyProfileDBHelper();
  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbHelperProfile.getMyProfileData();
    return data;
  }

  @override
  void myWishlistResponse(MyWishlistModel myWishlistModel) {
    setState(() {      
      MyWishListDBHelper().truncateWishlistData();
      if (myWishlistModel.success == 'true' &&
          myWishlistModel.updateResponse == true) {
        MyWishListDBHelper().truncateWishlistData();
      }
      getWishListDataFromDb().then((value) async {
        if (value.length < 1) {
          // if nodata in db Insert wishlist data into database /
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('wishlistapiresponsetime', DateTime.now().toString());

          return MyWishListDBHelper().save(
              MyWishListDbModel(null, json.encode(myWishlistModel.toJson())));
        }
      });
      if (myWishlistModel.success == "true") {
        if (!delete) widget.apiCallTabPage!();

        data = myWishlistModel.viewWishlist;
        myWishlistModelData=myWishlistModel;
        makesenseWishlistApiCall();

        cont = List.generate(data!.length, (index) => ScrollController());
        isLoading = false;
        _resetLoader();
      } else {
        data = null;
        if (!delete) widget.apiCallTabPage!();
        message = myWishlistModel.message ?? "";

        isLoading = false;
      }
    });
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
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
                                text: "productaddline",
                                color: black_color,
                                weight: FontWeight.bold,
                                size: text_font_medium_x_size,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: black_color, width: 1)),
                            margin: EdgeInsets.only(right: 15, left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget(
                              text: "continue_shoppping_normal",
                              color: black_color,
                              size: text_font_medium_x_size,
                              weight: FontWeight.bold,
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
                                  builder: (context) => CartDetailsPage()),
                            );
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: theme_color,
                            ),
                            margin: EdgeInsets.only(right: 15, left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: TextWidget(
                              text: "gotocart",
                              color: white_color,
                              size: text_font_medium_x_size,
                              weight: FontWeight.bold,
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

  void apiCall() {
    _presenter.loadMyWishlistData();
  }

  @override
  void myWishlistDeleteError(error) {}

  @override
  void myWishlistDeleteResponse(
      List<MyWishlistDeleteModel> myWishlistDeleteModel, String productId) {
    widget.apiCallTabPage!();
    delete = true;

    if (myWishlistDeleteModel[0].success == "true") {
      setState(() {
        isLoading = false;
      });

      internetCall(context, () => apiCall());
    } else {
      isLoading = false;
      Fluttertoast.showToast(
          msg: myWishlistDeleteModel[0].message ?? "",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {});
    }
  }

  @override
  void addToCartResponse(
      List<AddToCartModel> addToCartModel, String productId) {
    setState(() {});

    if (addToCartModel[0].success == "true") {
      var body = {
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
        "productId": productId
      };
      Fluttertoast.showToast(
          msg: addToCartModel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {
        sizeselected = null;
        productId = "";
        sizeList = [];
        configOptionSelected = "";
        CartDetailsDBHelper().truncateCartDetailsData();
        ShippingDetailsDBHelper().truncateShippingDetailsData();
        isLoading = false;
        internetCall(context, () {
          _deletePresenter.deleteMyWishlistData(body, productId);
          MyWishListDBHelper().truncateWishlistData();
        });
      });
    } else {
      isLoading = false;
      Fluttertoast.showToast(
          msg: addToCartModel[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
      setState(() {});
    }
  }

  @override
  void productaddWishListResponse(
      List<WishList> addWishlist, String productid, String quoteItemId) {
    // TODO: implement productaddWishListResponse
  }

  @override
  void productdeatilsResponse(List<ProductDetails> productDetails) {
    // TODO: implement productdeatilsResponse
  }

  @override
  void responseFailure(response) {
    // TODO: implement responseFailure
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => internetCall(context, () => apiCall()))));
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
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
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
  void recommendedProductResponse(List<YouMaLikeModel> youmaylike) {
    // TODO: implement recommendedProductResponse
  }
}
