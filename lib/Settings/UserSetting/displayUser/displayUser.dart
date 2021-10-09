import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

 class DisplayuserFromId extends StatefulWidget {

String userId;
DisplayuserFromId({@required this.userId});

   @override
   _DisplayuserFromIdState createState() => _DisplayuserFromIdState();
 }
 
 class _DisplayuserFromIdState extends State<DisplayuserFromId> {
   @override
   Widget build(BuildContext context) {
     return SafeArea(
       child: Scaffold(
     
         body: ListView(
             padding: EdgeInsets.symmetric(horizontal: 20.0),
             children: <Widget>[
               AutoSizeText("Display User"),
                Row(children: [
                    AutoSizeText("Name : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),
                  Row(children: [
                    AutoSizeText("UserPhone : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),
                  Row(children: [
                    AutoSizeText("UserRole : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),
                  Row(children: [
                    AutoSizeText("UserJoinedDate : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],), 
                 Row(children: [
                    AutoSizeText("UserBlocked : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),
                  Row(children: [
                    AutoSizeText("Name : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),

                  Row(children: [
                    AutoSizeText("Name : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),
                  Row(children: [
                    AutoSizeText("Name : " , style:  TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow),),
                      Expanded(child: AutoSizeText("asbhbvashcv /////////////////////////////////////ssvacva")) 
                ],),

             ],
         )
       ),
     );
   }
 }