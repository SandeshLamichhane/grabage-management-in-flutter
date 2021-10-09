import 'dart:async';
 

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
 import 'package:waste/Root/constant.dart';
import 'package:waste/Settings/UserSetting/StreamMyDevice/StreamDevice.dart';
import 'package:waste/Settings/UserSetting/StreamMyDevice/StreamDeviceController.dart';
import 'package:waste/Settings/UserSetting/TrackRoutes/trackTodayRouteController.dart';
import 'package:intl/intl.dart';
import 'package:waste/Settings/UserSetting/trackHospitalRoutes/trackHospitalModal.dart';
import 'package:waste/Settings/UserSetting/trackHospitalRoutes/trackHospitalRouteController.dart';


class TrackHospitalRoutes extends StatefulWidget {
  @override
  _TrackHospitalRoutesState createState() => _TrackHospitalRoutesState();
}

class _TrackHospitalRoutesState extends State<TrackHospitalRoutes> {
 DateTime dt= DateTime.now();
 final box=GetStorage();
 final _trackcontroller=Get.put(trackRoutesController());
   final _trackhospitalcontroller=Get.put(HospitalRouteController());
 HDTRefreshController _hdtRefreshController = HDTRefreshController();
 String _setTime, _setDate;

 String _hour, _minute, _time;

 String dateTime;

 DateTime selectedDate = DateTime.now();

 TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 00);
 
 TextEditingController _timeController = TextEditingController();
  
 final _streamController=Get.put(StreamDeviceController());

String todayBaar="";
 @override
 void initState() { 
   super.initState();
   _trackcontroller.updateTime();
   _trackcontroller.getVehicleIdFromDriverId('jLVt8lWEktdmx2YIX131vXcXKYL2');
  todayBaar=DateFormat("EEEE").format(DateTime.now());
   
 
  //_trackcontroller.currentTime;
   _trackhospitalcontroller.retrieveTodayHospitalRoutesFromFirestoreRoute('GA-1-TA-1289');
 }
  @override
 void dispose() {
   super.dispose();
 }
   int selectedRow=-1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation:0,
          title: Obx(()=>Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [   
            Text(_trackcontroller.myVehicleId, style:TextStyle(fontWeight: FontWeight.w800)),
              Padding(padding: EdgeInsets.all(1.0),
              child: TextButton( child: Text("Create-Route", style: TextStyle(color: Colors.white),),onPressed: (){
              //  _trackcontroller.retrieveSaturdayRoutesFromnewFirestoreRoute('GA-1-TA-1289');
               //    _trackcontroller.retrieveTodayRouteForVehicleID('GA-1-TA-1289');
                  _trackhospitalcontroller.createTodayRouteForVehicleID('GA-1-TA-1289');


              },),
              ),
            ] )),
        ),
        body: Container(
          child: Column(
            children:[
            Container(height: 130,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
             child:Column(
         mainAxisSize:MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
               Container(
                   color: Theme.of(context).primaryColor,
                 child:  Obx(()=>Row(
                   children:[
                          Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: Text("Stream : ", textAlign: TextAlign.left, style:TextStyle(color: Colors.white, fontWeight:FontWeight.w800)),
                          ),
                            Switch(
                                       value: _streamController.isStreaming,
                                       onChanged: (value) {
                                         
                                        _streamController.setStreaming(value);
                                       
                                       },
                                       activeTrackColor: Colors.lightGreenAccent,
                                       activeColor: Colors.green,
                                     ),
                                     Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                
                                child: TextButton(
                                  style: ButtonStyle(
shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(9.0),
  side:BorderSide( width: 1, color:Colors.white
)))),
   onPressed: (){
     Get.to(StreamDriverDevice());
   }, child: Text("Edit", style:TextStyle(color:Colors.white))) 
                              ),
     
                                
                         ]
                 ))),
              

             
           Padding(
             padding: const EdgeInsets.only(left: 15.0, bottom:8),
             child: Text("Driver Name : "+box.read(boxuserName), textAlign: TextAlign.left, style:TextStyle(color: Colors.white, fontWeight:FontWeight.w800)),
           ),
            Obx(()=> Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Text(_trackcontroller.currentTime,textAlign: TextAlign.left,  style:TextStyle(color: Colors.white, fontWeight:FontWeight.w800)),
            )),
         ],
       )
       ),
