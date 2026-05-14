import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

class ItemsOrdered extends StatefulWidget {
  ItemsOrdered({Key? key}) : super(key: key);

  @override
  _ItemsOrderedState createState() => _ItemsOrderedState();
}

class _ItemsOrderedState extends State<ItemsOrdered> {
  @override
  Widget build(BuildContext context) {
    return _itemsOrdered();
  }

  _itemsOrdered() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: black_color)),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/shop_assets/men/polo1.jpeg"))),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Product Name:',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                TextWidget(
                  text: 'Viscose Polo t-shirt For men',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Size:',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                TextWidget(
                  text: '10',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'SKU:',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                TextWidget(
                  text: 'RB547612120',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Price:',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                Spacer(
                  flex: 1,
                ),
                TextWidget(
                  text: 'AED 0.00',
                  color: grey_gunsmoke_text_color,
                  weight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
                TextWidget(
                  text: '  AED 65.00',
                  color: Colors.red,
                  weight: FontWeight.bold,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Qty:',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                Spacer(
                  flex: 1,
                ),
                TextWidget(
                  text: 'Ordered : 1 , ',
                  color: grey_gunsmoke_text_color,
                ),
                TextWidget(
                  text: 'Shipped : 1',
                  color: grey_gunsmoke_text_color,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Subtotal:',
                  color: black_color,
                ),
                TextWidget(
                  text: 'AED 61.90',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Cash on Delivery Fee:',
                  color: black_color,
                ),
                TextWidget(
                  text: 'AED 20.00',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Shipping & Handling ',
                  color: black_color,
                ),
                TextWidget(
                  text: 'AED 10.00',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Tax ',
                  color: black_color,
                ),
                TextWidget(
                  text: 'AED 3.10',
                  color: grey_gunsmoke_text_color,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Grand Total',
                  weight: FontWeight.bold,
                  color: black_color,
                ),
                TextWidget(
                  text: 'AED 95.00',
                  weight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
