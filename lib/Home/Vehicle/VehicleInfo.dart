import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste/Home/Vehicle/VehicleController.dart';
 

class   VehicleInfo extends   StatefulWidget {
//  const Home({ Key? key }) : super(key: key);

  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
 
 bool selected = false;
 final _vehicleInfoController= Get.put(VehicleInfoController());
Marker marker;
Circle circle;

@override
  void initState() {
    // TODO: implement initState
   // _vehicleInfoController.loadVehicleInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:   Stack(
                 children: [
        
                  
                     // height: MediaQuery.of(context).size.height,
                     // width: MediaQuery.of(context).size.width,
    
                     GetBuilder<VehicleInfoController>(
                       init: VehicleInfoController(),
                       builder: (_vehicleInfoController) =>
                       GoogleMap(
                      mapType: MapType.hybrid,
                      markers: Set.of((_vehicleInfoController.marker!=null)?[_vehicleInfoController.marker]:[]),
                         circles: Set.of((_vehicleInfoController.circle!=null)?[_vehicleInfoController.circle]:[]),
                          initialCameraPosition: CameraPosition(
                            target:  _vehicleInfoController.currentLatLang,),
                            onMapCreated: (GoogleMapController _mapcontroller){
                           _vehicleInfoController.myMapController=_mapcontroller;
                             _vehicleInfoController.listeningtoTruckLiveUpdate(context,
                              (){
   _vehicleInfoController.myMapController.animateCamera(CameraUpdate.newCameraPosition(
                              new CameraPosition(
                                  //  bearing: 192.8334901395799,
                                        target:  _vehicleInfoController.currentLatLang,
                                          zoom: 10.0,
                                       tilt: 0,
                                      )
                                  ));
                          },
                              );
                           } 
                            )
                     ),
                  
                  
                
                 AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
              curve: Curves.fastOutSlowIn,
                   bottom: 0.0,
                   left:0.0, 
                   right: 0.0,
                   height:  selected? 200.0:80.0,
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(15.0),
                       topRight: Radius.circular(15.0))
                     ),
                     
