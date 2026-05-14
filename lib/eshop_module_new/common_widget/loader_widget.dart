import 'package:flutter/widgets.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';

class Loader extends StatelessWidget {
  final Color? color;
  Loader({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: SpinKitCircle(
          color: theme_color,
        )));
  }
}
