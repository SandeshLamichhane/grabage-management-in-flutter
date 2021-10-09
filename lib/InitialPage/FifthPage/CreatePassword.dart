import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/InitialPage/FifthPage/custom/Home/addMargOda.dart';
import 'package:waste/InitialPage/FifthPage/custom/Hospital/addHospital.dart';
import 'package:waste/InitialPage/FifthPage/passwordController.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
 
import 'package:waste/Root/passwordField.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addHospital/addHospital.dart';
import 'package:waste/confi/color.dart';

class CreatePassword extends StatefulWidget {
 // const CreatePasswor({ Key? key }) : super(key: key);
  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  
 
final _controller= Get.put(PasswordController());

final _formKey = GlobalKey<FormState>();
    String writtenName="";
    String selectedHospital="";
    String selectedHomeId="";
TextEditingController namecontroller;
  @override
  void initState() { 
    super.initState();
    _controller.getAllHomeId();
    _controller.getAllHospitalId();
    namecontroller=TextEditingController();
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    namecontroller.dispose();
  }
final box=GetStorage();

String userName;

String userPassword;

String nepaliTextforHome="आफ्नो घर न. नभेटेको अवस्थामा, संबन्धित कार्यलयमा जानकारी दिनुहोस";

String nepaliTextforHospital="आफ्नो अस्पताल नभेटेको अवस्थामा, संबन्धित कार्यलयमा जानकारी दिनुहोस";

