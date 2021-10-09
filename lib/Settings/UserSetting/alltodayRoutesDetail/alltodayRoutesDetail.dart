import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:waste/Settings/UserSetting/alltodayRoutesDetail/alltodayroutesController.dart';


class AllRoutes extends StatefulWidget {
  @override
  _AllRoutesState createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
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

    final _alltodayRouteController=Get.put(TodayAkkRoutesController());

  String _vehicleIdValue;


 @override
 void initState() { 
   super.initState();
 
  //_trackcontroller.currentTime;
  _alltodayRouteController.retrieveVehicleIDFromServer();
  _alltodayRouteController.retrieveMaargaFromServer();
  _alltodayRouteController.retrieveTodayRoutesFromnewFirestoreRoute();

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
          actions: [
              Obx(()=>(
                 DropdownButtonHideUnderline(child:
                  DropdownButton(
                   style:TextStyle(color: Colors.orange[700], decorationColor: Colors.green, fontWeight:FontWeight.w900),
                value : _alltodayRouteController.selectedVehicleId,
                  items:  _alltodayRouteController.listofVehicleId.map<DropdownMenuItem>((String item) {
                        return   DropdownMenuItem<String>(
                          child: Text (item),
                          value: item,
                        );
                  }).toList(),
                  onChanged: (value) {
                      _alltodayRouteController.changeVehicleId(value);
                  }),
                ) )
              ),
          ],
          title: 
          AutoSizeText( "Travelled history", style:TextStyle(fontWeight: FontWeight.w800))
     
        ),
        body: Container(
        
          child: Column(
            children:[
       Container(
      
        width: MediaQuery.of(context).size.width,
         color: Theme.of(context).primaryColor,
       child:Obx(()=>(
          Column(
           mainAxisSize:MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
                 Container(
                     color: Theme.of(context).primaryColor,
                   child:  Row(
                     children:[
  //FIRST DATE //?????????????????????????
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText( _alltodayRouteController.dt1, style:TextStyle( fontWeight:FontWeight.w500, color:Colors.white)),
              ),
                  IconButton(onPressed: ()async{
             var y=    await showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2016), lastDate :DateTime(2030));
          
          try{
            if(y!=null){
              print(y);
              print(DateTime.now()); 
                String  abc= DateFormat("yyyy-MM-dd").format(y).toString();
            _alltodayRouteController.changeDt1(abc);
            }
          }
          catch(e){
            print("erro"+e.toString());
          }
             }, icon: Icon(Icons.date_range, color:Colors.white)),

          Spacer()          ,
 Padding(
   padding: const EdgeInsets.all(8.0),
   child: AutoSizeText( _alltodayRouteController.dt2, style:TextStyle(fontWeight:FontWeight.w500, color:Colors.white)),
 ),
             
  //////////////////ITS THE SECOND DATE $$$$$$$$$$$$$$$$$$$
         IconButton(onPressed: ()async{
             var x=    await showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(1900), lastDate :DateTime(2050));
                if(x!=null){
                  String  abcd= DateFormat("yyyy-MM-dd").format(x).toString(); 
                _alltodayRouteController.changeDt2(abcd);
                }
             }, icon: Icon(Icons.date_range, color:Colors.white)),                                  
          ]
    )),
                
             
               
              Container(
                color:Colors.grey,
                child: DropdownSearch(
                  hint:"Search marga...",
                  onChanged:(va){
                   _alltodayRouteController.changeMarga(va);
                  },
                  showSearchBox:true,
                  items: _alltodayRouteController.listofMarg
                ),
              )
               
             
           ],
         ))
       )
       ),
// driver Id  associated with
       
           Obx(()=>
              _trackcontroller.hasNoofTodayRoutes==true ?Container(child: Center(child: Text("o Routes for today"),),):
          _trackcontroller.refreshTbale==true|| _trackcontroller.refreshTbale==false?
          
           Expanded(
               child: HorizontalDataTable(
                leftHandSideColumnWidth: 150,
                rightHandSideColumnWidth: 1100,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder:_generateRightHandSideColumnRow,
                 itemCount:    _alltodayRouteController.listofsearchModalItemp.length,
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
            'Chowk/Maarg' , 150),
        onPressed: () {
          _trackcontroller.listofRoutes.sort((a,b){
            a.interval.compareTo(b.interval);
            return 1;
          });
 
        },
      ),
      

      _getTitleItemWidget('Oda', 50),    
      _getTitleItemWidget('Date', 150), 
     _getTitleItemWidget('Baar', 100),   
      _getTitleItemWidget('Destined', 150),
      _getTitleItemWidget('Covered', 100),
       _getTitleItemWidget('Time', 100),
       _getTitleItemWidget('Vehicle', 150),

         _getTitleItemWidget('Driver', 100),
           _getTitleItemWidget('Updated', 150),
    
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
         child: Text(_alltodayRouteController.listofsearchModalItemp[index].marga),
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
                   child: Text(_alltodayRouteController.listofsearchModalItemp[index].oda),
                  width: 50,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
 
            
                  Container(
               child: Text(
             DateFormat("yyyy-MM-dd").format(  DateTime.fromMillisecondsSinceEpoch(
             _alltodayRouteController.listofsearchModalItemp[index].todayDate

, isUtc: true)).toString()
 
 
                 
                 
                 ),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                               Container(
                  width: 100,
                   child: Text(_alltodayRouteController.listofsearchModalItemp[index].baar)
               ),
                  Container(
               child: Text(_alltodayRouteController.listofsearchModalItemp[index].destined),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),

                  Container(
                //child: Text(_addroutecontroller.listofRoutes[index].chowkLocation.latitude.toString()+'/'+
                //             _addroutecontroller.listofRoutes[index].chowkLocation.longitude.toString()),
              child:
                    _alltodayRouteController.listofsearchModalItemp[index].covered?
                     Icon(Icons.check_box, color:Colors.green): Icon(CupertinoIcons.multiply_circle, color:Colors.red), 
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
                Container(
                  width: 100,
                   child: Text(_alltodayRouteController.listofsearchModalItemp[index].coveredTimed)
                    ),
                    
                Container(
                  width: 150,
                   child: Text(_alltodayRouteController.listofsearchModalItemp[index].vehicleId)
               ),


                  Container(
                  width: 100,
                   child: Text(_alltodayRouteController.listofsearchModalItemp[index].driverName)
               ),
                 Container(
                  width: 150,
                   child: Text( _alltodayRouteController.listofsearchModalItemp[index].
                   firestoreUpdloadtime.length>30?  _alltodayRouteController.listofsearchModalItemp[index].
                   firestoreUpdloadtime.substring(0,30).toString(): _alltodayRouteController.listofsearchModalItemp[index].
                   firestoreUpdloadtime.toString(),
                   
                   overflow: TextOverflow.fade,)
               ),

            ],
          ),
        ),
      ),
    );
  }
  String formatTimestamp(Timestamp timestamp) {
  var format = new DateFormat('y-MM-dd'); // 'hh:mm' for hour & min
  return format.format(timestamp.toDate());
}

   
 
}
