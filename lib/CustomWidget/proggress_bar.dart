import 'package:flutter/material.dart';
import 'package:waste/confi/color.dart';

void showLoadingIndicator(BuildContext context, [String text]) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          backgroundColor: MyColor.backgroundColor,
          title: Text(text, style: TextStyle(fontFamily: "Brand Bold", fontSize: 15.0, 
          color: MyColor.facebookColor),),
          content: Container(
            height: 3,
            child: LinearProgressIndicator(
              
              backgroundColor: MyColor.facebookColor, 
              valueColor: AlwaysStoppedAnimation<Color> (MyColor.activeColor),
            ),
          ),
          elevation: 1,
          actions: <Widget>[
                /*    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("okay"), 
                    ), */
                  ],
         
        )
      );
    },
  );
}
 