import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/home_page_db_model.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/shop_home_model.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Presenter/shop_home_presenter.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Database/category_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_db_model.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_list_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/presenter/my_wishlist_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_view.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/add_to_cart_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_search_view.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/bounz_homepage_shimmer.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/splashscreen.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_config.dart';
import '../../category_module/Presenter/category_list_presenter.dart';
import '../../common_widget/back_to_gems.dart';
import '../../constants.dart';

class BonuzHomePage extends StatefulWidget {
  Function? apiCallTabPage;
  final int? tabIndex;
  BonuzHomePage({
    this.apiCallTabPage,
    required this.tabIndex,
    Key? key,
  }) : super(key: key);
  @override
  _BonuzHomePageState createState() => _BonuzHomePageState();
}

class _BonuzHomePageState extends State<BonuzHomePage>
    with SingleTickerProviderStateMixin
    implements CategoryListViewContract, ShopHomeViewContract, MyWishlistView {
  ShopHomeViewPresenter? _presenter;
  ShopHomeModel? _model;

  bool _isLoading = true;
  bool _noData = false;
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _currentPage = 0;
  PageController _pageControlller = PageController(
    initialPage: 0,
  );
  late TabController? _tabController;
  Timer? _timer;
  Completer? _completer = Completer();
  int _tabselectindex = 0;

  @override
  void initState() {
    super.initState();

    _presenter?.getShopHomeData();
    CategoryListPresenter(this).getCategoryListData();
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eShopHomePageName;

    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.tabIndex ?? 0);

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _timer = timer;
      if (_pageControlller.hasClients) {
        _pageControlller.animateToPage(
          _pageControlller.page!.toInt() + 1,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
    GlobalValue.paymentType = "collectbounz";
    _tabController?.addListener(tabListner);
  }


  makesenseCategoryEventCall(categoryType) {
    String keyName = GemsGLobals.eventCategoryPage;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
      'category_type': categoryType,
      'sub_category': "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventEcomHomePage;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void _resetLoader() {
    _completer?.complete();
    _completer = new Completer();
  }

  tabListner() {
    if (_tabController?.index == 0) {
      GlobalValue.paymentType = "collectbounz";
    } else {
      GlobalValue.paymentType = "usebounz";
    }
    setState(() {});
  }

  _BonuzHomePageState() {
    _presenter = ShopHomeViewPresenter(this);
  }
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();

    _pageControlller.dispose();
  }

  Future<List<HomePageDbModel>> getHomePageDataFromDb() {
    var data = HomePageDBHelper().getHomePageData();
    return data;
  }

  @override
  void onShopHomeViewSuccess(ShopHomeModel response) {
    setState(() {
      if (response.success == 'true' && response.updateResponse == true) {
        HomePageDBHelper().truncateHomePageData();
      }
      response.updateResponse = false;
      _isLoading = false;
      _model = response;

      getHomePageDataFromDb().then((value) async {
        /*  Insert home data into database */
        if (value.length == 0) {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('homeapiresponsetime', DateTime.now().toString());
          return HomePageDBHelper()
              .save(HomePageDbModel(null, json.encode(_model?.toJson())));
        }
      });
    });
    setState(() {
      if (response.success == 'true') {
        _model = response;
        _isLoading = false;
        _resetLoader();
        _noData = false;
      } else {
        _isLoading = false;
        _noData = true;
      }
    });
  }

  Future<void> homePageDataUpdate() async {
    await HomePageDBHelper().truncateHomePageData();
    _presenter?.getShopHomeData();
  }

  List<Widget> _recommendedProducts() {
    List<Widget> _products = [];
    for (var i = 0; i < (_model?.bestseller?.items?.length ?? 0); i++) {
      _products.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      create: (context) => WishListCartCount(),
                      child: ProductDetailNew(
                        routeType: "home",
                        modelData: _model?.bestseller?.items?[i].productData,
                        productcode: _model?.bestseller?.items?[i].sku,
                        burnRate: _model?.bestseller?.items?[i].burnrate,
                        minPointsReq:
                            _model?.bestseller?.items?[i].minipointrequired,
                        pointsEarned: _model?.bestseller?.items?[i].pointEarned,
                      ),
                    )),
          ).then((value) {
            if (value != null && value[0] == true) {
              setState(() {
                GlobalValue.totalCartCount =
                    GlobalValue.totalCartCount! + value[2];
              });
            }
            setState(() {});
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
          alignment: Alignment.bottomLeft,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.3,
                decoration: BoxDecoration(color: white_text_color),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: CachedNetworkImage(
                            imageUrl: (_model?.bestseller?.items?[i].imageurl ??
                                '' ??
                                ''),
                            height: 135,
                            width: 140,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                                  ImageConstants.noimages,
                                  fit: BoxFit.contain,
                                ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.cover,
                              );
                            }),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, bottom: 2),
                          child: TextWidget(
                            text: _model?.bestseller?.items?[i].name,
                            color: black_color,
                            weight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            size: text_font_size_x_small,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 1),
                              child: TextWidget(
                                text: _model
                                    ?.bestseller?.items?[i].currencySymbol,
                                color: black_color,
                                weight: FontWeight.w400,
                                size: text_font_size_x_small,
                              ),
                            ),
                            Container(
                              child: TextWidget(
                                text: _model?.bestseller?.items?[i]
                                            .specialPrice ==
                                        "0.00"
                                    ? "${pointsFormatter(double.parse(_model!.bestseller!.items![i].price!))}"
                                    : "${pointsFormatter(double.parse(_model!.bestseller!.items![i].specialPrice!))}",
                                color: Colors.black,
                                weight: FontWeight.w700,
                                size: text_font_medium_size,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _model?.bestseller?.items?[i].specialPrice != '0.00'
                                ? TextWidget(
                                    text: (_model?.bestseller?.items?[i]
                                                .currencySymbol ??
                                            '') +
                                        Constants.priceFormatter(double.parse(
                                            _model!.bestseller!.items![i].price!
                                                .replaceAll("AED ", ""))),
                                    color: black_color,
                                    weight: FontWeight.w400,
                                    size: text_font_size_x_small,
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: 5, bottom: 10, top: 3, left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: 'Earn ',
                              style: TextStyle(
                                  color: theme_color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                  text: GlobalValue.paymentType ==
                                          "collectbounz"
                                      ? _model!.bestseller!.items![i]
                                                  .pointEarned! ==
                                              ""
                                          ? '0'
                                          : Constants.pricePointsFormatter(
                                              int.parse(_model!.bestseller!
                                                  .items![i].pointEarned!))
                                      : Constants.burnPoints(
                                          _model!.bestseller!.items![i]
                                                      .specialPrice! ==
                                                  '0.00'
                                              ? _model!
                                                  .bestseller!.items![i].price!
                                              : _model!.bestseller!.items![i]
                                                  .specialPrice!,
                                          _model!
                                              .bestseller!.items![i].burnrate!,
                                          1),
                                  style: TextStyle(
                                      color: theme_color,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: ' GEMS Points ',
                                  style: TextStyle(
                                      color: theme_color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      (GemsGLobals.referralRelationType ==
                                  GemsGLobals.spouseValue &&
                              GemsGLobals.referralRelationType ==
                                  GemsGLobals.childValue)
                          ? _model!.bestseller!.items![i].burnrate.toString() ==
                                      "" ||
                                  _model!.bestseller!.items![i].burnrate
                                          .toString() ==
                                      "0"
                              ? Container(
                                  height: 0,
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 0.5,
                                        color: grey_color,
                                      ),
                                      TextWidget(
                                        text: ' OR ',
                                        weight: FontWeight.w500,
                                      ),
                                      Container(
                                        width: 50,
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
                          ? _model!.bestseller!.items![i].burnrate.toString() == "" ||
                             _model!.bestseller!.items![i].burnrate                                    .toString() ==                                 "0"
                          ? Container(
                              height: 0,
                           )
                              : Container(
                                  margin: EdgeInsets.only(
                                      right: 3, bottom: 10, top: 3, left: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        text: GemsGLobals.redeem,
                                        style: TextStyle(
                                            color: needGemsColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                "${Constants.pricePointsFormatter(needGemsPointsCal(num.parse(_model!.bestseller!.items![i].specialPrice == '0.00' ? _model!.bestseller!.items![i].price.toString() : _model!.bestseller!.items![i].specialPrice.toString()), double.parse(_model!.bestseller!.items![i].burnrate.toString())))}",
                                            style: TextStyle(
                                                color: needGemsColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: ' GEMS Points ',
                                            style: TextStyle(
                                                color: needGemsColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : Container(
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -6,
                  right: -2,
                  child: InkWell(
                      onTap: () {
                        addRemovefromWishlist(_model!.bestseller!.items![i], i);
                      },
                      child: _model?.bestseller?.items?[i].dbIsWishList == true
                          ? Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.3, color: Colors.grey),
                                color: white_color,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: theme_color,
                                size: 15,
                              ),
                            )
                          : Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: white_color,
                                  border: Border.all(
                                      width: 0.3, color: Colors.grey)),
                              child: Icon(
                                Icons.favorite_border,
                                color: theme_color,
                                size: 15,
                              ),
                            )))
            ],
          ),
        ),
      ));
    }
    return _products;
  }

  addRemovefromWishlist(productIndex, index) {
    if (productIndex.dbIsWishList == false) {
      productIndex.dbIsWishList = true;
      if (GemsGLobals.membershipNo == "" || GemsGLobals.membershipNo == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        ).then((value) {
          _makesenseAddtoWishlistApiCall(productIndex);
          _presenter?.addToWishList(productIndex.id, index);
        });
      } else {
        _makesenseAddtoWishlistApiCall(productIndex);
        _presenter?.addToWishList(productIndex.id, index);
      }
    } else {
      productIndex.dbIsWishList = false;
      if (GemsGLobals.membershipNo == "" || GemsGLobals.membershipNo == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        ).then((value) {
          _makesenseRemoveFromWishlistApiCall(productIndex);
          _presenter?.deleteFromWishList(productIndex.id, index);
        });
      } else {
        _makesenseRemoveFromWishlistApiCall(productIndex);
        _presenter?.deleteFromWishList(productIndex.id, index);
      }
    }
  }

  Widget _recommmendProduct() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.centerLeft,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: _model?.bestseller?.title ?? "",
              color: black_color,
              weight: FontWeight.w700,
              size: text_font_medium18_size,
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _recommendedProducts(),
              ),
            ),
          ]),
    );
  }


  _makesenseAddtoWishlistApiCall(response) {
    String keyName = GemsGLobals.eventEcomAddWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response?.name ?? "",
      "sku": response?.sku ?? "",
      "total_value": response?.price ?? "",
      "stock": response?.stock ?? "",
      "Quantity": GemsGLobals.staffUserTypeValue,
      "category_type":  response?.categoryType ?? "",
      "sub_category": response?.subCategory ?? "",
      "brand_name": response?.additionalAttributes != null
          ? response?.additionalAttributes["Brand"] ?? ""
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }
   
  _makesenseRemoveFromWishlistApiCall(response) {
    String keyName = GemsGLobals.eventEcomRemoveWishlist;
    var segmentReq = {
      "int_source": GemsGLobals.lastVisitPageName,
      "product_name": response?.name ?? "",
      "sku": response?.sku ?? "",
      "total_value": response?.price ?? "",
      "stock": response?.stock ?? "",
      "Quantity": GemsGLobals.staffUserTypeValue,
      "category_type":  response?.categoryType ?? "",
      "sub_category": response?.subCategory ?? "",
      "brand_name": response?.additionalAttributes != null
          ? response?.additionalAttributes["Brand"] ?? ""
          : "",
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  Widget _gridCategories() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _model?.homeCategories?.length ?? 0,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () { 
            makesenseCategoryEventCall(
                _model?.homeCategories?[index].name ?? "");           
            internetCall(
                context,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (context) => WishListCartCount(),
                            child: ProductListView(
                              catId: _model?.homeCategories?[index].id,
                              catName: _model?.homeCategories?[index].name,
                            )))));
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Image.asset(
                        ImageConstants.noimages,
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        ImageConstants.noimages,
                        fit: BoxFit.fill,
                      ),
                      imageUrl: _model!.homeCategories![index].thumbnail!,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextWidget(
                  alignment: TextAlign.center,
                  text: _model?.homeCategories?[index].name ?? "",
                  color: flight_text_black_color,
                  weight: FontWeight.w500,
                  size: text_font_size_small,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
        controller: _pageControlller,
        itemBuilder: (BuildContext context, int index) {
          final _index = index % (_model?.homeBanners?.length ?? 0);
          return InkWell(
            onTap: () {
              _model?.homeBanners?[_index].type == "product"
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => WishListCartCount(),
                                child: ProductDetailNew(
                                  productcode:
                                      _model?.homeBanners?[_index].typeid,
                                  burnRate: _model
                                      ?.bestseller?.items?[index].burnrate,
                                ),
                              )),
                    ).then((value) {
                      if (value != null && value[0] == true) {
                        setState(() {
                          GlobalValue.totalCartCount =
                              GlobalValue.totalCartCount! + value[2];
                        });
                      }
                      setState(() {});
                    })
                  : internetCall(
                      context,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (context) => WishListCartCount(),
                                  child: ProductListView(
                                    catId: _model?.homeBanners?[_index].typeid,
                                    catName: _model?.homeBanners?[_index].name,
                                  ))))).then((value) {
                      setState(() {});
                    });
            },
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              margin: EdgeInsets.fromLTRB(0, 0, 2, 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.fill,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.fill,
                    ),
                    imageUrl: _model?.homeBanners?[_index].image ?? '',
                    fit: BoxFit.fill,
                  )),
            ),
          );
        },
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index % (_model?.homeBanners?.length ?? 0);
            _currentPageNotifier.value =
                index % (_model?.homeBanners?.length ?? 0);
          });
        });
  }

  Widget _buildIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Center(
          child: DotsIndicator(
        dotsCount: (_model?.homeBanners?.length ?? 0),
        position: _currentPage.toDouble(),
        decorator: DotsDecorator(
          color: Colors.grey.shade300,
          activeColor: blue_color,
          size: Size(10.5, 7.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          activeSize: const Size(38.0, 7.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      )),
    );
  }

  Widget _banner() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 190,
      alignment: Alignment.topCenter,
      child: Stack(
        children: <Widget>[
          _buildPageView(),
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget earnburnWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0XFFf4f4f4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: grey_border, width: 0.8)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabselectindex = 0;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _tabselectindex == 0
                      ? button_bgemail_color
                      : Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextWidget(
                    text: "Collect GEMS Points",
                    color: _tabselectindex == 0
                        ? white_text_color
                        : flight_text_black_color,
                    size: text_font_medium14_size,
                    weight: _tabselectindex == 0
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabselectindex = 1;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _tabselectindex == 1
                      ? button_bgemail_color
                      : Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextWidget(
                    text: "Redeem GEMS Points",
                    color: _tabselectindex == 1
                        ? white_color
                        : flight_text_black_color,
                    size: text_font_medium14_size,
                    weight: _tabselectindex == 1
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 110,
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 0),
                  child: Row(
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          ImageConstants.eshop_basket,
                          height: 26,
                          color: white_text_color,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 0),
                        alignment: Alignment.bottomCenter,
                        child: TextWidget(
                          text: " GEMS eShop",
                          color: white_text_color,
                          weight: FontWeight.w500,
                          size: appbar_text_size,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (cxt) => SearchProductList()))
                          .then((value) {
                        var search = value;
                        if (search != null && search != '') {
                          internetCall(
                              context,
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                              create: (context) =>
                                                  WishListCartCount(),
                                              child: ProductListView(
                                                catId: null,
                                                searchValue: search,
                                              )))));
                        }
                      });
                    },
                    child: SvgPicture.asset(
                      ImageConstants.searchicon,
                      height: 23,
                      color: white_color,
                    ),
                  ),
                )
              ],
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
                child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                _model?.homeBanners != null ? _banner() : SizedBox(),
                SizedBox(
                  height: 15,
                ),
                _model?.homeCategories != null ? _gridCategories() : SizedBox(),
                _model?.bestseller != null ? _recommmendProduct() : SizedBox(),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          )
        ],
      ),
    );
  }

  Future<Null> displayPrediction(Itemsss p) async {
    if (p != null && p.title != '') {
      internetCall(
          context,
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => WishListCartCount(),
                      child: ProductListView(
                        catId: null,
                        searchValue: p.title,
                      )))));
    }
  }

  Future<List<Itemsss>?>? fetchPlaces(String query) async {
    final suggestionList = (query.length >= 3)
        ? ApiConfig().autosuggest(query).then((value) {
            final _resp = autoSuggestModelFromJson(value.body.toString());
            if (_resp[0].success == 'true') {
              return _resp[0].items;
            } else {
              return null;
            }
          })
        : null;
    return suggestionList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
         
          body: RefreshIndicator(
              onRefresh: () {
                if (!_isLoading) {
                  homePageDataUpdate();
                  return _completer!.future;
                }
                return Future.value(null);
              },
              child: Stack(
                children: [
                  _isLoading
                      ? SingleChildScrollView(child: BounzHomepageShimmer())
                      : _noData == false
                          ? _body()
                          : Center(
                              child: TextWidget(
                                text: 'No Data found!',
                                color: theme_color,
                              ),
                            ),
                  Positioned(
                      bottom: 150,
                      right: 0,
                      child: Container(child: BackToGems())),
                ],
              ))),
    );
  }

  @override
  void onCategoryListViewError(error) {}

  Future<List<CategoryDbModel>> getCategoryDataFromDb() {
    var data = CategoryPageDBHelper().getCategoryData();
    return data;
  }

  @override
  void onCategoryListViewSuccess(CategoryListModel response) {
    if (response.success == 'true' && response.updateResponse == true) {
      CategoryPageDBHelper().truncateCategoryData();
    }
    getCategoryDataFromDb().then((value) async {
      /*  Insert category data 5into database */
      if (value.length == 0) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('catapiresponsetime', DateTime.now().toString());
        return CategoryPageDBHelper()
            .save(CategoryDbModel(null, json.encode(response.toJson())));
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
                      ShopHomeViewPresenter(this).getShopHomeData())));
  }

  @override
  void onShopHomeViewError(error) {
    _isLoading = false;
    _noData = false;
    setState(() {});
  }

  @override
  void onAddToWishListError(error) {}

  @override
  void onAddToWishListSuccess(var response, index) {
    setState(() {
      if (response.success == 'true') {
        // _model?.bestseller?.items[index].dbIsWishList =
        //     !_model?.bestseller?.items[index].dbIsWishList;
        if (widget.apiCallTabPage != null) {
          widget.apiCallTabPage!();
        }
        // Provider.of<WishListCartCount>(context, listen: false)
        //     .addWishList(index);

        MyWishListDBHelper().truncateWishlistData();
        MyWishlistPresenter(this).loadMyWishlistData();
      }
    });
  }

  @override
  void onDeleteToWishListSuccess(var response, index) {
    setState(() {
      if (response.success == 'true') {
        // _model?.bestseller?.items[index].dbIsWishList =
        //     !_model?.bestseller?.items[index].dbIsWishList;
        if (widget.apiCallTabPage != null) {
          widget.apiCallTabPage!();
        }
        // Provider.of<WishListCartCount>(context, listen: false)
        //     .removeWishList(index);

        MyWishListDBHelper().truncateWishlistData();
        MyWishlistPresenter(this).loadMyWishlistData();
      }
    });
  }

  @override
  void myWishlistError(error) {}

  Future<List<MyWishListDbModel>> getWishListDataFromDb() {
    var data = MyWishListDBHelper().getMyWishListData();
    return data;
  }

  @override
  void myWishlistResponse(MyWishlistModel myWishlistModel) {
    getWishListDataFromDb().then((value) async {
      if (value.length < 1) {
        // if nodata in db Insert wishlist data into database /
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('wishlistapiresponsetime', DateTime.now().toString());

        return MyWishListDBHelper().save(
            MyWishListDbModel(null, json.encode(myWishlistModel.toJson())));
      }
    });
  }
}

class CategoryItem {
  var name;
  var image;

  CategoryItem(this.name, this.image);
}
