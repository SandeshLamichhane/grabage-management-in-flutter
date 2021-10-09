import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
 import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/BillPayment/AllBill/alluserBill.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createBill.dart';
import 'package:waste/Settings/UserSetting/BillPayment/billpaymentController.dart';
import 'package:waste/Settings/UserSetting/BillPayment/displayHomeBill.dart';
import 'package:waste/Settings/UserSetting/BillPayment/displayHospitalBill.dart';
  import 'package:waste/Settings/UserSetting/addRoutes/weekDay.dart';
import 'package:nepali_utils/nepali_utils.dart';

 
class AddBillRate extends StatefulWidget { 
  @override
  _AddBillRateState createState() => _AddBillRateState();
}

class _AddBillRateState extends State<AddBillRate> {

  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  var _formKey= GlobalKey<FormState>();

   var weekdaydifobj=WeekdayDifference();

   TextEditingController confirmDeleteController= new TextEditingController();
    

static final CameraPosition initialLocation= CameraPosition(target: LatLng(28.1833432777335, 83.9861154408866), zoom: 14.47);



   String newOdaNo="";
   String bar="";
   String interval="";
   String truckNo="";


 


TextEditingController textodaController=  new TextEditingController();
  

 

final _billPaymentController= Get.put(billPaymentController());

 
  TabController tabcontroller;
    final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];
 
 
@override
void dispose() { 
 
 confirmDeleteController.dispose();  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
       
      child: SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text('Bill Manage Garnuhos'),
        bottom:TabBar(tabs: [
          Tab(icon: Icon(Icons.file_copy)),
          Tab(icon: Icon(Icons.add)),
        ]),
        
          
      ),
      body:TabBarView(
          
            children: [
               
          
          
           Stack(
              children:[ PageView(
             
               children:[
              ///create the bill for month 
           // createBill(),
            homeuserbillrecord(),
              displayHomeBill(),        
              displayHospitalBill()
               ]
             ),]
           )
           ,

            addNewRouteWidget()
           ],
           
             ))));
  }


         
           
           
   
         
     


   
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ADDING NEW Biil rate WIDGET %%%%%%%%%%%%%%%%%%%%
  addNewRouteWidget() { 
     return Form(
                   key: _formKey,
                   child: Container(
                   child:ListView(
                     shrinkWrap: true,
                   padding: EdgeInsets.symmetric(horizontal: 20.0),
                   children: <Widget>[
                      
        SizedBox(height: 10,),
       AutoSizeText("Rate biniyojan garnuhos", 
                   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
      SizedBox(height:15),                  
//                              // FIRST ODA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
       Obx(()=>(
           DropdownSearch(
           selectedItem:  _billPaymentController.hospOrHome,
           onChanged:(value){
           _billPaymentController.chnageHospHome(value) ;
                 } ,
          validator: (val){
          return 
           null;
          },
           searchBoxDecoration: InputDecoration(
                                  labelText: "Select Hospital/Home",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                ),
                                 
                                mode: Mode.MENU,
                                showSearchBox: false,
                                label:"Select",
                                items:  ['Home', 'Hospital' ],
                              )
              ),),
                      
        SizedBox(height:15),
// FIRST ODA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   MAARGA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Obx(()=>  _billPaymentController.hospOrHome=="Home"?
HomeWidget() :HospitalWidget()),
        
 ////////////////////////////////////////// TIME INTERVAL //////////////////////////////////////////////////ROUTE
 
                       ]
                     )),
                 );
    
  }


 

  
  //////////////////////////////HELP US TO FIND &&&&&&&&&&&&&&&&&&&&&
 

 

  



  }
////////////////////////////////////////////////////////////
class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var _formKeyx= GlobalKey<FormState>();
  String homeIdValidator;
  String rateValidator;
  String remainingAmouValidator;
  String ownerNameValidator;
final _billController=Get.put(billPaymentController());
  @override
  void initState() { 
    super.initState();
    homeIdValidator=null;
    rateValidator=null;
    remainingAmouValidator=null;
    ownerNameValidator=null;
  }
  @override
  Widget build(BuildContext context) {

    return Form(
      key:  _formKeyx,


      child: ListView(
           shrinkWrap:true,
           children: [
      //for the home number 
             SizedBox(height: 10,),
              HometextField(
                maxLength: 5,
                hintText:"Enter Home Id"       ,
                onValidator: (val){
                  return homeIdValidator;
                }, 
                nameController: _billController.homeIdController,    
              ),
              SizedBox(height:20),
              DecimaltextField(
                
                hintText: "Enter Rate",
                onValidator: (val){
                  return rateValidator;
                },
                nameController:_billController.rateIdController
              ),

                 SizedBox(height:20),
              DecimaltextField(
                hintText: "aghillo mahinasammako baanki",
                onValidator: (val){
                  return remainingAmouValidator;
                },
                nameController:_billController.remainingAmountController
              ),
             SizedBox(height:20),
            StringtextField(
             hintText: "Enter Owner Name"
             ,
             nameController: _billController.ownerNameAmountController,
             onValidator: (val){
               return ownerNameValidator;
             },
            ),
              SizedBox(height:20),
              ClipRRect(
                borderRadius:BorderRadius.circular(5.0),
                child:SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: ()async{
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    //// on validator
                //  _formKey.currentState.validate();
              var x=   await  _billController.validateHomeId();
              homeIdValidator=x;
               var y=   await _billController.validateRateId();
               rateValidator=y;
              var z= await _billController.validateRemaingAmount();
              remainingAmouValidator=z;
               var a= await _billController.validateOwnerName();
               ownerNameValidator=a;
               
             if(_formKeyx.currentState.validate()){
                    _billController.AddNewData((){});
             }
                    },
                    child:Text("Add Home")
                  ),
                )
              ),
           
      SizedBox(height: 20,)
    
           ]    
    
      ),
    );
  }
}

////////////////////////////////// NOW ITS THE   hospital name 
class HospitalWidget extends StatefulWidget {
  @override
  _HospitalWidgetState createState() => _HospitalWidgetState();
}

class _HospitalWidgetState extends State<HospitalWidget> {
  var _formKeyx= GlobalKey<FormState>();
  String hospNamedValidator;
  String hosprateValidator;

final _billController=Get.put(billPaymentController());

  @override
  void initState() { 
    super.initState();
    hospNamedValidator=null;
    hosprateValidator=null;
    
  }
  @override
  Widget build(BuildContext context) {

    return Form(
      key:  _formKeyx,
      child: ListView(
           shrinkWrap:true,
           children: [
      //for the home number 
             SizedBox(height: 10,),
              HospitalNameTextField(
              
                hintText:"Hospital Name"       ,
                onValidator: (val){
                  return hospNamedValidator;
                }, 
                nameController: _billController.homeIdController,    
              ),
              SizedBox(height:20),
              DecimaltextField(
                
                hintText: "Enter Rate",
                onValidator: (val){
                  return hosprateValidator;
                },
                nameController:_billController.rateIdController
              ),
              SizedBox(height:20),
              ClipRRect(
                borderRadius:BorderRadius.circular(5.0),
                child:SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: ()async{
    //// on validator
                //  _formKey.currentState.validate();
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              var x=   await  _billController.validateHomeId();
              hospNamedValidator=x;
               var y=   await _billController.validateRateId();
               hosprateValidator=y;
             if(_formKeyx.currentState.validate()){
                  _billController.AddNewData((){

                  });
             }
                    },
                    child:Text("Add Hospital")
                  ),
                )
              ),
           
      SizedBox(height: 20,)
    
           ]    
    
      ),
    );
  }
}