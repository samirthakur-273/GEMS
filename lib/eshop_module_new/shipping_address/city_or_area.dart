import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class CityOrArea extends StatefulWidget {
  final String? title;
  final List? cityvalues;
  final List? areavalues;
  final selectedvalue;
  const CityOrArea({
    Key? key,
    this.title,
    this.cityvalues,
    this.areavalues,
    this.selectedvalue,
  }) : super(key: key);
  @override
  _CityOrAreaState createState() => _CityOrAreaState();
}

class _CityOrAreaState extends State<CityOrArea> {
  List cityvalues = [];
  List areavalues = [];
  String? name;
  int? select;
  List<String> duplicateItems = [
    "Dubai",
    "Fujairah",
    "Ghantout",
    "Hatta",
    "Liwa"
  ];
  String? selectedValue;
  TextEditingController editingController = TextEditingController();
  var items = <String>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cityvalues = widget.cityvalues ?? [];
    areavalues = widget.areavalues ?? [];
    name = widget.selectedvalue ?? "";
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    var isCity = widget.title == "City";
    dummySearchList = isCity ? cityvalues : areavalues;
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (isCity) {
          if (item.toString().toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        } else {
          if (item["City name"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        }
      });
      setState(() {
        isCity ? cityvalues = dummyListData : areavalues = dummyListData;
      });
    } else {
      setState(() {
        isCity
            ? cityvalues = widget.cityvalues ?? []
            : areavalues = widget.areavalues ?? [];
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    Widget _searchBar() {
      return Container(
          height: 50,
          decoration: BoxDecoration(
            color: white_text_color,
            border: Border.all(width: 0.3, color: grey_gunsmoke_text_color),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.14,
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 13),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ));
    }

    Widget _body() {
      return Container(
        child: Column(
          children: <Widget>[
            _searchBar(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15, right: 15),
                itemCount: widget.title == "City"
                    ? cityvalues.length
                    : areavalues.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      name = widget.title == "City"
                          ? cityvalues[i]
                          : areavalues[i]["City name"];
                      Navigator.pop(context, name);
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 20,
                                child: Image.asset(
                                  ImageConstants.pinMarkerIcon,
                                  color: blue_color,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              TextWidget(
                                text: widget.title == "City"
                                    ? cityvalues[i]
                                    : areavalues[i]["City name"],
                                size: text_font_medium_x_size,
                                weight: FontWeight.normal,
                              ),
                            ],
                          ),
                          widget.title == "City"
                              ? name == cityvalues[i]
                                  ? /*Container(
                                    child: Image.asset(
                                    "assets/shop_assets/Group 9975.png",
                                    height: 22,
                                    width: 22,
                                  ))*/
                                  Container(
                                      alignment: Alignment.center,
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(
                                          color: black_color,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.check,
                                        size: 18,
                                        color: white_text_color,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 22,
                                      width: 22,
                                    )
                              : name == areavalues[i]["City name"]
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(
                                          color: black_color,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.check,
                                        size: 18,
                                        color: white_text_color,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 22,
                                      width: 22,
                                    )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: GradientAppBar(
              title: widget.title == "City" ? "Select City" : "Select Area",
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 100,
            )),
        body: _body(),
      ),
    );
  }
}
