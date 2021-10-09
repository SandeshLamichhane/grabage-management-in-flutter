import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
 import 'package:waste/Root/constant.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addRoutes/EditRoutes.dart';
import 'package:waste/Settings/UserSetting/addRoutes/addRouteController.dart';
import 'package:waste/Settings/UserSetting/addRoutes/weekDay.dart';
 
class AddRoutes extends StatefulWidget { 

  @override
  _AddRoutesState createState() => _AddRoutesState();


}

class _AddRoutesState extends State<AddRoutes> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
   var _formKey= GlobalKey<FormState>();

   var weekdaydifobj=WeekdayDifference();

   TextEditingController confirmDeleteController= new TextEditingController();
   TextEditingController newmargController= new TextEditingController();

   
   TextEditingController  truckN= new TextEditingController();
   TextEditingController description= new TextEditingController();
   
   
 StreamSubscription _locationSubscription;

static final CameraPosition initialLocation= CameraPosition(target: LatLng(28.1833432777335, 83.9861154408866), zoom: 14.47);



   String newOdaNo="";
   String bar="";
   String interval="";
   String truckNo="";


Marker marker;

 
 Circle circle;  
GoogleMapController myController;
 LatLng currentlatLng=
 
 new LatLng(0.0, 0.0);

String odaValidator;
String maargValidator;
String baarValidator;
String pugneTimeValidator;
String vehicleIDValidator;
String chowkLatLongvalidator;
 


TextEditingController textodaController=  new TextEditingController();
String selectedOdaNo;
String selectedMarg;
String selectedBar;
String selectedInterval;
String selectedVehicleId;
LatLng selectedlatLongchowk;

final _addroutecontroller= Get.put(AddRouteController());
 
  TabController tabcontroller;
    final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];
 
@override
   void initState() { 
      super.initState();
     

     _addroutecontroller.retrieveVehicleIDFromServer();
     _addroutecontroller.loadAllRoutesFromFirestore();
  
    makeEMptyselected();
       odaValidator=null;
       maargValidator=null;
        baarValidator=null;
       pugneTimeValidator=null;
        vehicleIDValidator=null;
        chowkLatLongvalidator=null;
         
   }
  int selectedRow=-1;
