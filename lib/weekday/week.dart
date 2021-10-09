import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class Week{
  
String getWeekName(String incomingbaarweek){
 //determine next saturday 
 
 String weekbaar= DateFormat('EEEE').format(DateTime.now());
 int currentWeekInt= getIntFromWeekbaar(weekbaar);
 int incomingWeekInt= getIntFromWeekbaar(incomingbaarweek);
String returnValue="Null";
   incomingWeekInt<currentWeekInt?returnValue=incomingbaarweek :
 incomingWeekInt==currentWeekInt?returnValue="Today":
 incomingWeekInt==currentWeekInt-1?returnValue="Yestarday" :
 incomingWeekInt==currentWeekInt+1?returnValue="Tomorrow" :
  incomingWeekInt>currentWeekInt?returnValue=incomingbaarweek:returnValue="Saturday";
 return  returnValue;
}


getDaysLater(String incomingbaar){
   String weekbaar= DateFormat('EEEE').format(DateTime.now());
 int currentWeekInt= getIntFromWeekbaar(weekbaar);
 int incomingWeekInt= getIntFromWeekbaar(incomingbaar);

String returnValue="Null";
 incomingWeekInt==currentWeekInt?returnValue=DateFormat("MM-dd-yyyy").format(DateTime.now()):
 incomingWeekInt>currentWeekInt?returnValue=DateFormat("MM-dd-yyyy").format(DateTime.now().add(Duration(days: incomingWeekInt-currentWeekInt))):
incomingWeekInt<currentWeekInt?returnValue=DateFormat("MM-dd-yyyy").format(DateTime.now().add(Duration(days:(7-currentWeekInt)+incomingWeekInt))):
 
 returnValue="";
 return  returnValue;

}

  int getIntFromWeekbaar(String incomingbaar) {
    int incomingWeekInt=0;
    switch(incomingbaar){
   case  'Sunday':
   incomingWeekInt=0;
   break;

  case  'Monday':
   incomingWeekInt=1;
   break;

      case  'Tuesday':
   incomingWeekInt=2;
   break;

      case  'Wednesday':
   incomingWeekInt=3;
   break;

      case  'Thursday':
   incomingWeekInt=4;
   break;

      case  'Friday':
   incomingWeekInt=5;
   break;

      case  'Saturday':
   incomingWeekInt=6;
   break;

   default:
   incomingWeekInt=6;
   break;

 }

 return incomingWeekInt;
  }

 String nextSaturday(){
 //determine next saturday 
 int nextSat=0;
   String weekbaar= DateFormat('EEEE').format(DateTime.now());
    switch(weekbaar){
   case  'Sunday':
   nextSat=6;
   break;

  case  'Monday':
   nextSat=5;
   break;

      case  'Tuesday':
   nextSat=4;
   break;

      case  'Wednesday':
   nextSat=3;
   break;

      case  'Thursday':
   nextSat=2;
   break;

      case  'Friday':
   nextSat=1;
   break;

      case  'Saturday':
   nextSat=0;
   break;


   default:
   nextSat=1;
   break;

 }
 String abc;
 String currentDate= DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days:nextSat)));
 var nextSaturday=DateTime.now().add(Duration(days: nextSat));
  
 

 return  DateFormat("dd-MM-yyyy").format(nextSaturday);
}

nepaliMonthNameFromInt(int n){
  String returnvalue="";
   NepaliDateTime nepaliDateTime= DateTime.now().toNepaliDateTime();
 var myFormat=NepaliDateFormat('MM');
  var customDate=myFormat.format(nepaliDateTime).toString();
  
  int currentMonthInt=int.parse(customDate);
  if(n==0){
    n=currentMonthInt;
  }

   switch (n) {
     case 1:   returnvalue="Baisakh";  break;
         case 2:   returnvalue="Jestha";  break;
             case 3:   returnvalue="Ashad";  break;
                 case 4:   returnvalue="Shrawan";  break;
                     case 5:   returnvalue="Bhadra";  break;
                         case 6:   returnvalue="Ashoj";  break;
                             case 7:   returnvalue="Kartik";  break;
                                 case 8:   returnvalue="Mangsir";  break;
                                     case 9:   returnvalue="Poush";  break;
                                         case 10:   returnvalue="Magh";  break;
                                             case 11:   returnvalue="Falgun";  break;
                                           case 12:   returnvalue="Chaitra";  break;

     default:   returnvalue="Chaitra";  break;

   }
   return returnvalue;
}

nepaliMonthNametoint(String month){
 if(month==null){
   return;
 }
 int returnvalue=1;

   switch (month) {
     case "Baisakh":   returnvalue=01;  break;
         case "Jestha":   returnvalue=02;  break;
             case "Ashad":   returnvalue=03;  break;
                 case "Shrawan" :   returnvalue=04;  break;
                     case "Bhadra" :   returnvalue=05;  break;
                         case "Ashoj":   returnvalue=06;  break;
                             case "Kartik":   returnvalue= 07;  break;
                                 case "Mangsir" :   returnvalue=08;  break;
                                     case "Poush":   returnvalue=09;  break;
                                         case "Magh" :   returnvalue=10;  break;
                                             case "Falgun" :   returnvalue=11;  break;
                                           case "Chaitra" :   returnvalue=12;  break;

     default:   returnvalue=1;  break;

   }
   return returnvalue;
}





}