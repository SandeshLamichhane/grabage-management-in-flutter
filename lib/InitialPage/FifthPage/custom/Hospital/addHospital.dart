
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/InitialPage/FifthPage/custom/Hospital/addHospitalController.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/textfield.dart';

class addMyHospital extends StatefulWidget {
  @override
  _addMyHospitalState createState() => _addMyHospitalState();
}

class _addMyHospitalState extends State<addMyHospital> {
 /// const selectHospital({ Key? key }) : super(key: key);
 var _formKey=  GlobalKey<FormState>();
 
String selectedHospital= '';
 final controller=  Get.put(addnewHospitalController());
TextEditingController nameController= TextEditingController();
String writtenName="";
 @override
void initState() { 
  super.initState();
 // getDistritAndHospital();
}
 
@override
void dispose() { 
  nameController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    
    return  SafeArea(
      
      child:Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: globalFunction().customLinearGradient,
          ),
          child: Form(
            key:_formKey,
            child: ListView(

              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                 Align(
                   alignment:Alignment.bottomLeft,
                   child: SizedBox(height: 40.0,
                   child:IconButton(onPressed: (){
                     Get.back();
                   }, icon: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Icon(Icons.arrow_back, color:Theme.of(context).shadowColor),
                   ))),
                 ),
                 
                      CircleAvatar(
                           child: ClipRRect(
                                child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                              ),
                             radius: 50,
                             ),
                   
                          SizedBox(height: 30.0,),
                    AutoSizeText("पोखरा फोहोरमैला व्यवस्थापन", style: TextStyle(
                             fontWeight: FontWeight.w900, fontSize: 20.0, color: Theme.of(context).primaryColor ), ),
                  
                  SizedBox(height: 20,),

                    AutoSizeText("आफ्नो अस्पताल/ ल्याबको नाम लेखेर पठाउनुहोस्, केहि दिनभित्र नै प्रमाणित गर्ने छौ ", style:  TextStyle(fontWeight: FontWeight.w200,  color: Theme.of(context).primaryColor ), ),
                     SizedBox(height: 30,),
                       nametextField(
                       hintText:"आफ्नो नाम अंग्रेजीमा",
                       iconData: Icons.person,
                       nameController: nameController,
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
                     StringtextField(
                       hintText: "आफ्नो अस्पताल/ ल्याबको नाम लेख्नुहोस",
                      iconData: Icons.local_hospital,
                      onChnageField: (val){
                         selectedHospital=val;
                      },
                     ),
              SizedBox(height: 30,),
            ClipRRect(
              child: SizedBox(
          height:50,
          child: ElevatedButton(
            onPressed:(){
     print(selectedHospital);
       

        if(selectedHospital!="" && writtenName!=""){            
            controller.savePendingRequest(HospitalName: selectedHospital, name:writtenName);
        }
            },
            child:Text("अगाडि बढ्नुहोस्")
            ,)
              )
        
           ),
         
              ],
            ) ),
        ),

      ),
      
    );
  }

} 
  