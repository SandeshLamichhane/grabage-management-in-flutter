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


class TodayRoutes extends StatefulWidget {
 

  @override
  _TodayRoutesState createState() => _TodayRoutesState();
}

class _TodayRoutesState extends State<TodayRoutes> {
  DateTime dt= DateTime.now();
   final box=GetStorage();
 final _trackcontroller=Get.put(trackRoutesController());
   HDTRefreshController _hdtRefreshController = HDTRefreshController();

   String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 00);
  TextEditingController _timeController = TextEditingController();
final _streamController=Get.put(StreamDeviceController());



 @override
 void initState() { 
   super.initState();
   _trackcontroller.updateTime();
   _trackcontroller.getVehicleIdFromDriverId('jLVt8lWEktdmx2YIX131vXcXKYL2');
   _trackcontroller.retrieveTodayRouteForVehicleID('GA-1-TA-1289');
   _trackcontroller.updateBoxValueoftodayRoute();
   selectedTime=TimeOfDay(hour: 12, minute: 9) ;
  //_trackcontroller.currentTime;
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
              child: TextButton( child: Text("R-Route", style: TextStyle(color: Colors.white),),onPressed: (){
                _trackcontroller.retrieveSaturdayRoutesFromnewFirestoreRoute('GA-1-TA-1289');
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
       
           Obx(()=>
              _trackcontroller.hasNoofTodayRoutes!=true?Container(child: Center(child: Text("o Routes for today"),),):
          _trackcontroller.refreshTbale==true|| _trackcontroller.refreshTbale==false?
          
           Expanded(
               child: HorizontalDataTable(
                leftHandSideColumnWidth: 170,
                rightHandSideColumnWidth: 750,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder:_generateRightHandSideColumnRow,
                 itemCount:   _trackcontroller.listofTodayRoute.length,
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
                       _trackcontroller.retrieveTodayRouteForVehicleID('GA-1-TA-1289');
                  _hdtRefreshController.refreshCompleted();
                  setState(() {
                                 
                               });
                },
                htdRefreshController: _hdtRefreshController,
                 ),
                
                ): Container(),
           ),
      
         
            ],
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
            'Chowk/Maarg' , 170),
        onPressed: () {
 
        },
      ),
      

      _getTitleItemWidget('Oda', 50),      
      _getTitleItemWidget('Destined', 150),
      _getTitleItemWidget('Covered', 200),
       _getTitleItemWidget('Time', 150),
       _getTitleItemWidget('Upgrade', 200),
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
              _trackcontroller.listofTodayRoute[index].marga
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
                   child: Text( _trackcontroller.listofTodayRoute[index].oda),
                  width: 50,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
 
            
                  Container(
               child: Text( _trackcontroller.listofTodayRoute[index].destined),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),

                  Container(
                //child: Text(_addroutecontroller.listofRoutes[index].chowkLocation.latitude.toString()+'/'+
                //             _addroutecontroller.listofRoutes[index].chowkLocation.longitude.toString()),
              child:
                  _trackcontroller.listofTodayRoute[index].offline=="online"?
                  SwitchListTile(
                   title: Text(
                       
                      _trackcontroller.listofTodayRoute[index].covered?"Picked": "Not Picked"),
                   value:  _trackcontroller.listofTodayRoute[index].covered, 
                   onChanged: (val){
                     print("+++"+val.toString());
                    
                     _trackcontroller.changeCoveredAndTime(
                         _trackcontroller.listofTodayRoute[index].todayRouteId, 
                       val, 
                      _trackcontroller.listofTodayRoute[index].coveredTimed.toString(),
                       
                       (){
                         setState(() {
                             _trackcontroller.listofTodayRoute[index].covered=! _trackcontroller.listofTodayRoute[index].covered;
                         });
                       }

                     );

                 }): Padding(
                   padding: const EdgeInsets.only(left:14.0),
                   child: Text("Missed"),
                 ),
               
                width: 200,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
                Container(
                    width: 150,
                      height: 52,
                  child: 
                   _trackcontroller.listofTodayRoute[index].offline=="online"?
                  Row(
                    children: <Widget>[
                       IconButton(onPressed: ()async{
                          final TimeOfDay picker=   await   showTimePicker(context: context, initialTime:  selectedTime);
                               if(picker !=null){
                                  selectedTime=TimeOfDay(hour: picker.hour, minute: picker.minute);
                                 _trackcontroller.listofTodayRoute[index].coveredTimed=
                                 (selectedTime.hour.toString() +':'+ selectedTime.minute.toString());
                                 
                                 _trackcontroller.updateTimeofTrashed(_trackcontroller.listofTodayRoute[index].todayRouteId, selectedTime, (){
                                   print("Successfully updated time");
                                   setState(() {                  
                                 });
                                 });
                               }
                       }, icon: Icon(Icons.alarm)),
                    InkWell(
                      onTap: ()async{
                   
                      },
                      child: Container(
                      child: Text(  _trackcontroller.listofTodayRoute[index].coveredTimed.toString()),
                    
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                                  ),
                    ),
                    ]
                  ):Padding(padding: EdgeInsets.only(top:13, left:6), child: Text("Next Sat"))),
              
                Container(child:
           
                     _trackcontroller.listofTodayRoute[index].covered?
                     Text("Already picked"):
                     //if today is saturday //remanining routes
                     DateFormat('EEEE').format(DateTime.now())== "Saturday"? 
                     Text("Remaining routes."):
                    _trackcontroller.listofTodayRoute[index].offline=="online"? 
                 ElevatedButton( onPressed: (){
                       _trackcontroller.upgradeToSaturday(
                    todayRouteId:   _trackcontroller.listofTodayRoute[index].todayRouteId,    
                      vehicleId: _trackcontroller.listofTodayRoute[index].vehicleId,
                      maarg:  _trackcontroller.listofTodayRoute[index].marga,
                      odaNo: _trackcontroller.listofTodayRoute[index].oda,
                      interval:  _trackcontroller.listofTodayRoute[index].destined,
                      param1: (){
                    setState(() {
                     _trackcontroller.listofTodayRoute[index].offline="offline";
                    print( "///"+_trackcontroller.listofTodayRoute[index].offline);
                    });

                      });
                 } ,child: Text("Upgrade to Sat" )):
                  Text("Updated for Sat", style:TextStyle(fontSize: 15, fontWeight:FontWeight.w700, color:Colors.red)))
                 
              
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
