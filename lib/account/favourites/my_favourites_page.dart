import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/account/favourites/my_favourite_view.dart';
import 'package:gems_revamp/account/favourites/my_favourites_model.dart';
import 'package:gems_revamp/account/favourites/my_favourites_presenter.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/bottombar1.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/account/favourites/custom_expansion_tile.dart'
    as custom;
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_favourite/model_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_favourite/presenter_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_favourite/view_offerfav.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({Key? key}) : super(key: key);

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites>
    implements MyFavouriteView, OfferFavouriteView {
  MyFavouritePresenter? _myFavouritePresenter;
  MyFavouriteModel? _favouriteModel;
  OfferFavouriteModel offerfavdata = OfferFavouriteModel();
  OfferFavPresenter? _offerfavpresenter;

  List<MyFavouriteModel> favouriteDataList = [];

  bool? isLoadingFavouritelist = true;
  bool? _deleteloader = false;
  int _selectedIndex = 0;
  int _selectedvalueIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    _myFavouritePresenter = MyFavouritePresenter(this);
    _offerfavpresenter = OfferFavPresenter(this);
    wishlistApiCall();
    super.initState();
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  wishlistApiCall() {
    // var req = {
    //   'customer_id': 5339117062.toString(),
    //   'lat': 19.7921251.toString(),
    //   'long': 72.7582804.toString()
    // };

    var req = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": 19.7921251.toString(),
      "long": 72.7582804.toString()
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _myFavouritePresenter!.myFavouriteApiResponse(req);
      } else {
        _myFavouritePresenter!.myFavouriteApiResponse(req);
      }
    });
  }

  void callofferfavapi(index, ii) {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
//  "lat": 25.2532,
//   "long": 55.3657,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "brand_code": _favouriteModel!.values![index].favOffers![ii].brandCode,
      "outlet_code": _favouriteModel!.values![index].favOffers![ii].outletCode,
      "isFav": 0,
      "category_code": _favouriteModel!.values![index].categoryCode
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerfavpresenter!.offerFavAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerfavpresenter!.offerFavAPI(request);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _accordian() {
      return _favouriteModel != null && _favouriteModel!.status == true
          ? Container(
              margin: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                itemCount: _favouriteModel!.values!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 0),
                    child: custom.ExpansionTile(
                      initiallyExpanded: index == 0 ? true : false,
                      onExpansionChanged: (text) {},
                      backgroundColor: white_text_color,
                      iconColor: white_text_color,
                      headerBackgroundColor: white_text_color,
                      title: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                height: 25,
                                width: 25,
                                margin: EdgeInsets.only(right: 5),
                                child: ClipRRect(
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        ImageConstants.gems_placeholder,
                                    image: _favouriteModel!
                                        .values![index].categoryImage!,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        ImageConstants.gems_placeholder,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  ),
                                )

                                // Icon(
                                //   Icons.dinner_dining,
                                //   color: black_color,
                                // ),
                                ),
                            new SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: TextWidget(
                                text: _favouriteModel!
                                    .values![index].categoryName!,
                                color: passenger_black_text_color,
                                weight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          // height: _favouriteModel!
                          //         .values![index].favOffers!.length
                          //         .toDouble() *
                          //     113.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _favouriteModel!
                                .values![index].favOffers!.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int ii) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                OfferDetail(
                                                    brandcode: _favouriteModel!
                                                        .values![index]
                                                        .favOffers![ii]
                                                        .brandCode,
                                                    catcode: _favouriteModel!
                                                        .values![index]
                                                        .categoryCode!,
                                                    outletcode: _favouriteModel!
                                                        .values![index]
                                                        .favOffers![ii]
                                                        .outletCode,
                                                    catname: _favouriteModel!
                                                            .values![index]
                                                            .categoryName ??
                                                        "")));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: white_text_color),
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            height: 60, //100
                                            width: 60, //120
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.0, color: bg_color),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: FadeInImage.assetNetwork(
                                                image:
                                                    "${_favouriteModel!.values![index].favOffers![ii].brandLogo ?? ""}",
                                                placeholder: ImageConstants
                                                    .gems_placeholder,
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                    ImageConstants
                                                        .gems_placeholder,
                                                    fit: BoxFit.fill,
                                                  );
                                                },
                                              ),
                                            )),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    text: _favouriteModel!
                                                            .values![index]
                                                            .favOffers![ii]
                                                            .brandName ??
                                                        "",
                                                    size:
                                                        text_font_medium15_size,
                                                    weight: FontWeight.w600,
                                                    color:
                                                        favourite_title_text_color,
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  TextWidget(
                                                    text: _favouriteModel!
                                                            .values![index]
                                                            .favOffers![ii]
                                                            .areaName ??
                                                        "",
                                                    size: text_font_x_small,
                                                    color: grey_background,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextWidget(
                                                    text: _favouriteModel!
                                                            .values![index]
                                                            .favOffers![ii]
                                                            .outletDiscount ??
                                                        "",
                                                    color: Color(0XFFD51870),
                                                    maxLines: 2,
                                                    weight: FontWeight.w500,
                                                    size:
                                                        text_font_size_x_small,
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _deleteloader = true;
                                                  callofferfavapi(index, ii);

                                                  _selectedIndex = index;
                                                  _selectedvalueIndex = ii;
                                                });
                                              },
                                              child: _deleteloader == true &&
                                                      _selectedIndex == index &&
                                                      _selectedvalueIndex == ii
                                                  ? Center(
                                                      child: SpinKitCircle(
                                                      color: btn_bg_color,
                                                      size: 30,
                                                    ))
                                                  : Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: grey_color_300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          child:
                                                              SvgPicture.asset(
                                                            ImageConstants
                                                                .delete,
                                                            color: black_color,
                                                          ))),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        if (_favouriteModel!.values!.length - 1 == index)
                          SizedBox(
                            height: 10,
                          ),
                      ],
                    ),
                  );
                  // : Container(height: 0);
                },
              ),
            )
          : Center(
              child: Container(
              child: TextWidget(
                text: 'No Favorites found',
                size: text_font_medium18_size,
                weight: FontWeight.w500,
              ),
            ));
    }

    Widget _body() {
      return Container(
        color: bg_color,
        child: _accordian(),
      );
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // color: black_color,
        child: BottomBar(
          initialIndex: 2,
          tabvalue: "myaccount",
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            title: AppTexts.myFavoritesText,
            color: white_text_color,
            size: 18,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: isLoadingFavouritelist == true
            ? Center(
                child: SpinKitCircle(
                color: btn_bg_color,
              ))
            : _body(),
        bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }

//wish
  @override
  void favouriteListSuccessRes(MyFavouriteModel _myFavouriteModel) {
    if (_myFavouriteModel.status == true) {
      setState(() {
        isLoadingFavouritelist = false;

        _favouriteModel = _myFavouriteModel;
        _deleteloader = false;
      });
    } else {
      setState(() {
        isLoadingFavouritelist = false;
        _favouriteModel = null;
        _deleteloader = false;
      });
    }
  }

  @override
  void favouriteListError(error) {
    // TODO: implement favouriteListError
  }

  @override
  void offerfavResponseSuccess(OfferFavouriteModel offerfavModel) {
    if (offerfavModel.status == true) {
      setState(() {
        isLoadingFavouritelist = false;
        _deleteloader = false;
        showMessage(context, AppTexts.offerRemovedFromFavoritesText);

        wishlistApiCall();
      });
    } else {
      setState(() {
        isLoadingFavouritelist = false;
        _deleteloader = false;
        wishlistApiCall();
      });
    }
  }
}
