import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

class CheckoutCartDetails extends StatefulWidget {
  CheckoutCartDetails({Key? key}) : super(key: key);

  @override
  _CheckoutCartDetailsState createState() => _CheckoutCartDetailsState();
}

class _CheckoutCartDetailsState extends State<CheckoutCartDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _orderDetails(),
        SizedBox(
          height: 4,
        ),
        _cartDetails(),
        SizedBox(
          height: 4,
        ),
        _totalOrder(),
        Container(height: 4, color: theme_color),
      ],
    );
  }

  Widget _cartDetails() {
    return Container(
      height: 180,
      decoration: boxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _orderRow('Cart Subtotal', '', 'AED 54.00'),
          _orderRow('Disount', '', '-AED 21.60'),
          _orderRow(
            'Shipping',
            'shipping charges',
            'AED 10.00',
          ),
          _orderRow('Tax', '', 'AED 0.0'),
        ],
      ),
    );
  }

  _totalOrder() {
    return Container(
      height: 60,
      decoration: boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: _orderRow('Order Total', '', 'AED 42.40'),
      ),
    );
  }

  Widget _orderRow(label, label2, value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: label,
                toUpperCase: true,
                weight: FontWeight.bold,
              ),
              TextWidget(
                text: label2,
                toUpperCase: true,
                color: Colors.grey,
                weight: FontWeight.bold,
                size: 10,
              ),
            ],
          ),
          TextWidget(
            text: value,
            toUpperCase: true,
            weight: FontWeight.bold,
          )
        ],
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            offset: Offset(
              0,
              10,
            ),
            blurRadius: 20,
            color: Color(0xFF4056C6).withOpacity(.15))
      ],
    );
  }

  Widget _orderDetails() {
    return Container(
      height: 130,
      decoration: boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                height: 80,
                child: Image.asset("assets/shop_assets/men/polo1.jpeg")),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Cotton Polo Shirt for Men",
                ),
                TextWidget(
                  text: "Qty: 1",
                ),
                TextWidget(
                  text: "Size: M ",
                ),
                TextWidget(
                  text: "Price : AED 30",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _shippingOrPayment() {
    return Container(
        height: 120,
        margin: EdgeInsets.only(top: 20),
        decoration: boxDecoration(),
        child: Row(children: <Widget>[
          Expanded(
              child: RoundedContainer(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: TextWidget(text: "1"),
                ),
                Column(
                  children: <Widget>[
                    TextWidget(
                      text: 'Shipping',
                      toUpperCase: true,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 5.0),
                    TextWidget(
                      text: 'Please select or add your address',
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          )),
          Expanded(
              child: RoundedContainer(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 8.0,
            ),
            child: Row(
              children: [
                Column(
                  children: <Widget>[
                    TextWidget(
                      text: 'payment',
                      toUpperCase: true,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 5.0),
                    TextWidget(
                      text: 'Credit/Debit or CAsh on delivery',
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ))
        ]));
  }
}

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    @required this.child,
    this.height,
    this.width,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius,
    this.alignment,
    this.elevation,
  }) : super(key: key);
  final Widget? child;
  final double? width;
  final double? height;
  final Color ?color;
  final EdgeInsets ?padding;
  final EdgeInsets ?margin;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.all(0),
      color: color,
      elevation: elevation ?? 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(20.0),
      ),
      child: Container(
        alignment: alignment,
        height: height,
        width: width,
        padding: padding,
        child: child,
      ),
    );
  }
}
