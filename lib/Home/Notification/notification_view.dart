 

import 'package:auto_size_text/auto_size_text.dart';
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:readmore/readmore.dart';
import 'package:waste/Home/Notification/notification_controller.dart';
 import 'package:waste/Root/textfield.dart';
 
 class MyNotification extends StatefulWidget {
   //const MyNotification({ Key? key }) : super(key: key);
 
   @override
   _MyNotificationState createState() => _MyNotificationState();
 }
 
 class _MyNotificationState extends State<MyNotification> {
   final _notificationController= Get.put(NotificationController());
   String descriptionValidator;
   String titleValidator;
  var _formKey=GlobalKey<FormState>();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionValidator=null;
    titleValidator=null;
   // _notificationController.loadAllgunasoofUser();
    _notificationController.listeningtoFirestore();
  }
   @override
   Widget build(BuildContext context) {
     return SafeArea(
       child: Scaffold(
        
        backgroundColor: Color(0xffE7E4E4),
         body: Stack(
           children: [
         Padding(
             padding: const EdgeInsets.all(1.0),
             child: Column(
                    children:<Widget>[
        
              QuestionAnswer(),
              SizedBox(height:100)
                    ]
             )),
           
             showtextfield()  
           ]
         ),

       ),
       
     );
   }

  showtextfield() {
      return  Obx(()=>Form(
        key: _formKey,
        child: (
           AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),
                  curve: Curves.fastOutSlowIn,
                       bottom: 0.0,
                       left:0.0, 
                       right: 0.0,
                       height:  _notificationController.showHide? 400.0:80.0,
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
                          _notificationController.showHide?  hideTextField():
                         Column(
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                               Text( "Aafno gunaso lekhnuhos ?", style: TextStyle(
                                fontWeight: FontWeight.w700 , fontSize:18.0, color: Colors.teal)),
                               Container(
                                 child:  InkWell(
                                   onTap: (){
                                    // print("On Tap"+ _controller.showVehicleArrivalInfo.toString());
                                   // _controller.chanegvehicleArrivalInfo(true);
                                    _notificationController.changeShowHide();
                                     
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
        )),
      ),
      ) ;
  }

  hideTextField() {
    return 
              SingleChildScrollView(
                child: Container(
                      padding: const EdgeInsets.only(top:8.0),
                    height: 400,    
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),  
                  
                   child: Column(
                     children: <Widget>[
                        Flexible(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget> [
                          

                        Container(child: Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Text("Aafno gunaso lekhnuhos ?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
                        )),
                        GestureDetector(
                                      onTap: (){
                             
                            _notificationController.changeShowHide();
                            
                          },
                          child: ClipRRect(                         
                                            child: Padding(
                          padding: const EdgeInsets.only(right:0.0),
                          child: Container(
                                    decoration: BoxDecoration(
                                         color: Colors.green,
                                               borderRadius: BorderRadius.circular(5.0)
                                               ),
                                               height: 40,
                                               width: 40,
                                               child: Icon(CupertinoIcons.chevron_down, color: Colors.white,), ),
                                            ),
                                         ),
                        )
                      ],),),
              

 
                    SizedBox(height: 20.0,),
 
GunasooTextField
(
  onValidator: (value){
    return titleValidator;
  },
  hintText: "Enter Gunaso title",
 onChnageField: (value){

 },
 length: 40,
 nameController: _notificationController.titleTextFieldController,
),
SizedBox(height:10),
GunasooTextField
(
   onValidator: (value){
    return descriptionValidator;
  },
  hintText: "Describe in detail",
minline: 3,
maxline: 3,
nameController: _notificationController. descriptionTextFieldController,
 onChnageField: (value){
 },
 length: 300,
),
              
SizedBox(height:20),  
  Container(
    width: MediaQuery.of(context).size.width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height:50,
          child: ElevatedButton( onPressed: () async{
            //print("")
      var x= await  _notificationController.validateDescription();
       titleValidator=x;
      var y= await _notificationController.validateTitle();
      descriptionValidator=y;
         WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
     if( _formKey.currentState.validate())
   _notificationController.sendGunaso(
     (){
       _notificationController.changeShowHide();
     }

   );

          },  child: Text("Send Gunaso"),
        ),
        
      ),
    ),
  )
                     ],
                   ),
                
                  
                  ),
              );
  }
 }


 

class  HideAskPage extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return    Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:  Container(
              height: 400, color: Colors.green,
            ));
  }
}

