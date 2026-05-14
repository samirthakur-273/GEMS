import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';

class FullPolicyPage extends StatefulWidget {
  final policy;
  const FullPolicyPage({Key? key, this.policy}) : super(key: key);

  @override
  State<FullPolicyPage> createState() => _FullPolicyPageState();
}

class _FullPolicyPageState extends State<FullPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: GradientAppBar(
            height: 90,
            centerTitle: true,
            title: 'Full Policy',
            size: 18.5,
            weight: FontWeight.w600,
          )),
      body: Container(
        padding: EdgeInsets.all(10),
        child: TextWidget(
          text: this.widget.policy,
        ),
      ),
    );
  }
}
