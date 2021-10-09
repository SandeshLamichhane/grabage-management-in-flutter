import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
 
 import 'package:waste/Root/constant.dart';
import 'package:waste/Root/textfield.dart';
 import 'package:waste/Settings/UserSetting/addVehicle/addVehicleController.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:waste/Settings/UserSetting/addVehicle/vehicleModal.dart';

  

class AddTruck extends StatefulWidget { 

  @override
  _AddTruckState createState() => _AddTruckState();
}

class _AddTruckState extends State<AddTruck> {
  
   var _formKey= GlobalKey<FormState>();
   final _addVehicleController= Get.put(AddVehicleController());
   TextEditingController confirmDeleteController= new TextEditingController();
   String newDistrictName="";
   Map<String, dynamic> map= {'display': 'zya', 'value':"sas"};
   
   String vehicleNoValidator;

String selectDriverValidator;

TextEditingController _vehicleNoController;

List  _selectedDriverList;
 
 final Set <Marker> markerx= new Set();
 final Set <Circle> circlex= new Set();

String _myActivitiesResult;
  int incrementValue=-1;
List<dynamic> driverList;
 Timer _timer;


   @override
   void initState() { 
    
     super.initState();
    driverList=[map];
     _addVehicleController.loadAlltruckFromFirestore();
     _addVehicleController.retrieveDriverFromServer();
     vehicleNoValidator=null;
     selectDriverValidator=null;
     _vehicleNoController=new TextEditingController();
        _selectedDriverList = [];
       
    _myActivitiesResult = '';


   // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
   //  updateLatLangIn3Second(); // You can also call here any function.
    
  // });
   }
 
 
  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer!=null)_timer.cancel();
    super.dispose();
    _vehicleNoController.dispose();
    confirmDeleteController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    
    return SafeArea(
    child: Scaffold(
    appBar: AppBar(  
      title: Text('Trucks'),
      actions: [
        
          Padding(padding:EdgeInsets.only(top:8.0, left:10.0, right:20,bottom: 8 ),
         child: IconButton( icon : Icon(CupertinoIcons.arrow_2_circlepath), onPressed: (){
           _addVehicleController.loadAlltruckFromFirestore();
          

         },)
         ),

      

         Obx(()=>(
          ! _addVehicleController.showvehicleInMap? 
          Padding(padding:EdgeInsets.only(top:8.0, left:10.0, right:20,bottom: 8 ),
           child: IconButton( icon : Icon(CupertinoIcons.antenna_radiowaves_left_right), onPressed: (){
               _addVehicleController.changeshowvehiclesInMap(true);
                 _addVehicleController.listeningtoTruckLiveUpdate();
           },)
           )
          :
            Padding(padding:EdgeInsets.only(top:8.0, left:10.0, right:20,bottom: 8 ),
           child: IconButton( icon : Icon(CupertinoIcons.lightbulb_slash), onPressed: (){
               _addVehicleController.changeshowvehiclesInMap(false);

           },)
           )
         ),
         ),
        

        Padding(padding:EdgeInsets.only(top:8.0, left:10.0, right:20,bottom: 8 ),
          child:
             IconButton(icon: Icon(CupertinoIcons.sparkles),  onPressed: (){
              emptyValue();
               Get.bottomSheet(
                 GestureDetector(
                   onTap:(){ WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
} ,
                   child: Form(
                     key: _formKey,
                   child: Container(
                     color: Colors.cyan[900],
                     height: 360,
                     
                     child:ListView(
                       padding: EdgeInsets.symmetric(horizontal: 20.0),
                       children: <Widget>[
                         SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment:MainAxisAlignment.spaceBetween,
                           children: [ Text("Add New Vehicle", style:TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize:18.0)),
                           IconButton(onPressed: (){
                             Get.back();
                           }, icon: Icon(CupertinoIcons.multiply, color:Colors.white))
                           
                           ]
                           
                           ),
                        SizedBox(height: 10,),
                 // VEHICLE NO  #############################################################
                        simpleTextField(
                          customController: _vehicleNoController,
                          hintText: "Truck-No (GA-1-TA-1287 )",
                          onChnageField: (val){print(val); },
                          onValidator: (val){ return vehicleNoValidator ;}              
                          ),
                   
                         SizedBox(height: 10,),
                             
                    MultiSelectFormField(
                    
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.red),
                    ),
                     autovalidate: false,
                    chipBackGroundColor: Colors.blue,
                    chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    checkBoxActiveColor: Colors.blue,
                    checkBoxCheckColor: Colors.white,
                    dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    trailing:Icon(Icons.arrow_back, color:Colors.white), 
                    
                    title: Text(
                      "Select driver",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    fillColor: Colors.transparent,
                    errorText: "",
                    validator: (value) {
                     return selectDriverValidator;
                    },
                    
                    dataSource:  _addVehicleController.driverLists,
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    hintWidget: Text('(only two accepted)', style: TextStyle(color: Colors.white),),
                    initialValue: null,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                      _selectedDriverList=value;
                      
                      });
                    },
                                 ),
                              // ),
                                    SizedBox(height:20),
                    ClipRRect(
                      child:SizedBox(
                        height:50,
                        child:ElevatedButton(onPressed: ()async{
                              _formKey.currentState.save();
                               
                         var x =  await _addVehicleController.doesGadiNoAlreadyExists(_vehicleNoController.text.trim().toString());
                          vehicleNoValidator=x;
                       print(_selectedDriverList);
                   
                        var y= await _addVehicleController.doesDriverAlreadyExists(_selectedDriverList);
                            selectDriverValidator=y;        
                        
                         
                          if(_formKey.currentState.validate()) {
                              List<String>   str= _selectedDriverList.map((e) => e as String).toList();
                                List<String> listofdriversname=[];
                             List<String> listofdriversPhone=[];
                     

                              for(int i=0; i<str.length;i++){
                           var userDocument=  await _addVehicleController.loadPhoneNameFromUserId(str[i]);
                                      listofdriversPhone.add(userDocument['userPhone']);
                                       listofdriversname.add(userDocument['userName']);
                          print("////////////"+listofdriversPhone.toString()+listofdriversname.toString());

                              }
                             
                              
                              
                              _addVehicleController.AddNewVehicle( 
                                onSuceess: (){
                                  Get.back();
                                  _addVehicleController.loadAlltruckFromFirestore() ;
                                  setState(() {
                                                                     });
                                  },
                                 vehicleId: _vehicleNoController.text.trim().toString(), 
                                 driverIds:  str,
                                 listofdriversname: listofdriversname,
                                 listofdriversPhone:listofdriversPhone,
                                  );
                              
                          }
                        }, child: Text("Add New truck"))
                      )
                    )
                    ,SizedBox(height:20),
                       ]
                     )),
                                ),
                 ));
                
             },)
        ),
          ],
        
    ),
    body:
        
         Obx(()=>(
            !_addVehicleController.hasNoOfTrucks? Center(child: Container(child: Text("No Data Available,"),)):
       
             
               _addVehicleController.showvehicleInMap? displayVehicleInMAp():
                       ListView.builder(
               padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:10),
               itemCount: _addVehicleController.listOfVehicles.length,
               itemBuilder: (BuildContext context, int index){
                 return ExpansionPanelList(
                    animationDuration: Duration(milliseconds:1000),dividerColor: Colors.red,
                    elevation: 1,
            
                    children: [
                      ExpansionPanel(
                        headerBuilder:  (BuildContext context, bool isExpanded){
                             return  Row(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(13.0),
                                   child: index%2==0?
                                   Icon(CupertinoIcons.bus, 
                                   color: Colors.blue):Icon(Icons.car_rental_outlined, 
                                   color: Colors.red)
                                 ),
                                 Text(
                                 _addVehicleController.listOfVehicles[index].vehicleId,
                                 style: TextStyle(
                                     
                                   fontSize: 18,
                                   fontWeight:FontWeight.w900
                                 ),
                               ),]
                             );
                        }, 
            
                        
                         isExpanded:   _addVehicleController.listOfVehicles[index].expanded,
                        body:  Container(
                            padding: EdgeInsets.only(left:10.0, right:10.0, bottom:10.0),
                              child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start ,
                               mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
            
                                    Row(
                           mainAxisAlignment: MainAxisAlignment.start,   children: [
                                        Container(width: 120,child: Text("Lat  ", style:TextStyle(fontWeight: FontWeight.w600, fontSize:24))),
                                         Expanded(child: Text(_addVehicleController.listOfVehicles[index].geoPoint.latitude.toString(), style:TextStyle(fontWeight: FontWeight.w300, fontSize:20))),
                                      ],
                                    ),
                                    Divider(height: 1,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      
                                      children: [
                                        Container(width: 120,child: Text("Long  ", style:TextStyle(fontWeight: FontWeight.w600, fontSize:24))),
                                        Expanded(child: Text(_addVehicleController.listOfVehicles[index].geoPoint.longitude.toString(), style:TextStyle(fontWeight: FontWeight.w300, fontSize:20))),
                                      ],
                                    ),
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      
                                      children: [
                                        Container(width: 120,child: Text("Stream ", style:TextStyle(fontWeight: FontWeight.w600, fontSize:24))),
                                        Expanded(child: Text(_addVehicleController.listOfVehicles[index].streaming.toString()=="false"?"OFF":"ON", style:TextStyle(fontWeight: FontWeight.w300, fontSize:20))),
                                      ],
                                    ),
                                      Divider(height: 1,),
                                       Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container( width: 120, child: Text("Drivers ", 
                                        style:TextStyle(fontWeight: FontWeight.w600, fontSize:24))),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:<Widget>[
                                              for(int i=0; i<_addVehicleController.listOfVehicles[index].driverID.length; i++)
                                             
                                              Text('[ '+_addVehicleController.listOfVehicles[index].driverSName[i]+']',  style:TextStyle(fontWeight: FontWeight.w300, fontSize:20)),
                                                                                          
                                            ]          
                                        )
                                        
                                        ),
                                      ],
                                    ),
                         
                         
                          Divider(),
                                  SizedBox(height: 10,),
                                      InkWell(
                                        onTap: (){
            
            
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
                                      _addVehicleController.removeCurrentTruckFromServer(_addVehicleController.listOfVehicles[index].vehicleId,
                                         
                                           (){    
                                             _addVehicleController.loadAlltruckFromFirestore();
                                             setState(() {
                _addVehicleController.listOfVehicles[index].expanded =
              ! _addVehicleController.listOfVehicles[index].expanded;
            
                });                                         
                                           }
                                          );
                                }
                              }, 
                              child: Text("Confirm")),
                            )
                          )
                        ],
                      ),
                    )
                  );
             
             
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            child: AutoSizeText.rich(
                                            TextSpan(
                                              text: "if you want to remove truck ",
                                              style: TextStyle(fontWeight: FontWeight.w700,fontSize : 15,  color:Colors.green, fontStyle: FontStyle.italic)
                                              ,children: [
                                                TextSpan(
                                                  text: "Click here",
                                              style: TextStyle(fontWeight: FontWeight.w700,fontSize : 15,  color:Colors.red, fontStyle: FontStyle.italic)
                                                 )
                                              ]
                                              )
                                                                            ),
                                          ),
                                        ),
                                      ),
                               
                                    ],
                           ),
                            ),
                        )
                        
                    ],
                    expansionCallback: (int item, bool status) {
                setState(() {
                   _addVehicleController.listOfVehicles[index].expanded =
                  ! _addVehicleController.listOfVehicles[index].expanded;
                });
              },
                 );
               }
               
               )
            ))));
             
         
         
  }
  void emptyValue() {
     _selectedDriverList=[];
               _vehicleNoController.clear();
               vehicleNoValidator=null;
               selectDriverValidator=null;
  }

  Widget displayVehicleInMAp() {
      return Obx(()=>
             _addVehicleController.gettingStreamValue==true || _addVehicleController.gettingStreamValue==false?
             (
        GoogleMap(  
      mapType:MapType.hybrid,
        markers:  createMarker(),
        circles:createCircle() ,
        initialCameraPosition: CameraPosition(
        target: LatLng(28.0,  86.0),
          //   bearing: 192.8334901395799,
          // tilt: 0,
        zoom:  9.151926040649414
          ))
      ):Container());
  }


