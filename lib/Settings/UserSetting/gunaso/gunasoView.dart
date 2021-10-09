 

import 'package:auto_size_text/auto_size_text.dart';
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:readmore/readmore.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/gunaso/gunasoController.dart';
 
 class  GunasoResponse extends StatefulWidget {
   //const MyNotification({ Key? key }) : super(key: key);
 
   @override
   _GunasoResponseState createState() => _GunasoResponseState();
 }
 
 class _GunasoResponseState extends State<GunasoResponse> {
   final _gunasoController= Get.put(GunasoController());
   String descriptionValidator;
  var _formKey=GlobalKey<FormState>();

   @override
  void initState() {
     super.initState();
    descriptionValidator=null;
     
  _gunasoController.loadAllpendinggunasoofUser();

  }
   @override
   Widget build(BuildContext context) {
    
     @override
     void initState() { 
       super.initState();
 
     }
     return SafeArea(
       child: Scaffold(
         
        backgroundColor: Color(0xffE7E4E4),
        appBar: AppBar(
          title: Text("All your gunaso", style:TextStyle(color: Colors.white)),
          actions: [
            Obx(()=>(
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).primaryColor,
                  value:_gunasoController.dropDownValue,
                  onChanged: (val){   
                     _gunasoController.changeDropdowValue(val);
                  },   icon: Icon(Icons.keyboard_arrow_down),
            
                  items: _gunasoController.items.map(( String e){
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e, style:TextStyle(color:Colors.white)));
                }).toList()),
              )
            ))
          ],
        ),
          body: Stack(
           children: [
           Padding(
             padding: const EdgeInsets.all(1.0),
             child: Column(
                    children:<Widget>[
               
             
   
        
              QuestionAnswer(),
              SizedBox(height:100)
                    ]
             ),
           ),
      
          
             showtextfield()  
          
          
         
           ]
         ),

       ),
       
     );
   }

  showtextfield() {
      return  Obx(()=>Form(
        key: _formKey,
        child: (
           AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),
                  curve: Curves.fastOutSlowIn,
                       bottom: 0.0,
                       left:0.0, 
                       right: 0.0,
                       height:  _gunasoController.showHide? 400.0:80.0,
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(15.0),
                           topRight: Radius.circular(15.0))
                         ),
                         
                         padding: EdgeInsets.only(left: 20.0, right: 20.0 , top: 20.0),
                       //mainly for animatiom
                         child: 
                          _gunasoController.showHide?  hideTextField():
                         Column(
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                               Text( "Harek gunasaprati imaandar rahnuhos.", style: TextStyle(
                                fontWeight: FontWeight.w700 , fontSize:18.0, color: Colors.teal)),
                            
                               
                               
                               ],
                             )
                           ],
                         ),
                       ),
        )),
      ),
      ) ;
  }

  hideTextField() {
    return 
              SingleChildScrollView(
                child: Container(
                  
                      padding: const EdgeInsets.only(top:8.0),
                    height: 400,    
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),  
                  
                   child: Column(
                     children: <Widget>[
                       Align(alignment: Alignment.bottomLeft, child: Text("Gunaso:", style: TextStyle(fontWeight: FontWeight.w500, 
                       fontSize:18.0, color: Colors.pink),)),
                        Flexible(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget> [
                        Container(child: Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Text(_gunasoController.currentPrashn, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
                        )),
                        GestureDetector(
                            onTap: (){
                             _gunasoController.changeShow(-1, prashn: "", gunasoId: "",val: false);
              
                          },
                          child: ClipRRect(                         
                                            child: Padding(
                          padding: const EdgeInsets.only(right:0.0),
                          child: Container(
                                    decoration: BoxDecoration(
                                         color: Colors.green,
                                               borderRadius: BorderRadius.circular(5.0)
                                               ),
                                               height: 40,
                                               width: 40,
                                               child: Icon(CupertinoIcons.chevron_down, color: Colors.white,), ),
                                            ),
                                         ),
                        )
                      ],),),
 
SizedBox(height: 8,),
GunasooTextField
(
   onValidator: (value){
    return descriptionValidator;
  },
  hintText: "Reply the gunaso",
minline: 5,
maxline: 5,
nameController: _gunasoController.replyTextFieldController,
 onChnageField: (value){
 },
 length: 300,
),
              
SizedBox(height:20),  
  Container(
    width: MediaQuery.of(context).size.width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height:50,
          child: ElevatedButton( onPressed: () async{
            //print("")
      var x= await  _gunasoController.validateDescription();
      descriptionValidator=x;
     WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
     if( _formKey.currentState.validate()){
 
   _gunasoController.ReplyaGunaso();
     }

          },  child: Text("Reply Gunaso"),
        ),
        
      ),
    ),
  )
                     ],
                   ),
                
                  
                  ),
              );
  }
 }


 

