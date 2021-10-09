import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:waste/Constant/color.dart';

Widget build_logo(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RichText(
            text: TextSpan(
              text: 'Pokhara Waste Service',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 25,
                  fontWeight: FontWeight.bold,
                  color: whiteColor),
            ),
          ),
        ),
      )
    ],
  );
}


Widget buildContainer( BuildContext context){
 return Row(
   mainAxisAlignment: MainAxisAlignment.center,
   children: <Widget>[
                   ClipRRect(
                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                   
                   child: Container(
                     height: MediaQuery.of(context).size.height*0.6,
                     width: MediaQuery.of(context).size.width*0.8,
                     decoration: BoxDecoration(
                       color: darkwhiteColor,
                                 ),

                                 child: Column(
                                   mainAxisAlignment:  MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,

                                   children: <Widget>[
                                     Row(
                                         mainAxisAlignment:MainAxisAlignment.center,

                                         children: <Widget>[
                                           Text("Register to our Service",
                                            style:  TextStyle(
                                              fontSize: MediaQuery.of(context).size.height/30,

                                            ),
                                           )
                                         ],

                                     )

                                   ],
                                 ),
                                 
                   ),
                   )
   ],
   );

}