  @override
  Widget build(BuildContext context)   {
            String userFrom=     box.read(boxuserfrom);

 
   

print(UserModel.instance.userPhoneNumber);
    return SafeArea(
      
         child: Scaffold(
           backgroundColor: Colors.blue[100],
           body: Container(
             
         decoration: BoxDecoration(
           gradient: globalFunction().customLinearGradient1
         ),
             child: Form(
              key:_formKey,
               child: ListView(
                 padding: EdgeInsets.symmetric(horizontal: 17.0),
                 children: <Widget>[
                      SizedBox(height: 40.0,),
                      CircleAvatar(
                           child: ClipRRect(
                                child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                              ),
                             radius: 50,
                             ),
                             
                             SizedBox(height: 30.0,),
                           AutoSizeText("पोखरा फोहोरमैला व्यवस्थापन",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0, 
                            color: Theme.of(context).primaryColor), ),
                           SizedBox(height: 8,),
                          AutoSizeText("आफ्नो बारेमा थप जानकारी बताउनुहोस", 
                          style:TextStyle(fontWeight: FontWeight.w400, fontSize:20.0 ,
                           color: Theme.of(context).shadowColor,
                           letterSpacing: 1),),
                        ///////////////////////////////////////////////// PIN PUT $$$$$$$$$$$$$$$$$$$$$$$$$$
                       SizedBox(height: 20,),
                     
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
                     SizedBox(height:15),
                      //district
                    
                  if( box.read(boxuserfrom)=='Home')
                   selectHome(),
                   if( box.read(boxuserfrom)=='Hospital')
                    selectHospital() ,
                   
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        userFrom=='Home'?
                        nepaliTextforHome: userFrom=='Hospital' ?nepaliTextforHospital :"",
                      style:TextStyle(fontSize: 10,
                       fontStyle: FontStyle.italic, color: Theme.of(context).shadowColor)
                       ),
                    ),
              
                          SizedBox(height:30),
                    
                           ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                              height: 50,
                            child: 
                                
                                
                             ElevatedButton(
                              child: Text("अगाडि बढ्नुहोस्", style: TextStyle(fontSize: 15, 
                              fontFamily: "Brand Bold", fontWeight:FontWeight.w500)),
                               onPressed: () {
                               
                               //lets submit data into firestore 
                               writtenName=writtenName.trim(); 
                              selectedHomeId=selectedHomeId.trim();
                              print(selectedHospital+writtenName);
                               if(userFrom=='Home' && writtenName.trim()!="" && selectedHomeId!=""){
                                
                                 _controller.saveHomeIdAndName(nmae:writtenName,HomeId: selectedHomeId);
                                 
                               }else                                
                                if(userFrom=='Hospital' && writtenName!="" ){
                               
                             
                                 _controller.saveHospitalNameAndName(hospitalName : selectedHospital,  writtenname :  writtenName);
                               }else                                 
                               if(userFrom=='Guest' &&  writtenName!=""  ){
                                 
                                 _controller.saveGuestName(writtenName);
                               }

                               
                              },
                            ),)
                          ),
                    
               // email, phone,password,
            
          SizedBox(height:30),
          ClipRRect(
            child: Container(
              decoration: BoxDecoration(
              border: Border.all(width: 1.5, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(8.0)
              ),
              child: SizedBox(
                child: TextButton(onPressed: (){
                      if( userFrom=='Home'){
                    Get.to(AddMargOda());
                      }else if( userFrom=='Hospital'){
                          Get.to(addMyHospital());
                      }
                }, child:  Text("आफ्नो अस्पताल / घर नभेटे, यहाँ थिच्नुहोस् ",
                 style: TextStyle(color:  Theme.of(context).primaryColor, fontWeight:FontWeight.w700)  )),
              ),
            ),
          )   
                 ],
               ),
             ),
           ),

         ),
      

    );
  }

  Widget selectHome() {
     return GetBuilder(
       init:PasswordController(),
       builder: (_controller){
       return SizedBox(
                             height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: DropdownSearch(
                                      showAsSuffixIcons: true,
                                      searchBoxStyle: TextStyle(color:Colors.black),
                                      onChanged: (value){
                                      selectedHomeId=value;
                                      },
                                      showSearchBox: true,
                                      showClearButton: false,
                                      searchBoxDecoration: InputDecoration(
                                     //   hintText: "आफ्नो घर न. छान्नुहोस्"
                                      ),
                                       items:  _controller.listofhomeId,
                                     //  hint: "आफ्नो घर न. छान्नुहोस्",
                                       validator: (val){
                                         if(val==null || val=="")
                                         return "";
                                         return null;
                                       },
                                      dropDownButton: Icon(Icons.arrow_downward, color:Colors.black),
                                      dropdownSearchBaseStyle: TextStyle(color: Colors.red),
                                      dropdownSearchDecoration: InputDecoration(
                                       
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.5),
                                        ),
                                        prefixIcon: Icon(Icons.search, color:Colors.black),
                                        labelStyle: TextStyle(color: Colors.green[900]),
                                        labelText: "आफ्नो घर न. छान्नुहोस्",
                                         
                                        hintStyle:TextStyle(color: Colors.black),
                                        focusColor: Colors.red,
                                        border:  InputBorder.none,
                                       filled: true,
                                       fillColor: Colors.green.withOpacity(0.1)
                                      ),
                                    ),
                                  ),
                                );
       }
     );
  }

  selectHospital() {
      return GetBuilder(
          init:PasswordController(),
       builder: (_controller){
       return
        SizedBox(
                                  height: 60,
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: DropdownSearch(
                                      showAsSuffixIcons: true,
                                      searchBoxStyle: TextStyle(color:Colors.black),
                                      onChanged: (value){
                                       selectedHospital=value;
                                      },
                                      showSearchBox: true,
                                      showClearButton: false,
                                      searchBoxDecoration: InputDecoration(
                                        hintText: "आफ्नो अस्पताल छान्नुहोस्"
                                      ),
                                       items: _controller.listofHosptalName,
                                      hint: "आफ्नो अस्पताल छान्नुहोस्",
                                       
                                      dropDownButton: Icon(Icons.arrow_downward, color:Colors.black),
                                      dropdownSearchBaseStyle: TextStyle(color: Colors.red),
                                      dropdownSearchDecoration: InputDecoration(
                                       
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.5),
                                        ),
                                        prefixIcon: Icon(Icons.search, color:Colors.black),
                                        labelStyle: TextStyle(color: Colors.green[900]),
                                        labelText: "आफ्नो अस्पताल छान्नुहोस्",
                                         
                                        hintStyle:TextStyle(color: Colors.black),
                                        focusColor: Colors.red,
                                        border:  InputBorder.none,
                                       filled: true,
                                       fillColor: Colors.green.withOpacity(0.1)
                                      ),
                                    ),
                                  ));
                           
       });
  }
}

class Home extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}