class  HideAskPage extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return    Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:  Container(
              height: 400, color: Colors.green,
            ));
  }
}
 class QuestionAnswer extends StatelessWidget {
  final _gunasoController= Get.put(GunasoController());
   final confirmDeleteController=TextEditingController();

 @override
 void initState() { 
 
 }
   @override
   Widget build(BuildContext context) {
     return 
        GetBuilder(
          init: GunasoController(),
          builder: (_gunasoController)=>
          Flexible(
        
             //if the data is null then 

           child:  
           _gunasoController.isLaoding?
          
             
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: SizedBox(height:30, child:Center(child: CircularProgressIndicator(),)),
             ):
            _gunasoController.listofgunasoModel.length<1?
               SizedBox(
           height:150,
           child: Center(
             child: Card(
               color: Colors.white,
               elevation: 2,
                child:Center(
             child: Column(
               children:[
                 SizedBox(height: 30,),
                 Container(
                   color: Colors.green.withOpacity(0.1),
                   child: Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Text("kunai Gunaso aayeko chhain", style:TextStyle(fontWeight: FontWeight.w800,color: Colors.green, fontSize: 18.0)),
                   ),
                 ),
                 Center(child: Icon(CupertinoIcons.hand_raised_slash_fill, size:30, color:Colors.pink))
               ]
             ),
                )
                 ),
           ),
               ):
          ListView.builder(
                   itemCount: _gunasoController.listofgunasoModel.length,
                   itemBuilder: (BuildContext context, int index){
         return  Card(
              margin: EdgeInsets.only(top: 20, bottom: 20),
            color: Colors.grey[200],
            elevation: 2,
            shadowColor: Colors.grey,
            child: Container(
              child: 
            Column(
              children: [
          ListTile(
            leading:   
            Icon( CupertinoIcons.person_crop_circle_fill, size: 40.0,color: Colors.indigo,), 
            //title
            title: ReadMoreText(_gunasoController.listofgunasoModel[index].gunasotitle, style: TextStyle(color: Colors.brown, fontSize: 20.0, fontWeight: FontWeight.w500),),
            subtitle:  Column(
            children: [
                ReadMoreText(
              _gunasoController.listofgunasoModel[index].gunasodescription,
           style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
          trimLines: 5,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          lessStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
              //Either show pending or checked
              _gunasoController.listofgunasoModel[index].gunasorequestpending=="yes"?
              Container(
          decoration: BoxDecoration(
            color:Colors.green,
            border:Border.all(width: 1.0, color:Colors.grey) ,
            borderRadius: BorderRadius.circular(20.0)
          ),
          child:
          
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("New", style:TextStyle(color:Colors.white))
          )):  
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check_circle, color:Colors.grey),
             
           ),
           //Reply
           Padding(
             padding: const EdgeInsets.all(1.0),
             child: ClipRRect(
               child:InkWell(
               onTap:(){
                _gunasoController.changeShow(
                  index,
                  prashn: _gunasoController.listofgunasoModel[index].gunasotitle,
                  gunasoId:_gunasoController.listofgunasoModel[index].gunasoId.toString(),
                  val: true
                );
               },
                 child:Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Reply", style: TextStyle(color:Colors.red),),
                 )
               )
             ),
           ),

        ///since the delete for only the
         Padding(
             padding: const EdgeInsets.all(1.0),
             child: ClipRRect(
               child:InkWell(
               onTap:(){

                 AskBeforeDelete(
                   
                   _gunasoController.listofgunasoModel[index].gunasoId.toString(),
                   _gunasoController.listofgunasoModel[index].gunasotitle
                   );
               // _gunasoController.delete(
               //   gunashoId:_gunasoController.listofgunasoModel[index].gunasoId.toString(),
              //  );
               },
                 child:Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("delete", style: TextStyle(color:Colors.blueGrey),),
                 )
               )
             ),
           ),
           Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(_gunasoController.listofgunasoModel[index].gunasoquestionDate ,
             style: TextStyle(color: Colors.grey), textAlign: TextAlign.right,)),
              ],
            ),
          )
              ],
            )
          ),
          SizedBox(height: 10,),
           _gunasoController.listofgunasoModel[index].gunasorequestpending=="no"?
           Divider(height:2, color:Colors.grey):Container(),
            SizedBox(height: 10,),
          _gunasoController.listofgunasoModel[index].gunasorequestpending=="yes"?Container():
            ListTile(
              trailing: CircleAvatar(radius: 20,backgroundImage:AssetImage("assets/logo.png") ,),
              //title: ReadMoreText("samayma gaadi aayena ?", style: TextStyle(color: Colors.orange, fontSize: 20.0, fontWeight: FontWeight.w900),),
              subtitle: Padding(
          padding: EdgeInsets.only(top:20.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 25.0,),
              ),
              Flexible(
                child: AutoSizeText.rich(
                  TextSpan(
                    text: _gunasoController.listofgunasoModel[index].gunasomoderatorName,
                    style:  TextStyle(fontWeight: FontWeight.w500, color: Colors.teal),
                    children: [
                      TextSpan(
                        text:'  '+  _gunasoController.listofgunasoModel[index].gunasomoderatorrole.toString(),
                         style:  TextStyle(fontWeight: FontWeight.w400, color: Colors. grey),
                      ),
                        TextSpan(
                        text: '  '+_gunasoController.listofgunasoModel[index].gunasoreplyDate.toString(),
                         style:  TextStyle(fontWeight: FontWeight.w400, color: Colors. grey),
                      )
                    ]
                  ),
                  
                ),
              ),
            ],
          ),
              ),
               title:  ReadMoreText(
            _gunasoController.listofgunasoModel[index].gunasoreplytext,
           style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
            trimLines: 5,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
             lessStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          )),
              ],
            ),
          ),
          );
                   }),
          ),
        );
   }

  void AskBeforeDelete(String gunasoId, String title) {

        Get.bottomSheet(
                    Container(
                         height: 250,
                         color:Colors.white,
                         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Flexible(
                            child: AutoSizeText(title +" : will be removed from server", 
                            style:TextStyle(color: Colors.pink, fontWeight:FontWeight.w600)),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            child: DeleteTextField(
                              iconData: Icons.games,
                              hintText: "Enter { remove } to delete.",
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
                              child: ElevatedButton(
                                onPressed: () async {
                                
                                if(confirmDeleteController.text.trim()=='remove'){
                                  //suucess ful
                                  confirmDeleteController.clear();
                                  Get.back();
                                      _gunasoController.delete(
                  gunashoId:gunasoId,
                );    
                                              
                                           }
                                }
                                ,
                              
                              child: Text("Confirm")),
                            )
                          )
                        ],
                      ),
                    )
                  );
             
  }
 }