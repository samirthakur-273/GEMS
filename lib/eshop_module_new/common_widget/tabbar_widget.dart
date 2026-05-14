import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/gradient_text.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/details_view.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/details_presenter.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:provider/provider.dart';

class TabbarWidget extends StatefulWidget {
  final int index;
  TabbarWidget(this.index, {Key? key}) : super(key: key);
  @override
  _TabbarWidgetState createState() => _TabbarWidgetState();
}

class _TabbarWidgetState extends State<TabbarWidget>
    with SingleTickerProviderStateMixin implements DetailsView {
  DetailsModel? _detailsModel;
  MyDetailsPresenter? _detailsPresenter;
  TabController? tabController;
  List<TabItemList> tabList = [];
  var _index;

  @override
  void initState() {
    _index = widget.index;
    _detailsPresenter = MyDetailsPresenter(this);
    tabList.add(TabItemList(
        "Eshop", ImageConstants.eshop_icon, ImageConstants.selct_eshop_icon));
    tabList.add(TabItemList("Category", ImageConstants.category_icon,
        ImageConstants.selct_category_icon));
    tabList.add(TabItemList("My Cart", ImageConstants.mycart_icon,
        ImageConstants.selct_mycart_icon));
    tabList.add(TabItemList("Wishlist", ImageConstants.wishlist_icon,
        ImageConstants.selct_wishlist_icon));

    tabList.add(TabItemList("My Account", ImageConstants.myaccount_icon,
        ImageConstants.selct_myaccount_icon));

    tabController = TabController(
        length: tabList.length, vsync: this, initialIndex: _index);
    // tabController.addListener(listener);
    //apicall();
    super.initState();
    //userId();
  }

  listener() {
    if (tabController!.indexIsChanging) {
      setState(() {
        _index = tabController!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      height: 66,
      decoration: BoxDecoration(
        color: white_color,
        // border: Border(
        //   top: BorderSide(
        //     //                    <--- top side
        //     color: Colors.grey[350]!,
        //     width: 1.0,
        //   ),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TabBar(
          labelColor: black_color,
          labelPadding: EdgeInsets.all(0),
          controller: tabController,
          indicatorColor: Colors.transparent,
          tabs: List.generate(
            tabList.length,
            (index) => itemTab(tabList[index], index),
          )),
    );
  }

  int? _footerCount(Header header, int index) {
    switch (index) {
      case 3:
        return ((header.wishlistCount ?? 0) > 0) ? header.wishlistCount : 0;
      case 2:
        return ((header.cartCount ?? 0) > 0) ? header.cartCount : 0;
      default:
        return 0;
    }
  }

  @override
  void onDetailsViewError(error) {
    // TODO: implement onDetailsViewError
  }

  @override
  void onDetailsViewSuccess(DetailsModel response) {
    setState(() {
      _detailsModel = response;
    });
  }

  void apicall() {
    _detailsPresenter!.getMyDetailsData();
  }

  Widget itemTab(TabItemList tabList, index) {
    return Consumer<WishListCartCount>(
        builder: (context, cartwishListcount, child) {
      var count = _footerCount(_detailsModel?.header ?? Header(), index);
      return GestureDetector(
        onTap: () {
          // if (index == 1) {
          //   Navigator.pop(context);
          // } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopTabBarPage(
                      index: index,
                    )),
          );
          // }
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            count != 0 ||
                    (index == 3
                        ? cartwishListcount.countWishList != 0
                        : index == 2
                            ? cartwishListcount.countCartList != 0
                            : false)
                ? Stack(
                    children: <Widget>[
                      // Icon(Icons.brightness_1, size: 20.0, color: theme_color),
                      Positioned(
                          top: 3.0,
                          left: MediaQuery.of(context).size.width * 0.145,
                          child: Center(
                            child: TextWidget(
                                text: tabList.name == 'Wishlist'
                                    ? (count! + cartwishListcount.countWishList)
                                        .toString()
                                    : (count! + cartwishListcount.countCartList)
                                        .toString(),
                                color: Colors.black,
                                size: 12.0,
                                weight: FontWeight.w500),
                          )),
                    ],
                  )
                : SizedBox(),
            Container(
                width: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    _index == index
                        ? Container(
                            child: SvgPicture.asset(
                              tabList.selectImage,
                              height: 26,
                              fit: BoxFit.fill,
                              // color: Colors.grey,
                            ),
                          )
                        : Container(
                            child: SvgPicture.asset(
                              tabList.image,
                              height: 26,
                              fit: BoxFit.fill,
                              // color: Colors.grey,
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    _index == index
                        ? GradientText(
                            tabList.name,
                            style: const TextStyle(
                                fontSize: text_font_size_xx_small),
                            gradient: LinearGradient(
                                colors: [Color(0xFF00A3E0), Color(0xFF283593)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          )
                        : TextWidget(
                            textAlign: TextAlign.center,
                            text: tabList.name,
                            size: text_font_size_xx_small,
                            color: Colors.grey,
                          ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}

class TabItemList {
  var name;
  var image;
  var selectImage;

  TabItemList(this.name, this.image, this.selectImage);
}

