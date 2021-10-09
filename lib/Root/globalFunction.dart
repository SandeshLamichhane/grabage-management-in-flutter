import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class globalFunction{
 LinearGradient customLinearGradient= new LinearGradient(
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        stops: [
                      0.2,
                      0.5,
                      0.8,
                      0.7
                    ],
                        colors: [
                      Colors.blue[50],
                      Colors.blue[100],
                      Colors.blue[200],
                      Colors.blue[300]
                    ]);
   LinearGradient customLinearGradient1= new LinearGradient(
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        stops: [
                      0.2,
                      0.5,
                      0.8,
                      0.7
                    ],
                        colors: [
                      Colors.blue[100],
                      Colors.blue[200],
                      Colors.blue[300],
                      Colors.blue[400]
                    ]);
}
Future<bool> hasInsternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


  Widget LoadingAlertDialog(String text) {
 
    return  AlertDialog(
        
        backgroundColor: Colors.white,
         content:
         
            Container(
                height: 50,
                  child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                 
                 child:     Container(
                   
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       CircularProgressIndicator(),
                       Text(text, style: TextStyle(color: Colors.black, fontWeight:FontWeight.w800,),)
                     ],
                   ),)
               
             ),)
           ));
        
  }

 

  void showLoading({String s, bool showHide}) {
    if(showHide==false){
      Get.back();
      return;
    }
      Get.dialog(
   Platform.isAndroid?  WillPopScope(  onWillPop: () async{  return false; }, 
      child: 
       LoadingAlertDialog(s) ):
      LoadingAlertDialog(s),
       barrierDismissible: true

            
       );
  }

  class DisplayLoading {
  @override
 static String text="Loading...";  static bool  currentstatus=false;
 
  DisplayLoading.show({String text="Laoding...", bool display})   {
   if(currentstatus==false && display==false){
  //no need to Get.back 
   return;
   }
   print(currentstatus.toString()+display.toString());
   if(currentstatus==true && display==true){
     // no need to display
     return;
   }  
   currentstatus=display;
   if(display==false){
     Get.back();
     return;
   }

    Get.dialog(
   Platform.isAndroid?  WillPopScope(  onWillPop: () async{  
     currentstatus=false;
     return true; }, 
      child: 
       LoadAlertDialog(text )):
      LoadAlertDialog(text),
       barrierDismissible: false

            
       );
 
 
  }

  static LoadAlertDialog(String text) {
     return  
     AlertDialog(
          
          backgroundColor: Colors.white,
           content:
              Container(
                  height: 50,
                    child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Center(
                   child:     Container(
  
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         CircularProgressIndicator(),
                         Text(text, style: TextStyle(color: Colors.black, fontWeight:FontWeight.w800,),)
                       ],
                     ),)
                 
               ),)
             ),
  ); 
  }
 
}