////////////////////////////
 class QuestionAnswer extends StatelessWidget {
  final _notificationController= Get.put(NotificationController());
   @override
   Widget build(BuildContext context) {
     return 
        GetBuilder(
          init: NotificationController(),
          builder: (context)=> Flexible(
             //if the data is null then 
           child:   _notificationController.listofgunasoModel.length<1?
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: SizedBox(
           height:150,
           child: Center(
             child: Card(
                 color: Colors.white,
                 elevation: 2,
                  child:Center(
             child: Column(
                 children:[
                   SizedBox(height: 20,),
                   Container(
                     color: Colors.green.withOpacity(0.1),
                     child: Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Text("aafno pahilo gunaso  pokhnuhos", style:TextStyle(fontWeight: FontWeight.w800,color: Colors.green, fontSize: 18.0)),
                     ),
                   ),
                   Center(child: Icon(CupertinoIcons.arrow_down, size:30, color:Colors.pink))
                 ]
             ),
                  )
                   ),
           ),
                 ),
               )
               :


          ListView.builder(
            shrinkWrap: true,
            reverse:true,
                   itemCount: _notificationController.listofgunasoModel.length==null?0:_notificationController.listofgunasoModel.length,
                   itemBuilder: (BuildContext context, int index){
         return   Card(
           elevation: 2,
           color: Colors.white,
           child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
              ListTile(
             leading:   
              Icon( CupertinoIcons.person_crop_circle_fill, size: 40.0,color: Colors.indigo,), 
                 
                 title: ReadMoreText(_notificationController.listofgunasoModel[index].gunasotitle, style: TextStyle(color: Colors.brown, fontSize: 20.0, fontWeight: FontWeight.w500),),
             subtitle:  Column(
               mainAxisSize:MainAxisSize.min,
             children: [
                 ReadMoreText(
                   
              _notificationController.listofgunasoModel[index].gunasodescription,
                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
              trimLines: 5,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              lessStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                   
               //Either show pending or checked
               _notificationController.listofgunasoModel[index].gunasorequestpending=="yes"?
               Container(
              decoration: BoxDecoration(
             border:Border.all(width: 1.0, color:Colors.grey) ,
             borderRadius: BorderRadius.circular(20.0)
              ),
              child:
              
               Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text("Pending..."),
              )):  
               Padding(
             padding: const EdgeInsets.all(8.0),
             child: Icon(Icons.check_circle, color:Colors.grey),
              
               ),
              Align(
             alignment: Alignment.bottomRight,
             child: Text(_notificationController.listofgunasoModel[index].gunasoquestionDate ,
              style: TextStyle(color: Colors.grey), textAlign: TextAlign.right,)),
               ],
             ),
              )
               ],
             )
              ),
              SizedBox(height: 10,),
               _notificationController.listofgunasoModel[index].gunasorequestpending=="no"?
               Divider(height:2, color:Colors.grey):Container(),
             SizedBox(height: 10,),
              _notificationController.listofgunasoModel[index].gunasorequestpending=="yes"?Container():
             ListTile(
               trailing: CircleAvatar(radius: 20,backgroundImage:AssetImage("assets/logo.png") ,),
               //title: ReadMoreText("samayma gaadi aayena ?", style: TextStyle(color: Colors.orange, fontSize: 20.0, fontWeight: FontWeight.w900),),
               subtitle: Padding(
              padding: EdgeInsets.only(top:20.0),
              child: Row(
             children: [
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 25.0,),
               ),
               Flexible(
                 child: Container(
                   child: AutoSizeText.rich(
                     TextSpan(
                       text: "",//_notificationController.listofgunasoModel[index].gunasomoderatorName,
                       style:  TextStyle(fontWeight: FontWeight.w500, color: Colors.teal),
                       children: [
                         TextSpan(
                           text:  " (Waste Service) ",
                            style:  TextStyle(fontWeight: FontWeight.w400, color: Colors. grey),
                         ),
                           TextSpan(
                           text: _notificationController.listofgunasoModel[index].gunasoreplyDate,
                            style:  TextStyle(fontWeight: FontWeight.w400, color: Colors. grey),
                         )
                       ]
                     ),
                     
                   ),
                 ),
               ),
             ],
              ),
               ),
                title:  ReadMoreText(
             _notificationController.listofgunasoModel[index].gunasoreplytext,
               style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
               
             trimLines: 5,
             colorClickableText: Colors.pink,
             trimMode: TrimMode.Line,
             trimCollapsedText: 'Show more',
             trimExpandedText: 'Show less',
             moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              lessStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )),
               ],
             ),
         );
      
           
            }),
          ),
        );
   }
 }

 /*

 
           child: 
 */