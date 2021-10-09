import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Home/Notification/notificationModel.dart';
import 'package:waste/Settings/UserSetting/BillPayment/bill.dart';
import 'package:waste/Settings/UserSetting/gunaso/gunasoView.dart';

class adminDashboard extends StatefulWidget {
  @override
  _adminDashboardState createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {
  
  @override
  Widget build(BuildContext context) {
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        body:  Container(
          width: 400,
          child: Center(  
                child: GridView.extent(  
                  primary: false,  
                  padding: const EdgeInsets.all(16),  
                  crossAxisSpacing: 10,  
                  mainAxisSpacing: 10,  
                  maxCrossAxisExtent: 200.0,  
                  children: <Widget>[  
                    //first grid view
                    InkWell(
                      onTap: (){
                        Get.to(AddBillRate());
                      },
                      child: Material(
                        child: Container(  
                         
                          padding:   EdgeInsets.all(width/35),  
                          child: Padding(
                            padding:   EdgeInsets.symmetric(horizontal: width/40, vertical: height/ 20.0),
                            child: Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular((width/30)),
                            color: Colors.red.withOpacity(0.1)
                          ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                  child: 
                                    Text('Gunaso', style: TextStyle(fontSize:   width.toInt()/25,
                                   color: Colors.teal, fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(width: 5,),
                                Icon(CupertinoIcons.rays, color: Colors.pink , size: height/10,)
                                
                                ]
                              ),
                            ),
                          ),  
                          color: Colors.green.withOpacity(0.1),  
                        ),
                      ),
                    ),  

              //bill current 

                  InkWell(
                      onTap: (){
                        Get.to((AddBillRate()));
                      },
                      child: Material(
                        child: Container(  
                          padding:   EdgeInsets.all(width/35),  
                          child: Padding(
                            padding:   EdgeInsets.symmetric(horizontal: width/40, vertical: height/ 20.0),
                            child: Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular((width/30)),
                            color: Colors.indigo.withOpacity(0.1)
                          ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                  child: 
                                    Text('Bill', style: TextStyle(fontSize:   width.toInt()/25,
                                   color: Colors.indigo, fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(width: 5,),
                                Icon(CupertinoIcons.money_dollar, color: Colors.brown , size: height/10,)
                                
                                ]
                              ),
                            ),
                          ),  
                          color: Colors.green.withOpacity(0.1),  
                        ),
                      ),
                    ), 


                    Container(  
                      padding: const EdgeInsets.all(8),  
                      child: const Text('Second', style: TextStyle(fontSize: 20)),  
                      color: Colors.blue,  
                    ),  
                    Container(  
                      padding: const EdgeInsets.all(8),  
                      child: const Text('Third', style: TextStyle(fontSize: 20)),  
                      color: Colors.blue,  
                    ),  
                    Container(  
                      padding: const EdgeInsets.all(8),  
                      child: const Text('Four', style: TextStyle(fontSize: 20)),  
                      color: Colors.yellow,  
                    ),  
                    Container(  
                      padding: const EdgeInsets.all(8),  
                      child: const Text('Fifth', style: TextStyle(fontSize: 20)),  
                      color: Colors.yellow,  
                    ),  
                    Container(  
                      padding: const EdgeInsets.all(8),  
                      child: const Text('Six', style: TextStyle(fontSize: 20)),  
                      color: Colors.blue,  
                    ),  
                  ],  
                )),
        ),
      ),
    ); 
 
  }

  createGridView(){}
}