@override
void dispose() { 
  textodaController.dispose();
  newmargController.dispose();
 confirmDeleteController.dispose();  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
       
      child: SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text('Add your All Routes'),
        bottom:TabBar(tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(icon: Icon(Icons.directions_transit)),
        ]),
        
          
      ),
      body:TabBarView(
          
            children: [
               
          
          
           Obx(()=>(
              !_addroutecontroller.hasNumberofRoutes? Container(child:Center(child: Text("No data available")),):
              _addroutecontroller.refreshTable==true|| _addroutecontroller.refreshTable==false? 
              
               HorizontalDataTable(
              leftHandSideColumnWidth: 150,
              rightHandSideColumnWidth: 950,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder:_generateRightHandSideColumnRow,
               itemCount: _addroutecontroller.listofRoutes.length,
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
               
                
                _addroutecontroller.loadAllRoutesFromFirestore();
                _hdtRefreshController.refreshCompleted();
                setState(() {
                               
                             });
              },
              htdRefreshController: _hdtRefreshController,
               ): Container()
               )


           )
           ,

            addNewRouteWidget()
           ],
           
             ))));
  }


         
           
           
   
         
      
      
 List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Chowk/Maarg' ,
            150),
        onPressed: () {
        //  addOdaControler.loadAllOdaNo();
           
        },
      ),
      

      _getTitleItemWidget('Oda', 50),      
      _getTitleItemWidget('Rotation', 150),
      _getTitleItemWidget('Truck', 150),
       _getTitleItemWidget('Date', 150),
       _getTitleItemWidget('Interval', 150),
       _getTitleItemWidget('LatLng', 200),
         _getTitleItemWidget('Delete', 100),
      
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

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap:(){


       setState(() {
                selectedRow=index;        
              });    
          Get.to(EditRoutes(
           selectedRouteId: _addroutecontroller.listofRoutes[index].routeId,
           selectedOdaNo: _addroutecontroller.listofRoutes[index].oda,
           selectedMarg: _addroutecontroller.listofRoutes[index].marga,
           selectedBar:  _addroutecontroller.listofRoutes[index].baar,
           selectedInterval: _addroutecontroller.listofRoutes[index].interval,
           selectedVehicleId:  _addroutecontroller.listofRoutes[index].truckNo,

           selectedlatLongchowk: 
            LatLng(_addroutecontroller.listofRoutes[index].chowkLocation.latitude,
            (_addroutecontroller.listofRoutes[index].chowkLocation.longitude)

          )
          ));
              
                      print("doble tap");  },
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
            child: Text(_addroutecontroller.listofRoutes[index].marga.toString()),
            width: 150,
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
      onDoubleTap: (){
            print(index.toString()+'/'+selectedRow.toString());
          setState(() {
            selectedRow=index;
            
          });
      },
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
                  child: Text(_addroutecontroller.listofRoutes[index].oda),
                  width: 50,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
      
            
              Container(
                child: Text(_addroutecontroller.listofRoutes[index].baar),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
    
                  Container(
                child: Text(_addroutecontroller.listofRoutes[index].truckNo),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                 Container(
                child: Text( 
                  
                  
                weekdaydifobj.getWeekdayDifference(_addroutecontroller.listofRoutes[index].baar).toString()+ ' days later'),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                  Container(
                child: Text(_addroutecontroller.listofRoutes[index].interval),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                  Container(
                child: Text(_addroutecontroller.listofRoutes[index].chowkLocation.latitude.toString()+'/'+
                             _addroutecontroller.listofRoutes[index].chowkLocation.longitude.toString()),
                width: 200,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
                Container(
                child: IconButton(onPressed: ()async{
               deleteRouteFromServer(_addroutecontroller.listofRoutes[index].routeId);

                  
               
                }, icon: Icon(Icons.delete)),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ADDING NEW ROUTE WIDGET %%%%%%%%%%%%%%%%%%%%
  addNewRouteWidget() {
     return Form(
                   key: _formKey,
                   child: Container(
                   child:ListView(
                   padding: EdgeInsets.symmetric(horizontal: 20.0),
                   children: <Widget>[
                      SizedBox(height: 10,),
                    AutoSizeText("Gadi chalne route थप्नुहोस्  . ", 
                         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
                         SizedBox(height:15),                  
//                              // FIRST ODA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
              Obx(()=>(
                DropdownSearch(
                              selectedItem:  _addroutecontroller.odaObs,
                              onChanged:(value){ selectedOdaNo=value;  _addroutecontroller.changeOda(value);  } ,
                                validator: (val){
                                        return odaValidator;
                                },
                                searchBoxDecoration: InputDecoration(
                                  labelText: "Search oda...",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                ),
                                 
                                mode: Mode.MENU,
                                showSearchBox: false,
                                label:"ओडा छान्नुहोस्",
                                items:  ['07', '17' ''],
                              )
              ),),
                      
                            SizedBox(height:15),
// FIRST ODA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   MAARGA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        MargTextField(           
                          hintText: " मार्ग ya chowk lekhnu hos", 
                          onChnageField: (value){
                            selectedMarg=value
;                          }, 
                          onValidator:(value){
                            return maargValidator;
                          } ,    
                        ),
    //////////////////////////// ,This is FOR BAAR ###############################
      SizedBox(height:15),
            Obx(()=>(
              DropdownSearch(
                selectedItem:_addroutecontroller.barObs,
                 onChanged:(value){    selectedBar=value; _addroutecontroller.changebar(value);
                                } ,
                  validator: (val){  return baarValidator;    },
                 searchBoxDecoration: InputDecoration(
                                  labelText: "Search ...",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                ),
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                label:"यो मार्गमा गाडी जाने बार",
                                items:  ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
                              )))
            ,
                       
                           SizedBox(height:10),
 ////////////////////////////////////////// TIME INTERVAL //////////////////////////////////////////////////ROUTE
    TimeInterValTextField(
      
      hintText: "Pugne Time(2.10-4.10/AM)",
      onValidator: (value){
        return pugneTimeValidator;
      },
      onChnageField: (value){
         selectedInterval=value;
      },
    
    ),
    
 //   ////////////////// vehicle id validator // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
     SizedBox(height: 10,),
      Obx(()=>(
         DropdownSearch(
                       selectedItem: _addroutecontroller.vehicleIdObs,
                      onChanged:(value){ 
                        selectedVehicleId=value; 
                        _addroutecontroller.changeVehicleId(value); 
                        } ,
                     validator: (val ){
                       return  vehicleIDValidator;
                     },
                    searchBoxDecoration: InputDecoration(
                                  labelText: "Search Vehicle NO...",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                ),
                
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                label:"Gaadi छान्नुहोस्",
                                items:   _addroutecontroller.listofVehicleId
            )),      ),
                         
////////////////////////////////// LATITUDE AND LONGITUDE  ////////////////////////////////////////////////////////////
              SizedBox(height: 15,),
              AutoSizeText("Help App to find chowk", style:TextStyle(fontSize: 14, color:Colors.grey)),
                   
              Container(
                     height:60,
                            decoration: BoxDecoration(
                               shape: BoxShape.rectangle,
                               borderRadius: BorderRadius.circular(5.0),
                               border: Border.all(width:1.5, color:Colors.grey)),
                          child:InkWell(
                            onTap:(){
                     Get.defaultDialog(
                       title: "Find  your input chowk",
                       content:Container(
                          height: (MediaQuery.of(context).size.height-300),
                         width:double.infinity,
                         child:googleMap()
                       )
                       ,
                       cancel: Container(
                         width: double.maxFinite,
                         child: TextButton(onPressed: (){
                           Get.back();
                           setState(() {
                             
                           });
                         }, child: Text("Ok")))
                     );
                    
                   }, child:  Align(
                     alignment:Alignment.centerLeft,
                  child:   Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: Obx(()=>(
                       AutoSizeText("Lat : " +_addroutecontroller.chwoklatlong.latitude.toString()+ 
                      "   Lng : "+_addroutecontroller.chwoklatlong.longitude.toString(), textAlign: TextAlign.left)
                    )),
                  )
                   ))),
                   
                 SizedBox(height: 20,),
                    ClipRRect(
                      child:SizedBox(
                        height:50,
 child:ElevatedButton(onPressed: ()async{
                       
     
     
    
//FIRST OF ALL LETS VALIDATE ODA #####################################################
 _addroutecontroller.changeisEdit(false);
var x =  await _addroutecontroller.validateOda( selectedOdaNo);
odaValidator=x;
var y =  await _addroutecontroller.validateMarg( selectedMarg);
maargValidator=y;
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var z =  await _addroutecontroller.validateBar( selectedBar);
baarValidator=z;
var a =  await _addroutecontroller.validateInterval( selectedInterval);
pugneTimeValidator=a;
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var b =  await _addroutecontroller.validatevehicleId(selectedVehicleId);
vehicleIDValidator=b;
var c =  await _addroutecontroller.validateChowkLatLnf( selectedlatLongchowk);
chowkLatLongvalidator=c;
 
if(_formKey.currentState.validate()  ) {
  //cov
  _addroutecontroller.addNewRoutes(
    oda: selectedOdaNo,
    marg: selectedMarg,
    baar: selectedBar ,
    timeInterval:selectedInterval ,
    gaadiNo: selectedVehicleId ,
   
    chowkLocation: selectedlatLongchowk,
    onSuceess: ()async{
     await  makeEMptyselected();               
      selectedlatLongchowk= LatLng(0.0, 0.0);
       _formKey.currentState.reset();  
       _addroutecontroller.listofRoutes=[];
      //  _addroutecontroller.loadAllRoutesFromFirestore();
       setState(() {
         
       });
    }
     
  ) ;
}       
//  
                       },
                        
                       child: Text("Add New CHowk"))
                      )
                    )
                    ,SizedBox(height:20),
                       ]
                     )),
                 );
    
  }


void updateMarkerAndCircle(LatLng latLng){
    //LatLng latlng= LatLng(locationData.latitude,locationData.longitude);
    print(latLng.longitude.toString()+latLng.longitude.toString()+",,,,,,,,,,,,,,,,,,,,,,,,");
    this.setState(() {
      marker=
      Marker(
         infoWindow: InfoWindow(title: "Find this chowk", snippet:"Hold and Move to set"),
         markerId: MarkerId("chowkID"),
        position:latLng,
        draggable: true,
          zIndex: 1,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon:  BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
                   currentlatLng= new LatLng(newPosition.latitude, newPosition.longitude);
           print("//new"+ newPosition.longitude.toString());
           print("current"+currentlatLng.longitude.toString());

          })
      );
      
    });

}

  googleMap() {
  
   return  GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set.of(<Marker> [Marker(
         infoWindow: InfoWindow(title: "Find chowk", snippet:"Hold and Move to set"),
         markerId: MarkerId("chowkID"),
        position: LatLng(28.1833432777335, 83.9861154408866),
        draggable: true,
          zIndex: 1,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon:  BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
                   currentlatLng= new LatLng(newPosition.latitude, newPosition.longitude);
             selectedlatLongchowk =LatLng(currentlatLng.latitude, currentlatLng.longitude);
          _addroutecontroller.changechok(GeoPoint(selectedlatLongchowk.latitude, selectedlatLongchowk.longitude));

          })
      )
          ]),
         
          initialCameraPosition:  CameraPosition(target: LatLng(28.2433432777335, 83.9961154408866), zoom:14),
          onMapCreated:  (GoogleMapController controller){
           myController=controller;
          },
           
          
          //(GoogleMapController controller) {
         //   _controller.complete(controller);
        //  },
              );
              
  }
  //////////////////////////////HELP US TO FIND &&&&&&&&&&&&&&&&&&&&&
  changePosition(LatLng latLng){
      if(myController !=null){
             myController.animateCamera(CameraUpdate.newCameraPosition(           
               new CameraPosition(       
                 bearing: 192.8334901395799,
                 target:  LatLng(latLng.latitude,  latLng.longitude),
                 zoom: 18.0,
                 tilt: 0,
                 )
             ));

             updateMarkerAndCircle(latLng);
           }

}

    makeEMptyselected() async{
      _addroutecontroller.changeOda(null);
      _addroutecontroller.changebar(null);
      _addroutecontroller.changeVehicleId(null);
       _addroutecontroller.changechok(GeoPoint(0.0,0.0));
      selectedOdaNo="";
    selectedMarg='';
  selectedBar='';
  selectedInterval='';
  selectedVehicleId='';
  selectedlatLongchowk= LatLng(0.0, 0.0);
   
  }

  void deleteRouteFromServer(String routeId) {
     Get.bottomSheet(
                    Container(
                         height: 200,
                         color:Colors.white,
                         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            child: DeleteTextField(
                              iconData: Icons.games,
                              hintText: "Enter { remove } to delete.",
                              onChnageField: (value){              
                              },
                              nameController: confirmDeleteController,
                            )
                          ),
                          SizedBox(height: 20,),
                          ClipRRect(
                            child: SizedBox(
                              height:50,
                              width:double.maxFinite,
                              child: ElevatedButton(onPressed: () async {
                                
                                if(confirmDeleteController.text.trim()=='remove'){
                                  //suucess ful
                                  confirmDeleteController.clear();
                                  Get.back();
                   _addroutecontroller.deleteFromServer(
                        routeId,  () async{
                     await _addroutecontroller.loadAllRoutesFromFirestore();
  
                           });
                                           }
                              },
                       
                              child: Text("Confirm"),
                              )
                              ,
                            )
                          )
                        ],
                      ),
                    )
                  );
  } 



  }
////////////////////////////////////////////////////////////
