import 'dart:ui';
 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waste/confi/color.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Color Incoming_color;

  const CustomDialogBox({Key key, this.title, 
  this.descriptions, this.text, this.Incoming_color=Colors.green}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,// color transparent
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[

        Container(
          padding: EdgeInsets.only(left: 20,top:45.0+ 20.0, 
          right: 20.0, bottom:  40.0
          ),
          margin: EdgeInsets.only(top:45.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(45.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.7),offset: Offset(0,10),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600, color: widget.Incoming_color)),
              SizedBox(height: 15,),
              Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.text,style: TextStyle(fontSize: 18, color: MyColor.activeColor),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20.0,
            right: 20.0,
            child: CircleAvatar(
              backgroundColor:  Colors.transparent,
              radius: 45.0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  child: Image.asset("assets/logo.png")
              ),
            ),
        ),
      ],
    );
  }
}

