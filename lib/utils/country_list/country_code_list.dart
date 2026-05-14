import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/no_result_found.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class CountryCodeListPage extends StatefulWidget {
  final countryListData;
  const CountryCodeListPage({this.countryListData, Key? key}) : super(key: key);

  @override
  State<CountryCodeListPage> createState() => _CountryCodeListPageState();
}

class _CountryCodeListPageState extends State<CountryCodeListPage> {
  int checked = 0;
  List list = [];
  List ist = [];

  bool nodatafound = false;
  bool _loader = true;

  List? countryCodeData = [];
  List saerchResult = [];
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    countryCodeData = this.widget.countryListData;

    // TODO: implement initState
    super.initState();
  }

  _onChanged(String value) {
    if (value.length > 1) {
      setState(() {
        saerchResult.clear();
      });

      for (int i = 0; i < countryCodeData!.length; i++) {
      
        if (countryCodeData![i].name.toString().toLowerCase().contains(value) ||
            countryCodeData![i].countryCode.toString().contains(value)) {
          saerchResult.add(countryCodeData![i]);
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
                text: "Search your Country Code",
                size: 16,
                weight: FontWeight.normal,
                color: Colors.grey,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _countryCodeListWidget() {
      return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            // physics: ScrollPhysics(),
            itemCount: _textController.text.isEmpty
                ? countryCodeData!.length
                : saerchResult.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(
                      context,
                      _textController.text.isEmpty
                          ? countryCodeData![index]
                          : saerchResult[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    bottom: 5,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            child: TextWidget(
                              text: _textController.text.isEmpty
                                  ? '+${countryCodeData![index].countryCode}'
                                  : '+${saerchResult[index].countryCode}',
                              color: purchase_text_color,
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.fill,
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.fill,
                                  );
                                },
                                imageUrl: _textController.text.isEmpty
                                    ? countryCodeData![index].image
                                    : saerchResult[index].image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextWidget(
                              text: _textController.text.isEmpty
                                  ? countryCodeData![index].name
                                  : saerchResult[index].name,
                              color: purchase_text_color,
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
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
                          Navigator.of(context).pop();
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
                                      hintText: "Enter Country",
                                      hintStyle: TextStyle(
                                          color: hint_text_color,
                                          fontSize: text_font_size_x_small),
                                      contentPadding:
                                          EdgeInsets.only(left: 3, bottom: 10)),
                                ),
                              ),
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
          nodatafound == true ? _noDataFound() : _countryCodeListWidget()
        ],
      ),
    );
  }
}
