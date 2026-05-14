import 'package:flutter/material.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';

class MyCredit extends StatefulWidget {
  StoreCredit? model;

  MyCredit({Key? key, required this.model}) : super(key: key);
  @override
  _MyCreditState createState() => _MyCreditState();
}

class _MyCreditState extends State<MyCredit> implements MyProfileViewContract {
  List<Widget> _list = [];
  late MyProfilePresenter? _presenter;
  late MyProfileModel? _model;
  _MyCreditState() {
    _presenter = MyProfilePresenter(this);
  }
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.model == null) {
      _presenter?.getMyProfileData();
    } else {
      _isLoading = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white_color,
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                child: AppBarWidget(
                  color: theme_color,
                  title: "My Credit",
                ),
                preferredSize: Size.fromHeight(50)),
            body: _isLoading
                ? Loader()
                : ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 20.0),
                          leading: TextWidget(
                            text: "Available",
                            size: 15.0,
                            weight: FontWeight.bold,
                          ),
                          trailing: TextWidget(
                            size: 15.0,
                            text: "AED " +
                                widget.model!.availableAmount.toString(),
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                        child: (widget.model?.balanceHistory?.length ?? 0) > 0
                            ? TextWidget(
                                text: "Balance History",
                                weight: FontWeight.bold,
                                size: 15.0,
                              )
                            : Container(),
                      ),
                      SingleChildScrollView(
                        child: (widget.model?.balanceHistory?.length ?? 0) > 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _balancehistoryList(),
                              )
                            : Container(),
                      )
                    ],
                  )),
      ),
    );
  }

  SizedBox _nodatafound() {
    return SizedBox(
        height: 100,
        child: Center(
            child: TextWidget(
          text: 'No data found',
          weight: FontWeight.bold,
        )));
  }

  List<Widget> _balancehistoryList() {
    for (var i = 0; i < (widget.model?.balanceHistory?.length ?? 0); i++) {
      _list.add(
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, top: 18.0),
              child: ListBody(
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: "Action",
                        weight: FontWeight.bold,
                        size: text_font_small,
                      ),
                      SizedBox(width: 10.0),
                      TextWidget(
                        text:
                            widget.model?.balanceHistory?[i].actionTitle ?? "",
                        size: text_font_small,
                        color: dark_grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      TextWidget(
                        text: "Balance Change:",
                        weight: FontWeight.bold,
                        size: text_font_small,
                      ),
                      SizedBox(width: 10.0),
                      TextWidget(
                        text: "AED " +
                            (widget.model?.balanceHistory?[i].balanceDelta ??
                                ""),
                        size: text_font_small,
                        color: dark_grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      TextWidget(
                        text: "Balance",
                        weight: FontWeight.bold,
                        size: text_font_small,
                      ),
                      SizedBox(width: 10.0),
                      TextWidget(
                        text: "AED " +
                            (widget.model?.balanceHistory?[i].balanceAmount ??
                                ""),
                        size: text_font_small,
                        color: dark_grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      TextWidget(
                        text: "date",
                        weight: FontWeight.bold,
                        size: text_font_small,
                      ),
                      SizedBox(width: 10.0),
                      TextWidget(
                        text: widget.model?.balanceHistory?[i].updatedAt ?? "",
                        size: text_font_small,
                        color: dark_grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 18.0),
              child: Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    return _list;
  }

  @override
  void onMyProfileViewError(error) {
    // TODO: implement onMyProfileViewError
    _isLoading = false;
    setState(() {});
  }

  void onMyProfileViewSuccess(MyProfileModel response) {
    setState(() {
      if (response.success == 'true') {
        _model = response;
        _isLoading = false;

        widget.model = _model?.storeCredit;
      } else {
        _isLoading = false;
      }
    });
  }

  @override
  void onProfileTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyProfilePresenter(this).getMyProfileData())));
  }
}
