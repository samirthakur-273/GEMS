import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/policy_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/policy_presenter.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/policy_shimmer.dart';

class PolicyInnerHtmlPages extends StatefulWidget {
  final String? indentifier;
  final String? title;

  PolicyInnerHtmlPages({Key? key, this.indentifier, this.title})
      : super(key: key);

  @override
  _PolicyInnerHtmlPagesState createState() => _PolicyInnerHtmlPagesState();
}

class _PolicyInnerHtmlPagesState extends State<PolicyInnerHtmlPages>
    implements PolicyView {
  String? htmlContent;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    internetCall(
        context, () => PolicyPresenter(this).getPolicyData(widget.indentifier));
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
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              backgroundColor: white_color,
              body: SingleChildScrollView(
                child: isloading
                    ? PolicyShimmer()
                    : Container(
                        margin: EdgeInsets.all(20),
                        child: Html(
                          data: htmlContent ?? "",
                          style: {
                            "p": Style(
                                fontFamily: 'Sans_Pro',
                                fontSize: FontSize.medium),
                            "li": Style(
                                fontFamily: 'Sans_Pro',
                                fontSize: FontSize.medium),
                            "ul": Style(
                                fontFamily: 'Sans_Pro',
                                fontSize: FontSize.medium),
                          },
                        ),
                      ),
              ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: ShopGradientAppBar(
                  title: widget.title ?? "",
                  color: white_text_color,
                  size: 19,
                  weight: FontWeight.w500,
                  centerTitle: true,
                  height: 90,
                ),
              ),
            )));
  }

  @override
  void policyViewError(error) {
    isloading = false;
    setState(() {});
  }

  @override
  void policyViewSuccess(List<PolicyModel> model) {
    if (model[0].success == "true") {
      htmlContent = model[0].cmscontent;
      isloading = false;
      setState(() {});
    } else {
      isloading = false;
      setState(() {});
      Fluttertoast.showToast(
          msg: model[0].message.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  void policyViewTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => internetCall(
                      context,
                      () => PolicyPresenter(this)
                          .getPolicyData(widget.indentifier)))));
  }
}
