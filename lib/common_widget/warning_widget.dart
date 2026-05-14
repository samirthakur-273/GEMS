import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';

class WarningWidget extends StatelessWidget {
  final String? image;
  final String? message;

  const WarningWidget({Key? key, this.image, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   
    return Container(
      // color: Colors.red,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          color: Color(0xFFe8d5b0),
          height: 150,

          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 80,
                width: 80,
                child: Image.asset("images/info_new.png"),
             
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width - 110,
                    child: TextWidget(
                      size: 15,
                      weight: FontWeight.bold,
                      text: message,
                      softwrap: true,
                      overflow: TextOverflow.clip,
                      color: Colors.black,
                    ),
                  )),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
