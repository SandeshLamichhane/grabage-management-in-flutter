 
import 'package:flutter/material.dart';

Future<Widget> transparent_dialog(BuildContext context){

 
  return 
  
  showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          
          return WillPopScope(
             onWillPop:  () async => false,
                        child: Container(
              color: Colors.transparent,
              
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          );
        });

   

}