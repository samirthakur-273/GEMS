import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/custom_expansion_tile.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Database/product_filter_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_db_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Presenter/product_list_presenter.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/Components/product_list_filter_detail.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class ProductListFilter extends StatefulWidget {
  final catId;
  var selectedSortValue;
  final productIds;
  final ProductListPresenter? presenter;
  void Function(int value)? onListTypeChanged;
  ProductListFilter(
      {Key? key,
      required this.catId,
      this.selectedSortValue,
      this.productIds,
      this.presenter,
      this.onListTypeChanged});
  @override
  _ProductListFilterState createState() => _ProductListFilterState();
}

class _ProductListFilterState extends State<ProductListFilter>
    implements ProductListViewContract {
  static var dbHelper = ProductFilterDBHelper();

  ProductFilterModel? _model;
  ProductListPresenter? _presenter;
  bool _isLoading = true;
  bool _nodata = false;
  List<Widget> categoryList = [];
  List selectedCategoryOption = [];
  int _state = 0;
  int? value;
  List categoryOptionList = [];
  var colorCode;
  String? sortSelectedValue;
  String? sortSelectedName;
  List selectedMap = [];
  int? listType;
  List? sortByList = [
    {"name": "New", "key": "new_arrival"},
    {"name": "Price : High to Low", "key": "high_to_low"},
    {"name": "Price : Low to High", "key": "low_to_high"},
  ];
  String? sortType;
  bool _showFilter = true;
  bool isempty = true;
  bool isemptysort = true;
  @override
  void initState() {
    super.initState();
    _presenter!.getFilterData(widget.catId);
    sortSelectedValue = widget.selectedSortValue;
  }

  _ProductListFilterState() {
    _presenter = ProductListPresenter(this);
  }
  @override
  void onFilterDataViewSuccess(ProductFilterModel response) {
    setState(() {
      if (response.success == 'true') {
        _model = response;
        _isLoading = false;
        _nodata = false;
      } else {
        _isLoading = false;
        _nodata = true;
      }
    });
  }

  @override
  void onFilterDataViewError(error) {
    setState(() {
      _isLoading = false;
      _nodata = true;
    });
  }

  getCategoryOptions(categoryName) {
    _model!.filtercollection!
        .where((element) => element.title == categoryName)
        .forEach((element) {
      List data = [];
      data = element.data!;
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductListFilterDetail(
                      data: data,
                      title: categoryName,
                    ))).then((value) => {
              getSelectedData(value, categoryName),
            });
      });
    });
  }

  clearAllList(String calledOn) {
    setState(() {
      isempty = true;
      isemptysort = true;
      _model!.filtercollection!.forEach((filterData) {
        filterData.data!.forEach((element) {
          element.isSelected = false;
        });
      });
      dbHelper.truncatefilterData();
      if (calledOn == "reset") sortSelectedValue = "";
    });
  }

  getSelectedData(value, categoryName) async {
    var selectedValue = [];
    var selectedCode = [];
    _model!.catId = widget.catId;
    _model!.filtercollection!
        .where((element) => element.title == categoryName)
        .forEach((element) {
      setState(() {
        for (int i = 0; i < value.length; i++) {
          if (value[i]['isSelected'] == true) {
            selectedValue.add(value[i]['label']);
            if (categoryName == 'category') {
              selectedCode.add(value[i]['optioncode']);
            } else {
              selectedCode.add(value[i]['label']);
            }
            element.data![i].isSelected = true;
          }
        }
        element.filterJson![categoryName] = selectedCode;
        element.selectedData =
            selectedValue.toString().replaceAll('[', '').replaceAll(']', '');
      });
    });
  }

  sendFilterDataAPI() {
    dbHelper.truncatefilterData();
    /* Insert temp filter data into db */
    _model?.catId = widget.catId;
    dbHelper
        .save(ProductFilterDataModel(null, json.encode(_model!.toJson())))
        .then((value) {
      var sendValues = {};
      var sendFilterDisplayValues = {};
      var sendFilterIDValues = {};
      _model!.filtercollection?.forEach((filterdata) {
        var selectedData = [];
        var filterDisplayData = [];
        var filterDisplayDataID = [];

        filterdata.data?.forEach((element) {
          if (element.isSelected == true) {
            if (filterdata.title == 'price') {
              selectedData.add(element.label);
              filterDisplayDataID.add(element.label);
            } else {
              selectedData.add(element.optioncode);
              filterDisplayDataID.add(element.optioncode);
            }
            filterDisplayData.add(element.label);
          }
        });

        filterdata.filterJson![filterdata.title] = selectedData;
        filterdata.filterDisplayJson![filterdata.frontendLabel] =
            filterDisplayData;
        filterdata.filterDisplayDataID![filterdata.frontendLabel] =
            filterDisplayDataID;
        sendFilterIDValues.addAll(filterdata.filterDisplayDataID!);
        sendFilterIDValues.removeWhere((key, value) => value.isEmpty);

        sendFilterDisplayValues.addAll(filterdata.filterDisplayJson!);
        sendFilterDisplayValues.removeWhere((key, value) => value.isEmpty);
        sendValues.addAll(filterdata.filterJson!);
        sendValues.addAll({"sortfilter": sortSelectedValue});
        sendValues.removeWhere((key, value) => value == null || value.isEmpty);
      });

      var filterValues = {
        "sort": sortSelectedName,
        "filterDisplay": sendFilterDisplayValues,
        "filterValuesId": sendFilterIDValues,
        "filter": {
          "brandcode": Constants.brandCode,
          "country_code": Constants.countryCode,
          "lang_code": Constants.langCode,
          "category_id": widget.catId ?? "52",
          "filter": sendValues,
          "listType": _model!.listType,
          "limit": "20",
          "pageno": 1
        }
      };

      setState(() {
        _state = 1;
        if (sendValues.isNotEmpty) {
          Navigator.pop(context, filterValues);
        } else {
          Navigator.pop(context, _model!.listType);
        }
      });
      // } else {
      //   setState(() {
      //     _state = 0;
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
       
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: ShopGradientAppBar(
            title: "Sort & Filter",
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 100,
          ),
        ),
        body: _isLoading
            ? Loader()
            : _nodata
                ? Center(
                    child: TextWidget(
                      text: 'No Filter Option found',
                      weight: FontWeight.bold,
                      color: theme_color,
                    ),
                  )
                : _body(),
        bottomNavigationBar: _isLoading
            ? SizedBox()
            :  Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 15),
                child: _applyWidget(),
              ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     listType = 1;
                    //     widget.onListTypeChanged!(listType!);
                    //     _presenter!.changeListType(listType);
                    //     Navigator.pop(context);
                    //     setState(() {});
                    //   },
                    //   child: Container(
                    //       height: 30,
                    //       width: 30,
                    //       child: listType == 1
                    //           ? SvgPicture.asset(
                    //               ImageConstants.eshop_selectedListview,
                    //             )
                    //           : SvgPicture.asset(
                    //               ImageConstants.eshop_unListview)),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     listType = 2;
                    //     widget.onListTypeChanged!(listType!);
                    //     _presenter!.changeListType(listType);
                    //     Navigator.pop(context);
                    //     setState(() {});
                    //   },
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     child: listType == 2
                    //         ? SvgPicture.asset(
                    //             ImageConstants.eshop_selectedGridview,
                    //           )
                    //         : SvgPicture.asset(ImageConstants.eshop_unGridview),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       _showFilter = !_showFilter;
                    //     });
                    //   },
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     padding: EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //           width: 1,
                    //           color: black_color,
                    //         ),
                    //         gradient: _showFilter
                    //             ? gradient_theme_color
                    //             : LinearGradient(colors: [
                    //                 Color.fromARGB(255, 252, 249, 249),
                    //                 Color.fromRGBO(250, 248, 248, 1)
                    //               ]),
                    //         color: _showFilter ? blue_color : white_color,
                    //         borderRadius: BorderRadius.circular(25)),
                    //     child: SvgPicture.asset(
                    //       ImageConstants.sortandfilter,
                    //       color: _showFilter ? white_text_color : black_color,
                    //       height: 20,
                    //       width: 20,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          _sort(),
          _filter(),
          // ConstrainedBox(
          //     constraints: BoxConstraints(maxHeight: 500.0),
          //     child: Container(
          //       decoration: BoxDecoration(boxShadow: [
          //         BoxShadow(color: Colors.grey[300], blurRadius: 5)
          //       ], color: red_color),
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: _model?.filtercollection?.length ?? 0,
          //         itemBuilder: (BuildContext context, int index) {
          //           return Container(
          //             padding: EdgeInsets.all(10),
          //             width: MediaQuery.of(context).size.width,
          //             decoration: BoxDecoration(
          //                 border: Border(
          //                     bottom: BorderSide(
          //                         color: Colors.grey[300], width: 2))),
          //             child: InkWell(
          //               onTap: () {
          //                 setState(() {
          //                   getCategoryOptions(
          //                     _model?.filtercollection[index]?.title,
          //                   );
          //                 });
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         TextWidget(
          //                           text: _model.filtercollection[index]
          //                                   .frontendLabel
          //                                   .toString() ??
          //                               "NA",
          //                           color: black_color,
          //                           weight: FontWeight.bold,
          //                           size: text_font_small,
          //                         ),
          //                         _model.filtercollection[index].selectedData !=
          //                                 ''
          //                             ? TextWidget(
          //                                 text: _model.filtercollection[index]
          //                                         .selectedData ??
          //                                     "",
          //                                 maxLines: 5,
          //                                 size: text_font_size_x_small,
          //                               )
          //                             : SizedBox(),
          //                       ],
          //                     ),
          //                     Icon(
          //                       Icons.arrow_forward_ios,
          //                       size: 15,
          //                       color: grey_color,
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     )),
        ],
      ),
    );
  }

  Widget _sort() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(10),
          color: white_color),
      margin: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 0),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Row(
              children: <Widget>[
                TextWidget(
                  text: "Sort",
                  size: 20,
                  // color: grey600_color,
                  weight: FontWeight.w600,
                  // size: text_size_20,
                  color: theme_color,
                  // weight: FontWeight.bold,
                ),
                // Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     sortSelectedValue = "";
                //     setState(() {});
                //   },
                //   child: Container(
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle, color: close_grey),
                //     child: Icon(
                //       Icons.close,
                //       size: 20,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 0,
          // ),
          Column(
            children: _sortData(),
          ),
        ],
      ),
    );
  }

  List<Widget> _sortData() {
    List<Widget> _data = [];
    for (var i = 0; i < sortByList!.length; i++) {
      _data.add(GestureDetector(
        onTap: () {
          sortSelectedValue = sortByList![i]["key"];
          sortSelectedName = sortByList![i]["name"];
          setState(() {
            if (sortByList != null) {
              for (int i = 0; i < sortByList!.length; i++) {
                if (sortSelectedValue == sortByList![i]["key"]) {
                  isemptysort = false;
                  break;
                } else {
                  isemptysort = true;
                }
              }
            }
          });
        },
        child: AbsorbPointer(
          child: Container(
            alignment: Alignment.center,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: sortByList![i]["name"] ?? "",
                  // size: text_font_medium_x_size,
                  size: 16,
                  color: sortSelectedValue == sortByList![i]["key"]
                      ? black_color
                      : Colors.grey[500]!,
                  // weight: FontWeight.w600,
                ),
                // sortSelectedValue == sortByList![i]["key"]
                // ?
                Container(
                  height: 23,
                  width: 23,
                  child: SvgPicture.asset(
                    sortSelectedValue == sortByList![i]["key"]
                        ? ImageConstants.select_Option
                        : ImageConstants.unselect_Option,
                    fit: BoxFit.fill,
                  ),
                ),
                // Container(
                //     decoration: BoxDecoration(
                //         border:
                //             Border.all(color: country_select_color_border),
                //         shape: BoxShape.circle,
                //         color: white_color),
                //     child: Icon(Icons.check, size: 25, color: theme_color),
                //   )
                // : Container(
                //     decoration: BoxDecoration(
                //         border:
                //             Border.all(color: country_select_color_border),
                //         shape: BoxShape.circle),
                //     child: Icon(Icons.check_box_outline_blank,
                //         size: 25, color: transColor),
                //   )
              ],
            ),
          ),
        ),
      ));
    }
    return _data;
  }

  Widget _filter() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(10),
          color: white_color),
      margin: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
      padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Row(
                children: <Widget>[
                  TextWidget(
                    text: "Filter",
                    size: text_size_20,
                    color: theme_color,
                    // weight: FontWeight.bold,
                    weight: FontWeight.w600,
                    // size: text_size_20,
                    // color: theme_color,
                  ),
                  // Spacer(),
                  // GestureDetector(
                  //   onTap: () {
                  //     clearAllList("filter");
                  //   },
                  //   child: Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle, color: close_grey),
                  //     child: Icon(
                  //       Icons.close,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Column(
              children: _filterData(),
            )
          ]),
    );
  }

  List<Widget> _filterData() {
    List<Widget> _data = [];
    for (var i = 0; i < _model!.filtercollection!.length; i++) {
      _data.add(Theme(
        data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: black_color)),
        child: ListTileTheme(
          dense: true,
          child: CustomExpansionTile(
            initiallyExpanded: true,
            title: _model!.filtercollection![i].frontendLabel != null
                ? TextWidget(
                    // text: _model!.filtercollection![i].frontendLabel ?? "",

                    text: _model!.filtercollection![i].frontendLabel
                            .toString()
                            .substring(0, 1)
                            .toUpperCase() +
                        _model!.filtercollection![i].frontendLabel
                            .toString()
                            .substring(1)
                            .replaceAll('_', ' '),
                    color: black_color,
                    size: 16,
                    weight: FontWeight.w500,
                  )
                : TextWidget(text: ""),
            children: [
              _model!.filtercollection![i].data == []
                  ? SizedBox()
                  : Column(
                      children: _sectiondata(_model!.filtercollection![i].data!,
                          _model!.filtercollection![i].title!),
                    )
            ],
          ),
        ),
      ));
    }
    return _data;
  }

  selectOptions(catOptions, index, categoryName) {
    if (categoryName == 'price') {
      if (catOptions[index].isSelected == true) {
        catOptions[index].isSelected = false;
      } else {
        catOptions.forEach((element) => element.isSelected = false);
        catOptions[index].isSelected = true;
        selectedMap.add({
          "price": catOptions[index].label,
          "isSelected": catOptions[index].isSelected
        });
      }
      // selectedMap.forEach((element) => element['isSelected'] = false);
      // selectedMap[index]['isSelected'] = true;
    } else {
      catOptions[index].isSelected = !catOptions[index].isSelected;
      catOptions
          .where((element) => element.isSelected == true)
          .forEach((element) {
        selectedMap.add({
          categoryName: catOptions[index].label,
          "isSelected": catOptions[index].isSelected
        });
      });
      setState(() {});
    }
  }

  List<Widget> _sectiondata(List<Datum> filterOptions, String categoryName) {
    List<Widget> list = [];
    for (var i = 0; i < filterOptions.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          selectOptions(filterOptions, i, categoryName);
          setState(() {
            for (int i = 0; i < filterOptions.length; i++) {
              if (filterOptions[i].isSelected == true) {
                isempty = false;
                break;
              } else {
                isempty = true;
              }
            }
          });
        },
        child: AbsorbPointer(
          child: Container(
              // height: 60,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
              child: Card(
                elevation: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: TextWidget(
                          text: filterOptions[i].label!,
                          softwrap: true,
                          size: 14,
                        ),
                      ),
                      Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: blue_color,
                            value: filterOptions[i].isSelected == true
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                filterOptions[i].isSelected = value;
                                // statusofResetbtn();
                              });
                            },
                          ))

                      // filterOptions[i].isSelected == true
                      //     ? Container(
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 color: country_select_color_border),
                      //             shape: BoxShape.circle,
                      //             color: white_color),
                      //         child:
                      //             Icon(Icons.check, size: 25, color: theme_color),
                      //       )
                      //     : Container(
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 color: country_select_color_border),
                      //             shape: BoxShape.circle),
                      //         child: Icon(Icons.check_box_outline_blank,
                      //             size: 25, color: transColor),
                      //       ),
                    ]),
              )),
        ),
      ));
    }
    return list;
  }

  Widget _applyWidget() {
    return _state == 0
        ? Container(
            color: white_text_color,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new GestureDetector(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: gradient_theme_color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: TextWidget(
                            text: 'Apply',
                            size: text_font_medium_x_size,
                            color: white_text_color,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        sendFilterDataAPI();
                      }),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: new GestureDetector(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xFFf4f4f4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                width: 0.8,
                                color: black_color.withOpacity(0.2))),
                        child: Center(
                          child: TextWidget(
                            text: 'Reset',
                            size: text_font_medium_x_size,
                            color: !isempty || !isemptysort
                                ? grey_background
                                : text_color,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        clearAllList("reset");
                      }),
                ),
              ],
            ),
          )
        : Container(
            height: 50,
            // color: black_color,
            child: Center(
              child: Loader(),
            ),
          );
  }
  //   return _state == 0
  //       ? Padding(
  //           padding: const EdgeInsets.only(bottom: 15.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: <Widget>[
  //               Material(
  //                 elevation: 2,
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Container(
  //                   height: 45,
  //                   width: 140,
  //                   decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                           colors: new_gradient_color,
  //                           begin: Alignment.topLeft,
  //                           end: Alignment.bottomRight),
  //                       boxShadow: [
  //                         BoxShadow(color: Colors.grey[300]!, blurRadius: 5.0)
  //                       ],
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: TextButton(
  //                     child: TextWidget(
  //                       text: "Apply",
  //                       color: white_color,
  //                       weight: FontWeight.bold,
  //                       size: text_font_medium_x_size,
  //                     ),
  //                     onPressed: () {
  //                       sendFilterDataAPI();
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               // SizedBox(width:10),
  //               Material(
  //                 elevation: 2,
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Container(
  //                   height: 45,
  //                   width: 140,
  //                   padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
  //                   decoration: BoxDecoration(
  //                       color: Colors.grey[100],
  //                       borderRadius: BorderRadius.circular(10),
  //                       boxShadow: [
  //                         BoxShadow(color: Colors.grey[300]!, blurRadius: 5.0)
  //                       ]),
  //                   child: FlatButton(
  //                     onPressed: () {
  //                       clearAllList("reset");
  //                     },
  //                     child: TextWidget(
  //                       text: "Reset",
  //                       color: aqua_blue,
  //                       size: text_font_medium_x_size,
  //                       weight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       : Container(
  //           height: 50,
  //           color: black_color,
  //           child: Center(
  //             child: Loader(),
  //           ),
  //         );
  // }

  @override
  void onProductListViewSuccess(ProductListModel response, [index]) {
  }

  @override
  void onAddToWishListError(error) {}

  @override
  void onAddToWishListSuccess(AddToWishListModel response, index) {}

  @override
  void onDeleteToWishListSuccess(response, index) {}

  @override
  void onProductListViewError(error) {
    
  }

  @override
  void onProductSearchViewSuccess(ProductListModel response) {}

  @override
  void onListViewChangeSuccess(listType) {
    // TODO: implement onListViewChangeSuccess
  }

  @override
  void onTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      ProductListPresenter(this).getFilterData(widget.catId))));
  }
}
