import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Settings/UserSetting/StreamMyDevice/StreamDeviceController.dart';
import 'package:waste/Settings/UserSetting/userDashboard.dart';

class StreamDriverDevice extends StatefulWidget {
 
//STREAM DRIVER
  @override
  _StreamDriverDeviceState createState() => _StreamDriverDeviceState();
}

class _StreamDriverDeviceState extends State<StreamDriverDevice> {
  final box=GetStorage();
final _streamController=Get.put(StreamDeviceController());

  @override
  void initState() { 
    super.initState();
    box.writeIfNull(boxStreaming, 'false');
    box.read(boxStreaming)=='false' ?_streamController.setStreaming(false):_streamController.setStreaming(true);
   _streamController.loadVehicleIdForUserId();
   
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
                 CircleAvatar(
                   child: ClipRRect(
                                child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                              ),
                           radius: 50,
                           ),
                           
                           SizedBox(height: 30.0,),
                         AutoSizeText("Pokhara Waste Service", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0), ),
                         SizedBox(height: 20,),
        
            Text("Go to Live Stream", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Stream : "),
                       Obx(()=>(
                          Switch(
                                     value: _streamController.isStreaming,
                                     onChanged: (value) {
                                       
                                      _streamController.setStreaming(value);
                                     
                                     },
                                     activeTrackColor: Colors.lightGreenAccent,
                                     activeColor: Colors.green,
                                   )
                       )
                       )
                     ],
                   ),
            
            SizedBox(
              height: 20,
            ),
        
              
              InkWell(
                onTap: (){
                  _streamController.enableService();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText("Enable Location Service for App", style:TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w900)),
                ),
              ),
        
        
            ]
            
            ,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
          
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton( 
            backgroundColor: Colors.green,
            onPressed: (){
              Get.off(UserDashboard());
            },  child: Icon(Icons.arrow_back)),
        ),),
     
      
    );
  }
}