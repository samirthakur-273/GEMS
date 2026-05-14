import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Presenter/product_list_presenter.dart';

class SortValues extends StatefulWidget {
  final Function(dynamic,dynamic) onchanged;
  final selectedvalue;
  final catId;
  final productIds;
  final ProductListPresenter presenter;
  const SortValues(
      {Key? key,
      required this.onchanged,
      required this.selectedvalue,
      required this.catId,
      required this.productIds,
      required this.presenter})
      : super(key: key);
  @override
  _SortValuesState createState() => _SortValuesState();
}

class _SortValuesState extends State<SortValues> {
  int? value;

  @override
  void initState() {
    super.initState();
    value = widget.selectedvalue;
  }

  sendApiRequest(sortMethod) {
    widget.presenter.sortProductList("20", "1", widget.catId, sortMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: white_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: grey_color, blurRadius: 4)],
                color: white_color),
            height: 40,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 19.0),
                  child: TextWidget(
                    text: "sort",
                    size: text_size_18,
                    color: black_color,
                    weight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: close_grey),
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    value = 0;
                    widget.onchanged(value,'high_to_low');

                    Navigator.pop(context, () {
                      setState(() {});
                    });
                  });
                  sendApiRequest('high_to_low');
                },
                child: Container(
                  padding: EdgeInsets.only(left: 18, right: 18, top: 36, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "Price : High to Low",
                        size: text_font_medium_x_size,
                        color: value == 0 ? black_color : Colors.grey[500],
                        weight: FontWeight.w600,
                      ),
                      value == 0 ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                           gradient: GlobalValue.gradientColor,
                        ),
                        child: Icon(
                            Icons.check,
                            size: 20,
                            color: white_text_color
                        ),
                      ) :
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: country_select_color_border),
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.check_box_outline_blank,
                          size: 20,
                          color: transColor
                        ),
                      )
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    value = 1;
                    widget.onchanged(value,'low_to_high');
                    sendApiRequest('low_to_high');

                    Navigator.pop(context, () {
                      setState(() {});
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "Price : Low to High",
                        size: text_font_medium_x_size,
                        color: value == 1 ? black_color : Colors.grey[500],
                        weight: FontWeight.w600,
                      ),
                      value == 1 ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlobalValue.gradientColor,
                        ),
                        child: Icon(
                            Icons.check,
                            size: 20,
                            color: white_text_color
                        ),
                      ) :
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: country_select_color_border),
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                            Icons.check_box_outline_blank,
                            size: 20,
                            color: transColor
                        ),
                      )
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    value = 2;
                    widget.onchanged(value,'new_arrival');
                    sendApiRequest('new_arrival');

                    Navigator.pop(context, () {
                      setState(() {});
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "New",
                        size: text_font_medium_x_size,
                        color: value == 2 ? black_color : Colors.grey[500],
                        weight: FontWeight.w600,
                      ),
                      value == 2 ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlobalValue.gradientColor,
                        ),
                        child: Icon(
                            Icons.check,
                            size: 20,
                            color: white_text_color
                        ),
                      ) :
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: country_select_color_border),
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                            Icons.check_box_outline_blank,
                            size: 20,
                            color: transColor
                        ),
                      )
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       value = 3;
              //       widget.onchanged(value,'discount');
              //       sendApiRequest('discount');
              //       Navigator.pop(context, () {
              //         setState(() {});
              //       });
              //     });
              //   },
              //   child: Container(
              //     padding: EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 8),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         TextWidget(
              //           text: "Discount",
              //           size: text_font_medium_x_size,
              //           color: value == 3 ? black_color : Colors.grey[500],
              //           weight: FontWeight.w600,
              //         ),
              //         value == 3 ? Container(
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             gradient: GlobalValue.gradientColor,
              //           ),
              //           child: Icon(
              //               Icons.check,
              //               size: 20,
              //               color: white_text_color
              //           ),
              //         ) :
              //         Container(
              //           decoration: BoxDecoration(
              //               border: Border.all(color: country_select_color_border),
              //               shape: BoxShape.circle
              //           ),
              //           child: Icon(
              //               Icons.check_box_outline_blank,
              //               size: 20,
              //               color: transColor
              //           ),
              //         )
              //         // SizedBox(
              //         //   height: 10,
              //         // ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
