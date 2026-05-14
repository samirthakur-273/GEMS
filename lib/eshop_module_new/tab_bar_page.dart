import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/gradient_text.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/View/eshop_homepage.dart';
import 'package:gems_revamp/eshop_module_new/app_version_update_check/model/app_version_model.dart';
import 'package:gems_revamp/eshop_module_new/app_version_update_check/presenter/app_version_presenter.dart';
import 'package:gems_revamp/eshop_module_new/app_version_update_check/view/app_version_view.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/cart_details_page.dart';
import 'package:gems_revamp/eshop_module_new/category_module/View/category_list_view.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/localization/app_localization.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/details_view.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/my_profile_view.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/details_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_search_view.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_content_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/presenter/dialog_content_presenter.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/presenter/dialog_presenter.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/view/dialog_content_view.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/view/dialog_view.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopTabBarPage extends StatefulWidget {
  final index;
  final int? tabIndex;
  ShopTabBarPage({Key? key, this.index, this.tabIndex}) : super(key: key);

  @override
  ShopTabBarPageState createState() => ShopTabBarPageState();
}

class ShopTabBarPageState extends State<ShopTabBarPage>
    with SingleTickerProviderStateMixin
    implements
        DetailsView,
        DialogView,
        DialogContentView,
        AppVersionView,
        MyProfileViewContract {
  TabController? tabController;
  List<TabItemList> tabList = [];
  var _index = 0;
  TextEditingController emailController = new TextEditingController();
  bool valueTerms = false;
  bool valueWomen = false;
  bool valueMen = false;
  bool valueKids = false;
  MyDetailsPresenter? _detailsPresenter;
  DetailsModel? _detailsModel;
  AppVersionPresenter? _appVersionPresenter;
  DialogPresenter? _dialogPresenter;
  DialogContentPresenter? _dialogContentPresenter;
  List<DialogContent>? _dialogContent;
  String? version = "";
  MyProfileModel? responses;
  var loginResponse;

  @override
  void initState() {
    _index = widget.index ?? 0;

    _detailsPresenter = MyDetailsPresenter(this);
    _dialogPresenter = DialogPresenter(this);
    _dialogContentPresenter = DialogContentPresenter(this);
    _appVersionPresenter = AppVersionPresenter(this);
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
    tabController?.addListener(listener);
    // versionCall();
    packageInfo();

    apiCall();
    super.initState();
  }

  void signInUpResp(String email, String password, String guestid) async {
    Constants.customerId = '';
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("Guestid") == null ||
        prefs.getString("Guestid") == "") {
    } else {
      Constants.guestId = prefs.getString("Guestid");
    }
  }

  listener() {
    if (tabController!.indexIsChanging) {
      setState(() {
        _index = tabController!.index;
      });
      switch (tabController!.index) {
        case 0:
          break;
      }
    }
  }

  tabClick(index) {
    setState(() {
      tabController?.animateTo(index);
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: new_gradient_color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      height: 45,
      alignment: Alignment.center,
      child: SafeArea(
          top: false,
          bottom: true,
          child: PopScope(
            canPop: false,
            onPopInvoked: (canPop) async {
              Navigator.of(context).pushNamed('/tabbarpage');
              
            },
            child: Scaffold(
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: List.generate(tabList.length, (index) {
                  return pages(index);
                }),
              ),
              bottomNavigationBar:  Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 9),
                  height: 65,
                  decoration: BoxDecoration(
                    color: white_color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), 
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
                ),
              ),
            ),
          )),
    );
  }

  PreferredSize buildSearchAppBar() {
    return PreferredSize(
        preferredSize: new Size.fromHeight(80.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Image.asset(
                "assets/shop_assets/logo_rnb.png",
                height: 30,
              )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: InkWell(
                  onTap: () async {
                    
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (cxt) => SearchProductList()))
                        .then((value) {
                      var search = value;
                      if (search != null && search != '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductListView(
                                    catId: null, searchValue: search)));
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            child: AbsorbPointer(
                              child: IconButton(
                                  padding: EdgeInsets.only(
                                      left: 5, bottom: 13, top: 3, right: 0),
                                  icon: Icon(
                                    Icons.search,
                                    color: black_color,
                                  ),
                                  onPressed: () {}),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 15,
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    hintText: AppLocalizations.of(context)
                                        ?.translate("searchtext"),
                                    hintStyle: TextStyle(
                                        fontSize: text_font_size_x_small)),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void apiCall() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "action": "content",
      "email": emailController.text,
    };
    _detailsPresenter?.getMyDetailsData();
  }

  void versionCall() {
    _appVersionPresenter?.loadAppVersion();
  }

  void dialogCall() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "action": "content",
      "email": emailController.text,
    };
    _dialogContentPresenter?.dialogContentData(body);
  }



  pages(index) {
    switch (index) {
      case 0:
        return BonuzHomePage(
          apiCallTabPage: apiCall,
          tabIndex: widget.tabIndex ?? 0,
        );
        break;
      case 1:
        return CategoryListView(
          apiCall,
          tabBarPageState: this,
        );
        break;
      case 2:
        return (GemsGLobals.userType == "guest")
            ? Container(
                height: MediaQuery.of(context).size.height,
                color: grey200_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Please Login to view My Cart',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: gradient_theme_color,
                      ),
                      margin: EdgeInsets.only(top: 15),
                      child: MaterialButton(
                        child: TextWidget(
                          text: "Login",
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          GemsGLobals.routeTo = 'mycart';
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginHomePage()));
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : CartDetailsPage(
                apiCallTabPage: apiCall,
                tabBarPageState: this,
              );
        break;
      case 3:
        return (GemsGLobals.userType == "guest")
            ? Container(
                height: MediaQuery.of(context).size.height,
                color: grey200_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Please Login to view My Wishlist',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: gradient_theme_color,
                      ),
                      margin: EdgeInsets.only(top: 15),
                      child: MaterialButton(
                        child: TextWidget(
                          text: "Login",
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          GemsGLobals.routeTo = 'wishlist';
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginHomePage()));
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : MyWishlist(
                apiCallTabPage: apiCall,
                tabBarPageState: this,
              );
        break;
      case 4:
        return (GemsGLobals.userType == "guest")
            ? Container(
                height: MediaQuery.of(context).size.height,
                color: grey200_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Please Login to view My Account',
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: gradient_theme_color,
                      ),
                      margin: EdgeInsets.only(top: 15),
                      child: MaterialButton(
                        child: TextWidget(
                          text: "Login",
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          GemsGLobals.routeTo = 'myaccount';
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginHomePage()));
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : MyProfilePage(
                titlekeyaboutus: _detailsModel?.footer?.aboutUs,
                titlekeycustomer: _detailsModel?.footer?.customerServices,
                titlekeycontact: _detailsModel?.footer?.contactUs,
                tabBarPageState: this,
              );
        break;

      default:
        return Container();
    }
  }

  num? _footerCount(Header? header, int? index) {
    switch (index) {
      case 2:
        return GlobalValue.totalCartCount;
        break;
      case 3:
        return ((header?.wishlistCount ?? 0) > 0) ? header?.wishlistCount : 0;
        break;
      default:
        return 0;
    }
  }

  Widget itemTab(TabItemList tabList, index) {
    return Stack(
      children: [
        Positioned(
          left: MediaQuery.of(context).size.width * 0.11,
          top: 3,
          child: TextWidget(
            text: _footerCount(_detailsModel?.header, index) != 0
                ? _footerCount(_detailsModel?.header, index).toString()
                : "",
            color: Colors.black,
            size: 12,
          ),
        ),
        Container(
            width: 60,
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
                        ),
                      )
                    : Container(
                        child: SvgPicture.asset(
                          tabList.image,
                          height: 26,
                          fit: BoxFit.fill,
                        ),
                      ),
                SizedBox(
                  height: 5,
                ),
                _index == index
                    ? GradientText(
                        tabList.name,
                        style: const TextStyle(fontSize: text_size_9_half),
                        gradient: LinearGradient(
                            colors: [Color(0xFF00A3E0), Color(0xFF283593)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      )
                    : TextWidget(
                        textAlign: TextAlign.center,
                        text: tabList.name,
                        size: text_size_9_half,
                        color: Colors.grey,
                      ),
              ],
            )),
      ],
    );
  }

  @override
  void onDetailsViewError(error) {}

  @override
  void onDetailsViewSuccess(DetailsModel response) {
    setState(() {
      _detailsModel = response;
      GlobalValue.totalCartCount = _detailsModel?.header?.cartCount;
    });
  }

  Widget _savemoneyButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: ElevatedButton(
        style: ButtonStyle(
            textStyle:
                WidgetStateProperty.all(TextStyle(color: Colors.white)),
            backgroundColor: WidgetStateProperty.all(Colors.black),
            padding: WidgetStateProperty.all(
                EdgeInsets.only(top: 12, bottom: 12))),
        // textColor: Colors.white,
        // color: Colors.black,
        // padding: EdgeInsets.only(top: 12, bottom: 12),
        child: TextWidget(
          text: _dialogContent?[0].submitbuttontxt?.toString() ?? "",
          size: text_font_size_x_small,
          weight: FontWeight.bold,
        ),
        onPressed: () {
          var body = {
            "brandcode": Constants.brandCode,
            "country_code": Constants.countryCode,
            "lang_code": Constants.langCode,
            "action": "add",
            "email": emailController.text
          };
          setState(() {
            _dialogPresenter?.dialogData(body);
          });
        },
      ),
    );
  }

  Widget _emailTextfield() {
    return Container(
      color: white_text_color,
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        textAlign: TextAlign.left,
        autofocus: false,
        style: TextStyle(
            color: Colors.black,
            fontSize: text_font_size_xx_small,
            fontWeight: FontWeight.normal),
        controller: emailController,
        enabled: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          hintText: "Please enter a valid email address",
          hintStyle:
              TextStyle(color: Colors.black, fontSize: text_font_size_xx_small),
        ),
      ),
    );
  }

  @override
  void dialogError(error) {
  }

  @override
  void dialogResponse(DialogModel dialogModel) {
    if (dialogModel.success == "true") {
      Navigator.pop(context);
    } else {}
  }

  @override
  void dialogContentError(error) {}

  @override
  void dialogContentResponse(List<DialogContent> dialogContent) {
    setState(() async {
      _dialogContent = dialogContent;

      SharedPreferences prefSkip = await SharedPreferences.getInstance();
      var skipValue = prefSkip.getString('skip');
    });
  }

  @override
  void appVersionError(error) {
  }

  @override
  void appVersionResponse(AppVersionModel? response) {
    double? currentVersion = double.tryParse(version!);
    double? apiandroidforceupdateversion =
        double.tryParse(response!.androidForceUpdateVer!) ?? 0;
    double apiiosforceupdateversion =
        double.tryParse(response.iosForceUpdateVer!) ?? 0;

    if (Platform.isAndroid) {
      if (apiandroidforceupdateversion >= currentVersion!) {
        updateAppDialog();
      } else {}
    }
    if (Platform.isIOS) {
      if (apiiosforceupdateversion >= currentVersion!) {
        updateAppDialog();
      } else {}
    }
  }

  @override
  void onTimeout() {
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
  }

  void updateAppDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (canPop) async {
           Future.value(false);},
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              height: 120,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextWidget(
                      text: "there is a new version available for download.",
                      size: text_font_size_small,
                      weight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  new SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextWidget(
                      text: "Please update the app",
                      size: text_font_size_small,
                      weight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(top: 22),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: theme_color,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    child: new TextButton(
                      child: TextWidget(
                        text: "Update",
                        textAlign: TextAlign.center,
                        color: theme_color,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () async {},
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void onMyProfileViewError(error) {
    // TODO: implement onMyProfileViewError
  }

  @override
  void onMyProfileViewSuccess(MyProfileModel response) async {
    // TODO: implement onMyProfileViewSuccess
    if (response.success == "true") {
      responses = response;
      GlobalValue.firstname = responses?.customer?.firstName;
      GlobalValue.lastname = responses?.customer?.lastName;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString("firstName", responses?.customer?.firstName ?? '');
      prefs.setString("lastName", responses?.customer?.lastName ?? '');
      setState(() {});
    }
  }

  @override
  void onProfileTimeout() {
    // TODO: implement onProfileTimeout
  }
}

class TabItemList {
  var name;
  var image;
  var selectImage;

  TabItemList(this.name, this.image, this.selectImage);
}

class CustomCheckBox extends StatefulWidget {
  final bool? value;

  final ValueChanged<bool>? onChanged;

  const CustomCheckBox({Key? key, this.value, this.onChanged})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool? _value;

  @override
  void initState() {
    _value = widget.value ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.blue,
      activeColor: Colors.white,
      value: _value,
      onChanged: (bool? value) {
        setState(() {
          _value = value;
        });
        widget.onChanged!(value!);
      },
    );
  }
}
