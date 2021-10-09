 

 
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/InitialPage/FifthPage/custom/Home/addMargOdaController.dart';
 
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/dropDownFormField.dart';
 
 
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/textfield.dart';
 
class AddMargOda extends StatefulWidget {
  //const UserAddress({ Key? key }) : super(key: key);

  @override
  _AddMargOdaState createState() => _AddMargOdaState();
}

class _AddMargOdaState extends State<AddMargOda> {
 
  TextEditingController maargcontroller= new TextEditingController();
  TextEditingController  gharnocontroller= new TextEditingController();
  TextEditingController namecontroller=new TextEditingController();

 var _formKey= GlobalKey<FormState>();
  final _box= GetStorage();
 
 String odaSelected;
 String writtenMarga;
 String writtengharno;
 String writtenName;

 @override
 void initState() { 
   super.initState();
   odaSelected="";
   writtenMarga="";
   writtengharno="";
   writtenName="";

 }
 
 @override
 void dispose() { 
   maargcontroller.dispose();
   gharnocontroller.dispose();
   namecontroller.dispose();
   super.dispose();
 }
 

  @override
  Widget build(BuildContext context) {
    final _controller= Get.put(addodaMargController());
         
    return SafeArea(
      child: Scaffold(
        body:  
          Container(
               decoration: BoxDecoration(
           gradient: globalFunction().customLinearGradient
         ),
            child: Form(
              child: ListView(
                
                padding: EdgeInsets.symmetric(horizontal:20.0),
                children: <Widget>[
                 Align(
                   alignment:Alignment.bottomLeft,
                   child: SizedBox(height: 40.0,
                   child:IconButton(onPressed: (){
                     Get.back();
                   }, icon: Icon(Icons.arrow_back), color:Theme.of(context).shadowColor)),
                 ),
                 
                      CircleAvatar(
                           child: ClipRRect(
                                child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                              ),
                             radius: 50,
                             ),
                             

                          SizedBox(height: 30.0,),

                      AutoSizeText("पोखरा फोहोर महिला व्यवस्थापन", style: TextStyle(
                             fontWeight: FontWeight.w900, fontSize: 20.0,color: Theme.of(context).primaryColor ), ),
                      
                      SizedBox(height: 20.0,),
                    
                      AutoSizeText(
                                "  आफ्नो घरको जानकारी हामीलाई पठाउनुहोस, पठाएको केहि दिनभित्र नै सत्यापित गर्नेछौ  ",
                               style: TextStyle(fontWeight: FontWeight.w300,
                                fontSize:20.0 , letterSpacing: 1,
                                color: Theme.of(context).shadowColor
                                )
                         ),
                          
                        SizedBox(height: 20,),

                      
                     SizedBox(height:10),

            Container(
                                 
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: DropdownSearch(
                                       
                                      showAsSuffixIcons: true,
                                      searchBoxStyle: TextStyle(color:Colors.black),
                                      dropdownSearchBaseStyle:TextStyle(color: Colors.red),
                                      onChanged: (value){
                                        odaSelected=value;
                                      },
                                       
                                      showSearchBox: true,
                                      showClearButton: false,
                                      searchBoxDecoration: InputDecoration(
                                        hintText: "आफ्नो ओडा छान्नुहोस्"
                                      ),
                                       items:  ["07", "17"],
                                      hint: "आफ्नो ओडा छान्नुहोस्",
                                       
                                      dropDownButton: Icon(Icons.arrow_downward, color:Colors.black),
                                       dropdownSearchDecoration: InputDecoration(
                                       
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.5),
                                        ),
                                        prefixIcon: Icon(Icons.search, color:Colors.black),
                                        labelStyle: TextStyle(color: Colors.green[900]),
                                        labelText: "आफ्नो ओडा छान्नुहोस्",
                                         
                                        hintStyle:TextStyle(color: Colors.black),
                                        focusColor: Colors.red,
                                        border:  InputBorder.none,
                                       filled: true,
                                       fillColor: Colors.green.withOpacity(0.1)
                                      ),
                                    ),
                                  ) ),

                                  SizedBox(height:25),

       nametextField(
                       hintText:"आफ्नो नाम अंग्रेजीमा",
                       iconData: Icons.person,
                       nameController: namecontroller,
                       fieldType: "name",
                       onChnageField: (value){
                         writtenName=value;
                      
                       },
                       onValidator: (value){
                       if(  value==null||value==""){
                          
                       }
                       return null;
                       },
                     ),

              
// ##################################### GHAR NO TO BE DISPLAY WHEN MARG IS SELECTED ##################
 SizedBox(height: 25,) ,    
      StringtextField(
        iconData: Icons.home,
        hintText: "घरस्थान रहेको मार्ग लेख्नुहोस",
        nameController:  maargcontroller,
        onChnageField:(val){
           writtenMarga=val;
        }
      ),
                
// ##################################### NOW  WRITE TOL BATAAUNU HOS ################################ 

SizedBox(height: 25,) ,   


  DecimaltextField(
    hintText:"घर न लेख्नुहोस" ,
  iconData:  Icons.home,
  onChnageField: (val){
    writtengharno=val;
  },
  ),

SizedBox(height: 20,),
    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                            height: 50,
                          child: 
                       
                               
                           ElevatedButton(
                            child: Text("अगाडि बढ्नुहोस्", style: TextStyle(fontSize: 15, fontFamily: "Brand Bold")),
                             onPressed: () {
                             
                     if(
                       writtenName.trim()!="" &&
                       odaSelected.trim()!="" && writtengharno.trim()!=null && writtenMarga.trim()!=""){
               _controller.savePendingRequest(
                 name: writtenName,
                 oda:odaSelected.trim(),maarga: writtenMarga.trim(), gharno: writtengharno.trim());
                     }}
                            
                          ),)
                        ),
                 

             ],
              )
            ),
          ))
    
       
      
    );
  }
}

 
