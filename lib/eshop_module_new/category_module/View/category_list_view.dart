import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/placeholder.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Database/category_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_db_model.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_list_model.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Presenter/category_list_presenter.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/custom_expansion_tile.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/loading_category.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_search_view.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_config.dart';
import '../../common_widget/back_to_gems.dart';
import '../../tab_bar_page.dart';

class CategoryListView extends StatefulWidget {
  final int? index;
  final Function? apiCallTabPage;
  final ShopTabBarPageState? tabBarPageState;

  CategoryListView(this.apiCallTabPage,
      {Key? key, this.index, this.tabBarPageState})
      : super(key: key);

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin
    implements CategoryListViewContract {
  CategoryListPresenter? _presenter;
  CategoryListModel? _model;
  TabController? tabController;
  int _selectedIndex = 0;
  int selectedTabIndex = 0;
  bool _isLoading = true;
  bool _ontapCat = false;
  int selectedIndex = 0;
  int typeOfView = 1;
  var gridSelectedcatValue;
  var gridL4value;
  int value = 0;
  int? childValue;
  List checkvalue = [];
  List checkvaluechild = [];
  var lastPage = "";
  
  @override
  void initState() {
    super.initState();   
    lastPage = GemsGLobals.lastVisitPageName; 
    widget.apiCallTabPage!();
    tabController = TabController(
        length: 3, vsync: this, initialIndex: GlobalValue.tabValue);
    selectedTabIndex = GlobalValue.tabValue;
    tabController!.addListener(listener);
    _presenter!.getCategoryListData();
  }

  makesenseEventCall(categoryType,subCategory) {
    String keyName = GemsGLobals.eventCategoryPage;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
      'category_type': categoryType,
      'sub_category': subCategory,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  static var dbHelper = CategoryPageDBHelper();
  Future<List<CategoryDbModel>> getCategoryDataFromDb() {
    var data = dbHelper.getCategoryData();
    return data;
  }

  listener() {
    if (tabController!.indexIsChanging) {
      setState(() {
        switch (tabController!.index) {
          case 0:
            selectedTabIndex = tabController!.index;
            _selectedIndex = 0;
            break;
          case 1:
            selectedTabIndex = tabController!.index;
            _selectedIndex = 0;
            break;
          case 2:
            selectedTabIndex = tabController!.index;
            _selectedIndex = 0;
            break;
        }
      });
    }
  }

  @override
  void onCategoryListViewSuccess(CategoryListModel response) {
    if (this.mounted) {
      setState(() {
        if (response.success == 'true') {              
          if (response.success == 'true' && response.updateResponse == true) {
            CategoryPageDBHelper().truncateCategoryData();
          }
          _model = response;
          _isLoading = false;
          makesenseEventCall(_model?.categories![_selectedIndex].name, _model?.categories![_selectedIndex].childs![0].name);
          GemsGLobals.lastVisitPageName = GemsGLobals.eventCategoryPage;
          gridSelectedcatValue = _model?.categories![_selectedIndex].childs![0];

          getCategoryDataFromDb().then((value) async {
            /*  Insert category data into database */
            if (value.length == 0) {
              var prefs = await SharedPreferences.getInstance();
              prefs.setString('catapiresponsetime', DateTime.now().toString());
              return dbHelper
                  .save(CategoryDbModel(null, json.encode(_model?.toJson())));
            }
          });
        }
      });
    }
  }

  @override
  void onCategoryListViewError(error) {}

  _CategoryListViewState() {
    _presenter = CategoryListPresenter(this);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: white_text_color,
            body: _isLoading == true
                ? LoadingCatPage()
                : Stack(
                    children: [
                      _body(),
                      Positioned(
                          bottom: 150,
                          right: 0,
                          child: Container(child: BackToGems())),
                    ],
                  )),
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
                          categorypage: "yes")))));
    }
  }

  Future<List<Itemsss>?> fetchPlaces(String query) async {
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

  Widget buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      color: white_text_color,
      child: TabBar(
        labelColor: theme_color,
        unselectedLabelColor: hint_text_color,
        indicatorColor: theme_color,
        controller: tabController,
        tabs: List<Widget>.generate(_model!.categories!.length, (int index) {
          return Tab(
              child: TextWidget(
            text: _model?.categories![index].name ?? "",
            weight: FontWeight.bold,
          ));
        }),
      ),
    );
  }

  Widget _appbar() {
    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [          
          Expanded(
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cxt) => SearchProductList())).then((value) {
                  var search = value;
                  if (search != null && search != '') {
                    internetCall(
                        context,
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) => WishListCartCount(),
                                    child: ProductListView(
                                        catId: null,
                                        searchValue: search,
                                        categorypage: "yes")))));
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 15, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              height: 20,
                              child: SvgPicture.asset(
                                ImageConstants.searchicon,
                                color: white_color,
                                height: 15,
                              )),
                          TextWidget(
                            text: "What are you looking for?",
                            color: white_text_color,
                            weight: FontWeight.w500,
                            size: text_font_small,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),          
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
        child: Column(children: <Widget>[
      _appbar(),
      Divider(height: 1.0, color: Colors.grey),
      Expanded(child: _category()),
    ]));
  }

  Widget _category() {
    return Container(
        child: Row(children: <Widget>[
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10, left: 10),
            child: TextWidget(
              alignment: TextAlign.center,
              text: "CATEGORIES",
              color: grey_background,
              weight: FontWeight.w600,
              size: text_size_16,
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: theme_color,
                    //  Color(0xffffbf3c),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(30))),
                margin: EdgeInsets.only(right: 5),
                width: 120,
                child: ListView.builder(
                  itemCount: _model?.categories?.length ?? 0,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _ontapCat = false;

                      _selectedIndex = index;
                      gridSelectedcatValue =
                          _model?.categories![_selectedIndex].childs![0];
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Color(0xfff4f4f4)),
                            bottom: BorderSide(color: Color(0xfff4f4f4))),
                        color: _selectedIndex == index
                            ? Color(0xfff4f4f4)
                            : theme_color,
                        /*gradient: _selectedIndex == index
                              ? GlobalValue.gradientColor
                              : GlobalValue.disablegradientColor,*/
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, right: 5, top: 10, bottom: 10),
                        child: TextWidget(
                          alignment: TextAlign.center,
                          text: _model!.categories![index].name,
                          color: _selectedIndex == index
                              ? grey600_color
                              : white_color,
                          weight: _selectedIndex == index
                              ? FontWeight.w500
                              : FontWeight.w400,
                          textAlign: TextAlign.center,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
      Container(
          color: white_color,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 1.60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                child: TextWidget(
                  text:
                      _model?.categories![_selectedIndex].name.toUpperCase() ??
                          "",
                  color: theme_color,
                  size: text_size_16,
                  weight: FontWeight.w600,
                ),
              ),              
              _categoryListView(
                  _model!.categories![_selectedIndex].childs != null
                      ? _model!.categories![_selectedIndex].childs
                      : [])
            ],
          ))
    ])
        // ),
        );
  }


  Widget _categoryListView(List<CategoryChild>? child) {
    if (_model!.categories![_selectedIndex].childs != null &&
        _model!.categories![_selectedIndex].childs!.isNotEmpty) {
      for (int i = 0;
          i < _model!.categories![_selectedIndex].childs!.length;
          i++) {
        checkvalue.add(false);
      }
    }

    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 0),
        shrinkWrap: true,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: title(_model!.categories![_selectedIndex].childs),
          ),
        ],
      ),
    );
  }

  List<Widget> title(List<CategoryChild>? childs) {
    List<Widget> list = [];
    if (childs != null && childs.isNotEmpty) {
      for (int i = 0; i < childs.length; i++) {
        checkvaluechild.add(false);
      }
    }
    for (var i = 0; i < (childs?.length ?? 0); i++) {
      list.add(Column(
        children: [
          GestureDetector(
            onTap: childs?[i].childs?.length == 0
                ? () {
                    setState(() {
                      value = i;
                      if (value == i) {
                        _ontapCat = true;

                        checkvalue[i] = !checkvalue[i];
                      } else if (value != i) {
                        checkvalue[i] = false;
                      }
                    });

                    internetCall(
                        context,
                        () {
                          GemsGLobals.lastVisitPageName = lastPage;
                          makesenseEventCall(_model?.categories![_selectedIndex].name, childs?[i].name);
                          GemsGLobals.lastVisitPageName = GemsGLobals.eventCategoryPage;
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) => WishListCartCount(),
                                    child: ProductListView(
                                        catId: childs?[i].id,
                                        catName: childs?[i].name,
                                        categorypage: "yes"))));
                        });
                  }
                : () {
                    setState(() {
                      value = i;
                      childValue = null;
                    });

                    setState(() {
                      if (value == i) {
                        _ontapCat = true;
                        checkvalue[i] = !checkvalue[i];
                      }

                      if (_model!.categories![_selectedIndex].childs != null) {
                        for (int i = 0;
                            i <
                                _model!
                                    .categories![_selectedIndex].childs!.length;
                            i++) {
                          if (value != i) {
                            checkvalue[i] = false;
                          }
                        }
                      }
                    });
                  },
            child: AbsorbPointer(
              child: Container(
                height: 40,
                width: 350,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 0.3),
                    color: white_color),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 160,
                      child: TextWidget(
                        text: childs![i].name,
                        overflow: TextOverflow.ellipsis,
                        color: value == i && _ontapCat == true
                            ? theme_color
                            : black_color,
                      ),
                    ),
                    Icon(
                      value == i &&
                              childs[i].childs!.isNotEmpty &&
                              checkvalue[i] == true
                          ? Icons.keyboard_arrow_down_sharp
                          : Icons.keyboard_arrow_right_sharp,
                      color: value == i && _ontapCat == true
                          ? theme_color
                          : Colors.grey.shade300,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (checkvalue.isNotEmpty)
            Column(
              children: _listdata(
                  value == i && checkvalue[i] == true ? childs[i].childs : [],
                  value),
            )
        ],
      ));
    }
    return list;
  }

  List<Widget> _listdata(List<PurpleChild>? childs, int? values) {
    List<Widget> _list = [];
    for (var i = 0; i < (childs?.length ?? 0); i++) {
      _list.add(Column(
        children: [
          GestureDetector(
            onTap: childs![i].childs?.length == 0
                ? () {
                    internetCall(
                        context,
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) => WishListCartCount(),
                                    child: ProductListView(
                                        catId: childs[i].id,
                                        catName: childs[i].name,
                                        categorypage: "yes")))));
                  }
                : () {
                    childValue = i;

                    setState(() {
                      if (childValue == i) {
                        checkvaluechild[i] = !checkvaluechild[i];
                      }

                      if (childs.length != 0) {
                        for (int i = 0; i < childs.length; i++) {
                          if (childValue != i) {
                            checkvaluechild[i] = false;
                          }
                        }
                      }
                    });
                  },
            child: Container(
              height: 40,
              width: 310,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(width: 1, color: Colors.grey.shade200)),
                  color: white_color),
              child: Row(
                children: [
                  Icon(
                    childValue == i &&
                    checkvaluechild[i] == true
                        ? Icons.keyboard_arrow_down_sharp
                        : Icons.keyboard_arrow_right_sharp,
                    color: childValue == i ? theme_color : Colors.grey.shade300,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextWidget(
                    text: childs[i].name ?? "",
                    color: childValue == i ? theme_color : black_color,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: _childData(childValue == i && checkvaluechild[i] == true
                ? childs[i].childs
                : []),
          )
        ],
      ));
    }
    return _list;
  }

  List<Widget> _childData(List<FluffyChild>? childs) {
    List<Widget> _list = [];
    for (var i = 0; i < (childs?.length ?? 0); i++) {
      _list.add(Column(
        children: [
          GestureDetector(
            onTap: () {
              internetCall(
                  context,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                              create: (context) => WishListCartCount(),
                              child: ProductListView(
                                  catId: childs![i].id,
                                  catName: childs[i].name,
                                  categorypage: "yes")))));
            },
            child: AbsorbPointer(
              child: Container(
                alignment: Alignment.centerRight,
                height: 40,
                width: 310,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextWidget(
                      text: childs![i].name ?? "",
                    ),
                    Icon(Icons.keyboard_arrow_right_sharp,
                        color: Colors.grey.shade300)
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return _list;
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => _presenter!.getCategoryListData())));
  }
}

class GridList {
  String? image;
  String? name;
  GridList({
    this.image,
    this.name,
  });
}
