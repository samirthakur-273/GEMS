import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Database/product_list_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_search_history_model.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:http/http.dart' as http;

import '../../api_config.dart';

class SearchProductList extends StatefulWidget {
  const SearchProductList({Key? key}) : super(key: key);

  @override
  _SearchProductListState createState() => _SearchProductListState();
}

class _SearchProductListState extends State<SearchProductList> {
  static var dbHelper = ProductListDBHelper();
  bool _isLoading = false;
  bool noResult = false;

  Future<List<ProductSearchHistory>> getSearchHistory() {
    var data = dbHelper.getSearchHistory();
    return data;
  }

  _deleteHistory(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextWidget(
                text: "Are you sure you want to delete recent searches?"),
            actions: <Widget>[
              MaterialButton(
                child: TextWidget(
                  text: "Cancel",
                  color: black_color,
                  weight: FontWeight.bold,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: TextWidget(
                  text: "Delete",
                  color: red_color,
                  weight: FontWeight.bold,
                ),
                onPressed: () {
                  dbHelper.truncateSearchHistory();
                  Fluttertoast.showToast(
                    msg: " Recent searches deleted.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /* insert search history to db */
  void insertIntoDB(String text) {
    if (text != "") {
      ProductSearchHistory property = ProductSearchHistory(
        null,
        text,
      );
      dbHelper.save(property);
    }
  }

  void deleteFromDB(String text) {
    //print("call is here");
    if (text != "") {
      //print('io');
      dbHelper.delete(text);
    }
    setState(() {});
  }

  TextEditingController query = new TextEditingController();
  Future<List<Itemsss>>? suggestionList;
  List<Itemsss> list = [];

  Widget _body() {
    final searchHistory = getSearchHistory();
    return Container(
      child: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
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
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 10, right: 15, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 15, right: 0),
                            height: 20,
                            child: SvgPicture.asset(
                              ImageConstants.searchicon,
                              color: white_color,
                              height: 15,
                            )),
                        Expanded(
                          child: TextFormField(
                            controller: query,
                            autofocus: true,
                            onChanged: (text) {
                              if (text.length >= 3) {
                                _isLoading = true;
                                suggestionList =
                                    ApiConfig().autosuggest(text).then((value) {
                                  final _resp = autoSuggestModelFromJson(
                                      value.body.toString());
                                  if (_resp[0].success == 'true') {
                                    _isLoading = false;
                                    return _resp[0].items!;
                                  } else {
                                    _isLoading = false;
                                    return [];
                                  }
                                });
                                setState(() {
                                  
                                });
                              }
                            },
                            style: TextStyle(
                              color: white_color,
                            ),
                            cursorColor: white_color,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "What are you looking for?",
                                hintStyle: TextStyle(
                                  color: white_color,
                                  fontFamily: "Poppins",
                                  fontSize: text_font_small,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: FutureBuilder(
                        future: searchHistory,
                        builder: (context, snapshot) {
                          return Container(
                              child: FutureBuilder(
                                  future: searchHistory,
                                  builder: (context, snapshot) {
                                    List data = snapshot.data as List;

                                    if (data.isEmpty ||
                                        list == [] || noResult == true) {
                                      return SizedBox(
                                        height: 0,
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            // SizedBox(height: 10),
                                            Container(
                                              // height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListTile(
                                                leading: TextWidget(
                                                  text: 'Recent Searches',
                                                  color: black_color,
                                                  weight: FontWeight.w400,
                                                  size: text_font_medium_size,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 6),
                                            Wrap(
                                              spacing: 5,
                                              runSpacing: 10,
                                              children: <Widget>[
                                                for (var item
                                                    in snapshot.data as List)
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: blueaqua,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Wrap(
                                                      // clipBehavior: Clip.none,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(item
                                                                    .productName);
                                                          },
                                                          child: Container(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8,
                                                                    bottom: 8.0,
                                                                    left: 8),
                                                            child: TextWidget(
                                                              text: item
                                                                  .productName,
                                                              size: 10,
                                                              color: blackish,
                                                            ),
                                                          )),
                                                        ),

                                                        InkWell(
                                                          onTap: () {
                                                            deleteFromDB(item
                                                                .productName);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 7.0,
                                                                    left: 4),
                                                            child: Container(
                                                              // height: 20,
                                                              // width: 20,
                                                              // decoration:
                                                              //     BoxDecoration(
                                                              //   gradient:
                                                              //       LinearGradient(
                                                              //           colors:
                                                              //               new_gradient_color),

                                                              //   shape: BoxShape
                                                              //       .circle,

                                                              // ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    black_color,
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 6),
                                                        // )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }));
                        }),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    child: FutureBuilder(
                        future: list == [] ? null : suggestionList,
                        builder: (context, snapshot) {
                          
                          list = snapshot.data != null
                              ? snapshot.data as List<Itemsss>
                              : [];

                          if ((list == [] || list.isEmpty) &&
                              query.text != "") {
                                noResult = true;
                            return _isLoading == true
                                ? SpinKitCircle(
                                    color: blue_color,
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    child: ListView(
                                      shrinkWrap: true,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            ImageConstants.noResultFound),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TextWidget(
                                          text: "Sorry! No result found",
                                          size: text_size_20,
                                          weight: FontWeight.bold,
                                          alignment: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: "Please try another way as we were unable to find what you were looking for.",
                                              // "We're sorry what you were looking for.\n Please try another way",
                                          size: text_size_16,
                                          alignment: TextAlign.center,
                                          color: black_color,
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  bluishgradient,
                                                  blue_color,
                                                ],
                                              )),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
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
                                                  Navigator.pop(context);
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
                                  );
                          } else {
                            return _isLoading == true
                                ? SpinKitCircle(
                                    color: blue_color,
                                  )
                                : Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              insertIntoDB(list[index].title!);
                                              Navigator.of(context)
                                                  .pop(list[index].title);
                                            },
                                            child: Container(
                                            
                                              padding: EdgeInsets.fromLTRB(
                                                  16, 0, 16, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    children: [
                                                      // Container(
                                                      //   height: 15,
                                                      //   width: 15,
                                                      //   child: Image.asset(
                                                      //     ImageConstants
                                                      //         .history_timer,
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      Expanded(
                                                        child: Container(
                                                          child: TextWidget(
                                                            text:
                                                                list[index].title ??
                                                                    "",
                                                            color: black_color,
                                                            size: text_font_small,
                                                            weight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(

                                                        child: Icon(Icons.arrow_forward_ios,
                                                        size: 15,
                                                        color: grey_gunsmoke_text_color,
                                                          
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: list.length),
                                  );
                          }
                        }
                        // }),
                        ),
                  ),
                ],
              )))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          body: _body(),
        ));
  }
}