// driver Id  associated with
       
          GetBuilder(
            init:HospitalRouteController() ,
            builder:  (  context){
             
          return
           Expanded(
               child: HorizontalDataTable(
                leftHandSideColumnWidth: 170,
                rightHandSideColumnWidth: 950,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder:_generateRightHandSideColumnRow,
                 itemCount:    _trackhospitalcontroller.listoftodayHospitalRoute.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Color(0x02020200),
                 rightHandSideColBackgroundColor:  Color(0x00551020),
                verticalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.yellow,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.red,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                enablePullToRefresh: true,
                refreshIndicator: const WaterDropHeader(),
                refreshIndicatorHeight: 60,
                onRefresh: () async {
                  //Do sth
                     _trackhospitalcontroller.retrieveTodayHospitalRoutesFromFirestoreRoute('GA-1-TA-1289');
                  _hdtRefreshController.refreshCompleted();
                  setState(() {                              
                               });
                },
                htdRefreshController: _hdtRefreshController,
                 ),
                
                ); 
            }
      
         
           ) ],
          )
        ),
        
      ),
    );
  }

   List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Hospital Name' , 170),
        onPressed: () {
 
        },
      ),
      

      _getTitleItemWidget('Maarga', 150),      
      _getTitleItemWidget('Destined', 150),
      _getTitleItemWidget('WeekDay', 150),
      _getTitleItemWidget('Covered', 250),
       _getTitleItemWidget('Time', 250),
  
    ];
   }

   Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,)),
      width: width,
      height: 56,
      decoration:BoxDecoration(
        color:  Color(0xFF3333FAFF),

      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
  //////////////////////////////////////////////////////////////////
  
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap:(){
       setState(() {
                selectedRow=index;        
              });    
                },
      child: InkWell(
        onTap: (){
          // BotToast.showText(text: users.userdetail[index].userPhone );
              setState(() {
                selectedRow=index;        
              });
        },
        child: Tooltip(
          message: "Double tap to edit",
          child: Container(
             color:  selectedRow==index?Colors.blueGrey: Colors.transparent,
           child: Text(
              _trackhospitalcontroller.listoftodayHospitalRoute[index].HospitalName
             //_trackcontroller.tracktodayRouteModal[index].marga
             
             ),
            width: 170,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }
      
   
  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return GestureDetector(
     
      child: InkWell(
        onTap: (){
          print(index.toString()+'/'+selectedRow.toString());
          setState(() {
            selectedRow=index;
          });
        },
        child: Container(
          color:  selectedRow==index?Colors.blueGrey : Colors.transparent,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap:(){
                },
                child: Container(
                   child: Text(   _trackhospitalcontroller.listoftodayHospitalRoute[index].maarga),
                  width: 150,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
 
            
                  Container(
               child: Text(   _trackhospitalcontroller.listoftodayHospitalRoute[index].destined),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                  Container(
               child: Text(   _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.toString()),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),

                  Container(
                //child: Text(_addroutecontroller.listofRoutes[index].chowkLocation.latitude.toString()+'/'+
                //             _addroutecontroller.listofRoutes[index].chowkLocation.longitude.toString()),
              child:
          SwitchListTile(
             title: Text( 
       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('All weekday') &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered.contains('null')? 'Not picked':

_trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('All weekday') &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered.contains('Picked')? 'Picked' :

       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') 
       &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=='null' &&
     _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=='null'    ?
         "Not picked" :
         _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null"
         ?"Picked"+' [ '+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)+" ] " :
 
 
 _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]==todayBaar           ?
  "Picked"+' [ '+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)+
  ","+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+ " ]"
         : 

   _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar  
         ?
  "Already Picked"+' [ '+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)+
  ","+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+ " ]"  :      
      

////////////////////ITS THE  THRICE THE WEEKDAY ###############################################
       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
         ?"Not picked" :

     _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
            _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]==todayBaar && 
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null" 
         ?
        "Picked-1"+' [ '+
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)+ ",  -  " + ',  -  '
 // ","+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+ 
 // "," + _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2].toString().substring(0,3) + 
  " ]"
         :

         _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
         ?"Picked-1 [ "+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)
         + " , pick" +" ,  ]" :

               _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!= todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]==todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
         ? "Picked-2 [ "+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)
         + ","+_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+       
           " ,  ]"  :

        _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
         ?"Picked-2 [ "+
   _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)
  + " , "+ _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)+
  " , "+ " - " +" ]" :
 
