import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Settings/UserSetting/BillPayment/AllBill/alluserbillController.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/AddFine/addFine.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createBill.dart';
 class homeuserbillrecord extends StatefulWidget {
  
   @override
   _homeuserbillrecordState createState() => _homeuserbillrecordState();
 }
 
 class _homeuserbillrecordState extends State<homeuserbillrecord> {
    final _billController=Get.put(homeuserBillController());
  @override
  void initState() { 
    super.initState();
    _billController.getAllHomeId();
    _billController.initData();
  
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
       
      child:   GetBuilder(
                      init:homeuserBillController() ,
                      builder:(_billController)=>(
        Stack(
          children: [
            
            
            Column(
          mainAxisSize: MainAxisSize.min,
            children: [
             
                 Container(
                     height:160,
                   child: ClipRRect(
                     borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(25.0), bottomRight:Radius.circular(25.0)),
                     child: Container(
                       color: Colors.grey.withOpacity(0.3),
                     
                       child:ListView(
                         shrinkWrap: true,
                         children: [
                             Container(
                        child: SizedBox(
                                height: 80,
                                
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: DropdownSearch(
                                    showAsSuffixIcons: true,
                                    searchBoxStyle: TextStyle(color:Colors.black),
                                    onChanged: (value){
                                      _billController.changeVehicleId(value);
                                    },
                                    showSearchBox: true,
                                    showClearButton: false,
                                    searchBoxDecoration: InputDecoration(
                                      hintText: "Type here to search."
                                    ),
                                    items: _billController.listofHomeId,
                                    hint: "Search home id",
                                     
                                    dropDownButton: Icon(Icons.arrow_downward, color:Colors.black),
                                    dropdownSearchBaseStyle: TextStyle(color: Colors.red),
                                    dropdownSearchDecoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search, color:Colors.black),
                                      labelStyle: TextStyle(color: Colors.black),
                                      labelText: "Search home id",
                                      hintStyle:TextStyle(color: Colors.black),
                                      focusColor: Colors.red,
                                      border:  InputBorder.none,
                                     filled: true,
                                     fillColor: Colors.grey.withOpacity(0.3)
                                    ),
                                  ),
                                ),
                              ),
                      ),
         _billController.listofModelMonth.length<1? Center(child: Text(""),):
                      Container(
                         child: (
                            Row(
                              mainAxisSize:MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                             SizedBox(width: 15,),
                               Padding(
                                 padding: const EdgeInsets.all(4.0),
                                 child: AutoSizeText( _billController.fromDate, 
                                 style: TextStyle(  
                                 color: Colors.indigo, fontFamily: "Brand Bold"),),
                               ),
                               SizedBox(width: 15,),
                               Spacer(),
                               AutoSizeText("  -  ", style:TextStyle(color: Colors.indigo)),
                               Spacer(),
                               SizedBox(width: 15,),
                               Padding(
                                 padding: const EdgeInsets.all(4.0),
                                 child: AutoSizeText(_billController.toDate, 
                                 style: TextStyle(  color:Colors.indigo,fontFamily: "Brand Bold"),),
                               ),
                               SizedBox(width: 15,),
                             ],
                           )),
                       ),
                    
                       
        
              
              _billController.listofModelMonth.length<1? Center(child: Text(""),):
                 Container(
               child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                      
                                Padding(
                              padding: const EdgeInsets.only(left:25.0),
                              child: AutoSizeText.rich(
                                
                                TextSpan(
                                   
                                  children:[
                                    TextSpan(text: "Amount : ", style: TextStyle(color: Colors.pink,
                                     fontFamily: "Brand Bold")),
                                     TextSpan(text: _billController.totalAmounttoPay+' /-',
                                     style: TextStyle(  color:Colors.red,  fontFamily: "Brand Bold"),
                              
                                 )
                                    ]
                                    )  
                                   ),     
                                ),
                           Spacer(),
                                  
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AutoSizeText("Fine : ", 
                            overflow: TextOverflow.ellipsis, style: TextStyle(  color: Colors.brown, fontFamily:"Brand Bold", )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AutoSizeText(_billController.totalFinetoPay+ " /-",
                             overflow: TextOverflow.ellipsis,
                             style:TextStyle(color: Colors.brown,fontFamily: "Brand Bold", )),
                          )
                                 
                          
                               ])),
             
              
         
                         ],
                       )
                     ),
                   ),
                 ),
        
          //////////////////////////////////////////////////// 2nd element for column
        
                Flexible(
                 child:
                
                    
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _billController.listofModelMonth.length,
                            itemBuilder: (BuildContext context, int index){
                      
                               return
                           InkWell(
                             onTap:(){
                               //Get.to(
                             //  displayBill(        _billController.listofModelMonth[index].monthyluBillModel                
      
                             //));
                             },
                             child: ListTile(
                                  leading: Icon(CupertinoIcons.calendar),
                                  title:  AutoSizeText( _billController.listofModelMonth[index].monthName.toString()+
                                   "-"+_billController.listofModelMonth[index].year.toString()
                               , style: 
                                  TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),
                                               
                                  subtitle:AutoSizeText(  _billController.listofModelMonth[index].transaction,
                                   style: TextStyle(color: Colors.blueGrey),) ,
                                  trailing: AutoSizeText(
                                               
                                    'Rs  ' +_billController.listofModelMonth[index].totalAmount.toString()+" /-",
                                      style: TextStyle(
                                         color: _billController.listofModelMonth[index].paid?
                                        Colors.grey : Colors.green, 
                                        fontFamily: "Brand Bold",
                                      decoration:  
                                      _billController.listofModelMonth[index].paid?
                                      TextDecoration.lineThrough:
                                      TextDecoration.none
                                      ),),
                                ),
                           );
                            })
                          
                        ),
                   
               
                                
           
           SizedBox(height: 55,),
                      ]),
      
        //////////////////////////////  Positioned bottom
          _billController.listofModelMonth.length<1? Center(child: Text(""),):(
          Positioned(
        bottom: 0,
        left: 0,
        right:0,
        child: ClipRRect(
          child:Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height:50,
              child:ElevatedButton(onPressed: (){
             //
           print( _billController.selectedIdHome+
                _billController.toDate+
               _billController.totalAmounttoPay,);
        (double.parse(  _billController.totalAmounttoPay)==0)?print(""):
             Get.to(AddFine(
               HomeId:
               _billController.selectedIdHome,
               todate:   _billController.toDate,
               totalAmounttoPay: _billController.totalAmounttoPay,
               
             ));
              }, child: Text(  "Pay Now"))
            ),
          )
        ),
          )
        ),
      
          ]
        )
      ))));
  }
}

/*
  ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("Last Month", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Due Amount", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 400.00", style: TextStyle(color: Colors.red[900], fontFamily: "Brand Bold"),),
                        ),
                        
                        
                         ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("Baisakh", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Transaction Received", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 200.00", style: TextStyle(color: Colors.grey,
                          decoration: TextDecoration.lineThrough, fontFamily: "Brand Bold"),),
                        ),
                             ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("Chait", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Transaction Received", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 200.00", style: TextStyle(color: Colors.grey,
                          decoration: TextDecoration.lineThrough, fontFamily: "Brand Bold"),),
                        ),
                             ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("Falgun", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Transaction Received", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 300.00", style: TextStyle(color: Colors.grey,
                          decoration: TextDecoration.lineThrough, fontFamily: "Brand Bold"),),


                        ),
                             ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("Maghx", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Transaction Received", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 300.00", style: TextStyle(color: Colors.grey,
                          decoration: TextDecoration.lineThrough, fontFamily: "Brand Bold"),),
                          
                        ),

*/