import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waste/Home/Billing/Billing_controller.dart';


class BillingPage extends GetView<BillingController>{

  @override
 
  Widget build(BuildContext context) {
    double totalAmount=400.0;
    double fineAmount=200.0;

    double width= (MediaQuery.of(context).size.width)-40;
    double redColorValue;
      double greenColorValue;
      
 
      @override
      void inittate() { 
        greenColorValue
      = (width)*((totalAmount)/(totalAmount+fineAmount));
          redColorValue=  (width)*((fineAmount)/(totalAmount+fineAmount));
      }

    return Scaffold(
      body:  SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[

            
           Container(
    height: 200,
    width:double.infinity,
    decoration: BoxDecoration(
       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
        gradient:LinearGradient(
            colors: [
            Colors.blue[900], 
            Colors.blue[600],
          
            //add more colors for gradient
            ],
            begin: Alignment.centerLeft, //begin of the gradient color
            end: Alignment.centerRight, //end of the gradient color
            stops: [0, 0.2] //stops for individual color
            //set the stops number equal to numbers of color
        ),
    ),
    child: Column(
      children: [
        SizedBox(height: 25,),
       Row(
         
         children: [
         SizedBox(width: 15,),
           AutoSizeText("2077-10-12", style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: "Brand Bold"),),
           SizedBox(width: 15,),
           AutoSizeText("  -  ", style:TextStyle(color: Colors.white)),
           SizedBox(width: 15,),
           AutoSizeText("2078-10-13", style: TextStyle(fontSize: 20.0, color:Colors.white,fontFamily: "Brand Bold"),),
           SizedBox(width: 15,),

         ],
        
       )  ,
       SizedBox(
         height: 50,
       ) ,
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
 
  Padding(
    padding: const EdgeInsets.only(left:15.0),
    child: AutoSizeText.rich(
      TextSpan(
        children:[
          TextSpan(text: "Amount :", style: TextStyle(color: Colors.white, fontFamily: "Brand Bold")),
           TextSpan(text: ' Rs 200 /-',
           style: TextStyle(fontSize: 20, color:Colors.yellow,  fontFamily: "Brand Bold"),
    
)
          ]
          )
 
    ),
  ),
  //////////////DISPLAY FINE INSIDE ROW
  Container(
    padding: EdgeInsets.only(right: 15.0),
    child: Column(
      
      children: [
        Row(
          children:[
            AutoSizeText("Jarimana : ", style: TextStyle(color: Colors.white, fontFamily:"Brand Bold",)),
        AutoSizeText(" Rs 500 /-", style:TextStyle(color: Colors.orange,fontFamily: "Brand Bold", fontSize: 18))

          ]
        )
      ],
    ),
  ),
  

  ]
  
   ),
      
      SizedBox(height:15),
        Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
    height: 5,
    child: Row(
      children:<Widget>[
        SizedBox(
          width: greenColorValue, 
          child: Container(color: Colors.teal,)),

            SizedBox(
          width: redColorValue, 
          child: Container(
            
            color: Colors.red,)),
      ]
    ),
  )
      ],
    ),
),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children:[
                 ListView(
                   padding: EdgeInsets.symmetric(horizontal: 15.0),
                   children: [
                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            SizedBox(height: 20.0,),
                             AutoSizeText("Amount Pending :", style: TextStyle(color: Colors.grey[800],fontSize: 20.0, fontFamily:"Brand Bold",))
                        , Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText('2077-2078', style: TextStyle(color: Colors.grey)),
                               AutoSizeText('RU 200 /-', style: TextStyle(color: Colors.grey)
                              )
                            ],
                          ),
                        ),

                       
                        
                        
                         
                          ]
                        ),
                      ),
                     ListTile(
                          leading: Icon(CupertinoIcons.calendar),
                          title:  AutoSizeText("This Month", style: 
                          TextStyle(color: Colors.teal[900], fontFamily: "Brand Bold", fontSize: 15),),

                          subtitle:AutoSizeText("Pending Amount", style: TextStyle(color: Colors.blueGrey),) ,
                          trailing: AutoSizeText("Rs 200.00", style: TextStyle(color: Colors.green, fontFamily: "Brand Bold"),),
                        ),

                         
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
                        Container(height: 100,)
                          
                   ],
                 ),
                                
                     
                                      
                  

                    Positioned(
                      bottom: 0,
                      left:0,
                      right:0,
                      child: Material(
                         
                        color: Colors.white,
                        child: InkWell(
                          onTap: (){print("Pay Now");},
                          child: Container(
                            margin: EdgeInsets.all(9.0),
                            child:  Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 2,
                                    blurRadius: 1
                                  )
                                ]
                              ),
                             
                              child: Center(
                                child: Text("Pay Now", style: TextStyle(fontSize: 20.0, color: Colors.white,fontFamily: "Brand Bold"),)),
                            )
                          ),
                        )
                      ),
                    )

                ]
              )
              
            )]
                    ),
        )
      );
      
  }


}