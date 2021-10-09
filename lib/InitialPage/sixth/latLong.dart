import 'dart:async';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:waste/InitialPage/sixth/latlangController.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
 

class LATLONG extends StatefulWidget {

  @override
  _LATLONGState createState() => _LATLONGState();
}

class _LATLONGState extends State<LATLONG> {

final _classcontroller= Get.put(latlongController());
Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;

LocationData _locationData;
 
Marker marker;

static final CameraPosition initialLocation= CameraPosition(target: LatLng(28.39382, 86.9834,), zoom: 14.47);

 Circle circle;  
GoogleMapController myController;

     LatLng currentlatLng= new LatLng(0.0, 0.0);

final box=GetStorage();
String  homeInfo="आफ्नो घर भएको ठाउँमा, नक्सामा रहेको मार्कर लगेर राख्नुहोस";
String hospitalinfo="आफ्नो अस्पताल / ल्याब भएको ठाउँमा,  तलको मार्कर लगेर राख्नुहोस";
 
 
void checklocationServive() async{
  try{
_serviceEnabled = await location.serviceEnabled();

if(!_serviceEnabled){
_serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
     Get.snackbar("Enable location Service", "Once you enable, you will get live track of your device");
    return;
  }}

  _locationData = await location.getLocation();
  setState(() {
       currentlatLng = new LatLng(  _locationData.latitude, _locationData.longitude) ;
      changePosition(currentlatLng);
  });
  }catch(e){
    BotToast.showText(text: e.toString());
  }
 
 }

  @override
  void initState() { 
  super.initState();
 checklocationServive();
 ////////////////////////////////
 
  } 

  @override
 
  void dispose() { 
 super.dispose();
  }


changePosition(LatLng latLng){
      if(myController !=null){
             myController.animateCamera(CameraUpdate.newCameraPosition(           
               new CameraPosition(       
                // bearing: 192.8334901395799,
                 target:  LatLng(latLng.latitude,  latLng.longitude),
                 zoom: 18.0,
               //  tilt: 0,
                 ) 
             ));

             updateMarkerAndCircle(latLng);
           }

}  


void updateMarkerAndCircle(LatLng latLng){
      this.setState(() {
      marker=
      Marker(
         infoWindow: InfoWindow(title: "Find your Home", snippet:"Hold and Move to set"),
         markerId: MarkerId("home"),
        position:latLng,
        draggable: true,
 
         zIndex: 1,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon:  BitmapDescriptor.defaultMarker,
           onDragEnd: ((newPosition) {
             currentlatLng= new LatLng(newPosition.latitude, newPosition.longitude);
          })
      );
      
    });

}

 bool x=false;
  @override
  Widget build(BuildContext context) {

  // FIRST CHECK THE PERMISSION FOR MAP IF NOT THEN ASK FOR PERMISSION
    return SafeArea(
      child: Scaffold(
        body:
       // permission == LocationPermission.denied
       x!=false
         ?
          ListView(
            children: <Widget>[
                SizedBox(height: 40.0,),
                  CircleAvatar(
                       child: ClipRRect(
                            child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                          ),
                         radius: 50,

                         ),
                         AutoSizeText( currentlatLng.latitude !=0.0? currentlatLng.latitude.toString(): "is Null attributre of lattitude"),
                    AutoSizeText(_serviceEnabled.toString(), style: TextStyle(fontSize: 18.0, fontWeight:  FontWeight.w200),)
            ],
          )
          :
        Stack(
          children:[
           GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set.of((marker!=null)?[marker]:[]),
         
          initialCameraPosition:  CameraPosition(target: LatLng(30.98,  58.98)),
          onMapCreated:  (GoogleMapController controller){
           myController=controller;
          },
           
          
          //(GoogleMapController controller) {
         //   _controller.complete(controller);
        //  },
              ),

        Positioned(
          top: 5.0,
          left: 5.0,
          right: 5.0,
          
          child: Center(
            child: Container(
              height: 100,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: globalFunction().customLinearGradient1,
                color: Colors.black,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,17),
                    color: Colors.grey.withOpacity(0.9),
                    spreadRadius: -23,
                    blurRadius: 17,
                  )
                ]
              ),

              child: 
                  Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                           
                          child: AutoSizeText.rich(
                                TextSpan(
                                  text:UserModel.instance.userFrom=="Hospital"? 
                                     hospitalinfo: homeInfo ,
                                     style: TextStyle(fontSize: 15, fontWeight:  FontWeight.w700, color: Theme.of(context).primaryColor ),
                                    children:[ 
                                    TextSpan(
                                      text: "  तपाइको गोपनीयताको पूर्ण सम्मान गर्छौ",
                                           style:TextStyle( color: Colors.grey, fontStyle: FontStyle.italic,
                                     fontSize: 10, fontWeight: FontWeight.w100)),
                                    ]                         )
                          ),
                        ),
                      )
                     
                  
                    ],
                  )),
               
               
            ),
          )
          
           ),

        //SECOND ELEMENT ##############
 
      
       //######################### GET THE CURRENT POSITIONED ###############################
   
        
         Positioned(
              bottom: 17.0,
              left: 10.0,
              right: 5,
              child: 

             
                 
           CircleAvatar(
             radius: 65,
             backgroundColor:Colors.blue,
             child: CircleAvatar(
               radius: 55,
               backgroundColor: Colors.white,
               child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100, height: 100),
                  child:  ElevatedButton.icon( 
                     icon: Icon(CupertinoIcons.compass_fill, size: 20,), 
                   label: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                    ),
                         
                    onPressed: ()  async {
                                  if( currentlatLng.longitude==0.0){
                                  BotToast.showText(text: "तपाइले कुनै जानकारी दिनुभएन");
                                   checklocationServive();
                                 //if service is not enable request for service
                                 }
                                 else{
                                   //lets update the latitude and longitude inforamtion
                

          
                              _classcontroller.updateLatLong(currentlatLng.latitude.toString(),currentlatLng.longitude.toString() );
                                
                                
                                 }
                                      },
              
                                      ),
                                   ),
             ),
           ),
                  
                 
              
              )
       ] )
       
      ),
      
    );
  }
}

 