//CREATE MARKER FOR ALL VEHICLE ###################################################
Set<Marker> createMarker(){
markerx.clear();

for(int i=0;i<_addVehicleController.listOfVehicles.length; i++){
 markerx.add( Marker( //add second marker
  markerId: MarkerId(_addVehicleController.listOfVehicles[i].vehicleId.toString() ),
  position:  LatLng( _addVehicleController.listOfVehicles[i].geoPoint.latitude,
                         _addVehicleController.listOfVehicles[i].geoPoint.longitude,) , //position of marker
  infoWindow: InfoWindow( //popup info 
  title:_addVehicleController.listOfVehicles[i].vehicleId.toString() ,
 snippet: _addVehicleController.listOfVehicles[i].streaming? " ON ": " OFF "  ,
  ),
  icon: BitmapDescriptor.defaultMarker, //Icon for Marker
)  ); 
}
 
 return markerx;
 }

 Set<Circle> createCircle(){
circlex.clear();

for(int i=0;i<_addVehicleController.listOfVehicles.length; i++){
  
 circlex.add( Circle( //add second marker
  circleId: CircleId(_addVehicleController.listOfVehicles[i].vehicleId.toString() ),
  zIndex: 2,
   strokeColor: Colors.blue,
 fillColor: Colors.blue.withAlpha(70),
    radius: 20, 
  center:  LatLng( _addVehicleController.listOfVehicles[i].geoPoint.latitude,
                         _addVehicleController.listOfVehicles[i].geoPoint.longitude,) , //position of marker
   
  //Icon for Marker
)  ); 
}
 
 return circlex;
 }


List <LatLng>updateLatLangIn3Second(){
  print("Updating on 3 seconds");
  double lats=28.90; double longs=87.90;
  incrementValue++;
List<LatLng> listofLatLangs=[LatLng( lats+(incrementValue*0.1),longs+(incrementValue*0.1)), 
LatLng( lats+(incrementValue*0.11),longs+(incrementValue*0.12)), 
LatLng( lats+(incrementValue*0.13),longs+(incrementValue*0.05)), 
  ];
  
 print(listofLatLangs.toString());
return listofLatLangs;
}

}

////////////////////////////////////////////////////////////
 