import 'package:flutter/material.dart';
import 'package:waste/confi/color.dart';

class SmallRoundButton extends StatelessWidget {
  @required VoidCallback onpress;
  
  @required String   buttonName;
  Color color;
  IconData iconData;

  SmallRoundButton({this.buttonName, this.iconData, this.onpress, this.color=MyColor.blueColor});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
                    onPressed: onpress,
                      icon: Icon(
                      iconData,
                      size: 30,
                      color: MyColor.facebookColor,
                    ),
                    label: Text(
                      "Camera",
                      style: TextStyle(color: MyColor.facebookColor),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        backgroundColor: MyColor.whiteColor,
                        onSurface: MyColor.facebookColor,
                        shadowColor: MyColor.facebookColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Color.fromRGBO(20, 130, 170, 0.8)))),
                  );
  }
}