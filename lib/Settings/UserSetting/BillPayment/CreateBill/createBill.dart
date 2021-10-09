import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/AddFine/addFine.dart';
 import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createBillcontroller.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createbillModel.dart';

class displayBill extends StatefulWidget {

  @override
  _displayBillState createState() => _displayBillState();
}

class _displayBillState extends State<displayBill> {
  final _billController=Get.put(createBillController());
 @override
 void initState() { 
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffeef5f3),
         
        body:   GetBuilder(
            init:createBillController(),
            builder:(_billController) =>Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
        
            Positioned(
              top: 80,
              right: 0,
              left: 0,

              child: Container(
                height: MediaQuery.of(context).size.height-80,
                 
                child: Container(
                  
                  color: Colors.green.withOpacity(0.1),
                  child: 
                  ///onto this child now ... lets
                  ///
                  displayUserBill()
               
                  ),
              ),
            )
          ],
        ),
        
      ),
    )
    );
  }

  Widget displayUserBill() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
         Expanded(child: Card(
           child: ListView(
            padding: EdgeInsets.all(5.0),
            shrinkWrap:true,
            children: <Widget>[
            // getRowElement("Home  Id :",  ""),
             //getRowElement("Owner :", ""),
             //getRowElement("Current Month:" ),
             //getRowElement("Current Month:" ),
             //getRowElement("Monthly Charge:" ),
         
            //getRowTextField("Fine"),
            //getRowElement(" Remaingn Amount :"  ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Divider(height: 2, color: Colors.grey,),
           ),
           //id the ramining
            /// getRowElement(" Total Amount of Month:", widget.cre.totalAmount ),
        
           Padding(
             padding: const EdgeInsets.all(4.0),
             child: Divider(height: 2, color: Colors.red,),
           ),
            
           Padding(
             padding: const EdgeInsets.all(4.0),
             child: Divider(height: 5, color: Colors.red,),
           ),
           //id the ramining
           //  getRowElement(" Overall total:", widget.cre.overalltotalAmount ),
        
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(child:SizedBox(
              height: 50,
              child: ElevatedButton(onPressed: (){
                
                //load him to next page 
              }, child: Text("Pay Now")))),
          )
        
         
            ],
          ),
        ))

      ],
    );
  }

  getRowElement(String title, String description ) {
    return   Row(
    children: <Widget>[
      SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(title, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize:18.0,),
        ))),
        SizedBox(width: 5,),

      Flexible(child: Text(description, style:TextStyle(fontSize: 17, color:Colors.grey)))
    ],
    ) ;

  }

  getRowTextField(String s, String t) {
      return  Row(
    children: <Widget>[
      SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(s, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500, fontSize:18.0,),
        ))),
        SizedBox(width: 5,),

        Flexible(child: InkWell(
          onTap: (){
            BottomSheetForFine( "docID", "currentAmount" );
          },
          child: Text(t, 
             

              style:TextStyle(fontSize: 17, color:Colors.grey, decoration:TextDecoration.underline)
              
              ),
        ))
    ],
    ) ;
  }

  void BottomSheetForFine(String s, String t) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(topLeft:  Radius.circular(5.0), topRight: Radius.circular(5.0)),
        child: Container(
          height: 200,
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              Text("Home Id: "),
              SizedBox(height:5),
              DecimaltextField(hintText: "Enter fine",),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child:SizedBox(
                  height:50,
                  child: ElevatedButton(onPressed: (){}, child: Text("Add fine")),
                )
              )
            ]
          ),
        ),
      )
    );
  }
}