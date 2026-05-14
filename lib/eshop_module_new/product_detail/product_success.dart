import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:http/http.dart' as http;
import '../tab_bar_page.dart';

class ProductSuccess extends StatefulWidget {
  final bool? isAddedToCart;
  final String? productId;
  final int? sizeselected;
  ProductSuccess({
    Key? key,
    this.isAddedToCart,
    this.productId,
    this.sizeselected,
  }) : super(key: key);

  @override
  _ProductSuccessState createState() => _ProductSuccessState();
}

class _ProductSuccessState extends State<ProductSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffF94E3A),
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient_theme_color,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 270,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: TextWidget(
                    text: "Successfully added to cart",
                    color: white_color,
                    size: 20,
                    weight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: white_color,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          var returnData = [
                            widget.isAddedToCart,
                            widget.productId,
                            widget.sizeselected
                          ];
                          Navigator.pop(context);
                          Navigator.pop(context, returnData);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(
                          ImageConstants.success_AddtoCart,
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        // TextWidget(
                        //   text: "Successfully added to cart",
                        //   color: Colors.black,
                        //   size: 18,
                        //   weight: FontWeight.w500,
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopTabBarPage(
                                          index: 2,
                                        )),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color:Colors.grey,width: 0.3),
                                  color: grey100_color,
                                 
                                  ),
                              child: Center(
                                child: TextWidget(
                                  text: "Go to Cart",
                                  color: black_color,
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              var returnData = [
                                widget.isAddedToCart,
                                widget.productId,
                                widget.sizeselected
                              ];
                              Navigator.pop(context);
                              Navigator.pop(context, returnData);                             
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  
                                  gradient: gradient_theme_color,
                                 
                                  
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: TextWidget(
                                  text: "Continue Shopping",
                                  color: white_text_color,
                                  size: 14,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
