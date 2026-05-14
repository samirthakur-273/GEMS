import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/tabbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/loading_plp.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_db_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Database/product_filter_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_db_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Presenter/product_list_presenter.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/Components/product_card.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/Components/product_list_filter.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/Components/product_sort.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_search_view.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:provider/provider.dart';

import '../../common_widget/back_to_gems.dart';

class ProductListView extends StatefulWidget {
  var catId;
  var catName;
  var searchValue;
  var categorypage;
  var brandId;
  var brandName;
  ProductListView(
      {Key? key,
      required this.catId,
      this.catName,
      this.searchValue,
      this.categorypage,
      this.brandId,
      this.brandName})
      : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    implements ProductListViewContract {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  ProductListPresenter? _presenter;
  ProductListModel? _model;
  final searchController = TextEditingController();
  List<ProductItem> productList = [];
  List<Widget> catList = [];
  List productIdList = [];
  bool isCategorySelected = true;
  bool _isLoading = true;
  bool _isSearch = false;
  bool _isFilterApplied = false;
  bool _isSortingApplied = false;
  bool _isCategoryApplied = false;
  bool ispaginationEnabled = true;
  bool _isCategoryHide = false;
  bool _istriggerFetchMoreData = true;
  Completer _completer = Completer();
  int? sortvalue;
  var _pageNo = 1;
  int listType = 1;
  int _currentMax = 10;
  var _limit = "10";
  var _nodata = false;
  var catId;
  var sortValue;
  var filterValues;
  List<CatChild> catChild = <CatChild>[];
  var selectedSortValue;
  var filterAndSortValues;
  Map? filterdata;
  bool? pageInit;
  List<Widget> selectedFilterAndSort = [];
  var request = {
    "brandcode": Constants.brandCode,
    "country_code": Constants.countryCode,
    "lang_code": Constants.langCode,
    "email": GemsGLobals.useremail,
    "shopuserid": GemsGLobals.custEncryptedId ?? "",
    "limit": "20",
    "pageno": "1"
  };
  Future<List<MyWishListDbModel>> getWishListDataFromDb() {
    var data = MyWishListDBHelper().getMyWishListData();
    return data;
  }

  @override
  void initState() {
    pageInit = true;
    super.initState();
    if (widget.searchValue == null) {
      if (widget.catId == null) {
        widget.catId = "52";
      }
      catId = widget.catId;
      _presenter = ProductListPresenter(this);
      _presenter?.getProductListData(catId, request);

      _scrollController.addListener(() {
        var triggerFetchMoreData =
            0.5 * _scrollController.position.maxScrollExtent;
        if (_scrollController.position.pixels < triggerFetchMoreData &&
            ispaginationEnabled == true &&
            _istriggerFetchMoreData == true &&
            productList.length < (_model!.totalCount!)) {
          if (productList.length != _model!.totalCount) {
            _getMoreData(catId);
            _istriggerFetchMoreData = false;
          } else {
            ispaginationEnabled = false;
          }
        }
      });
    } else {
      _isLoading = true;
      searchController.text = widget.searchValue;
      if (widget.catId == null) {
        widget.catId = "32";
      }
      catId = widget.catId;
      _presenter = ProductListPresenter(this);
      _presenter?.getProductSearchData(request, widget.searchValue);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {}
      });
    }
  }

  Widget _newappbar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.topLeft,
          height: 100,
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 10),
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
          ),
        ),
      ],
    );
  }

  void categoryFilter(productCat, index) {
    if (productCat[index].name == 'All ' + _model!.catName.toString()) {
      _presenter?.getProductListData(widget.catId, request);
    } else {
      var filterRequest = {
        "brandcode": Constants.brandCode,
        "country_code": Constants.countryCode,
        "lang_code": Constants.langCode,
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId ?? "",
        "limit": "20",
        "pageno": _pageNo
      };
      catId = productCat[index].id;
      _presenter?.getProductListData(productCat[index].id, filterRequest);
    }
    _isCategoryApplied = true;
    productCat.forEach((element) {
      element.status = false;
    });
    productCat[index].status = true;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getMoreData(catId, {bool refresh = false}) {
    if (refresh) {
      _pageNo = 1;
    } else {
      _pageNo = _pageNo + 1;
    }
    var request = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId ?? "",
      "limit": (_currentMax + 10).toString(),
      "pageno": _pageNo
    };
    if (searchController.text != '') {
      _presenter?.getProductSearchData(request, searchController.text);
    } else if (_isSortingApplied == true && _isFilterApplied == false) {
      _presenter?.sortProductList(
          (_currentMax + 10).toString(), _pageNo, catId, sortValue);
    } else if (_isFilterApplied == true && _isSortingApplied == false) {
      _pageNo = (_currentMax + 10);
      _limit = filterValues["limit"];
      _pageNo = filterValues["pageno"];
      _presenter?.sendFilterData(filterValues, catId);
    } else {
      _presenter?.getProductListData(catId, request);
    }

    setState(() {});
  }

  @override
  void onProductListViewSuccess(ProductListModel response) {
    setState(() {
      if (response.success == 'true') {
        _model = response;
        if (pageInit == true) {
          pageInit = false;
          catChild.add(new CatChild(
              id: widget.catId,
              name:
                  _model!.catName != null ? "${"All " + _model!.catName!}" : "",
              status: true));

          catChild.addAll(_model!.catChild!);
        }

        _istriggerFetchMoreData = true;
        ispaginationEnabled = true;

        if (_isCategoryApplied == true) {
          productList.clear();
          _isCategoryApplied = false;
        }
        productList.addAll(response.items!);
        response.items!.forEach((k) {
          productIdList.add(k.id);
        });
        _isLoading = false;
        _completer.complete();
        _completer = new Completer();
        _nodata = false;

        if (GemsGLobals.isEShopSubcategory) {
          _isCategoryHide = true;
          var value = {
            "sort": null,
            "filterDisplay": {
              "brand": [widget.brandName]
            },
            "filterValuesId": {
              "brand": [widget.brandId]
            },
            "filter": {
              "brandcode": "1",
              "country_code": "main_website_store",
              "lang_code": "1",
              "category_id": catId,
              "filter": {
                "brand": [widget.brandId]
              },
              "listType": "2",
              "limit": 30,
              "pageno": 1
            }
          };
          updateFilterFromListPage(value);
          GemsGLobals.isEShopSubcategory = false;
        }
      } else {
        _isLoading = false;
        _nodata = true;
      }
    });
  }

  @override
  void onProductSearchViewSuccess(ProductListModel response) {
    setState(() {
      if (response.success == 'true') {
        _model = response;
        if (_isSearch == false) {
          productList.clear();
        }
        productList.addAll(response.items!);
        _isSearch = true;
        _nodata = false;
        _isLoading = false;
      } else {
        _isLoading = false;
        _nodata = true;
      }
    });
  }

  @override
  void onProductListViewError(error) {
    setState(() {
      _isLoading = false;
      _nodata = true;
      _isCategoryHide = false;
      _isCategoryApplied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == false && _nodata == false && catChild != null) {
      for (int i = 0; i < (catChild.length); i++) {
        catList = List<Widget>.generate(
            catChild.length, (int i) => _categories(catChild, i)).toList();
      }
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
          primary: true,
          appBar: PreferredSize(
              preferredSize: Platform.isIOS
                  ? Size.fromHeight(80)
                  : Size.fromHeight(80),
              child: _newappbar()),
          body: Stack(
            children: [
              _body(),
              Positioned(
                  bottom: 150,
                  right: 0,
                  child: Container(child: BackToGems())),
            ],
          ),
          bottomNavigationBar: _isLoading
              ? SizedBox()
              : TabbarWidget(1),
        ));
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: widget.catName ?? "",
                color: blue_color,
                size: text_size_18,
                weight: FontWeight.bold,
              ),
              if (_nodata == false || widget.categorypage != "yes")
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductListFilter(
                                        onListTypeChanged: (value) {
                                          listType = value;
                                          setState(() {});
                                        },
                                        catId: catId,
                                        presenter: _presenter,
                                        selectedSortValue: selectedSortValue,
                                      ))).then((value) {
                            selectedFilterAndSort.clear();
                            if (value == 2) {
                              selectedSortValue = "";
                              filterAndSortValues = null;
                              _presenter?.changeListType(value);
                              _presenter?.getProductListData(catId, request);
                              _isLoading = true;
                              setState(() {});
                            } else if (value != null) {
                              _isCategoryHide = true;
                              updateFilterFromListPage(value);
                            } else {}
                          });
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: black_color),
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          shape: BoxShape.circle,
                        ),
                        margin: Platform.isIOS
                            ? EdgeInsets.only(top: 5)
                            : EdgeInsets.only(top: 0),
                        padding: EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          ImageConstants.sortandfilter,
                          color: black_color,
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: selectedFilterAndSort.isNotEmpty ? 10 : 0,
        ),
        selectedFilterAndSort.isNotEmpty
            ? Container(
                height: 35,
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      filterAndSortValues != null &&
                              filterAndSortValues['sort'] != null &&
                              filterAndSortValues['sort'] != ""
                          ? Container(
                              height: 40,
                              margin:
                                  EdgeInsets.only(left: 5, top: 5, right: 0),
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: theme_color, width: 1)),
                              child: TextWidget(
                                text: filterAndSortValues['sort'],
                                color: theme_color,
                                size: text_font_small,
                                weight: FontWeight.w600,
                              ),
                            )
                          : SizedBox(),
                      if (selectedFilterAndSort.isNotEmpty)
                        ...selectedFilterAndSort
                    ],
                  ),
                ),
              )
            : Container(),
        _isCategoryHide == false && widget.searchValue == null
            ? Container(
                padding: EdgeInsets.only(left: 10),
                child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: catList,
                    )),
              )
            : SizedBox(
                height: 5,
              ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0),
            children: _isCategoryApplied == false && _isLoading == false
                ? <Widget>[
                    _nodata
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(ImageConstants.noResultFound),
                                SizedBox(
                                  height: 15,
                                ),
                                TextWidget(
                                  text: "Sorry! No product found",
                                  // size: 20,
                                  size: 20,
                                  weight: FontWeight.bold,
                                  alignment: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextWidget(
                                  text:
                                      "We're sorry what you were looking for.\n Please try another way",
                                  size: 16,
                                  alignment: TextAlign.center,
                                  color: black_color,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          bluishgradient,
                                          blue_color,
                                        ],
                                      )),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  child: TextButton(
                                    child: TextWidget(
                                      text: "Try Again",
                                      color: white_text_color,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      Internetconnectivity()
                                          .isConnected()
                                          .then((result) {
                                        if (result) {
                                          Navigator.pop(context, "1");
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          )
                        : ProductCard(
                            onrefresh: () {
                              _getMoreData(catId, refresh: true);
                              return _completer.future;
                            },
                            totalCount: _model!.totalCount,
                            productReturn:
                                _model!.productReturnStoreCredit ?? Product(),
                            productShipping:
                                _model!.productShippingInformation ?? Product(),
                            productList: productList,
                            scrollController: _scrollController,
                            presenter: _presenter!,
                            listType: listType,
                            catImage: _model!.catImage ?? "",
                            catName:widget.catName ??"",
                            ispaginationEnabled: ispaginationEnabled),
                  ]
                : <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: LoadingPLPPage()),
                  ],
          ),
        ),
      ],
    );
  }

  Widget _categories(productCat, index) {
    return InkWell(
      onTap: () {
        setState(() {
          _pageNo = 1;
          categoryFilter(productCat, index);
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: productCat[index].status == true
                  ? Colors.transparent
                  : grey_gunsmoke_text_color,
              width: 1),
          color: productCat[index].status == true ? blue_color : white_color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          productCat[index].name.toString(),
          style: TextStyle(
            fontSize: text_font_size_x_small,
            height: 1,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            color: productCat[index].status == true
                ? white_color
                : grey_gunsmoke_text_color,
          ),
        ),
      ),
    );
  }

  bool equalsIgnoreCase(String a, String b) =>
      (a == null && b == null) ||
      (a != null && b != null && a.toLowerCase() == b.toLowerCase());
  updateFilterFromListPage(value) {
    if (value['filterDisplay'].length <= 0) {
      _isCategoryHide = false;
    }
    filterAndSortValues = value;
    filterdata = filterAndSortValues['filterDisplay'];
    filterdata!.entries.forEach((element) {
      selectedFilterAndSort.add(Container(
        height: 50,
        child: Stack(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 5, top: 5, right: 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme_color, width: 1)),
              child: TextWidget(
                text: element.key,
                color: theme_color,
                size: text_font_small,
                weight: FontWeight.w600,
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  value['filterDisplay']
                      .removeWhere((key, value) => key == element.key);
                  value["filter"]["filter"].removeWhere((key, value) {
                    return equalsIgnoreCase(key, element.key);
                  });
                  filterdata!.removeWhere((key, value) => key == element.key);

                  selectedFilterAndSort.clear();
                  updateFilterFromListPage(value);
                  this.setState(() {});
                },
                child: Container(
                  child: SvgPicture.asset(
                    ImageConstants.cross,
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ));

      for (String data in element.value)
        selectedFilterAndSort.add(Container(
          height: 50,
          child: Stack(children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 5, top: 5),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme_color, width: 1)),
              child: TextWidget(
                text: data,
                color: theme_color,
                size: text_font_small,
                weight: FontWeight.w600,
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  var index;
                  for (int i = 0;
                      i < value['filterDisplay'][element.key].length;
                      i++) {
                    if (value['filterDisplay'][element.key][i] == data) {
                      index == i;

                      value['filterDisplay'][element.key].removeAt(i);

                      value["filter"]["filter"][element.key.toLowerCase()]
                          .removeAt(i);
                    }
                  }
                  selectedFilterAndSort.clear();
                  updateFilterFromListPage(value);
                  this.setState(() {});
                },
                child: Container(
                  child: SvgPicture.asset(
                    ImageConstants.cross,
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            )
          ]),
        ));
    });
    selectedSortValue = value['sort'] != "" ? value['sort'] : "";
    sendDataforFilter(value['filter']);
    _pageNo = 1;
    filterValues = value['filter'];

    productList.clear();
  }

  Future<List<ProductFilterDataModel>> getFilterDataFromDb() {
    var data = ProductFilterDBHelper().getFilterData();
    return data;
  }

  var filterValuesRequest = {};

  sendDataforFilter(value) {
    filterValuesRequest = value;
    if (value != null && value is Map) {
      setState(() {
        _isLoading = true;
        _isFilterApplied = true;
        _isSortingApplied = false;

        if (selectedSortValue != null) {
          sortValue = value['filter']['sortfilter'];
          selectedSortValue = sortValue;
        }

        if (value['filter'].length == 1 &&
            value['filter'].containsKey('sortfilter')) {
          _isSortingApplied = true;
          _isFilterApplied = false;

          _presenter?.sortProductList("20", "1", catId, selectedSortValue);
        } else {
          _presenter?.sendFilterData(value, catId);
        }
      });
    } else {
      setState(() {
        _isLoading = true;
        _nodata = false;
        getFilterDataFromDb().then((data) async {
          if (data.length > 0) {
            /* if listype changes */
            if (value !=
                ProductFilterModel.fromJson(json.decode(data.last.filterdata))
                    .listType) {
              ProductFilterDBHelper().truncatefilterData();
            }
          }
          _presenter?.changeListType(value);
          _presenter?.getProductListData(catId, request);
        });
      });
    }
  }

  @override
  void onAddToWishListError(error) {}

  @override
  void onAddToWishListSuccess(var response, index) {
    setState(() {
      if (response.success == 'true') {
        productList[index].dbIsWishList = productList[index].dbIsWishList;
        Provider.of<WishListCartCount>(context, listen: false)
            .addWishList(index);
        MyWishListDBHelper().truncateWishlistData();
      }
    });
  }

  @override
  void onDeleteToWishListSuccess(var response, index) {
    setState(() {
      if (response.success == 'true') {
        setState(() {
          productList[index].dbIsWishList = productList[index].dbIsWishList;
          Provider.of<WishListCartCount>(context, listen: false)
              .removeWishList(index);
          MyWishListDBHelper().truncateWishlistData();
        });
      }
    });
  }

  @override
  void onFilterDataViewError(error) {}

  @override
  void onFilterDataViewSuccess(ProductFilterModel response) {}

  @override
  void onListViewChangeSuccess(listType) {
    setState(() {
      this.listType = listType;
      _isLoading = false;
    });
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => ProductListPresenter(this)
                      .getProductListData(catId, request))));
  }
}
