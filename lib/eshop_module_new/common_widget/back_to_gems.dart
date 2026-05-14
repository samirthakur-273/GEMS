import 'package:flutter/material.dart';
import 'package:gems_revamp/homepage/homesearch/common_search.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/tabbarpage.dart';
import '../../utils/constants_files/imageconstants.dart';

class BackToGems extends StatefulWidget {
  const BackToGems({Key? key}) : super(key: key);

  @override
  State<BackToGems> createState() => _BackToGemsState();
}

class _BackToGemsState extends State<BackToGems> {
  Widget _switchToBonuz() {
    return GestureDetector(
        onTap: () {
          GemsGLobals.alumniStatus = false;

          if (GemsGLobals.backbutton == "true") {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CommonSearch(choose: 'E Shop')));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabsScreen(
                        initialIndex: 0,
                      )),
            );
          }
        },
        child: Container(
          height: 60,
          child: Image.asset(ImageConstants.eshop_backtoGems),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _switchToBonuz();
  }
}