// thrice option all true
    _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!= todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]==todayBaar
         ?  "All picked [ "+
          _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)
     + ", "+_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+       
   ", "+_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2].toString().substring(0,3) +"]"  :


// thrice option all picked
    _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!= todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]!=todayBaar
         ?  "Already picked [ "+
          _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0].toString().substring(0,3)
     + ", "+_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1].toString().substring(0,3)+       
   ", "+_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2].toString().substring(0,3) +"]"  :

       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains(DateFormat('EEEE').format(DateTime.now())) &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="null"?"Not picked" :

        _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains(DateFormat('EEEE').format(DateTime.now())) &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="Picked"?"Picked" :""
        ),
        

//////////////////////////////////////updating on value field
       value:  
       
         _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('All weekday') &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered.contains('')?false:

      _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('All weekday') &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered.contains('Picked')? true :

       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null"
         ? false :

      _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]== todayBaar 
         ? true : 
 
         
         _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
          _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]== todayBaar 
         ? true:

     _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Twice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!="null" &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!= todayBaar 
         ? false:
                         
      
                         
////////////////////////////////////////////////// THRICE Q WEEK DAY ?????????????????????????????
       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
         ? false :

     _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
               _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]== todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"  
         ? true:


    _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]=="null" &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null" 
         ? false:

           _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]==todayBaar  &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]=="null"
     
         ? true:

//thrice 3rd option false option thrice
         _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar&&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]!=todayBaar  
         ? false:
         
//thrice option for true
    _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]==todayBaar  
         ? true:
//already picked for thrice option
    _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains('Thrice weekday') &&
       _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[1]!=todayBaar &&
      _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[2]!=todayBaar  
         ? false:
///////////////////////////////////////////////////////////////////////////////////////its a logic here
       _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains(DateFormat('EEEE').format(DateTime.now())) &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="null"? false :

        _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar.contains(DateFormat('EEEE').format(DateTime.now())) &&
        _trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]=="Picked"?true :false,
   
   onChanged: (val){
 print(_trackhospitalcontroller.listoftodayHospitalRoute[index].covered[0]);
         
        _trackhospitalcontroller.updateCoveredTimex(
          _trackhospitalcontroller.listoftodayHospitalRoute[index].todayRouteId, 
          _trackhospitalcontroller.listoftodayHospitalRoute[index].covered,
          _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar,
          
            val,  
            (){
              print("Successfully added");
              _trackhospitalcontroller.retrieveTodayHospitalRoutesFromFirestoreRoute("GA-1-TA-1289");
            });
                       },),

                              
                 
                width: 250,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
                Container(
                    width: 250,
                      height: 52,
                 
                  child: 
                  ! _trackhospitalcontroller.listoftodayHospitalRoute[index].coveredTime.contains('covered')?
                  Row(
                    children: <Widget>[
                       IconButton(onPressed: ()async{
                   
                             final TimeOfDay timeOfDay=   await   showTimePicker(context: context, initialTime:  selectedTime);
                            if(timeOfDay==null) return;
                             
                                
                                  selectedTime=TimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);
                                 
                          _trackhospitalcontroller.updateTimeofTrashed(
          _trackhospitalcontroller.listoftodayHospitalRoute[index].todayRouteId, 
          _trackhospitalcontroller.listoftodayHospitalRoute[index].covered,
           _trackhospitalcontroller.listoftodayHospitalRoute[index].coveredTime,
          _trackhospitalcontroller.listoftodayHospitalRoute[index].weekBaar,
         selectedTime,
            (){
               _trackhospitalcontroller.retrieveTodayHospitalRoutesFromFirestoreRoute("GA-1-TA-1289");
            });
                     
                           
                       }, icon: Icon(Icons.alarm)),
                    InkWell(
                      onTap: ()async{
                      },
                      child: Container(
                      child: Text(_trackhospitalcontroller.listoftodayHospitalRoute[index].coveredTime.toString()),
                    
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                                  ),
                    ),
                    ]
                  ):Padding(padding: EdgeInsets.only(top:13, left:6), child: Text("Next Sat"))),
   
                  
              
            ],
          ),
        ),
      ),
    );
  }

  timeWidget() {
      InkWell(
                  onTap: () {
                   
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width:100,
                    height:  50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                       // _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                       controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ));
  }

  void _selectTime(BuildContext context) {
      Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
   //     _timeController.text =   
  
  });
      }
  }
 
}
