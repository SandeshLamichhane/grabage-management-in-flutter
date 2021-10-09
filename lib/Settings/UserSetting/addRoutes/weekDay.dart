import 'package:intl/intl.dart';

class WeekdayDifference{
 final  String  baar;

 WeekdayDifference({this.baar});

List<String>saturdayFormat=[];
//////////////////////////////////////// GET THE DIFFERENCE ////////////////////////////////////////////////////
int previousSundaywithTime(){
 //determine next saturday 
 int prevSun=0;
   String weekbaar= DateFormat('EEEE').format(DateTime.now());
    switch(weekbaar){
   case  'Sunday':
   prevSun=0;
   break;

  case  'Monday':
   prevSun=1;
   break;

      case  'Tuesday':
   prevSun=2;
   break;

      case  'Wednesday':
   prevSun=3;
   break;

      case  'Thursday':
   prevSun=4;
   break;

      case  'Friday':
   prevSun=5;
   break;

      case  'Saturday':
   prevSun=6;
   break;


   default:
   prevSun=1;
   break;

 }
  var previousSun=DateTime.now().subtract(Duration(days: prevSun));
 String xyz=  DateFormat("yyyy-MM-dd").format(previousSun);
 String  lastnight=  xyz+' 01:10:00';

 var dateTime=DateTime.parse(lastnight);
 int millisecondepoch=dateTime.millisecondsSinceEpoch;
 return  millisecondepoch;
}


/////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////// GET THE DIFFERENCE ////////////////////////////////////////////////////
int nextSaturdaywithTime(){
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
  var nextSaturday=DateTime.now().add(Duration(days: nextSat));
 String xyz=  DateFormat("yyyy-MM-dd").format(nextSaturday);
 String  lastnight=  xyz+' 23:59:00';

 var dateTime=DateTime.parse(lastnight);
 int millisecondepoch=dateTime.millisecondsSinceEpoch;
 return  millisecondepoch;
}


/////////////////////////////////////////////////////////////////////////////////////////////
List<String> nextSaturday(){
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
 String currentDate= DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days:nextSat)));
 var nextSaturday=DateTime.now().add(Duration(days: nextSat));
 saturdayFormat.add(DateFormat("dd-MM-yyyy").format(nextSaturday));
  saturdayFormat.add(nextSaturday.toString());
saturdayFormat.add(DateFormat("yyyy-MM-dd").format(nextSaturday));

 return  saturdayFormat;
}

 getWeekNameFromWeekInt(){
   var date = DateTime.now();
print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
 int today = (date.weekday); 
 print('//'+date.weekday.toString());
  String weekname;
switch(today){
   case  7:
   weekname='Sunday';
   break;

  case  2:
   weekname='Monday';
   break;

  case  3:
   weekname= 'Tuesday';
   break;

      case 4:
   weekname= 'Wednesday';
   break;

      case 5:
   weekname='Thursday';
   break;

  case 6:
   weekname='Friday';
   break;

      case 7:
   weekname= 'Saturday';
   break;


   default:
   weekname= 'Saturday';
   break;
 }
 print(weekname);
 return weekname;

 }
getWeekdayDifference(String baar){
var date = DateTime.now();
print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
 int today = (date.weekday)+1; 
 print(today.toString()+"today");
 int incoming=0;
 
 switch(baar){
   case  'Sunday':
   incoming=1;
   break;

  case  'Monday':
   incoming=2;
   break;

      case  'Tuesday':
   incoming=3;
   break;

      case  'Wednesday':
   incoming=4;
   break;

      case  'Thursday':
   incoming=5;
   break;

      case  'Friday':
   incoming=6;
   break;

      case  'Saturday':
   incoming=7;
   break;


   default:
   incoming=1;
   break;

 }
 int dateDiff=0;
 if(today<=incoming){
   dateDiff=incoming-today;
 }else{
  dateDiff= (7-today)+incoming;
 }

 return dateDiff;

 //we have incoming and current value  
//today 1 incoming 1=>0day //
//today 1 incoming 2=>1 days
//today 1 incoming 3=>2 days
//today 1 incoming 4=>3day
//today 1 incoming 5=>4 days
//today 1 incoming 6=>5 days
//today 1 incoming 7=>6 days

//today 2 incoming 1=>6day
//today 2 incoming 2=>0 days
//today 2 incoming 3=>1 days
//today 2 incoming 4=>2day
//today 2 incoming 5=>3 days
//today 2 incoming 6=>4 days
//today 2 incoming 7=>5 days

//today 3 incoming 1=>5day //(total-today)+incoming
//today 3 incoming 2=>6 days
//today 3 incoming 3=>0 days
//today 3 incoming 4=>1day
//today 3 incoming 5=>2 days
//today 3 incoming 6=>3days
//today 3 incoming 7=>4 days

//today 4 incoming 1=>4day
//today 4 incoming 2=>5 days
//today 4 incoming 3=>6 days
//today 4 incoming 4=>0day
//today 4 incoming 5=>1 days
//today 4 incoming 6=>2days
//today 4 incoming 7=>3 days

}

 }

 