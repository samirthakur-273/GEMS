/* Author name : Animesh Banerjee
  creation date: 20/03/2020
  */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/no_result_found.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class Nationality extends StatefulWidget {
  final nationalityData;
  @override
  _NationalityState createState() => _NationalityState();
  Nationality({Key? key, this.nationalityData}) : super(key: key);
}

class _NationalityState extends State<Nationality> {
  TextEditingController _textController = TextEditingController();
  int checked = 0;
  List list = [];
  List ist = [];

  bool nodatafound = false;
  bool _loader = true;

  List? nationalityData = [];

  List saerchResult = [];

  @override
  void initState() {
    nationalityData = widget.nationalityData;

    super.initState();
  }

  // List _newData = [];
  // List _news = [];
  _onChanged(String value) {
    if (value.length > 1) {
      setState(() {
        saerchResult.clear();
      });

      for (int i = 0; i < nationalityData!.length; i++) {
        if (nationalityData![i].name.toString().toLowerCase().contains(value)) {
          saerchResult.add(nationalityData![i]);
        }

        if (saerchResult.length == 0) {
          setState(() {
            nodatafound = true;
          });
        } else {
          setState(() {
            nodatafound = false;
          });
        }
        // else {
        //   setState(() {
        //     nodatafound = true;
        //   });
        // }
      }
    } else {
      setState(() {
        nodatafound = true;
      });
    }
  }

  Widget _new() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return ListTile(
            title: TextWidget(
                text: _textController.text.isEmpty
                    ? nationalityData![i].name
                    : saerchResult[i].name),
            onTap: () {
              Navigator.of(context).pop(_textController.text.isEmpty
                  ? nationalityData![i]
                  : saerchResult[i]);
            },
          );
        },
        itemCount: _textController.text.isEmpty
            ? nationalityData!.length
            : saerchResult.length,
      ),
    );
    // } else {
    //   return _newData != null && _newData.length != 0
    //       ? Expanded(
    //           child: ListView.builder(
    //             itemBuilder: (context, i) {
    //               return ListTile(
    //                 title: TextWidget(text: _newData[i]),
    //                 onTap: () {
    //                   var newData;
    //                   for (var j = 0; j < ist.length; j++) {
    //                     if (nationalityData![i].name.toString() ==
    //                         _newData[i].toString()) {
    //                       setState(() {
    //                         newData = ist[j];
    //                       });
    //                       Navigator.of(context).pop(newData);
    //                     }
    //                   }
    //                 },
    //               );
    //             },
    //             itemCount: _newData.length,
    //           ),
    //         )
    //       : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Widget _searchBar() {
      return new Container(
        padding: EdgeInsets.only(bottom: 5),

        height: 100,
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    color: appbar_backarw_bg_color),
                child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: SvgPicture.asset(
                      ImageConstants.backbutton,
                      height: 50,
                      width: 50,
                      fit: BoxFit.scaleDown,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 7),
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: SvgPicture.asset(
                          ImageConstants.searchicon,
                          height: 20,
                        )),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _textController,
                        onChanged: _onChanged,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Nationality",
                            hintStyle: TextStyle(
                                color: hint_text_color,
                                fontSize: text_font_size_x_small),
                            contentPadding:
                                EdgeInsets.only(left: 3, bottom: 10)),
                      ),
                    ),
                    Container(
                        color: Color.fromRGBO(0, 0, 0, 0.0),
                        child:
                            //  (_textController.text.length >= 1)
                            //     ?
                            IconButton(
                          onPressed: () {
                            _textController.clear();
                            setState(() {
                              nationalityData = widget.nationalityData;
                            });

                            // _onChanged(_textController.text);
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 25,
                          ),
                          color: Colors.black45,
                        )
                        // : Container()
                        )
                  ],
                ),
              ),
            )
          ],
        ),
        // ])
      );
    }

    Widget _noDataFound() {
      return new Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 250),
        child: Center(
          child: _textController.text.length >= 2
              ? NoResultFoundNew()
              // Container(
              //     child: TextWidget(
              //       text: 'Sorry, no results found',
              //     ),
              //   )
              : TextWidget(
                  text: "Search your Nationality",
                  size: 16,
                  weight: FontWeight.normal,
                  color: Colors.grey,
                ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
          child: SafeArea(
            top: false,
            child: Container(
                decoration: BoxDecoration(gradient: gradient_theme_color),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  top: 25,
                ),
                height: 100,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                          // Navigator.of(context).maybePop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue[400],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 22,
                                color: white_text_color,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                          ),
                          height: 40,
                          child: Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 7),
                                  padding: EdgeInsets.only(left: 5, right: 10),
                                  child: SvgPicture.asset(
                                    ImageConstants.searchicon,
                                    height: 20,
                                  )),
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  controller: _textController,
                                  onChanged: _onChanged,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Nationality",
                                      hintStyle: TextStyle(
                                          color: hint_text_color,
                                          fontSize: text_font_size_x_small),
                                      contentPadding:
                                          EdgeInsets.only(left: 3, bottom: 10)),
                                ),
                              ),
                              // Container(
                              //     color: Color.fromRGBO(0, 0, 0, 0.0),
                              //     child:IconButton(
                              //             onPressed: () {
                              //               _textController.clear();
                              //               setState(() {
                              //                 nationalityData =
                              //                     widget.nationalityData;
                              //               });

                              //               // _onChanged(_textController.text);
                              //             },
                              //             icon: Icon(
                              //               Icons.clear,
                              //               size: 25,
                              //             ),
                              //             color: Colors.black45,
                              //           )
                              //       )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          preferredSize: Size.fromHeight(100.0)),
      body: Column(
        children: <Widget>[
          // _searchBar(),
          nodatafound == true ? _noDataFound() : _new()
        ],
      ),
    );
  }
}
