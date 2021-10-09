import 'package:auto_size_text/auto_size_text.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
 import 'package:waste/InitialPage/FourthPage/PhoneNumber.dart';
import 'package:waste/InitialPage/userModel.dart';
  import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/root.dart';
 

class SelectService extends StatelessWidget {
String homesubtite="यदि तपाइको घर पोखरा महानगरपालिका ओडा नम्बर ७/१७ अन्तर्गत पर्छ भने,  यहाँ थिच्नुहोसएल";
 SetBoxData setBoxData=new SetBoxData();
 
  @override
  Widget build(BuildContext context) {
    return  
       SafeArea(
         child: Scaffold(
           body:Container(
             decoration: BoxDecoration(
               gradient:globalFunction().customLinearGradient,
             ),
             child: ListView(
               padding: EdgeInsets.symmetric(horizontal: 12.0),

               children: [
              
                 SizedBox(height: 20.0,),
                 CircleAvatar(
                   
                  child: ClipRRect(
                    child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                  ),
                   radius: 50,
                 ),
                 SizedBox(height: 20.0,),
      Center(child: AutoSizeText("Pokhara Waste Service", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22.0),)),
             

                  SizedBox(height: 60,),
       SelectButton(textValue: "घर",color: Colors.blue[900], 
       icondata: Icons.home, subtitle: homesubtite, type: "Home",),
 SizedBox(height: 20,),
    SelectButton(textValue: "अस्पताल या ल्याब",color: Colors.blue[900], 
                  icondata: Icons.local_hospital_outlined, type: "Hospital",
                  subtitle: "यदि तपाइले अस्पताल या ल्याबको फोहोर व्यवस्थापन गर्न चाहे, यहाँ थिच्नुहोस",),
               
    SizedBox(height: 20,),
   SelectButton(textValue: "पाउना",color: Colors.blue[900], icondata: Icons.person_pin_circle,
                   subtitle: "सेवासुविदाप्रति पाउनाको रुपमा प्रविष्ट गर्नुहोस ", type: "Guest",
                  ),
                  
        

               ],
             ),
           ) ,
            
             
           ),
       );
  }
}

class SelectButton extends StatelessWidget {
  String textValue ;
  IconData icondata ;
  Color color;
  String subtitle;
  String type;
final box= GetStorage();

  SelectButton({ this.textValue, this.icondata, this.color, this.subtitle, this.type});
  Widget build(BuildContext context) {
    return    ClipRRect(
      
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              
                    
              child: ListTile(
                leading: Icon(icondata, size: 20,),
               title: Text(this.textValue,style: TextStyle(fontWeight: FontWeight.w600, ),),
               trailing: Icon(Icons.arrow_forward_ios_sharp, size: 20,  ),
                subtitle: Text( this.subtitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, )),
                onTap: (){
                 //recomment to 
                
                type=="Home" ?   box.write( boxuserfrom,   "Home") :
                type=="Hospital" ?  box.write( boxuserfrom, "Hospital") :
                box.write( boxuserfrom, "Guest");
 
               UserModel.instance.userFrom=type;
                 Get.to(PhoneNumberVerification());
                },
              ),
            ),
);
  }

  
}