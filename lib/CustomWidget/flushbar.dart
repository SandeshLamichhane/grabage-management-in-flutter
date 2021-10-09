 import 'package:flutter/material.dart';
 import 'package:another_flushbar/flushbar.dart';
import 'package:waste/confi/color.dart';

flush_msg(BuildContext context, String msg){
 
return Flushbar(
   
  message:  msg ,
  icon: Icon(
    Icons.info_outline,
    size: 25.0,
    color: Colors.blue[300],
    ),
  duration: Duration(seconds: 3),
  leftBarIndicatorColor: Colors.blue[300],
)..show(context);

}
  display_flush({ Key key1,
    BuildContext context, IconData iconData= Icons.info_outline_rounded,
     String title,String msg, Color color=MyColor.facebookColor, int sec=4})    {
  print("cosd");
 
      return Flushbar(
    leftBarIndicatorColor:  MyColor.backgroundColor,
    padding: EdgeInsets.all(10.0),
    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    icon:  Icon(iconData, color: MyColor.whiteColor, size: 20.0,),
    shouldIconPulse: true,
    backgroundColor: color,
    isDismissible: true,
     dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    duration: Duration(seconds: sec),
    forwardAnimationCurve: Curves.easeOut,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
    animationDuration: Duration(seconds: 1),
    showProgressIndicator: false,
      title: title,
  
    message: msg,
  ).show(context) ; 
 
}
  
 