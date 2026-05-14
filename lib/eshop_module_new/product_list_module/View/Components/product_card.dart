import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Presenter/product_list_presenter.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/splashscreen.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final totalCount;
  final List<ProductItem> productList;
  final scrollController;
  final ProductListPresenter presenter;
  final listType;
  final ispaginationEnabled;
  final Product productShipping;
  final Product productReturn;
  final String catImage;
  final String catName;
  Function() onrefresh;
  ProductCard(
      {Key? key,
      required this.productList,
      this.scrollController,
      required this.presenter,
      this.listType,
      this.ispaginationEnabled,
      required this.productShipping,
      required this.productReturn,
      this.totalCount,
      required this.catImage,
      required this.onrefresh, 
      required this.catName})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<dynamic> colorConfigGalleryImages = [];
  List<Widget> swatchList = [];
  Completer _completer = Completer();

  _makesenseAddtoWishlistApiCall(ProductItem response) {
     String keyName = GemsGLobals.eventEcomAddWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response.name ?? "",
      "sku": response.sku ?? "",
      "total_value": response.price ?? "",
      "stock": response.stock ?? "",
      "Quantity": GemsGLobals.staffUserTypeValue,
      "category_type":  response.categoryType ?? "",
      "sub_category": response.subCategory ?? "",
      "brand_name": response.additionalAttributes != null
          ? response.additionalAttributes!["Brand"] ?? ""
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  _makesenseRemoveFromWishlistApiCall(ProductItem response) {
     String keyName = GemsGLobals.eventEcomRemoveWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response.name ?? "",
      "sku": response.sku ?? "",
      "total_value": response.price ?? "",
      "stock": response.stock ?? "",
      "Quantity": GemsGLobals.staffUserTypeValue,
      "category_type": response.categoryType ?? "",
      "sub_category": response.subCategory ?? "",
      "brand_name": response.additionalAttributes != null
          ? response.additionalAttributes!["Brand"] ?? ""
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  bool _isrefreshed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 1.30,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: RefreshIndicator(
              onRefresh: () async {
                  Future.delayed(Duration(seconds: 1), () {
           
         
                _isrefreshed = true;
                widget.productList.clear();
                try {
                } catch (e) {
                  
                }
                return widget.onrefresh();
                 });
              },
              child: CustomScrollView(
                  //physics: NeverScrollableScrollPhysics(),
                  controller: widget.scrollController,
                  slivers: <Widget>[
                    widget.catImage != null && widget.catImage.isNotEmpty
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, bottom: 0),
                              child: SizedBox(
                                  height: 140.0,
                                  width: 300.0,
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: widget.catImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : SliverToBoxAdapter(child: SizedBox()),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    widget.listType == 2
                        ? SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widget.listType ?? 2,
                              mainAxisSpacing: 6.0,
                              crossAxisSpacing: 6.0,
                              childAspectRatio: 0.70,
                              // childAspectRatio: widget.listType == 2 ? 0.50 : 0.90,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int productIndex) {
                              var product = widget.productList[productIndex];

                              for (int i = 0;
                                  i < product.swatchGalleryImages!.length;
                                  i++) {
                                swatchList = List<Widget>.generate(
                                    product.swatchGalleryImages!.length,
                                    (int i) => _swatchListWidget(
                                        product.swatchGalleryImages![i],
                                        productIndex,
                                        i)).toList();
                              }

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: white_color,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: grey_color_300)),
                                      padding: EdgeInsets.all(8.0),
                                      margin: EdgeInsets.all(10),
                                      // color:
                                      //     white_text_color, //Color(0xffF4F4F4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _mediaGalleryImage(
                                              productIndex, product.id),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0 / 4),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              child: TextWidget(
                                                text: product.name ?? '',
                                                size: text_font_size_x_small,
                                                weight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0, right: 4.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        '${product.currencySymbol} ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          text_font_size_x_small,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: product
                                                                    .specialPrice ==
                                                                '0.00'
                                                            ? "${Constants.priceFormatter(double.tryParse(product.price!))}"
                                                            : "${Constants.priceFormatter(double.tryParse(product.specialPrice!))}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize:
                                                              text_font_medium_size,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          product.specialPrice != '0.00'
                                              ? Container(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: TextWidget(
                                                    text:
                                                        "${product.currencySymbol}${Constants.priceFormatter(double.tryParse(product.price!))}",
                                                    weight: FontWeight.w400,
                                                    size:
                                                        text_font_size_x_small,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              : SizedBox(),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Earn ',
                                                style: TextStyle(
                                                    color: theme_color,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins",
                                                    fontSize: 10),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: GlobalValue
                                                                .paymentType ==
                                                            "collectbounz"
                                                        ? Constants.pricePointsFormatter(
                                                            int.parse(product
                                                                        .pointEarned ==
                                                                    ""
                                                                ? "0"
                                                                : product
                                                                    .pointEarned))
                                                        : Constants.burnPoints(
                                                            (product.specialPrice ==
                                                                    '0.00'
                                                                ? product.price
                                                                : product
                                                                    .specialPrice)!,
                                                            product.burnrate!,
                                                            1),
                                                    style: TextStyle(
                                                        color: theme_color,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: ' Gems Points',
                                                    style: TextStyle(
                                                      color: theme_color,
                                                      fontSize: 10,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            addRemovefromWishlist(productIndex);
                                          });
                                        },
                                        child: widget.productList[productIndex]
                                                .dbIsWishList!
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
                                ],
                              );
                            }, childCount: widget.productList.length))
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              var product = widget.productList[index];

                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      GemsGLobals.lastVisitPageName = GemsGLobals.productListingPage;
                                     Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (cnt) =>
                                                ChangeNotifierProvider(
                                              create: (context) =>
                                                  WishListCartCount(),
                                              child: ProductDetailNew(
                                                addWishlist: () {
                                                  Provider.of<WishListCartCount>(
                                                          context,
                                                          listen: false)
                                                      .addWishList(index);
                                                },
                                                deleteWishlist: () {
                                                  Provider.of<WishListCartCount>(
                                                          context,
                                                          listen: false)
                                                      .removeWishList(index);
                                                },
                                                productReturn: widget
                                                    .productReturn.content,
                                                productShipping: widget
                                                    .productShipping.content,
                                                routeType: "plp",
                                                modelData: widget
                                                    .productList[index]
                                                    .productData,
                                                productcode: widget
                                                    .productList[index].sku,
                                                burnRate: widget
                                                    .productList[index]
                                                    .burnrate,
                                                minPointsReq: widget
                                                    .productList[index]
                                                    .minipointrequired,
                                                pointsEarned: widget
                                                    .productList[index]
                                                    .pointEarned,
                                              ),
                                            ),
                                          )).then((value) {
                                        if (value != null && value[0] == true) {
                                          Provider.of<WishListCartCount>(
                                                  context,
                                                  listen: false)
                                              .addCartList(value[2]);
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 20, left: 8, right: 8),
                                      padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                      decoration: BoxDecoration(
                                        color: white_text_color,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.3),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            // color: black_color,
                                            child: CachedNetworkImage(
                                              imageUrl: product
                                                      .mediaGalleryImages!
                                                      .isNotEmpty
                                                  ? product
                                                      .mediaGalleryImages![0]
                                                      .url!
                                                  : "",
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                ImageConstants.noimages,
                                                fit: BoxFit.fill,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                ImageConstants.noimages,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.9,
                                                child: TextWidget(
                                                  softwrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: product.name ?? "",
                                                  color: black_color,
                                                  weight: FontWeight.w500,
                                                  size: text_font_size_x_small,
                                                  // maxLines: 2,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  // shrinkWrap: true,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    product.specialPrice !=
                                                            '0.00'
                                                        ? Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child: TextWidget(
                                                              text:
                                                                  "${product.currencySymbol}${Constants.priceFormatter(double.tryParse(product.price!))}",
                                                              weight: FontWeight
                                                                  .w400,
                                                              size:
                                                                  text_font_size_x_small,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0,
                                                              right: 4.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              '${product.currencySymbol} ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                text_font_size_x_small,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: product
                                                                          .specialPrice ==
                                                                      '0.00'
                                                                  ? "${Constants.priceFormatter(double.tryParse(product.price!))}"
                                                                  : "${Constants.priceFormatter(double.tryParse(product.specialPrice!))}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    text_font_medium_size,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 2),
                                                          child: TextWidget(
                                                            text: "Earn ",
                                                            weight:
                                                                FontWeight.w500,
                                                            size: 11,
                                                            color: theme_color,
                                                          ),
                                                        ),
                                                        Container(
                                                          child: TextWidget(
                                                            text: GlobalValue
                                                                        .paymentType ==
                                                                    "collectbounz"
                                                                ? Constants.pricePointsFormatter(int.parse(
                                                                    product.pointEarned ==
                                                                            ""
                                                                        ? "0"
                                                                        : product
                                                                            .pointEarned))
                                                                : Constants.burnPoints(
                                                                    (product.specialPrice ==
                                                                            '0.00'
                                                                        ? product
                                                                            .price
                                                                        : product
                                                                            .specialPrice)!,
                                                                    product
                                                                        .burnrate!,
                                                                    1),
                                                            color: theme_color,
                                                            size: 15,
                                                            weight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 2),
                                                          child: TextWidget(
                                                            text:
                                                                " GEMS Points",
                                                            weight:
                                                                FontWeight.w500,
                                                            size: 11,
                                                            color: theme_color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                 (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                GemsGLobals.referralRelationType !=  GemsGLobals.childValue) ? product.burnrate== "" || product.burnrate== "0"?
                                                    Container(height: 0,):
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 70,
                                                            height: 0.5,
                                                            color: grey_color,
                                                          ),
                                                          TextWidget(
                                                            text: ' OR ',
                                                            weight:
                                                                FontWeight.w500,
                                                          ),
                                                          Container(
                                                            width: 70,
                                                            height: 0.5,
                                                            color: grey_color,
                                                          ),
                                                        ],
                                                      ),
                                                    ):Container(
                              height: 0,
                            ),
                                                 (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                GemsGLobals.referralRelationType !=  GemsGLobals.childValue) ? product.burnrate== "" || product.burnrate== "0"?
                                                    Container(height: 0,):
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: 'Redeem ',
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                              color:
                                                                  needGemsColor,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "${Constants.pricePointsFormatter(needGemsPointsCal(num.parse(product.specialPrice =='0.00'? product.price.toString(): product.specialPrice.toString()), num.parse(product.burnrate!)))}",
                                                              style: TextStyle(
                                                                  color:
                                                                      needGemsColor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ' GEMS Points ',
                                                              style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                  color:
                                                                      needGemsColor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ):Container(
                              height: 0,
                            ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 15,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            addRemovefromWishlist(index);
                                          });
                                        },
                                        child: widget.productList[index]
                                                .dbIsWishList!
                                            ? Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: Colors.grey),
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
                                                    border: Border.all(
                                                        width: 0.3,
                                                        color: Colors.grey)),
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  color: theme_color,
                                                  size: 15,
                                                ),
                                              )),
                                  ),
                                ],
                              );
                            }, childCount: widget.productList.length),
                          ),
                    widget.productList.length != widget.totalCount &&
                            _isrefreshed == false
                        ? SliverToBoxAdapter(
                            child: Container(
                            padding: EdgeInsets.only(bottom: 30),
                            height: 60,
                            child: Loader(),
                          ))
                        :
                         SliverToBoxAdapter(
                            child: widget.productList.isNotEmpty
                                ? Container(
                                    padding: EdgeInsets.only(bottom: 50),
                                    alignment: Alignment.center,
                                    child: TextWidget(
                                        text: '----- No more products ----',
                                        color: theme_color,
                                        weight: FontWeight.bold),
                                  )
                                : Container(
                                    height: 0,
                                  ))
                  ])),
        ));
  }

  _mediaGalleryImage(productIndex, id) {
    return Flexible(
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // height: 200,
            padding: EdgeInsets.only(top: 10),
            child: Stack(alignment: Alignment.topRight, children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (cnt) => ChangeNotifierProvider(
                          create: (context) => WishListCartCount(),
                          child: ProductDetailNew(
                            addWishlist: () {
                              Provider.of<WishListCartCount>(context,
                                      listen: false)
                                  .addWishList(index);
                            },
                            deleteWishlist: () {
                              Provider.of<WishListCartCount>(context,
                                      listen: false)
                                  .removeWishList(index);
                            },
                            productReturn: widget.productReturn.content,
                            productShipping: widget.productShipping.content,
                            routeType: "plp",
                            modelData:
                                widget.productList[productIndex].productData,
                            productcode: widget.productList[productIndex].sku,
                            burnRate: widget.productList[productIndex].burnrate,
                            minPointsReq: widget
                                .productList[productIndex].minipointrequired,
                            pointsEarned:
                                widget.productList[productIndex].pointEarned,
                          ),
                        ),
                      )).then((value) {
                    if (value != null && value[0] == true) {
                      Provider.of<WishListCartCount>(context, listen: false)
                          .addCartList(value[2]);
                    }
                  }

                      //

                      );
                },
                child: CachedNetworkImage(
                  imageUrl: widget.productList[productIndex]
                      .mediaGalleryImages![index].url!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // placeholder: (context, url) => SvgPicture.asset(
                  //     "assets/shop_assets/Group 9551.svg",
                  //     fit: BoxFit.contain,
                  //     color: Colors.grey.withOpacity(0.1)),
                  // errorWidget: (context, url, error) => Icon(Icons.error),
                  placeholder: (context, url) => Image.asset(
                    ImageConstants.noimages,
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    ImageConstants.noimages,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 25,
              //   height: 25,
              //   child: FloatingActionButton(
              //     backgroundColor: Colors.white,
              //     mini: true,
              //     onPressed: () {
              //       setState(() {
              //         addRemovefromWishlist(productIndex);
              //       });
              //     },
              //     child: Positioned(
              //       top: 3.0,
              //       right: 4.0,
              // child: widget.productList[productIndex].iswishlist
              //     ? Icon(
              //         Icons.favorite,
              //         color: theme_color,
              //         size: 15,
              //       )
              //     : Icon(
              //         Icons.favorite_border,
              //         size: 15,
              //       ),
              //     ),
              //   ),
              // ),
            ]),
          );
        },
        itemCount: widget.productList[productIndex].mediaGalleryImages!.length,
        // control: new SwiperControl(
        //     size: 15,
        //     color: Colors.grey[400],
        //     padding: EdgeInsets.all(3),
        //     disableColor: Colors.transparent),
      ),
    );
  }

  bool isSelectedValue = true;
  _swatchListWidget(swatches, productIndex, swatchIndex) {
    if (widget.productList[productIndex].id == swatches.entityId &&
        isSelectedValue == true) {
      swatches.isSelected = true;
    }
    return InkWell(
      onTap: () {
        isSelectedValue = false;
        findGalleryImages(swatches.entityId, productIndex, swatchIndex);
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 10),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: Border.all(
                    color: theme_color,
                    width: swatches.isSelected == true ? 2 : 1),
                shape: BoxShape.circle,
                image:
                    DecorationImage(image: NetworkImage(swatches.swatchurl))),
          ),
        ],
      ),
    );
  }

  findGalleryImages(var entityId, productIndex, swatchIndex) {
    var product = widget.productList[productIndex];
    var color = widget.productList[productIndex].colorConfigGalleryImages;
    var media = widget.productList[productIndex].mediaGalleryImages;
    var swatches = widget.productList[productIndex].swatchGalleryImages;
    media!.clear();
    product.sku = '';
    color!.where((element) => element.productId == entityId).forEach((element) {
      product.sku = element.sku;
      media.add(MediaGalleryImages(url: element.url));
      setState(() {
        swatches!.forEach((element) => element.isSelected = false);
        swatches[swatchIndex].isSelected = true;
      });
    });
  }

  addRemovefromWishlist(productIndex) {
    if (widget.productList[productIndex].dbIsWishList == false) {
      setState(() {
        widget.productList[productIndex].dbIsWishList = true;
        if (GemsGLobals.membershipNo == "" ||
            GemsGLobals.membershipNo == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          ).then((value) {
            _makesenseAddtoWishlistApiCall(widget.productList[productIndex]);
            widget.presenter.addToWishList(
                widget.productList[productIndex].id, productIndex);
          });
        } else {
          _makesenseAddtoWishlistApiCall(widget.productList[productIndex]);
          widget.presenter
              .addToWishList(widget.productList[productIndex].id, productIndex);
        }
      });
    } else {
      setState(() {
        widget.productList[productIndex].dbIsWishList = false;
        if (GemsGLobals.membershipNo == "" ||
            GemsGLobals.membershipNo == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          ).then((value) {
            _makesenseRemoveFromWishlistApiCall(
                widget.productList[productIndex]);
            widget.presenter.deleteFromWishList(
                widget.productList[productIndex].id, productIndex);
          });
        } else {
          _makesenseRemoveFromWishlistApiCall(widget.productList[productIndex]);
          widget.presenter.deleteFromWishList(
              widget.productList[productIndex].id, productIndex);
        }
      });
    }
  }
}
