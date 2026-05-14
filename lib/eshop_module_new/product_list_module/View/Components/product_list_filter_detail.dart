import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

class ProductListFilterDetail extends StatefulWidget {
  final title;
  List data = [];
  ProductListFilterDetail({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);
  @override
  _ProductListFilterDetailState createState() =>
      _ProductListFilterDetailState();
}

class _ProductListFilterDetailState extends State<ProductListFilterDetail> {
  List<Widget> categoryOptionList = [];
  List selectedMap = [];
  bool iselected = false;
  var colorCode;
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data.length; i++) {
      selectedMap.add({
        "isSelected": widget.data[i].isSelected,
        "label": widget.data[i].label,
        "optioncode": widget.data[i].optioncode
      });
    }
  }

  selectOptions(catOptions, index) {
    setState(() {
      if (widget.title == 'price') {
        if (widget.data[index].isSelected == true) {
          widget.data[index].isSelected = false;
        } else {
          widget.data.forEach((element) => element.isSelected = false);
          widget.data[index].isSelected = true;
        }

        selectedMap.forEach((element) => element['isSelected'] = false);
        selectedMap[index]['isSelected'] = true;
      } else {
        catOptions.isSelected = !catOptions.isSelected;
        selectedMap
            .where((element) => element['label'] == catOptions.label)
            .forEach((element) {
          element['isSelected'] = catOptions.isSelected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      for (var i = 0; i < widget.data.length; i++) {
        categoryOptionList = List<Widget>.generate(widget.data.length,
            (int i) => _categoryOptionWidget(widget.data[i], i)).toList();
      }
    }

    return Container(
      color: theme_color,
      child: SafeArea(
        top: false,
        bottom: true,
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: _appbar(),
            ),
            body: _body(),
            bottomNavigationBar: _applyWidget(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryOptionList,
        ),
      )),
    );
  }

  Widget _appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: new_gradient_color,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          height: 90,
          alignment: Alignment.center,
        ),
        leading: Padding(
          padding: EdgeInsets.all(15),
          child: RawMaterialButton(
            elevation: 0.0,
            constraints: BoxConstraints.tight(Size(36, 36)),
            child: Icon(
              Icons.arrow_back_ios,
              color: theme_color,
              size: 12,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            shape: CircleBorder(),
            fillColor: Colors.white,
          ),
        ),
        title: TextWidget(
          text: widget.title ?? "",
          size: text_font_medium_x_size,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: <Widget>[
          // InkWell(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Center(
          //         child: TextWidget(
          //       text: 'Cancel',
          //       size: text_font_medium_x_size,
          //       weight: FontWeight.bold,
          //     )),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _applyWidget() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, selectedMap);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: GlobalValue.gradientColor,
        ),
        child: Center(
            child: TextWidget(
          text: 'Apply',
          toUpperCase: true,
          weight: FontWeight.bold,
          color: white_color,
          size: text_font_medium_size,
        )),
      ),
    );
  }

  Widget _categoryOptionWidget(catOptions, index) {
    if (widget.title == 'color' && catOptions.swatchcode != null) {
      colorCode = catOptions.swatchcode.replaceAll('#', '0xff');
    }

    return InkWell(
      onTap: () {
        selectOptions(catOptions, index);
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    widget.title == 'color' && catOptions.swatchcode != null
                        ? Container(
                            margin: EdgeInsets.only(top: 5, right: 10),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: widget.title == 'color' &&
                                      catOptions.swatchcode != null
                                  ? Colors.transparent
                                  : Color(int.parse(colorCode)),
                              shape: BoxShape.circle,
                            ),
                          )
                        : SizedBox(),
                    TextWidget(
                      text: catOptions.label ?? "",
                      color: black_color,
                      size: text_font_small,
                    ),
                  ],
                ),
                catOptions.isSelected == true
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlobalValue.gradientColor,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 20,
                          color: white_color,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: country_select_color_border),
                            shape: BoxShape.circle),
                        child: Icon(Icons.check_box_outline_blank,
                            size: 20, color: transColor),
                      )
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Color(0xFF3ef4136), Color(0xFFfbb040)],
        // tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
