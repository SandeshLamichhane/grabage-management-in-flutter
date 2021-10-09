import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
 import 'package:pinput/pin_put/pin_put.dart';
import 'package:waste/InitialPage/FourthPage/phnController.dart';
import 'package:waste/InitialPage/SecondPage/SecondPage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/regx.dart';
 

class VerifyYourPhone extends StatefulWidget {
final phoneNumber;
VerifyYourPhone({@required this.phoneNumber});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<VerifyYourPhone> {
 
  @override
  void initState() { 
    super.initState();
   if(widget.phoneNumber==null || widget.phoneNumber==''){
     Get.back();
     return;
   }
    
  }

  BoxDecoration get pinPutDecoration {
    return BoxDecoration(
      gradient: globalFunction().customLinearGradient,
      color:   Colors.red,
        borderRadius: BorderRadius.circular(5.0),
       border: Border.all(
       color: const Color.fromRGBO(126, 203, 224, 1),     
      ),
      
    );
  }

  final BoxDecoration _pinPutDecoration = BoxDecoration(
      color: Colors.green,
     // color: const Color.fromRGBO(43, 46, 66, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(

        //color: const Color.fromRGBO(126, 203, 224, 1),
     
        
      ),
    );


  final _pinPutFocusNode = FocusNode();
   final control=PhoneNumberController();
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child:  Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: globalFunction().customLinearGradient,
          ),
          child: Form(
            child:ListView(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              children: <Widget>[
          SizedBox(height: 40,) ,                        
         
      Text("${widget.phoneNumber} तपाइको यो फोन नम्बर मा,  ६ अङ्कको कोड पठाइएको छ ",
       style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.0),)
                          
          ,SizedBox(height:20),
        PinPut(
              eachFieldHeight: 65.0,
              withCursor: true,
              
              fieldsCount: 6,
              focusNode: _pinPutFocusNode,
              controller:  control.pinPutController,
              onSubmit: (String pin) =>  print(pin),
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              textStyle: const TextStyle(color:    Colors.teal, fontSize: 25.0),
            ),
               
               SizedBox(height:20),
                      
          GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.symmetric(vertical: 50),
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio:1/.8,
              children: [
                ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
                  return RoundedButton(
                    title: '$e',
                    onTap: () {
                      control.pinPutController.text = '${control.pinPutController.text}$e';
                    },
                  );
                }),
                RoundedButton(
                  title: 'X',
                  onTap: () {
                    if (control.pinPutController.text.isNotEmpty) {
                      control.pinPutController.text = control.pinPutController.text
                          .substring(0, control.pinPutController.text.length - 1);
                    }
                  },
                ),
                RoundedButton(
                  title: 'Ok',
                  onTap: () {
         
            if(control.pinPutController.text.trim().length>5){
                  control.comparePinToken(control.pinPutController.text.trim()); 
                  }  
                  },
                ),
                                  ]), 
              SizedBox(height: 5,),
        
              InkWell(
                onTap:(){
                
                  //control.sendOtpToNumber(this.widget.phoneNumber);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text("कोड नपाएको भए, पुनः पठाउनुहोस्",
               style: TextStyle(fontWeight: FontWeight.w600,
               
                    color:  Theme.of(context).primaryColor),),
                  ),
                ))
        
              
              ],
            
           
              ),
              
            ),
        )));
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: globalFunction().customLinearGradient1,
            shape: BoxShape.circle,
      color: const Color.fromRGBO(12, 80, 66, 1),
          ),
          alignment: Alignment.center,
          child: Text(
            '$title',
            style: TextStyle(fontSize:  (MediaQuery.of(context).size.height)/30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}



