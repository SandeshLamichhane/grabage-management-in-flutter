import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:waste/InitialPage/FifthPage/CreatePassword.dart';
import 'package:waste/InitialPage/FourthPage/phnController.dart';
import 'package:waste/InitialPage/FourthPage/verifyPhone.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/textfield.dart';

class PhoneNumberVerification extends StatefulWidget {
 
  @override
  _PhoneNumberVerificationState createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  var _formKey= GlobalKey<FormState>();

   TextEditingController phoneController= new TextEditingController();

   final _controller= Get.put(PhoneNumberController());

    final boxx= GetStorage();

    int userPhone;
 
  
  
  @override
  void initState() { 
    super.initState();
  print('+++'+boxx.read(boxuserType));
  }
 

  
 //if the phone is already registered but no password then go to password

  @override
  Widget build(BuildContext context) {
     String initialCountry = 'NP';
  PhoneNumber number = PhoneNumber(isoCode: 'NP');

       String phn= boxx.read(boxuserPhoneNumber).toString();
             String verifiedstate=boxx.read(boxverifiedState);
           // String password= boxx.read(boxUserPassword);
         print(phn+verifiedstate);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: globalFunction().customLinearGradient,
          ),
          child: Form(
            key: _formKey,

            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                  SizedBox(height: 40.0,),
                   CircleAvatar(
                     child: ClipRRect(
                      child:  Image.asset("assets/logo.png", fit: BoxFit.cover,)
                    ),
                     radius: 50,
                   ),
                   SizedBox(height: 30.0,),
                 AutoSizeText("पोखरा फोहोरमैला व्यवस्थापन", 
                 style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0,
                 color:Theme.of(context).primaryColor
                 ),
                 
                  ),
               
               SizedBox(height: 50,),
               Padding(
                 padding: const EdgeInsets.only(top:8.0,bottom:20),
                 child: AutoSizeText("आफ्नो नम्बर राख्नुहोस", style: TextStyle(color: Theme.of(context).primaryColor,
                 fontWeight:FontWeight.w800
                 ),),
               ) ,
           SizedBox(height: 20,),
             InternationalPhoneNumberInput(
               maxLength: 10,
               hintText:'फोन नम्बर प्रविष्ट गर्नुहोस' ,
              onInputChanged: (PhoneNumber number) {
                 userPhone= int.parse(number.toString());
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
             // textFieldController: controller,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
                
                  
            
              SizedBox(height: 30,),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                 
                  height: 50,
                  child: ElevatedButton.icon(
                    
                    icon: Icon(CupertinoIcons.arrowshape_turn_up_right_circle, size: 20,),
                    label: Text('अगाडि बढ्नुहोस्', style: TextStyle(fontSize: 15),),
                    onPressed: () async {
                    String newuserPhone="+"+  userPhone.toString().trim();
                 //  String formatNumber=newuserPhone.substring(newuserPhone.length-10, )

          //  PhoneNumberController(). methodForStoringUserInfo( '+9779844734458',  'b7DKjhMEFnWfkmOP3zMe2YPSf1S2');
             // return;
                   if(  _formKey.currentState.validate()){
                    bool hasinternet= await hasInsternet();
                    if(hasinternet){
                 
                    if(userPhone==null|| userPhone.toString().length<10 ){
                      BotToast.showText(text: "Oops");
                    }
                    
                   
                      PhoneNumberController().sendAuthenticationtoPhone(newuserPhone);

                     
                       DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);
                    
                        

                     } else{
                      BotToast.showText(text:"Oops");
                     }

                       } 
                  
                   }
                    //  print(phoneController.text);
          
          
                    
                  ),
                ),
          ),
              ],
          
            ),
          ),
        ),
      ),
      
    );
  }
}
