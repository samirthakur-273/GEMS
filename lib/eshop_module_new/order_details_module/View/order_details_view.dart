import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/order_details_module/View/Components/items_ordered.dart';

class OrderDetailsView extends StatefulWidget {
  OrderDetailsView({Key? key}) : super(key: key);

  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: black_color,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: TextWidget(
          text: 'Order Details',
          toUpperCase: true,
          weight: FontWeight.bold,
          color: theme_color,
          size: text_font_medium_x_size,
        ),
      ),
      body: ListView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          _orderInfo(),
          SizedBox(
            height: 20,
          ),
          _shippingDetails(),
          SizedBox(
            height: 20,
          ),
          _billingPaymentDetails(),
          SizedBox(
            height: 20,
          ),
          _orderLinks(),
          SizedBox(
            height: 20,
          ),
          _itemsOrderedHeading(),
          SizedBox(
            height: 10,
          ),
          ItemsOrdered()
        ],
      ),
    );
  }

  _orderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: 'Order # 10000263',
          weight: FontWeight.bold,
          size: text_font_large_size,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: black_color, width: 1.0)),
                child: TextWidget(
                  text: 'Delivered',
                  toUpperCase: true,
                )),
            Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(color: black_color, width: 1.0)),
                child: TextWidget(text: 'Return')),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        TextWidget(
          text: 'January 12, 2021',
        ),
      ],
    );
  }

  _shippingDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          direction: Axis.vertical,
          spacing: 5,
          children: [
            TextWidget(
              text: 'Billing Address',
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 5,
            ),
            TextWidget(
              text: 'Varsha Hon',
            ),
            TextWidget(
              text: 'near xsdf',
            ),
            TextWidget(
              text: 'Academic City, Dubai,',
            ),
            TextWidget(
              text: 'United Arab Emirates',
            ),
            TextWidget(
              text: 'T: +971502087339',
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextWidget(
                text:
                    'Address: Villa No-11 ,opposite Aisha bint khalfan near family development center 100',
                maxLines: 5,
              ),
            ),
            TextWidget(
              text: 'House No: 76,',
            ),
            TextWidget(
              text: 'Address Type: Home ',
            ),
          ],
        ),
        Wrap(
          direction: Axis.vertical,
          spacing: 5,
          children: [
            TextWidget(
              text: 'Shipping Method',
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 5,
            ),
            TextWidget(
              text: 'Standard Charges',
            ),
          ],
        ),
      ],
    );
  }

  _billingPaymentDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          direction: Axis.vertical,
          spacing: 5,
          children: [
            TextWidget(
              text: 'Shipping Address',
              weight: FontWeight.bold,
            ),
            SizedBox(
              height: 5,
            ),
            TextWidget(
              text: 'Varsha Hon',
            ),
            TextWidget(
              text: 'near xsdf',
            ),
            TextWidget(
              text: 'Academic City, Dubai,',
            ),
            TextWidget(
              text: 'United Arab Emirates',
            ),
            TextWidget(
              text: 'T: +971502087339',
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextWidget(
                text:
                    'Address: Villa No-11 ,opposite Aisha bint khalfan near family development center 100',
                maxLines: 5,
              ),
            ),
            TextWidget(
              text: 'House No: 76,',
            ),
            TextWidget(
              text: 'Address Type: Home ',
            ),
          ],
        ),
        Wrap(
          direction: Axis.vertical,
          spacing: 10,
          children: [
            TextWidget(
              text: 'Payment Method',
              weight: FontWeight.bold,
            ),
            TextWidget(
              text: 'Cash on delivery',
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: TextWidget(
                text: 'an additional fee will apply',
                toUpperCase: true,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _orderLinks() {
    return Scrollbar(
      controller: _scrollController,
      // isAlwaysShown: true,
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            InkWell(
              splashColor: theme_color,
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: black_color, width: 1.0)),
                  child: Center(
                    child: TextWidget(
                      text: 'Items Ordered',
                      toUpperCase: true,
                    ),
                  )),
            ),
            InkWell(
              splashColor: theme_color,
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: black_color, width: 1.0)),
                  child: Center(
                    child: TextWidget(
                      text: 'Invoices',
                      toUpperCase: true,
                    ),
                  )),
            ),
            InkWell(
              splashColor: theme_color,
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: black_color, width: 1.0)),
                  child: Center(
                    child: TextWidget(
                      text: 'Order Shipments',
                      toUpperCase: true,
                    ),
                  )),
            ),
            InkWell(
              splashColor: theme_color,
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: black_color, width: 1.0)),
                  child: Center(
                    child: TextWidget(
                      text: 'Return',
                      toUpperCase: true,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _itemsOrderedHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: 'Items Ordered',
          size: text_font_medium_size,
        ),
        InkWell(
            splashColor: theme_color,
            onTap: () {},
            child: TextWidget(
              text: 'Track Order',
              size: text_font_size_small,
              decoration: TextDecoration.underline,
            )),
      ],
    );
  }
}
