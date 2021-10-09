import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/AddFine/addfineController.dart';

class AddFine extends StatefulWidget {
 String  HomeId;
 String  todate;
 String totalAmounttoPay;
 
 AddFine({ @required this.HomeId, @required this.todate, @required this.totalAmounttoPay});
  @override
  _AddFineState createState() => _AddFineState();
}

class _AddFineState extends State<AddFine> {
 final _addcontroller= Get.put(addfineController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffdbdadf),
        appBar: AppBar(
          title: Text("Confirm your payment")
        ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.all(18.0),
            children: <Widget>[
              SizedBox(height: 20,),
              AutoSizeText("Once you confirm, All the Money will be paid.",
               style: TextStyle(fontWeight: FontWeight.w800, color:Colors.green,)),
               getRowElement('Home Id', widget.HomeId),
               getRowElement('Upto',  widget.todate),
              getRowElement('Amount',  widget.totalAmounttoPay),
             Divider(thickness: 2,),
            ClipRRect(
              
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                height: 50,
                child: ElevatedButton(onPressed: (){
               _addcontroller.confirmPayment(HomeId:widget.HomeId,
                upto: widget.todate, Amount: widget.totalAmounttoPay, 
                onSuccess: (){
                 Get.back();
                }
                );
        
                }, 
                child: Text("Confirm")),
              ),
            )
            ],
            
          ),
        ),
      ),
    );
  }

  getRowElement(String s, String t) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
   SizedBox(width: 100,
   child: Text(s, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
   ),
   ),

   Padding(padding: EdgeInsets.only(left: 5, right: 5 ),
   child:Text(" : ")
   ),
       
   Flexible( child:Text(t, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),))
      ],),
    );
  }

 }