                     padding: EdgeInsets.only(left: 20.0, right: 20.0 , top: 20.0),
                   //mainly for animatiom                 
                     child: 
                      selected?  vehiclecontainer():
                     Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                           Text("Arrival Information", style: TextStyle(
                             fontFamily:"Brand Bold", fontSize:23.0, color: Colors.teal)),
                           Container(
                             child:  InkWell(
                               onTap: (){
                                // print("On Tap"+ _controller.showVehicleArrivalInfo.toString());
                               // _controller.chanegvehicleArrivalInfo(true);
                                setState(() {
                    selected = !selected;
                  });
                                 
                               },
                               child: ClipRRect(
                                 
                                 child: Container(
                                  
                                   decoration: BoxDecoration(
                                      color: Colors.green,
                                     borderRadius: BorderRadius.circular(5.0)
                                   ),
                                   height: 40,
                                   width: 40,
                                   
                                   child: Icon(CupertinoIcons.chevron_up, color: Colors.white,), ),
                               )
                               
                             ),
                           )
                           
                           ],
                         )
                       ],
                     ),
                   ),
                 ), 
                 
                 
                 ] )));
               
          
           
        
        
    
  }

  Widget vehiclecontainer(){
   return  Obx(()=>(
     SingleChildScrollView(
                          child: Column(
                           
                           children: [
                             Row(
                               
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                               Expanded(
                                 child: AutoSizeText("Arrival Information",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis, style: TextStyle(
                                   fontWeight:FontWeight.w500, fontSize:18.0, color: Colors.teal)),
                               ),
                               Container(
                                 child:  InkWell(
                                   onTap: (){
                               _vehicleInfoController.loadVehicleInfo();
                                 // print(_controller.showVehicleArrivalInfo.toString());
                                  // _controller.chanegvehicleArrivalInfo(false);
                                    setState(() {
                                          selected = !selected;
                                        });
                                   },
                                   child: ClipRRect(
                                     child: Container(
                                       decoration: BoxDecoration(
                                          color: Colors.green,
                                         borderRadius: BorderRadius.circular(5.0)
                                       ),
                                       height: 40,
                                       width: 40,
                                       
                                       child: Icon(CupertinoIcons.chevron_down, color: Colors.white,), ),
                                   )
                                   
                                 ),
                               ),
                        
                               ////////////////////////////////
                               
                               
                               ],
                             ),
                        
                                SizedBox(height: 1,),
                             //Second ROw for Arrival time
                          Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           //LEFT HAND SIDE COLUMN ######################################
                                           Column(
                                           
                                             crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text("Arrival time :", textAlign:TextAlign.left, style:TextStyle(fontSize: 15, fontFamily:"Brand Bold"))),
                             Container(
                               child: Text(_vehicleInfoController.arrivalTime,   textAlign:TextAlign.left,
                              style: TextStyle(fontSize: 16, fontFamily: "Brand Bold", color:Colors.teal[700],))),
                           ],
                     ),
                                           //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NRIGHT HAND SIDE COLUMN ##############
                 Flexible(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                               crossAxisAlignment:CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding:EdgeInsets.only(top: 12.0),
                                   child: AutoSizeText.rich(  
                                     TextSpan(
                                       children: [
                                          TextSpan(text: "Date : ",
                                           style: TextStyle(   fontWeight:FontWeight.w200, fontFamily:"Brand Bold",color: Colors.black)),
                                           TextSpan(text:  _vehicleInfoController.dateofarrival,  
                                           style: TextStyle(   fontFamily:"Brand Bold", 
                                           color: Colors.red[300])),
                                           
                                       ]
                                     ),
                                     minFontSize: 12.0,),
                                 ),
                    
                                 Container(
                                   child: AutoSizeText(_vehicleInfoController.daysLater,maxLines: 1,minFontSize: 12,
                                          style:TextStyle(fontSize: 15, color: Colors.grey[600])),
                                 ),
                                         
                            SizedBox(height: 20,),
                                     
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text("Truck No: "+_vehicleInfoController.arrivalvehicleNo,
                                         overflow: TextOverflow.ellipsis, style:TextStyle(fontSize: 12,
                                          color: Colors.grey, fontFamily:"Brand Bold", fontWeight:  FontWeight.w200)),
                                      ),
                               ],
                             ),
                 ),                                         
 ],
   
                          ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                        
                        
                            ],
                          ),
                        ///////////////////////////////////////////////////////////////////
                           ],
                       )                  )
                        ),
   );
                   /*
                    ),
                 ),
               );
 */
  }

//////////////////////////////////////////////////
Future<Uint8List> getMarker() async {
    ByteData byteData =await DefaultAssetBundle.of(context).load('assets/car.png');
    return byteData.buffer.asUint8List();
  }

  void updateLocation() async {
     Uint8List imageData= await getMarker();// for image 
         _vehicleInfoController.myMapController.animateCamera(CameraUpdate.newCameraPosition(
               new CameraPosition(
                 bearing: 192.8334901395799,
                 target:  _vehicleInfoController.currentLatLang,
                 zoom: 10.0,
                 tilt: 0,

                 )
             ));

           updateMarkerAndCircle(imageData);
           }
////////////////////////////////////// $$$$$$$$$$$$$$ UPDATE MARKER AND CIRCLE $$$$$$$$$$$$$$
  void updateMarkerAndCircle( Uint8List imageData) {

    LatLng latlng=      _vehicleInfoController.currentLatLang;
  
   this.setState(() {
      marker=Marker(
        markerId: MarkerId("home"),
        position:latlng,
        rotation:   1,
        draggable: false,
        zIndex: 2,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon: BitmapDescriptor.fromBytes(imageData));


        circle=Circle(circleId: CircleId("car"),
         // radius:  createDynamicRadius(latlng),//on the decimal value range we can change the data ,
          center: latlng,
          zIndex: 1,
          strokeColor: Colors.blue,
          
           fillColor: Colors.blue.withAlpha(70));
       
   });
      
  }
}