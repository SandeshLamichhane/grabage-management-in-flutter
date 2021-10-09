import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/BillPayment/billpaymentController.dart';

class displayHospitalBill extends StatefulWidget {
  @override
  _displayHospitalBillState createState() => _displayHospitalBillState();

}


class _displayHospitalBillState extends State<displayHospitalBill> {
 final _billPaymentController=Get.put(billPaymentController());

   HDTRefreshController _hdtRefreshController = HDTRefreshController();

  int selectedRow=-1;
@override
void initState() { 
  super.initState();
  _billPaymentController.loadHospitalBillRate();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Hospital Rate"),
      ),
      body:  GetBuilder( 
            init:billPaymentController(),
            builder:(billPaymentController){
              return 
 
               _billPaymentController.isLoading?
               Center(child: Padding(padding: EdgeInsets.all(18.0), child: CircularProgressIndicator(),)) :
              
              _billPaymentController.listofHospitalRate.length<1 ?
              Container(child:Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(child: Text("No data available")),
              ),):
            
              
               HorizontalDataTable(
              leftHandSideColumnWidth: 150,
              rightHandSideColumnWidth: 350,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder:_generateRightHandSideColumnRow,
               itemCount:_billPaymentController.listofHospitalRate.length,// _addroutecontroller.listofRoutes.length,
              rowSeparatorWidget: const Divider(
                color: Colors.black54,
                height: 1.0,
                thickness: 0.0,
              ),
              leftHandSideColBackgroundColor: Color(0x02020200),
               rightHandSideColBackgroundColor:  Color(0x00551020),
              verticalScrollbarStyle: const ScrollbarStyle(
                thumbColor: Colors.yellow,
                isAlwaysShown: true,
                thickness: 4.0,
                radius: Radius.circular(5.0),
              ),
              horizontalScrollbarStyle: const ScrollbarStyle(
                thumbColor: Colors.red,
                isAlwaysShown: true,
                thickness: 4.0,
                radius: Radius.circular(5.0),
              ),
              enablePullToRefresh: true,
              refreshIndicator: const WaterDropHeader(),
              refreshIndicatorHeight: 60,
              onRefresh: () async {
                //Do sth
               
                
              //  _addroutecontroller.loadAllRoutesFromFirestore();
                _hdtRefreshController.refreshCompleted();
               
              },
              htdRefreshController: _hdtRefreshController,
               );
            }


           ) ,
      
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Home Id' , 150),
        onPressed: () {
 
        },
      ),
      

      _getTitleItemWidget('Rate', 100),    
      _getTitleItemWidget('Date', 150), 
     _getTitleItemWidget('Delete', 100),   
      
    ];
   }

   Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,)),
      width: width,
      height: 56,
      decoration:BoxDecoration(
        color:  Color(0xFF3333FAFF),
      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  //////////////////////////////////////////////////////////////////
  
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap:(){
       setState(() {     selectedRow=index;         });    
                },
      child: InkWell(
        onTap: (){
          // BotToast.showText(text: users.userdetail[index].userPhone );
              setState(() {
                selectedRow=index;        
              });
        },
        child: Tooltip(
          message: "Double tap to edit",
          child: Container(
             color:  selectedRow==index?Colors.blueGrey: Colors.transparent,
         child: Text( _billPaymentController.listofHospitalRate[index].hospitalName),
            width: 150,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return GestureDetector(
     
      child: InkWell(
        onTap: (){
           setState(() {
            selectedRow=index;
          });
        },
        child: Container(
          color:  selectedRow==index?Colors.blueGrey : Colors.transparent,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap:(){
                },
                child: Container(
                   child: Text(_billPaymentController.listofHospitalRate[index].rate, overflow:TextOverflow.ellipsis), 
                  width: 100,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
 
            
        Container(
               child: Text(
            DateTime.fromMillisecondsSinceEpoch(_billPaymentController.listofHospitalRate[index].datetime).toString()

                 ),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
    //////////////////////
        InkWell(
          onTap: (){
             
             setState(() {
            selectedRow=index;
          });
            _billPaymentController.chnageHospHome('Hospital');
             deleteCurrentHospitalRate(_billPaymentController.listofHospitalRate[index].datetime);
          },
          child: Container(
                    width: 100,
                     child: Icon(Icons.delete)
                 ),
        )
          
           ] ) )));
               
}

  void deleteCurrentHospitalRate(int datetime) {
     Get.bottomSheet(
                    Container(
                         height: 200,
                         color:Colors.white,
                         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            child: DeleteTextField(
                              iconData: Icons.games,
                              hintText: "Enter { remove } to delete.",
                              onChnageField: (value){              
                              },
                              nameController:_billPaymentController.confirmDeleteController,
                            )
                          ),
                          SizedBox(height: 20,),
                          ClipRRect(
                            child: SizedBox(
                              height:50,
                              width:double.maxFinite,
                              child: ElevatedButton(onPressed: () async {
                                
                                if(_billPaymentController.confirmDeleteController.text.trim()=='remove'){
                                  //suucess ful
                                  _billPaymentController.confirmDeleteController.clear();
                                  Get.back();
                                _billPaymentController.deleteFromFirestore(
                                  datetime.toString(),
                                 (){}
                                 );
                              
                                
                                         
                                }
                              }, 
                              child: Text("Confirm")),
                            )
                          )
                        ],
                      ),
                    )
                  );
             

  }
  
  
  
  }