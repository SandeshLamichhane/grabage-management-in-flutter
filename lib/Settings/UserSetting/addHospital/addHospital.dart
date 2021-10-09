import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
 import 'package:waste/Root/constant.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addHospital/addHospitalController.dart';

class AddHospital extends StatefulWidget { 

  @override
  _AddHospitalState createState() => _AddHospitalState();
}

class _AddHospitalState extends State<AddHospital> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  final hospitalController= Get.put(AddHospitalController());
   var _formKey= GlobalKey<FormState>();
   TextEditingController confirmDeleteController= new TextEditingController();
      TextEditingController newHospitalController= new TextEditingController();
      String newDistrictName="";





   @override
   void initState() { 
     super.initState();
     hospitalController.loadAllHospital();
   }
    int selectedRow=-1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
   
   
  child: Scaffold(
    appBar: AppBar(
      
      title: Text('All Hospital'),
      actions: [
        Padding(padding:EdgeInsets.only(top:8.0, left:10.0, right:20,bottom: 8 ),
          child:
             IconButton(icon: Icon(Icons.add, color: Colors.white,),  onPressed: (){
               Get.bottomSheet(
                 Form(
                   key: _formKey,
                 child: Container(
                   color: Colors.white70,
                   height: 330,
                   
                   child:ListView(
                     padding: EdgeInsets.symmetric(horizontal: 20.0),
                     children: <Widget>[
                       SizedBox(height: 10,),
                       Text("Add New Hospital", style:TextStyle(fontWeight: FontWeight.w900, fontSize:18.0)),
                      SizedBox(height: 10,),
                        Container(
                        
                          child: DropdownSearch(
                            
                            onChanged:(value){
                              newDistrictName=value;
                            } ,
                            validator: (val){
                              if(val==null){
                                return"";
                              }
                              return null;
                            },
                            searchBoxDecoration: InputDecoration(
                              labelText: "Search district...",
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                              filled: true,
                            ),
                           
                             
                            mode: Mode.DIALOG,
                            showSearchBox: true,
                            label:"Select district",
                            items:  allNepalDistricts,
                          ),
                        ),
                          SizedBox(height:10),
                        StringtextField(
                          hintText: 'Hospital / labs Name',
                          iconData: Icons.local_hospital_rounded,
                          nameController:  newHospitalController,
                          onChnageField: (val){},
                        ),
                         SizedBox(height:20),
                  ClipRRect(
                    child:SizedBox(
                      height:50,
                      child:ElevatedButton(onPressed: ()async{
                        if(_formKey.currentState.validate()){
                          Get.back();
                         
                          await  hospitalController.AddNewHospital(
                          districtName:newDistrictName,
                          hospitalName:  newHospitalController.text.toString());
                           newDistrictName="";
                          newHospitalController.clear();

                           await hospitalController.loadAllHospital();
                           setState(() {
                             
                           });
                        }
                      }, child: Text("Add New"))
                    )
                  )
                  ,SizedBox(height:20),
                     ]
                   )),
               ));
                
             },)
        ),
          ],
        
    ),
    body:
        
         Obx(()=>(
           hospitalController.snapshotLngth==0? Container():
             HorizontalDataTable(
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: 300,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder:_generateRightHandSideColumnRow,
            itemCount: hospitalController.listOfHosptial.length,
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
             
              hospitalController.loadAllHospital();
              _hdtRefreshController.refreshCompleted();
              setState(() {
                             
                           });
            },
            htdRefreshController: _hdtRefreshController,
             ))
         )));
         
      
      
  }

  DisplayListOfHospital() {}

 List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'SN' ,
            100),
        onPressed: () {
          hospitalController.loadAllHospital();
           
        },
      ),
      
       
      _getTitleItemWidget('Hospital Name', 100),
      _getTitleItemWidget('District', 100),
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

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        // BotToast.showText(text: users.userdetail[index].userPhone );
            setState(() {
              selectedRow=index;
               
            });
          
      },
      child: Container(
         color:  selectedRow==index?Colors.blueGrey: Colors.transparent,
        child: Text(   (index+1).toString()),
        width: 100,
        height: 52,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }


  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        print(index.toString()+'/'+selectedRow.toString());
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
                child: Text(hospitalController.listOfHosptial[index].hospital),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
            ),
    
          
            Container(
              child: Text(hospitalController.listOfHosptial[index].district),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
            
              Container(
              child: IconButton(onPressed: (){

                Get.bottomSheet(
                  Container(
                       height: 200,
                       color:Colors.white,
                       padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          child: StringtextField(
                            iconData: Icons.games,
                           
                            hintText: "Enter <<"+hospitalController.listOfHosptial[index].district.toString()+">> to delete",
                            onChnageField: (value){              
                            },
                            nameController: confirmDeleteController,
                          )
                        ),
                        SizedBox(height: 20,),
                        ClipRRect(
                          child: SizedBox(
                            height:50,
                            width:double.maxFinite,
                            child: ElevatedButton(onPressed: () async {
                              
                              if(confirmDeleteController.text.trim()==hospitalController.listOfHosptial[index].district){
                                //suucess ful
                                confirmDeleteController.clear();
                                Get.back();
                                    await  hospitalController.deleteHospital(
                hospitalController.listOfHosptial[index].district.toString(),
                hospitalController.listOfHosptial[index].hospital.toString(),
                                                                               );
                         await hospitalController.loadAllHospital();
                         setState(() {            });
                              }
                            }, 
                            child: Text("Confirm")),
                          )
                        )
                      ],
                    ),
                  )
                );
           

              }, icon: Icon(Icons.delete)),
              width:100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )
            
          ],
        ),
      ),
    );
  }

}
////////////////////////////////////////////////////////////
